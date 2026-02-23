import express, { type Request, type Response, type NextFunction } from "express";
import cors from "cors";
import helmet from "helmet";
import morgan from "morgan";
import { createProxyMiddleware } from "http-proxy-middleware";
import type { ClientRequest, IncomingMessage, ServerResponse } from "node:http";
import type { Socket } from "node:net";
import crypto from "node:crypto";
import { createRemoteJWKSet, jwtVerify, errors as JoseErrors, type JWTPayload } from "jose";

/**
 * API Gateway (Application Programming Interface Gateway)
 * - Express + headers de seguridad (helmet) + logs estructurados + correlation id
 * - Reverse proxy hacia microservicios internos
 * - Validación JWT (JSON Web Token) OIDC (OpenID Connect) + aud (audience) por ruta
 */

const app = express();

// =========================
// Config
// =========================
const PORT = Number(process.env.PORT ?? "4000");

// Upstreams internos (en red Docker)
const CATALOG_API_URL = process.env.CATALOG_UPSTREAM ?? "http://catalog-api:8000";
const ORDERS_API_URL = process.env.ORDERS_UPSTREAM ?? "http://orders-api:8000";

// OIDC (OpenID Connect) / JWT (JSON Web Token)
const KEYCLOAK_ISSUER = process.env.KEYCLOAK_ISSUER ?? "http://keycloak.localtest.me:8080/realms/asrp";
const KEYCLOAK_JWKS_URL =
  process.env.KEYCLOAK_JWKS_URL ?? `${KEYCLOAK_ISSUER}/protocol/openid-connect/certs`;

// Audiences por ruta
const EXPECTED_AUDIENCE_CATALOG = process.env.EXPECTED_AUDIENCE ?? ""; // e.g. asrp-catalog
const EXPECTED_AUDIENCE_ORDERS = process.env.ORDERS_EXPECTED_AUDIENCE ?? ""; // e.g. asrp-orders

// CORS (Cross-Origin Resource Sharing)
const CORS_ALLOWED_ORIGINS = (process.env.CORS_ALLOWED_ORIGINS ?? "http://localhost:5173")
  .split(",")
  .map((s) => s.trim())
  .filter(Boolean);
const CORS_ALLOW_CREDENTIALS = (process.env.CORS_ALLOW_CREDENTIALS ?? "false").toLowerCase() === "true";

// Body limits
const JSON_BODY_LIMIT = process.env.JSON_BODY_LIMIT ?? "1mb";
const URLENCODED_BODY_LIMIT = process.env.URLENCODED_BODY_LIMIT ?? "1mb";

// Proxy debug (opc.)
const PROXY_DEBUG = (process.env.PROXY_DEBUG ?? "false").toLowerCase() === "true";
const proxyLogger = PROXY_DEBUG ? console : undefined;

// =========================
// Hardening base
// =========================
app.disable("x-powered-by"); // CHANGE: no revelar framework (hardening)
app.set("trust proxy", (process.env.TRUST_PROXY ?? "false").toLowerCase() === "true"); // CHANGE: cloud-ready

app.use(express.json({ limit: JSON_BODY_LIMIT })); // CHANGE: límites de payload
app.use(express.urlencoded({ extended: true, limit: URLENCODED_BODY_LIMIT })); // CHANGE: límites de payload

app.use(
  helmet({
    // CHANGE: en local no forzar HSTS (solo HTTPS real en cloud)
    hsts: false,
    frameguard: { action: "sameorigin" },
    noSniff: true,
    referrerPolicy: { policy: "no-referrer" },
    contentSecurityPolicy: false,
  })
);

// =========================
// CHANGE (Observability): Correlation ID (X-Request-Id)
// - Si viene de cliente lo respetamos
// - Si no viene, lo generamos
// - Lo devolvemos siempre en response headers
// =========================
function ensureRequestId(req: Request, res: Response, next: NextFunction) {
  const incoming = req.header("x-request-id");
  const requestId = incoming && incoming.trim().length > 0 ? incoming.trim() : crypto.randomUUID();

  // CHANGE: fijamos header para que lo vean middlewares y proxyReq
  req.headers["x-request-id"] = requestId;

  // CHANGE: lo devolvemos siempre al cliente
  res.setHeader("X-Request-Id", requestId);
  next();
}
app.use(ensureRequestId);

// =========================
// CORS (Cross-Origin Resource Sharing) estricto
// =========================
app.use(
  cors({
    origin: (origin, cb) => {
      // Permite requests sin Origin (curl, health checks, server-to-server)
      if (!origin) return cb(null, true);

      if (CORS_ALLOWED_ORIGINS.includes(origin)) return cb(null, true);
      return cb(new Error(`CORS blocked for origin: ${origin}`));
    },
    credentials: CORS_ALLOW_CREDENTIALS,
    methods: ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
    allowedHeaders: ["authorization", "content-type", "x-request-id"],
    exposedHeaders: ["x-request-id", "X-Request-Id"],
    maxAge: 600,
  })
);
app.options("*", cors());

// =========================
// CHANGE (Observability): Morgan en JSON con requestId + latencia
// =========================
morgan.token("requestId", (req: Request) => String(req.headers["x-request-id"] ?? ""));
morgan.token("remoteIp", (req: Request) => {
  const xfwd = req.headers["x-forwarded-for"];
  return String((Array.isArray(xfwd) ? xfwd[0] : xfwd) ?? req.socket.remoteAddress ?? "");
});

app.use(
  morgan((tokens, req, res) =>
    JSON.stringify({
      timestamp: new Date().toISOString(),
      level: "INFO",
      service: "api-gateway",
      env: process.env.NODE_ENV ?? "development",
      requestId: tokens.requestId(req, res),
      method: tokens.method(req, res),
      path: tokens.url(req, res),
      status: Number(tokens.status(req, res)),
      durationMs: Number(tokens["response-time"](req, res)),
      remoteIp: tokens.remoteIp(req, res),
      userAgent: tokens["user-agent"](req, res),
    })
  )
);

// =========================
// OIDC/JWT verifier (JOSE - JavaScript Object Signing and Encryption)
// =========================
const JWKS = createRemoteJWKSet(new URL(KEYCLOAK_JWKS_URL)); // CHANGE: cachea JWKS remoto

function authError(
  res: Response,
  status: 401 | 403,
  code: "unauthorized" | "forbidden",
  message: string,
  requestId: string
) {
  return res.status(status).json({ error: code, message, requestId });
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
    const options: any = { issuer: KEYCLOAK_ISSUER }; // CHANGE: valida iss estrictamente
    if (expectedAudience && expectedAudience.length > 0) {
      options.audience = expectedAudience; // CHANGE: valida aud por ruta
    }

    const { payload } = await jwtVerify(token, JWKS, options);

    // @ts-expect-error - guardamos payload para diagnóstico (no se loguea el token)
    req.jwt = payload;

    return { ok: true as const, payload };
  } catch (err: any) {
    // Claim validation (aud/iss/etc.)
    if (err instanceof JoseErrors.JWTClaimValidationFailed) {
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

function requireJwt(expectedAudience?: string) {
  return async (req: Request, res: Response, next: NextFunction) => {
    const requestId = String(req.headers["x-request-id"] ?? "");
    const result = await verifyAccessToken(req, expectedAudience);
    if (!result.ok) {
      const status = result.status;
      return authError(res, status, status === 401 ? "unauthorized" : "forbidden", result.message, requestId);
    }
    return next();
  };
}

// ============================================================
// [FIX] Error handler estable para http-proxy-middleware
// ============================================================
const onProxyError = (
  err: Error,
  req: IncomingMessage,
  res: ServerResponse<IncomingMessage> | Socket,
  _target?: unknown
) => {
  const reqId = (req.headers["x-request-id"] as string | undefined) ?? "";

  if ("writeHead" in res && typeof (res as any).writeHead === "function") {
    const httpRes = res as ServerResponse<IncomingMessage>;
    if (!httpRes.headersSent) {
      httpRes.writeHead(502, { "Content-Type": "application/json", "X-Request-Id": reqId });
    }
    httpRes.end(JSON.stringify({ error: "bad_gateway", message: err.message, requestId: reqId }));
    return;
  }

  try {
    (res as Socket).destroy(err);
  } catch {
    // noop
  }
};

// =========================
// Health
// =========================
app.get("/health", (req: Request, res: Response) => {
  res.status(200).json({
    status: "ok",
    service: "api-gateway",
    env: process.env.NODE_ENV ?? "development",
    requestId: req.headers["x-request-id"] ?? null, // CHANGE: trazabilidad
  });
});

// ============================================================
// Auth per-route (audience por proxy)
// ============================================================
// CHANGE: Excluir health upstream para permitir readiness checks
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
      pathRewrite: (path: string) => path.replace(/^\/catalog/, ""),

      on: {
        proxyReq: (proxyReq: ClientRequest, req: IncomingMessage) => {
          const auth = req.headers["authorization"];
          if (typeof auth === "string" && auth.length > 0) {
            proxyReq.setHeader("authorization", auth);
          }

          // CHANGE (Observability): Propaga X-Request-Id al upstream
          const reqId = req.headers["x-request-id"];
          if (typeof reqId === "string" && reqId.length > 0) {
            proxyReq.setHeader("x-request-id", reqId);
          }

          const xfwd = req.headers["x-forwarded-for"];
          if (typeof xfwd === "string" && xfwd.length > 0) {
            proxyReq.setHeader("x-forwarded-for", xfwd);
          }
        },
        error: onProxyError as any,
      },

      ...(proxyLogger ? { logger: proxyLogger } : {}),
    } as any
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
      pathRewrite: (path: string) => path.replace(/^\/orders/, ""),

      on: {
        proxyReq: (proxyReq: ClientRequest, req: IncomingMessage) => {
          const auth = req.headers["authorization"];
          if (typeof auth === "string" && auth.length > 0) {
            proxyReq.setHeader("authorization", auth);
          }

          // CHANGE (Observability): Propaga X-Request-Id al upstream
          const reqId = req.headers["x-request-id"];
          if (typeof reqId === "string" && reqId.length > 0) {
            proxyReq.setHeader("x-request-id", reqId);
          }

          const xfwd = req.headers["x-forwarded-for"];
          if (typeof xfwd === "string" && xfwd.length > 0) {
            proxyReq.setHeader("x-forwarded-for", xfwd);
          }
        },
        error: onProxyError as any,
      },

      ...(proxyLogger ? { logger: proxyLogger } : {}),
    } as any
  )
);

// =========================
// 404
// =========================
app.use((req: Request, res: Response) => {
  res.status(404).json({ error: "not_found", requestId: req.headers["x-request-id"] ?? null }); // CHANGE: trazabilidad
});

// =========================
// Start
// =========================
app.listen(PORT, () => {
  console.log(
    JSON.stringify({
      timestamp: new Date().toISOString(),
      level: "INFO",
      service: "api-gateway",
      message: `listening on :${PORT}`,
      issuer: KEYCLOAK_ISSUER,
      jwks: KEYCLOAK_JWKS_URL,
      catalogUpstream: CATALOG_API_URL,
      ordersUpstream: ORDERS_API_URL,
      corsAllowedOrigins: CORS_ALLOWED_ORIGINS,
    })
  );
});
