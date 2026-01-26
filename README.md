# asRP-python — Catalog API con OIDC (OpenID Connect) + JWT (JSON Web Token) + RBAC (Role-Based Access Control)

Stack de microservicios con Docker Compose y autenticación/autorización mediante Keycloak (OIDC).
El microservicio `catalog-api` valida JWT y aplica RBAC por roles de cliente.

## Objetivo demostrable (portfolio)
- Endpoint protegido: `GET /v1/products`
- Autenticación: `Authorization: Bearer <JWT>`
- Validación JWT: firma + claims (`iss` issuer, `aud` audience)
- Autorización RBAC: rol `catalog_read` (client role en Keycloak)

## Requisitos
- Windows 11 + WSL (Windows Subsystem for Linux) con Ubuntu
- Docker Desktop
- `docker compose`
- `curl`
- `jq` (opcional, para inspección del OpenAPI)

## Arranque del stack
Desde la raíz del repo:

```bash
cd ~/work/asRP-python
docker compose up -d --build
docker compose ps
