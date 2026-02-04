from fastapi import APIRouter, Depends

from app.security.deps import require_role

router = APIRouter()


@router.get("/health")
def health():
    return {"status": "ok", "service": "orders-api", "env": "local", "version": "0.1.0"}


@router.get("/v1/orders", dependencies=[Depends(require_role("orders_read"))])
def list_orders():
    # [ENTERPRISE] Stub inicial: luego conectamos DB + modelos
    return [
        {"id": "ord_001", "status": "created"},
        {"id": "ord_002", "status": "paid"},
    ]
