import express, { type Request, type Response } from "express";
import cors from "cors";
import helmet from "helmet";
import morgan from "morgan";
import { createProxyMiddleware } from "http-proxy-middleware";
import type { ClientRequest, IncomingMessage, ServerResponse } from "http";
import type { Socket } from "net";

const app = express();

// =========================
// Config (env)
// =========================
const PORT = Number(process.env.PORT ?? 4000);

// Targets internos en red Docker (docker compose)
//
// [ENTERPRISE] Compat: aceptamos nombres antiguos y nuevos de variables.
// - docker-compose.yml (actual): CATALOG_UPSTREAM
// - legado: CATALOG_API_URL
const CATALOG_UPSTREAM =
  process.env.CATALOG_UPSTREAM ??
  process.env.CATALOG_API_URL ??
  "http://catalog-api:8000";

// [ENTERPRISE] Orders: no arrancamos el microservicio aún (profile "orders").
// De momento dejamos el proxy preparado: si Orders no está levantado, devolverá 502 (Bad Gateway).
const ORDERS_UPSTREAM = process.env.ORDERS_UPSTREAM ?? "http://orders-api:8000";

// CORS (Cross-Origin Resource Sharing) para Vite (Vite) dev server
const ALLOWED_ORIGINS = (process.env.ALLOWED_ORIGINS ?? "http://localhost:5173")
  .split(",")
  .map((s) => s.trim())
  .filter(Boolean);

// Logger opcional del proxy (sin usar logLevel, que no existe en http-proxy-middleware v3)
const PROXY_DEBUG = (process.env.PROXY_DEBUG ?? "false").toLowerCase() === "true";
const proxyLogger = PROXY_DEBUG
  ? {
      log: console.log.bind(console),
      info: console.info.bind(console),
      warn: console.warn.bind(console),
      error: console.error.bind(console),
    }
  : undefined;

// =========================
// Middlewares
// =========================
app.disable("x-powered-by");
app.use(helmet());

app.use(
  cors({
    origin: (origin, cb) => {
      // Permite requests sin origin (curl / health checks)
      if (!origin) return cb(null, true);
      if (ALLOWED_ORIGINS.includes(origin)) return cb(null, true);
      return cb(new Error(`CORS blocked origin: ${origin}`));
    },
    credentials: false,
    allowedHeaders: ["Authorization", "Content-Type", "Accept"],
    methods: ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
  })
);

app.use(morgan("combined"));
app.use(express.json({ limit: "1mb" }));

// =========================
// Health
// =========================
app.get("/health", (_req: Request, res: Response) => {
  res.status(200).json({
    status: "ok",
    service: "api-gateway",
    env: process.env.NODE_ENV ?? "development",
    upstreams: {
      catalog: CATALOG_UPSTREAM,
      // [INFO] Orders puede no estar levantado; el proxy igualmente está preparado.
      orders: ORDERS_UPSTREAM,
    },
  });
});

// =========================
// Proxy helpers
// =========================
function isServerResponse(x: ServerResponse | Socket): x is ServerResponse {
  // [FIX] En on.error, http-proxy-middleware puede pasar Socket.
  return typeof (x as ServerResponse).setHeader === "function";
}

function makeProxy(prefix: string, target: string) {
  return createProxyMiddleware({
    target,
    changeOrigin: true,

    // /<prefix>/... -> /...
    pathRewrite: (path) => path.replace(new RegExp(`^/${prefix}`), ""),

    // Hooks v3: van dentro de "on"
    on: {
      proxyReq: (
        proxyReq: ClientRequest,
        req: IncomingMessage,
        _res: ServerResponse<IncomingMessage>
      ) => {
        // Preserva Authorization: Bearer <JWT> (JSON Web Token)
        const auth = req.headers["authorization"];
        if (typeof auth === "string" && auth.length > 0) {
          proxyReq.setHeader("authorization", auth);
        }

        // Forward real IP (útil para logs)
        const xfwd = req.headers["x-forwarded-for"];
        if (typeof xfwd === "string" && xfwd.length > 0) {
          proxyReq.setHeader("x-forwarded-for", xfwd);
        }
      },

      error: (err: Error, req: IncomingMessage, res: ServerResponse | Socket) => {
        // [ENTERPRISE] Cuando el upstream no existe / está down, devolvemos 502 consistente en JSON.
        // Esto es clave mientras Orders está "apagado" por profile.
        if (!isServerResponse(res) || res.headersSent) return;

        const message = err?.message || "Upstream connection failed";

        res.statusCode = 502; // Bad Gateway
        res.setHeader("content-type", "application/json; charset=utf-8");

        const payload = JSON.stringify({
          error: "Bad Gateway",
          message,
          upstream: target,
          path: req.url ?? "",
        });

        res.end(payload);
      },
    },

    // v3: logger en vez de logLevel (si PROXY_DEBUG=true)
    ...(proxyLogger ? { logger: proxyLogger } : {}),
  });
}

// =========================
// Proxy: /catalog -> Catalog-API
// =========================
// /catalog/health      -> Catalog /health
// /catalog/v1/products -> Catalog /v1/products
app.use("/catalog", makeProxy("catalog", CATALOG_UPSTREAM));

// =========================
// Proxy: /orders -> Orders-API (preparado, aunque Orders aún no esté levantado)
// =========================
// [ENTERPRISE] No arranques Orders todavía (profile "orders").
// Este proxy quedará listo: si orders-api no está levantado, verás 502 (Bad Gateway) con JSON.
app.use("/orders", makeProxy("orders", ORDERS_UPSTREAM));

// =========================
// 404
// =========================
app.use((_req: Request, res: Response) => {
  res.status(404).json({ error: "Not found" });
});

// =========================
// Error handler
// =========================
app.use((err: unknown, _req: Request, res: Response, _next: (e?: unknown) => void) => {
  const msg = err instanceof Error ? err.message : "Unknown error";
  res.status(500).json({ error: msg });
});

// =========================
// Start
// =========================
app.listen(PORT, () => {
  // eslint-disable-next-line no-console
  console.log(
    `[api-gateway] listening on :${PORT} | catalog -> ${CATALOG_UPSTREAM} | orders -> ${ORDERS_UPSTREAM}`
  );
});
