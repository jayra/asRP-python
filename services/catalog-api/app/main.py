from __future__ import annotations

import os
import time

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api.v1.routes import router as v1_router
from app.core.config import settings

# CHANGE (Observability): logging + request id middleware (nuevos módulos)
from app.core.logging import configure_logging, logger  # CHANGE
from app.middlewares.request_id import RequestIdMiddleware  # CHANGE

# --- FIX (robustez): evitar crash si faltan atributos opcionales en Settings ---
_app_name = getattr(settings, "app_name", "catalog-api")
_app_version = getattr(settings, "app_version", "0.1.0")

# CHANGE: configurar logging estructurado lo antes posible
configure_logging()  # CHANGE

app = FastAPI(title=_app_name, version=_app_version)

# CHANGE (Observability): correlation id + logs request start/end
app.add_middleware(RequestIdMiddleware)  # CHANGE

# --- FIX (CORS): permitir el front (Vite) sin abrir "*" ---
_raw_origins = os.getenv("CORS_ALLOWED_ORIGINS", "http://localhost:5173")
_allowed_origins = [o.strip() for o in _raw_origins.split(",") if o.strip()]

app.add_middleware(
    CORSMiddleware,
    allow_origins=_allowed_origins,
    allow_credentials=False,
    allow_methods=["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
    allow_headers=["Authorization", "Content-Type", "Accept", "X-Request-Id"],  # CHANGE: permitir request id
)

@app.get("/health")
def health():
    env = getattr(settings, "environment", None)
    if not env:
        env = os.getenv("APP_ENV") or os.getenv("ENV") or os.getenv("ENVIRONMENT") or "unknown"

    return {
        "status": "ok",
        "service": _app_name,
        "env": env,
        "version": _app_version,
    }

# API v1
app.include_router(v1_router)
