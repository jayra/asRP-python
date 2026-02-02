from __future__ import annotations

from fastapi import APIRouter, Depends

from app.core.auth import require_roles  # --- FIX (RBAC): protección por roles ---

router = APIRouter(prefix="/v1")  # --- FIX: añade prefijo /v1 para exponer /v1/products ---


@router.get("/products", dependencies=[Depends(require_roles(["catalog_read"]))])
async def list_products():
    # TODO: replace with real persistence.
    return [
        {"sku": "SKU-001", "name": "Demo product 1"},
        {"sku": "SKU-002", "name": "Demo product 2"},
    ]
