
---

# 5) `docs/security/oidc-keycloak.md`

```md
# OIDC (OpenID Connect) / Keycloak

## Endpoints (local)
- Base Keycloak: `http://localhost:8080`
- Health ready: `http://localhost:9000/health/ready`

## Realm
- Realm: `asrp`

## Issuer estable (importante)
- `http://keycloak.localtest.me:8080/realms/asrp`

Motivo:
- Evita problemas de issuer distinto entre red docker interna y host.
- Se usa para validar claim `iss` en JWT.

## Discovery (OpenID configuration)
- `http://keycloak.localtest.me:8080/realms/asrp/.well-known/openid-configuration`

## JWKS (JSON Web Key Set)
- `http://keycloak.localtest.me:8080/realms/asrp/protocol/openid-connect/certs`

## Audiencias (aud)
- Catalog: `asrp-catalog`
- Orders: `asrp-orders`

## Flujos
### Usuario (frontend)
- Authorization Code + PKCE (Proof Key for Code Exchange)
- Frontend: Vite + React + oidc-client-ts
- Objetivo: login sin F5 y token válido consumido por Gateway

### M2M (Machine-to-Machine) (smoke)
- Service accounts (clientes confidenciales) en Keycloak
- Script `scripts/smoke-auth.sh` obtiene secretos, pide tokens y valida 200/403.
