# Arquitectura: overview

## Componentes
- **Keycloak**: proveedor de identidad (OIDC: OpenID Connect) y emisión de JWT (JSON Web Token)
- **API Gateway (Express)**:
  - valida JWT por ruta (audience)
  - proxy inverso hacia microservicios
  - propaga `X-Request-Id`
- **catalog-api (FastAPI)**:
  - valida JWT (issuer + firma por JWKS)
  - aplica RBAC con `catalog_read/catalog_write`
- **orders-api (FastAPI)**:
  - valida JWT (issuer + firma por JWKS)
  - aplica RBAC con `orders_read/orders_write`
- **PostgreSQL** por microservicio:
  - `catalog-db`, `orders-db`, `keycloak-db`

## Flujo: frontend → gateway → API
1. Usuario hace login en Keycloak (Authorization Code + PKCE)
2. Frontend recibe tokens
3. Frontend llama al Gateway (`/orders/...` o `/catalog/...`) con `Authorization: Bearer <JWT>`
4. Gateway valida `aud` según la ruta y reenvía a la API
5. API valida issuer/firma + roles y responde
6. `X-Request-Id` se propaga para trazabilidad

## Endpoints de salud
- Gateway: `/health`
- Catalog proxy: `/catalog/health`
- Orders proxy: `/orders/health`
- Keycloak: `:9000/health/ready`
