#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# Smoke E2E (End-to-End) Auth Tests
# - Gateway health
# - Proxy health (Catalog + Orders)
# - 200 with M2M token WITH role
# - 403 with M2M token WITHOUT role
#
# OIDC (OpenID Connect) / JWT (JSON Web Token)
# M2M (Machine-to-Machine)
# -----------------------------------------------------------------------------

REALM="asrp"

GATEWAY_BASE="http://localhost:4000"

# -------------------------
# Catalog (ajusta si difieren tus clientId)
# -------------------------
CATALOG_CLIENT_WITH_ROLE="asrp-catalog-m2m"
CATALOG_CLIENT_NO_ROLE="asrp-catalog-m2m-noread"
CATALOG_PRODUCTS="$GATEWAY_BASE/catalog/v1/products"

# -------------------------
# Orders (ajusta si difieren tus clientId)
# -------------------------
ORDERS_CLIENT_READER="asrp-orders-m2m-reader"
ORDERS_CLIENT_WRITER="asrp-orders-m2m-writer"
ORDERS_CLIENT_NOROLE="asrp-orders-m2m-norole"
ORDERS_ORDERS="$GATEWAY_BASE/orders/v1/orders"

# Si Orders aún no está activo en tu compose, puedes poner esto a "false"
RUN_ORDERS="${RUN_ORDERS:-true}"

# CHANGE: Export opcional de tokens para poder decodificarlos fuera del script.
# - DUMP_TOKENS=true    -> guarda .tmp/tokens.env (chmod 600) con TOKEN_* generados
# - PRINT_PAYLOADS=true -> imprime el payload (claims) de los TOKEN_* (sin firma)
DUMP_TOKENS="${DUMP_TOKENS:-false}"
PRINT_PAYLOADS="${PRINT_PAYLOADS:-false}"

# -----------------------------------------------------------------------------
# Helpers
# -----------------------------------------------------------------------------

echo "[i] 0) Preflight: docker compose disponible"
docker compose version >/dev/null

echo "[i] 1) Gateway /health"
curl -fsS "$GATEWAY_BASE/health" >/dev/null
echo "[v] GW /health OK"

echo "[i] 2) Proxy /catalog/health"
curl -fsS "$GATEWAY_BASE/catalog/health" >/dev/null
echo "[v] GW /catalog/health OK"

if [[ "$RUN_ORDERS" == "true" ]]; then
  echo "[i] 3) Proxy /orders/health"
  if curl -fsS "$GATEWAY_BASE/orders/health" >/dev/null; then
    echo "[v] GW /orders/health OK"
  else
    echo "[!] GW /orders/health no responde. Skipping Orders smoke."
    RUN_ORDERS="false"
  fi
fi

echo "[i] 4) Login kcadm (admin) para leer client secrets"
KC_ADMIN="$(docker compose exec -T keycloak sh -lc 'printf %s "$KEYCLOAK_ADMIN"')"
KC_PASS="$(docker compose exec -T keycloak sh -lc 'printf %s "$KEYCLOAK_ADMIN_PASSWORD"')"

docker compose exec -T keycloak /opt/keycloak/bin/kcadm.sh config credentials \
  --server http://localhost:8080 \
  --realm master \
  --user "$KC_ADMIN" \
  --password "$KC_PASS" >/dev/null
echo "[v] kcadm login OK"

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

# Devuelve 0 (true) si el token está expirado o va a expirar en <= leeway segundos
jwt_expired_or_soon() {
  local token="$1"
  local leeway="${2:-30}"
  python3 - <<'PY'
import os, json, base64, time, sys
t=os.environ.get("T","")
leeway=int(os.environ.get("LEEWAY","30"))
if not t or t.count(".") < 2:
  print("1")
  sys.exit(0)
p=t.split(".")[1]
p += "="*((4-len(p)%4)%4)
p=p.replace("-","+").replace("_","/")
try:
  claims=json.loads(base64.b64decode(p).decode())
  exp=int(claims.get("exp", 0))
  now=int(time.time())
  # Expirado o expira pronto
  print("0" if (exp - now) > leeway else "1")
except Exception:
  print("1")
PY
}

# CHANGE: Decodifica el payload (claims) de un JWT (JSON Web Token) sin verificar firma.
# Útil para inspeccionar iss (issuer), aud (audience), roles, etc.
decode_jwt_payload() {
  local token="$1"
  T="$token" python3 - <<'PY'
import os, json, base64, sys
t=os.environ.get('T','')
if not t or t.count('.') < 2:
  sys.exit(1)
p=t.split('.')[1]
p += '=' * (-len(p) % 4)
try:
  data=json.loads(base64.urlsafe_b64decode(p))
  print(json.dumps(data, indent=2, sort_keys=True))
except Exception:
  sys.exit(1)
PY
}

# Pide token client_credentials desde dentro de Docker para evitar problemas de red/DNS
get_token_cc_internal() {
  local client_id="$1"
  local client_secret="$2"
  local exec_service="${3:-catalog-api}"  # contenedor desde el que haces la llamada a keycloak:8080

  docker compose exec -T "$exec_service" sh -lc \
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
print(payload.get('access_token',''))
PY"
}

get_or_refresh_token() {
  local name="$1"
  local client_id="$2"
  local client_secret="$3"
  local exec_service="$4"

  local token="${!name:-}"

  # Si no hay token o está expirado/por expirar => regenerar
  local expired="1"
  if [[ -n "${token:-}" ]]; then
    expired="$(T="$token" LEEWAY="30" jwt_expired_or_soon "$token" "30")"
  fi

  if [[ -z "${token:-}" || "$expired" == "1" ]]; then
    token="$(get_token_cc_internal "$client_id" "$client_secret" "$exec_service")"
  fi

  if [[ -z "${token:-}" ]]; then
    echo "[x] No pude obtener token para $client_id" >&2
    exit 1
  fi

  export "$name=$token"
  echo "[v] Token $name OK (len=${#token})"
}

http_code() {
  local url="$1"
  shift
  curl -s -o /dev/null -w '%{http_code}' "$url" "$@"
}

# -----------------------------------------------------------------------------
# Catalog smoke
# -----------------------------------------------------------------------------
echo "[i] 5) Catalog: obtener client secrets"
CAT_CID_WITH="$(get_client_id "$CATALOG_CLIENT_WITH_ROLE")"
CAT_CID_NO="$(get_client_id "$CATALOG_CLIENT_NO_ROLE")"

if [[ -z "$CAT_CID_WITH" || -z "$CAT_CID_NO" ]]; then
  echo "[x] No encuentro alguno de los clientes Catalog: $CATALOG_CLIENT_WITH_ROLE / $CATALOG_CLIENT_NO_ROLE"
  exit 1
fi

CAT_SECRET_WITH="$(get_client_secret "$CAT_CID_WITH")"
CAT_SECRET_NO="$(get_client_secret "$CAT_CID_NO")"

if [[ -z "$CAT_SECRET_WITH" || -z "$CAT_SECRET_NO" ]]; then
  echo "[x] No pude leer secrets de Catalog (¿kcadm login ok? ¿clientes existen?)"
  exit 1
fi
echo "[v] Catalog secrets OK (with=${#CAT_SECRET_WITH} no=${#CAT_SECRET_NO})"

echo "[i] 6) Catalog: tokens (M2M) + checks HTTP"
get_or_refresh_token "TOKEN_CATALOG_WITH" "$CATALOG_CLIENT_WITH_ROLE" "$CAT_SECRET_WITH" "catalog-api"
get_or_refresh_token "TOKEN_CATALOG_NO"   "$CATALOG_CLIENT_NO_ROLE"   "$CAT_SECRET_NO"   "catalog-api"

echo "[i] 6.1) Catalog esperado 200 con rol"
STATUS_200="$(http_code "$CATALOG_PRODUCTS" -H "Authorization: Bearer $TOKEN_CATALOG_WITH")"
echo "[i] HTTP $STATUS_200"
[[ "$STATUS_200" == "200" ]] || exit 1
echo "[v] OK"

echo "[i] 6.2) Catalog esperado 403 sin rol"
STATUS_403="$(http_code "$CATALOG_PRODUCTS" -H "Authorization: Bearer $TOKEN_CATALOG_NO")"
echo "[i] HTTP $STATUS_403"
[[ "$STATUS_403" == "403" ]] || exit 1
echo "[v] OK"

# -----------------------------------------------------------------------------
# Orders smoke
# -----------------------------------------------------------------------------
if [[ "$RUN_ORDERS" == "true" ]]; then
  echo "[i] 7) Orders: obtener client secrets"
  ORD_CID_READER="$(get_client_id "$ORDERS_CLIENT_READER")"
  ORD_CID_WRITER="$(get_client_id "$ORDERS_CLIENT_WRITER")"
  ORD_CID_NOROLE="$(get_client_id "$ORDERS_CLIENT_NOROLE")"

  if [[ -z "$ORD_CID_READER" || -z "$ORD_CID_WRITER" || -z "$ORD_CID_NOROLE" ]]; then
    echo "[x] No encuentro alguno de los clientes Orders:"
    echo "    reader=$ORDERS_CLIENT_READER"
    echo "    writer=$ORDERS_CLIENT_WRITER"
    echo "    norole=$ORDERS_CLIENT_NOROLE"
    exit 1
  fi

  ORD_SECRET_READER="$(get_client_secret "$ORD_CID_READER")"
  ORD_SECRET_WRITER="$(get_client_secret "$ORD_CID_WRITER")"
  ORD_SECRET_NOROLE="$(get_client_secret "$ORD_CID_NOROLE")"

  if [[ -z "$ORD_SECRET_READER" || -z "$ORD_SECRET_WRITER" || -z "$ORD_SECRET_NOROLE" ]]; then
    echo "[x] No pude leer secrets de Orders (¿clientes existen? ¿norole clientId correcto?)"
    exit 1
  fi
  echo "[v] Orders secrets OK (r=${#ORD_SECRET_READER} w=${#ORD_SECRET_WRITER} n=${#ORD_SECRET_NOROLE})"

  echo "[i] 8) Orders: tokens (M2M) + checks HTTP"
  get_or_refresh_token "TOKEN_ORDERS_READER" "$ORDERS_CLIENT_READER" "$ORD_SECRET_READER" "orders-api"
  get_or_refresh_token "TOKEN_ORDERS_WRITER" "$ORDERS_CLIENT_WRITER" "$ORD_SECRET_WRITER" "orders-api"
  get_or_refresh_token "TOKEN_ORDERS_NOROLE" "$ORDERS_CLIENT_NOROLE" "$ORD_SECRET_NOROLE" "orders-api"

  echo "[i] 8.1) Orders esperado 200 con reader"
  S1="$(http_code "$ORDERS_ORDERS" -H "Authorization: Bearer $TOKEN_ORDERS_READER")"
  echo "[i] HTTP $S1"
  [[ "$S1" == "200" ]] || exit 1
  echo "[v] OK"

  echo "[i] 8.2) Orders esperado 200 con writer (misma ruta GET)"
  S2="$(http_code "$ORDERS_ORDERS" -H "Authorization: Bearer $TOKEN_ORDERS_WRITER")"
  echo "[i] HTTP $S2"
  [[ "$S2" == "200" ]] || exit 1
  echo "[v] OK"

  echo "[i] 8.3) Orders esperado 403 sin rol"
  S3="$(http_code "$ORDERS_ORDERS" -H "Authorization: Bearer $TOKEN_ORDERS_NOROLE")"
  echo "[i] HTTP $S3"
  [[ "$S3" == "403" ]] || exit 1
  echo "[v] OK"
fi

echo "[✓] Smoke auth OK"

# -----------------------------------------------------------------------------
# CHANGE: Persistencia opcional de tokens para inspección posterior.
# -----------------------------------------------------------------------------
if [[ "$DUMP_TOKENS" == "true" ]]; then
  mkdir -p .tmp
  chmod 700 .tmp

  # Guardamos SOLO los tokens generados en esta ejecución.
  # Ojo: esto contiene secretos (access tokens). Mantener fuera de Git.
  {
    [[ -n "${TOKEN_CATALOG_WITH:-}" ]] && printf "TOKEN_CATALOG_WITH='%s'\n" "$TOKEN_CATALOG_WITH"
    [[ -n "${TOKEN_CATALOG_NO:-}"   ]] && printf "TOKEN_CATALOG_NO='%s'\n" "$TOKEN_CATALOG_NO"
    [[ -n "${TOKEN_ORDERS_READER:-}" ]] && printf "TOKEN_ORDERS_READER='%s'\n" "$TOKEN_ORDERS_READER"
    [[ -n "${TOKEN_ORDERS_WRITER:-}" ]] && printf "TOKEN_ORDERS_WRITER='%s'\n" "$TOKEN_ORDERS_WRITER"
    [[ -n "${TOKEN_ORDERS_NOROLE:-}" ]] && printf "TOKEN_ORDERS_NOROLE='%s'\n" "$TOKEN_ORDERS_NOROLE"
  } > .tmp/tokens.env

  chmod 600 .tmp/tokens.env
  echo "[i] Tokens guardados en .tmp/tokens.env (chmod 600)"
fi

# CHANGE: Impresión opcional de payloads (claims) para validar iss/aud/roles.
if [[ "$PRINT_PAYLOADS" == "true" ]]; then
  echo "[i] JWT payloads (claims)"

  if [[ -n "${TOKEN_CATALOG_WITH:-}" ]]; then
    echo "==== TOKEN_CATALOG_WITH ===="
    decode_jwt_payload "$TOKEN_CATALOG_WITH" || echo "[!] No pude decodificar TOKEN_CATALOG_WITH"
  fi
  if [[ -n "${TOKEN_CATALOG_NO:-}" ]]; then
    echo "==== TOKEN_CATALOG_NO ===="
    decode_jwt_payload "$TOKEN_CATALOG_NO" || echo "[!] No pude decodificar TOKEN_CATALOG_NO"
  fi
  if [[ -n "${TOKEN_ORDERS_READER:-}" ]]; then
    echo "==== TOKEN_ORDERS_READER ===="
    decode_jwt_payload "$TOKEN_ORDERS_READER" || echo "[!] No pude decodificar TOKEN_ORDERS_READER"
  fi
  if [[ -n "${TOKEN_ORDERS_WRITER:-}" ]]; then
    echo "==== TOKEN_ORDERS_WRITER ===="
    decode_jwt_payload "$TOKEN_ORDERS_WRITER" || echo "[!] No pude decodificar TOKEN_ORDERS_WRITER"
  fi
  if [[ -n "${TOKEN_ORDERS_NOROLE:-}" ]]; then
    echo "==== TOKEN_ORDERS_NOROLE ===="
    decode_jwt_payload "$TOKEN_ORDERS_NOROLE" || echo "[!] No pude decodificar TOKEN_ORDERS_NOROLE"
  fi
fi
