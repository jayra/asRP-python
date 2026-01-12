from fastapi import FastAPI

from app.api.v1.routes import router as v1_router
from app.core.config import settings
from app.core.logging import configure_logging

configure_logging()

app = FastAPI(title=settings.app_name, version=settings.app_version)

@app.get("/health")
def health():
    return {
        "status": "ok",
        "service": "catalog-api",
        "version": settings.app_version,
        "env": settings.environment,
    }

app.include_router(v1_router)
