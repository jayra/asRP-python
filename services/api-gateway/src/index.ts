import express, { type Request, type Response, type NextFunction } from "express";
import cors from "cors";
import helmet from "helmet";
import morgan from "morgan";
import { createProxyMiddleware } from "http-proxy-middleware";
import type { ClientRequest, IncomingMessage, ServerResponse } from "node:http";
import type { Socket } from "node:net";
import { randomUUID } from "node:crypto";
import { createRemoteJWKSet, jwtVerify, errors as JoseErrors, type JWTPayload } from "jose";

/**
 * API Gateway (Application Programming Interface Gateway)
 * - Express + seguridad (helmet) + CORS estricto + logs (morgan)
 * - Reverse proxy hacia microservicios internos
 * - Defense-in-depth: validación JWT (JSON Web Token) + aud (audience) por ruta
 */

const app = express();

// =========================
// Config
// =========================
const PORT = Number(process.env.PORT ?? "4000");

// Upstreams internos (en red Docker)
const CATALOG_API_URL = process.env.CATALOG_UPSTREAM ?? "http://catalog-api:8000";
const ORDERS_API_URL = process.env.ORDERS_UPSTREAM ?? "http://orders-api:8000";

// Proxy debug (opc.)
const PROXY_DEBUG = (process.env.PROXY_DEBUG ?? "false").toLowerCase() === "true";
const proxyLogger = PROXY_DEBUG ? console : undefined;

// --- OIDC (OpenID Connect) / JWT (JSON Web Token) ---
const KEYCLOAK_ISSUER =
  process.env.KEYCLOAK_ISSUER ??
  process.env.OIDC_ISSUER ??
  "http://keycloak.localtest.me:8080/realms/asrp"; // CHANGE: issuer estable por defecto (enterprise)

const KEYCLOAK_JWKS_URL =
  process.env.KEYCLOAK_JWKS_URL ??
  process.env.OIDC_JWKS_URL ??
  `${KEYCLOAK_ISSUER}/protocol/openid-connect/certs`; // CHANGE: fallback Keycloak JWKS (JSON Web Key Set)

// Audiences por ruta
const EXPECTED_AUDIENCE_CATALOG = process.env.EXPECTED_AUDIENCE ?? "";
const EXPECTED_AUDIENCE_ORDERS = process.env.ORDERS_EXPECTED_AUDIENCE ?? "";

// --- CORS (Cross-Origin Resource Sharing) ---
const CORS_ALLOWED_ORIGINS = (process.env.CORS_ALLOWED_ORIGINS ?? "http://localhost:5173")
  .split(",")
  .map((s) => s.trim())
  .filter(Boolean);

const CORS_ALLOW_CREDENTIALS = (process.env.CORS_ALLOW_CREDENTIALS ?? "false").toLowerCase() === "true";

// --- Body limits ---
const JSON_BODY_LIMIT = process.env.JSON_BODY_LIMIT ?? "1mb";
const URLENCODED_BODY_LIMIT = process.env.URLENCODED_BODY_LIMIT ?? "1mb";

// =========================
// App hardening base
// =========================
app.disable("x-powered-by"); // CHANGE: hardening - no revelar framework

// CHANGE: útil si luego hay reverse proxy/ingress (en local no molesta).
app.set("trust proxy", (process.env.TRUST_PROXY ?? "false").toLowerCase() === "true");

// CHANGE: limitar payloads
app.use(express.json({ limit: JSON_BODY_LIMIT }));
app.use(express.urlencoded({ extended: true, limit: URLENCODED_BODY_LIMIT }));

// CHANGE: Helmet configurado (no “default ciego”)
app.use(
  helmet({
    // En local dev puede haber iframes (p.ej. herramientas), por defecto SAMEORIGIN es razonable
    frameguard: { action: "sameorigin" },
    // No intentes forzar HSTS en HTTP local (solo HTTPS real en cloud)
    hsts: false,
    // Ajustes seguros habituales
    noSniff: true,
    referrerPolicy: { policy: "no-referrer" },
    // CSP (Content Security Policy) se deja desactivado en este checkpoint para no romper dev.
    // En cloud/prod la activaremos con whitelist real. (Punto 4)
    contentSecurityPolicy: false,
  })
);

// CHANGE: Request/Correlation ID (id de correlación)
app.use((req: Request, res: Response, next: NextFunction) => {
  const incoming = req.header("x-request-id");
  const requestId = typeof incoming === "string" && incoming.length > 0 ? incoming : randomUUID();

  // @ts-expect-error - añadimos campo interno para logs/middlewares
  req.requestId = requestId;

  res.setHeader("x-request-id", requestId);
  next();
});

// CHANGE: Morgan con requestId
morgan.token("reqid", (req: any) => req.requestId ?? "-");
app.use(morgan(':remote-addr - :method :url :status :res[content-length] - :response-time ms reqid=":reqid"'));

// CHANGE: CORS estricto por allowlist
app.use(
  cors({
    origin: (origin, cb) => {
      // Permite requests sin Origin (curl, health checks, server-to-server)
      if (!origin) return cb(null, true);

      if (CORS_ALLOWED_ORIGINS.includes(origin)) return cb(null, true);

      // Bloquea el resto
      return cb(new Error(`CORS blocked for origin: ${origin}`));
    },
    credentials: CORS_ALLOW_CREDENTIALS,
    methods: ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
    allowedHeaders: ["authorization", "content-type", "x-request-id"],
    exposedHeaders: ["x-request-id"],
    maxAge: 600,
  })
);

// Respuesta consistente a preflight
app.options("*", cors());

// =========================
// OIDC/JWT verifier (JOSE)
// =========================
// CHANGE: cache de JWKS remoto (se reutiliza entre requests)
const JWKS = createRemoteJWKSet(new URL(KEYCLOAK_JWKS_URL));

// CHANGE: normaliza errores 401/403 de auth
function authError(
  res: Response,
  status: 401 | 403,
  code: "unauthorized" | "forbidden",
  message: string,
  requestId: string
) {
  return res.status(status).json({
    error: code,
    message,
    requestId,
  });
}

async function verifyAccessToken(req: Request, expectedAudience?: string) {
  const header = req.header("authorization") ?? "";
  const m = header.match(/^Bearer\s+(.+)$/i);
  if (!m) {
    return { ok: false as const, status: 401 as const, message: "Missing Bearer token" };
  }

  const token = m[1].trim();
  if (!token) {
    return { ok: false as const, status: 401 as const, message: "Empty Bearer token" };
  }

  try {
    const options: any = {
      issuer: KEYCLOAK_ISSUER, // CHANGE: valida iss estrictamente
    };

    // CHANGE: valida aud por ruta si está configurado
    if (expectedAudience && expectedAudience.length > 0) {
      options.audience = expectedAudience;
    }

    const { payload } = await jwtVerify(token, JWKS, options);

    // @ts-expect-error - guardamos payload en request para logs/debug
    req.jwt = payload;

    return { ok: true as const, payload };
  } catch (err: any) {
    // Mapear errores JOSE a 401/403 consistentes
    // - Token inválido/expirado/firma mala -> 401
    // - Audience mismatch -> 403 (token puede ser válido, pero no para esta ruta)
    if (err instanceof JoseErrors.JWTClaimValidationFailed) {
      // err.claim suele ser 'aud'/'iss'/etc.
      if (err.claim === "aud") {
        return { ok: false as const, status: 403 as const, message: "Token audience not allowed for this route" };
      }
      return { ok: false as const, status: 401 as const, message: `JWT claim validation failed: ${err.claim}` };
    }

    if (err instanceof JoseErrors.JWTExpired) {
      return { ok: false as const, status: 401 as const, message: "Token expired" };
    }

    return { ok: false as const, status: 401 as const, message: "Invalid token" };
  }
}

// Middleware factory
function requireJwt(expectedAudience?: string) {
  return async (req: Request, res: Response, next: NextFunction) => {
    // @ts-expect-error - requestId inyectado arriba
    const requestId: string = req.requestId ?? "-";

    const result = await verifyAccessToken(req, expectedAudience);
    if (!result.ok) {
      const status = result.status;
      return authError(res, status, status === 401 ? "unauthorized" : "forbidden", result.message, requestId);
    }
    return next();
  };
}

// ============================================================
// [FIX] Error handler estable para http-proxy-middleware (variación de typings entre versiones)
//      En v2/v3 el tipo de "error" difiere (res puede ser ServerResponse o Socket; target puede ser string|object).
//      Solución: handler robusto + casteo controlado a "any" al inyectarlo en el proxy.
// ============================================================
const onProxyError = (
  err: Error,
  _req: IncomingMessage,
  res: ServerResponse<IncomingMessage> | Socket,
  _target?: unknown
) => {
  // Si es un ServerResponse (HTTP), devolvemos JSON 502
  if ("writeHead" in res && typeof (res as any).writeHead === "function") {
    const httpRes = res as ServerResponse<IncomingMessage>;
    if (!httpRes.headersSent) {
      httpRes.writeHead(502, { "Content-Type": "application/json" });
    }
    httpRes.end(JSON.stringify({ error: "Bad gateway", message: err.message }));
    return;
  }

  // Si es un Socket (p.ej. upgrade), cerramos
  try {
    (res as Socket).destroy(err);
  } catch {
    // noop
  }
};

// =========================
// Health
// =========================
app.get("/health", (_req: Request, res: Response) => {
  res.status(200).json({
    status: "ok",
    service: "api-gateway",
    env: process.env.NODE_ENV ?? "development",
  });
});

// ============================================================
// Auth per-route (audience por proxy)
// ============================================================
// CHANGE: Excluir health upstream (si lo usas) de auth, para permitir readiness checks
function isUpstreamHealth(req: Request) {
  return req.path === "/health" || req.path === "/health/" || req.path.startsWith("/health?");
}

// ============================================================
// Proxy: /catalog -> Catalog-API
// ============================================================
// CHANGE: JWT requerido para catálogo (excepto /catalog/health)
app.use("/catalog", (req, res, next) => {
  if (isUpstreamHealth(req)) return next();
  return requireJwt(EXPECTED_AUDIENCE_CATALOG)(req, res, next);
});

app.use(
  "/catalog",
  createProxyMiddleware(
    {
      target: CATALOG_API_URL,
      changeOrigin: true,

      // /catalog/health -> /health
      // /catalog/v1/products -> /v1/products
      pathRewrite: (path: string) => path.replace(/^\/catalog/, ""),

      // Hooks v3: van dentro de "on"
      on: {
        proxyReq: (proxyReq: ClientRequest, req: IncomingMessage, _res: ServerResponse<IncomingMessage>) => {
          // Preserva Authorization: Bearer <JWT> (JSON Web Token)
          const auth = req.headers["authorization"];
          if (typeof auth === "string" && auth.length > 0) {
            proxyReq.setHeader("authorization", auth);
          }

          // CHANGE: Propaga correlation id
          const reqId = req.headers["x-request-id"];
          if (typeof reqId === "string" && reqId.length > 0) {
            proxyReq.setHeader("x-request-id", reqId);
          }

          // Forward real IP (útil para logs)
          const xfwd = req.headers["x-forwarded-for"];
          if (typeof xfwd === "string" && xfwd.length > 0) {
            proxyReq.setHeader("x-forwarded-for", xfwd);
          }
        },

        // [FIX] Tipings inestables entre versiones -> casteo controlado en el objeto del proxy
        error: onProxyError as any,
      },

      // v3: logger en vez de logLevel (si PROXY_DEBUG=true)
      ...(proxyLogger ? { logger: proxyLogger } : {}),
    } as any // [FIX] Evita TS2322 por discrepancias de tipos en http-proxy-middleware
  )
);

// ============================================================
// Proxy: /orders -> Orders-API
// ============================================================
// CHANGE: JWT requerido para orders (excepto /orders/health)
app.use("/orders", (req, res, next) => {
  if (isUpstreamHealth(req)) return next();
  return requireJwt(EXPECTED_AUDIENCE_ORDERS)(req, res, next);
});

app.use(
  "/orders",
  createProxyMiddleware(
    {
      target: ORDERS_API_URL,
      changeOrigin: true,

      // /orders/health -> /health
      // /orders/v1/orders -> /v1/orders
      pathRewrite: (path: string) => path.replace(/^\/orders/, ""),

      on: {
        proxyReq: (proxyReq: ClientRequest, req: IncomingMessage, _res: ServerResponse<IncomingMessage>) => {
          // Preserva Authorization: Bearer <JWT> (JSON Web Token)
          const auth = req.headers["authorization"];
          if (typeof auth === "string" && auth.length > 0) {
            proxyReq.setHeader("authorization", auth);
          }

          // CHANGE: Propaga correlation id
          const reqId = req.headers["x-request-id"];
          if (typeof reqId === "string" && reqId.length > 0) {
            proxyReq.setHeader("x-request-id", reqId);
          }

          // Forward real IP
          const xfwd = req.headers["x-forwarded-for"];
          if (typeof xfwd === "string" && xfwd.length > 0) {
            proxyReq.setHeader("x-forwarded-for", xfwd);
          }
        },

        // [FIX] Igual que Catalog
        error: onProxyError as any,
      },

      ...(proxyLogger ? { logger: proxyLogger } : {}),
    } as any // [FIX] Evita TS2322 por discrepancias de tipos en http-proxy-middleware
  )
);

// =========================
// 404
// =========================
app.use((_req: Request, res: Response) => {
  res.status(404).json({ error: "Not found" });
});

// =========================
// Start
// =========================
app.listen(PORT, () => {
  console.log(`[api-gateway] listening on :${PORT}`);
  console.log(`[api-gateway] catalog upstream: ${CATALOG_API_URL}`);
  console.log(`[api-gateway] orders  upstream: ${ORDERS_API_URL}`);
  console.log(`[api-gateway] issuer: ${KEYCLOAK_ISSUER}`);
  console.log(`[api-gateway] jwks:   ${KEYCLOAK_JWKS_URL}`);
  console.log(`[api-gateway] cors allowed origins: ${CORS_ALLOWED_ORIGINS.join(", ") || "(none)"}`);
});
