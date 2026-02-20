from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from app.api.routes import router
from app.core.config import settings
from app.core.logging import configure_logging, logger
from app.middlewares.request_id import RequestIdMiddleware

# CHANGE: logging estructurado (JSON) configurado al arrancar (enterprise observability)
configure_logging()

app = FastAPI(title="orders-api", version="0.1.0")

# CHANGE: Correlation ID middleware (X-Request-Id) para trazabilidad end-to-end
app.add_middleware(RequestIdMiddleware)

# CHANGE: CORS (Cross-Origin Resource Sharing) desde config (enterprise: allowlist)
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins_list(),  # CHANGE: CORSMiddleware espera lista
    allow_credentials=settings.cors_allow_credentials,
    allow_methods=["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
    allow_headers=["Authorization", "Content-Type", "X-Request-Id"],
    expose_headers=["X-Request-Id"],
)

# CHANGE: Handler homogéneo para errores no controlados con requestId
@app.exception_handler(Exception)
async def unhandled_exception_handler(request: Request, exc: Exception):
    # Si es un error “no controlado”, no filtramos detalles internos (enterprise).
    request_id = getattr(request.state, "request_id", None)
    logger.exception("Unhandled exception", extra={"requestId": request_id})
    return JSONResponse(
        status_code=500,
        content={
            "error": "internal_server_error",
            "message": "Unexpected error",
            "requestId": request_id,
        },
    )


# Incluye rutas
app.include_router(router)

# CHANGE: Log de arranque con parámetros clave (sin secretos)
logger.info(
    "orders-api started",
    extra={
        "env": settings.environment,
        "issuer": settings.oidc_issuer_expected,
        "audience": settings.oidc_audience,
        "rbacClientId": settings.rbac_client_id,
        "corsOrigins": settings.cors_allowed_origins,  # CHANGE: CSV original (útil para debug)
        "corsOriginsList": settings.cors_origins_list(),
    },
)
