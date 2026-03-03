# Arquitectura: overview

## Componentes principales
- **Frontend (Vite + React) + NGINX (unprivileged)**:
  - Sirve SPA y dispara el login OIDC.
  - URL: `https://app.localtest.me`
- **Keycloak**: proveedor de identidad **OIDC (OpenID Connect)** y emisión de **JWT (JSON Web Token)**.
  - URL: `https://keycloak.localtest.me`
  - Realm: `asrp`
- **API Gateway (Express)**:
  - Reverse proxy hacia microservicios.
  - Verifica JWT (issuer, firma por JWKS) y aplica **RBAC (Role-Based Access Control)** por roles de cliente.
  - URL: `https://api.localtest.me`
- **catalog-api (FastAPI)**:
  - Verifica JWT y aplica RBAC `catalog_read/catalog_write`.
  - BBDD independiente: `catalog-db` (Postgres).
- **orders-api (FastAPI)**:
  - Verifica JWT y aplica RBAC `orders_read/orders_write`.
  - BBDD independiente: `orders-db` (Postgres).

## Kubernetes local (kind)
- Cluster local: **kind (Kubernetes IN Docker)** sobre Docker Desktop.
- Namespace: `asrp`
- Ingress: **ingress-nginx**
- TLS: **cert-manager** con certificado **self-signed** (en local puede aparecer “No seguro” en el navegador).
- Autoscaling: **HPA (Horizontal Pod Autoscaler)** para `api-gateway`, `catalog-api`, `orders-api`.
- Hardening: **NetworkPolicy (Kubernetes NetworkPolicy)** deny-by-default + allow mínimo.

## Flujos principales
### 1) Login OIDC (Authorization Code + PKCE)
1. Usuario entra en `https://app.localtest.me`
2. Click Login → redirección a Keycloak (`https://keycloak.localtest.me/realms/asrp/...`)
3. Keycloak autentica y devuelve tokens al Frontend (Authorization Code + **PKCE (Proof Key for Code Exchange)**)
4. El Frontend guarda el `access_token` (JWT) y lo usa como `Authorization: Bearer <token>` al llamar a la API.

### 2) Llamadas API (Frontend → Gateway → Microservicio)
1. Frontend llama a `https://api.localtest.me/...` con Bearer token
2. Gateway valida token y RBAC por roles de cliente:
   - `resource_access["asrp-catalog"].roles`: `catalog_read/catalog_write`
   - `resource_access["asrp-orders"].roles`: `orders_read/orders_write`
3. Gateway reenvía a `catalog-api` o `orders-api` por red interna de K8s.

## Endpoints relevantes
- Gateway: `GET /health`
- Catalog proxy: `GET /catalog/health` y rutas `GET /catalog/v1/...`
- Orders proxy: `GET /orders/health` y rutas `GET /orders/v1/...`
- OIDC discovery: `GET https://keycloak.localtest.me/realms/asrp/.well-known/openid-configuration`

## Modelo RBAC (Keycloak realm `asrp`)
### Clientes (clients)
- `asrp-frontend` (public client + PKCE)
- `asrp-catalog` (roles `catalog_read`, `catalog_write`)
- `asrp-orders` (roles `orders_read`, `orders_write`)

### Usuarios (ejemplo)
- `asrp-catalog-reader`, `asrp-catalog-writer`
- `asrp-orders-reader`, `asrp-orders-writer`

Recomendación enterprise:
- Writer = read + write (p. ej. `asrp-orders-writer` tiene `orders_read` y `orders_write`).

## Observabilidad mínima
- Los logs de `api-gateway`, `catalog-api`, `orders-api` están en Kubernetes:
  - `kubectl -n asrp logs deploy/<svc> --tail=80`

## Diagrama
- Mermaid: `docs/architecture/diagram.mmd`

## Reproducibilidad
- Runbook completo y comandos reproducibles: `docs/checkpoints/checkpoint-p5-k8s-local-enterprise.md`
