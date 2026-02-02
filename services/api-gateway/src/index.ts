import express, { type Request, type Response } from "express";
import cors from "cors";
import helmet from "helmet";
import morgan from "morgan";
import { createProxyMiddleware } from "http-proxy-middleware";
import type { ClientRequest, IncomingMessage, ServerResponse } from "http";

const app = express();

// =========================
// Config (env)
// =========================
const PORT = Number(process.env.PORT ?? 4000);

// Targets internos en red Docker (docker compose)
const CATALOG_API_URL = process.env.CATALOG_API_URL ?? "http://catalog-api:8000";

// CORS (Cross-Origin Resource Sharing) para Vite (Vite) dev server
const ALLOWED_ORIGINS = (process.env.ALLOWED_ORIGINS ?? "http://localhost:5173")
  .split(",")
  .map((s) => s.trim())
  .filter(Boolean);

// Logger opcional del proxy (sin usar logLevel, que no existe en v3)
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
  });
});

// =========================
// Proxy: /catalog -> Catalog-API
// =========================
app.use(
  "/catalog",
  createProxyMiddleware({
    target: CATALOG_API_URL,
    changeOrigin: true,

    // /catalog/health -> /health
    // /catalog/v1/products -> /v1/products
    pathRewrite: (path) => path.replace(/^\/catalog/, ""),

    // Hooks v3: van dentro de "on"
    on: {
      proxyReq: (
        proxyReq: ClientRequest,
        req: IncomingMessage,
        _res: ServerResponse
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
    },

    // ✅ v3: logger en vez de logLevel (si PROXY_DEBUG=true)
    ...(proxyLogger ? { logger: proxyLogger } : {}),
  })
);

// =========================
// 404
// =========================
app.use((_req: Request, res: Response) => {
  res.status(404).json({ error: "Not found" });
});

// =========================
// Error handler
// =========================
app.use(
  (
    err: unknown,
    _req: Request,
    res: Response,
    _next: (e?: unknown) => void
  ) => {
    const msg = err instanceof Error ? err.message : "Unknown error";
    res.status(500).json({ error: msg });
  }
);

// =========================
// Start
// =========================
app.listen(PORT, () => {
  // eslint-disable-next-line no-console
  console.log(
    `[api-gateway] listening on :${PORT} | catalog -> ${CATALOG_API_URL}`
  );
});
