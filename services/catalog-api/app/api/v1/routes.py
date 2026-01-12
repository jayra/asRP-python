from fastapi import APIRouter

from app.core.config import settings

from fastapi import Depends
from sqlalchemy.orm import Session
from sqlalchemy import select
from app.core.deps import get_db
from app.models import Product

router = APIRouter(prefix="/v1")

@router.get("/ping")
def ping():
    return {"message": "pong", "service": "catalog-api", "env": settings.environment}

@router.get("/products")
def list_products(db: Session = Depends(get_db)):
    items = db.execute(select(Product)).scalars().all()
    return [{"id": p.id, "sku": p.sku, "name": p.name} for p in items]
