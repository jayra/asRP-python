from fastapi import FastAPI
from app.routers.health import router as health_router

app = FastAPI(
    title="orders-api",
    version="0.1.0",
)

# Routers
app.include_router(health_router)


@app.get("/v1/orders")
def list_orders():
    # [ENTERPRISE] Placeholder: en el siguiente paso añadimos:
    # - Validación JWT (JSON Web Token)
    # - RBAC (Role-Based Access Control) orders_read/orders_write
    return [
        {"id": "ORD-001", "status": "NEW"},
        {"id": "ORD-002", "status": "PAID"},
    ]
