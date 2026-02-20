from fastapi import APIRouter, Depends

from app.core.config import settings  # CHANGE: usamos config.py (no settings.py)
from app.security.deps import require_role

router = APIRouter()


@router.get("/health")
def health():
    # CHANGE: settings.version no existe; usamos app_version (y fallback defensivo)
    return {
        "status": "ok",
        "service": settings.app_name,
        "env": settings.environment,
        "version": getattr(settings, "app_version", "0.1.0"),
    }


@router.get("/v1/orders", dependencies=[Depends(require_role("orders_read"))])
def list_orders():
    return [
        {"id": "ord_001", "status": "created"},
        {"id": "ord_002", "status": "paid"},
    ]
