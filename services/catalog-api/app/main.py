from __future__ import annotations

import os

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware  # --- FIX (CORS): habilitar middleware CORS ---

from app.api.v1.routes import router as v1_router
from app.core.config import settings

# --- FIX (robustez): evitar crash si faltan atributos opcionales en Settings ---
_app_name = getattr(settings, "app_name", "catalog-api")  # --- FIX: fallback seguro ---
_app_version = getattr(settings, "app_version", "0.1.0")  # --- FIX: fallback seguro ---

app = FastAPI(title=_app_name, version=_app_version)

# --- FIX (CORS): permitir el front (Vite) sin abrir "*" ---
# En dev puedes sobreescribir con CORS_ALLOWED_ORIGINS="http://localhost:5173,http://127.0.0.1:5173"
_raw_origins = (
    os.getenv("CORS_ALLOWED_ORIGINS", "http://localhost:5173")  # --- FIX: default Vite ---
)
_allowed_origins = [o.strip() for o in _raw_origins.split(",") if o.strip()]

app.add_middleware(
    CORSMiddleware,  # --- FIX (CORS): middleware oficial FastAPI/Starlette ---
    allow_origins=_allowed_origins,  # --- FIX: orígenes explícitos (enterprise)
    allow_credentials=False,  # --- FIX: normalmente False con Bearer token
    allow_methods=["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],  # --- FIX: preflight
    allow_headers=["Authorization", "Content-Type", "Accept"],  # --- FIX: headers típicos
)

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
