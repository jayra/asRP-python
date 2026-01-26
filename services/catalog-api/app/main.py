from __future__ import annotations

import os

from fastapi import FastAPI

from app.api.v1.routes import router as v1_router
from app.core.config import settings

# --- FIX (robustez): evitar crash si faltan atributos opcionales en Settings ---
_app_name = getattr(settings, "app_name", "catalog-api")  # --- FIX: fallback seguro ---
_app_version = getattr(settings, "app_version", "0.1.0")  # --- FIX: fallback seguro ---

app = FastAPI(title=_app_name, version=_app_version)


@app.get("/health")
def health():
    # --- FIX (health): no depender de settings.environment si no existe ---
    env = getattr(settings, "environment", None)  # --- FIX: getattr para evitar AttributeError ---
    if not env:
        env = (
            os.getenv("APP_ENV")
            or os.getenv("ENV")
            or os.getenv("ENVIRONMENT")
            or "unknown"
        )  # --- FIX: fallback por variables de entorno ---

    return {
        "status": "ok",
        "service": _app_name,
        "env": env,
        "version": _app_version,
    }


# API v1
# --- FIX (routing): evitar doble prefijo /v1/v1. El router v1 ya incorpora /v1 en su definición/árbol ---
app.include_router(v1_router)  # --- FIX: sin prefix="/v1" ---
