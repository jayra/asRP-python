# asRP-python

Plataforma tipo ERP (Enterprise Resource Planning) en microservicios con Python (FastAPI) y Node.js (Express), autenticación centralizada con Keycloak y autorización por roles (RBAC: Role-Based Access Control).

## Stack (local dev)
- **WSL Ubuntu** + **Docker Compose**
- **Keycloak** (OIDC: OpenID Connect) + **PostgreSQL**
- **API Gateway** (Express) con proxy:
  - `/catalog` → `catalog-api`
  - `/orders` → `orders-api`
- **catalog-api** (FastAPI) con OIDC/JWT + RBAC (`catalog_read`, `catalog_write`)
- **orders-api** (FastAPI) con OIDC/JWT + RBAC (`orders_read`, `orders_write`)
- **asrp-frontend** (Vite + React + oidc-client-ts) con Authorization Code + PKCE (Proof Key for Code Exchange)

## Puertos
- API Gateway: `http://localhost:4000`
- Catalog API (directo): `http://localhost:8002`
- Orders API (directo): `http://localhost:8003`
- Identity API: `http://localhost:8001`
- Keycloak: `http://localhost:8080`
- Keycloak health/metrics: `http://localhost:9000`

## OIDC (OpenID Connect): issuer estable
Issuer del realm `asrp`:
- `http://keycloak.localtest.me:8080/realms/asrp`

Discovery:
- `http://keycloak.localtest.me:8080/realms/asrp/.well-known/openid-configuration`

## Cómo arrancar (desarrollo)
```bash
cd ~/work/asRP-python
docker compose up -d --build
docker compose ps
