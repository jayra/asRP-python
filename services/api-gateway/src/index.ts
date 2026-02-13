import express, { type Request, type Response } from "express";
import cors from "cors";
import helmet from "helmet";
import morgan from "morgan";
import { createProxyMiddleware } from "http-proxy-middleware";
import type { ClientRequest, IncomingMessage, ServerResponse } from "node:http";
import type { Socket } from "node:net";

/**
 * API Gateway (Application Programming Interface Gateway)
 * - Express + seguridad básica (helmet) + logs (morgan)
 * - Reverse proxy hacia microservicios internos
 */

const app = express();

const PORT = Number(process.env.PORT ?? "4000");

// Upstreams internos (en red Docker)
const CATALOG_API_URL = process.env.CATALOG_UPSTREAM ?? "http://catalog-api:8000";
const ORDERS_API_URL = process.env.ORDERS_UPSTREAM ?? "http://orders-api:8000";

// Proxy debug (opc.)
const PROXY_DEBUG = (process.env.PROXY_DEBUG ?? "false").toLowerCase() === "true";
const proxyLogger = PROXY_DEBUG ? console : undefined;

// --- Middlewares base ---
app.use(helmet());
app.use(cors({ origin: true, credentials: true }));
app.use(morgan("combined"));

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
// Proxy: /catalog -> Catalog-API
// ============================================================
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
});
