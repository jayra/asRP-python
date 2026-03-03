
---

# 4) `docs/runbooks/runbook-auth-smoke.md`

```md
# Runbook: Smoke de Auth (OIDC/JWT + RBAC)

## Objetivo
Verificar que:
- El Gateway valida JWT (JSON Web Token) por audience (aud).
- Los microservicios aplican RBAC (Role-Based Access Control) devolviendo:
  - 200 si rol correcto
  - 403 si token válido pero sin rol
  - 401 si falta token / token inválido

## Script
```bash
bash scripts/smoke-auth.sh
