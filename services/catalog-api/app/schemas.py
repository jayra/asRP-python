from pydantic import BaseModel, Field


class ProductCreate(BaseModel):
    sku: str = Field(min_length=1, max_length=64)
    name: str = Field(min_length=1, max_length=255)


class ProductRead(BaseModel):
    id: int
    sku: str
    name: str
