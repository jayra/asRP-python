#!/usr/bin/env bash
# scripts/asrp-compose-prodlike.sh
#
# Wrapper controlado para ejecutar docker compose en prod-like con envs/secretos.
# Uso:
#   ./scripts/asrp-compose-prodlike.sh ps
#   ./scripts/asrp-compose-prodlike.sh up -d --build
#   ./scripts/asrp-compose-prodlike.sh exec keycloak sh -lc '...'

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

exec docker compose \
  --env-file "${ROOT_DIR}/env/.env.prod" \
  --env-file "${ROOT_DIR}/env/.secrets.env" \
  -f "${ROOT_DIR}/compose/docker-compose.prod.yml" \
  -f "${ROOT_DIR}/compose/docker-compose.prodlike.local.yml" \
  --profile prodlike \
  "$@"
