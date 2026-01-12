from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.core.config import settings
from app.core.deps import get_db
from app.repositories import create_product, get_product, get_product_by_sku, list_products
from app.schemas import ProductCreate, ProductRead

router = APIRouter(prefix="/v1")


@router.get("/ping")
def ping():
    return {"message": "pong", "service": "catalog-api", "env": settings.environment}


@router.get("/products", response_model=list[ProductRead])
def http_list_products(db: Session = Depends(get_db)):
    return list_products(db)


@router.get("/products/{product_id}", response_model=ProductRead)
def http_get_product(product_id: int, db: Session = Depends(get_db)):
    item = get_product(db, product_id)
    if not item:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Product not found")
    return item


@router.post("/products", response_model=ProductRead, status_code=status.HTTP_201_CREATED)
def http_create_product(payload: ProductCreate, db: Session = Depends(get_db)):
    existing = get_product_by_sku(db, payload.sku)
    if existing:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="SKU already exists",
        )
    return create_product(db, payload)
