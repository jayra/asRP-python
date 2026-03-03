
---

# 2) `docs/checkpoints/checkpoint-p2-hardening.md`

```md
# Checkpoint: checkpoint-p2-hardening

## Git
- Tag: `checkpoint-p2-hardening`
- Commit: `03e0e0f`

## Estado del stack (Docker Compose)
Servicios relevantes en ejecución:
- `api-gateway` (4000)
- `catalog-api` (8002)
- `orders-api` (8003)
- `keycloak` (8080) + health/metrics (9000)
- PostgreSQL: `catalog-db`, `orders-db`, `keycloak-db`

## Decisiones técnicas (seguridad)
### OIDC (OpenID Connect)
- Issuer estable:
  - `http://keycloak.localtest.me:8080/realms/asrp`
- JWKS (JSON Web Key Set) URL:
  - `http://keycloak.localtest.me:8080/realms/asrp/protocol/openid-connect/certs`

### API Gateway (Express)
- Proxy:
  - `/catalog` → `http://catalog-api:8000` (path rewrite: quita `/catalog`)
  - `/orders` → `http://orders-api:8000` (path rewrite: quita `/orders`)
- Validación por ruta (audience):
  - `EXPECTED_AUDIENCE` para catalog: `asrp-catalog`
  - `ORDERS_EXPECTED_AUDIENCE` para orders: `asrp-orders`
- Excepciones:
  - `/catalog/health` y `/orders/health` no requieren JWT

### RBAC (Role-Based Access Control)
- Catalog:
  - roles: `catalog_read`, `catalog_write`
- Orders:
  - roles: `orders_read`, `orders_write`

## Validaciones realizadas (evidencia)
### 1) Health
- Gateway: `GET /health` → 200
- Proxy Catalog: `GET /catalog/health` → 200
- Proxy Orders: `GET /orders/health` → 200
- Keycloak: `GET http://localhost:9000/health/ready` → 200 `"status":"UP"`

### 2) Smoke Auth (scripts/smoke-auth.sh)
Resultados esperados y verificados:
- Catalog:
  - con rol → 200
  - sin rol → 403
- Orders:
  - reader → 200
  - writer → 200 (GET)
  - sin rol → 403

### 3) 401 consistente
- `GET http://localhost:4000/orders/v1/orders` sin token → 401 Unauthorized (OK)

### 4) Correlation ID (X-Request-Id)
- `curl -i -H "X-Request-Id: test-req-001" http://localhost:4000/orders/health`
  - responde `x-request-id: test-req-001` (OK)

## Notas de seguridad
- No incluir `docker compose config` completo en documentación porque expone secretos.
- Secrets deben residir en:
  - `.env.*.secrets` (no versionado)
  - o Docker secrets (recomendado para cloud)
