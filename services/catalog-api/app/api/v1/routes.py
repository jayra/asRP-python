from fastapi import APIRouter

from app.core.config import settings

router = APIRouter(prefix="/v1")

@router.get("/ping")
def ping():
    return {"message": "pong", "service": "catalog-api", "env": settings.environment}
