# orders-api

FastAPI (Fast Application Programming Interface) microservice for Orders.
- OIDC (OpenID Connect) / JWT (JSON Web Token) validation
- RBAC (Role-Based Access Control): orders_read / orders_write
- PostgreSQL (Postgres Structured Query Language) with SQLAlchemy + Alembic

This service is activated via Docker Compose profile: `orders`.

## Run (profile)
docker compose --profile orders up -d --build

## Health
curl -i http://localhost:8003/health
