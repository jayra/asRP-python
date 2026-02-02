#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# Smoke E2E (End-to-End) Auth Tests
# - Gateway health
# - Proxy health
# - 200 with M2M token WITH role
# - 403 with M2M token WITHOUT role
# -----------------------------------------------------------------------------

REALM="asrp"

# M2M clients (ajusta si tus clientId difieren)
CLIENT_WITH_ROLE="asrp-catalog-m2m"
CLIENT_NO_ROLE="asrp-catalog-m2m-noread"

GATEWAY_BASE="http://localhost:4000"
CATALOG_PRODUCTS="$GATEWAY_BASE/catalog/v1/products"

echo "[i] 1) Gateway /health"
curl -fsS "$GATEWAY_BASE/health" >/dev/null
echo "[v] OK"

echo "[i] 2) Proxy /catalog/health"
curl -fsS "$GATEWAY_BASE/catalog/health" >/dev/null
echo "[v] OK"

echo "[i] 3) Login kcadm (admin) para leer client secrets"
KC_ADMIN="$(docker compose exec -T keycloak sh -lc 'printf %s "$KEYCLOAK_ADMIN"')"
KC_PASS="$(docker compose exec -T keycloak sh -lc 'printf %s "$KEYCLOAK_ADMIN_PASSWORD"')"

docker compose exec -T keycloak /opt/keycloak/bin/kcadm.sh config credentials \
  --server http://localhost:8080 \
  --realm master \
  --user "$KC_ADMIN" \
  --password "$KC_PASS" >/dev/null

get_client_id() {
  local clientId="$1"
  docker compose exec -T keycloak /opt/keycloak/bin/kcadm.sh get clients -r "$REALM" \
    -q "clientId=$clientId" --fields id --format csv \
    | tail -n 1 | tr -d '\r' | tr -d '"'
}

get_client_secret() {
  local cid="$1"
  docker compose exec -T keycloak /opt/keycloak/bin/kcadm.sh get "clients/$cid/client-secret" -r "$REALM" \
    --fields value --format csv \
    | tail -n 1 | tr -d '\r' | tr -d '"'
}

CID_WITH="$(get_client_id "$CLIENT_WITH_ROLE")"
CID_NO="$(get_client_id "$CLIENT_NO_ROLE")"

if [[ -z "$CID_WITH" || -z "$CID_NO" ]]; then
  echo "[x] No encuentro alguno de los clientes: $CLIENT_WITH_ROLE / $CLIENT_NO_ROLE"
  exit 1
fi

SECRET_WITH="$(get_client_secret "$CID_WITH")"
SECRET_NO="$(get_client_secret "$CID_NO")"

get_token_cc() {
  local client_id="$1"
  local client_secret="$2"

  # Pedimos el token desde dentro de Docker para evitar problemas de red:
  # - URL interna al IdP (Identity Provider): http://keycloak:8080/...
  docker compose exec -T catalog-api sh -lc \
    "python3 - <<'PY'
import json, urllib.parse, urllib.request
realm='$REALM'
client_id='$client_id'
client_secret='$client_secret'
url=f'http://keycloak:8080/realms/{realm}/protocol/openid-connect/token'
data=urllib.parse.urlencode({
  'grant_type':'client_credentials',
  'client_id':client_id,
  'client_secret':client_secret
}).encode()
req=urllib.request.Request(url, data=data, headers={'Content-Type':'application/x-www-form-urlencoded'})
payload=json.loads(urllib.request.urlopen(req).read().decode())
print(payload['access_token'])
PY"
}

echo "[i] 4) Token M2M con rol"
TOKEN_WITH="$(get_token_cc "$CLIENT_WITH_ROLE" "$SECRET_WITH")"
echo "[v] OK (len=${#TOKEN_WITH})"

echo "[i] 5) Token M2M sin rol"
TOKEN_NO="$(get_token_cc "$CLIENT_NO_ROLE" "$SECRET_NO")"
echo "[v] OK (len=${#TOKEN_NO})"

echo "[i] 6) Esperado 200 con rol"
STATUS_200="$(curl -s -o /dev/null -w '%{http_code}' "$CATALOG_PRODUCTS" -H "Authorization: Bearer $TOKEN_WITH")"
echo "[i] HTTP $STATUS_200"
[[ "$STATUS_200" == "200" ]] || exit 1
echo "[v] OK"

echo "[i] 7) Esperado 403 sin rol"
STATUS_403="$(curl -s -o /dev/null -w '%{http_code}' "$CATALOG_PRODUCTS" -H "Authorization: Bearer $TOKEN_NO")"
echo "[i] HTTP $STATUS_403"
[[ "$STATUS_403" == "403" ]] || exit 1
echo "[v] OK"

echo "[✓] Smoke auth OK"
