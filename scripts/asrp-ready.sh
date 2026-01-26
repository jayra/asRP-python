#!/usr/bin/env bash
# scripts/asrp-ready.sh
#
# Uso (IMPORTANTE: hay que SOURCEAR para exportar variables):
#   source scripts/asrp-ready.sh catalog-api reader
#   source scripts/asrp-ready.sh catalog-api writer
#
# Hace:
#   1) Carga envs (.env + .env.<service> + .env.<service>.secrets)
#   2) Genera token JWT (JSON Web Token) vía OIDC (OpenID Connect) contra Keycloak
#      desde la red Docker y exporta READER_TOKEN o WRITER_TOKEN.

# ---------------------------------------------------------------------
# [FIX] Guardar opciones actuales del shell (porque este script se sourcea)
#       y restaurarlas al finalizar para no dejar "set -u" activado.
# ---------------------------------------------------------------------
__ASRP_READY_SAVED_OPTS="$(set +o)"

# Si NO está siendo "source", aborta.
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  echo "[asrp-ready] ERROR: ejecuta con: source scripts/asrp-ready.sh <service> <mode>" >&2
  exit 2
fi

# Activamos modo estricto, pero lo restauramos al final (ver trap).
set -u
set -o pipefail

# [FIX] Restaurar opciones al salir (return) del script sourceado
__asrp_restore_opts() {
  # shellcheck disable=SC2086
  eval "${__ASRP_READY_SAVED_OPTS}"
}
trap "__asrp_restore_opts" RETURN

_service="${1:-catalog-api}"
_mode="${2:-reader}"

_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${_root}" || { echo "[asrp-ready] ERROR: no puedo cd al root ${_root}" >&2; return 1; }

_die() { echo "[asrp-ready] ERROR: $*" >&2; return 1; }
_info() { echo "[asrp-ready] $*"; }

# Validación del modo
case "${_mode}" in
  reader|writer) ;;
  *) _die "mode inválido: '${_mode}'. Usa: reader|writer" ;;
esac

# Carga un env file si existe (sin petar si no existe)
_load_env_file() {
  local f="$1"
  if [[ -f "$f" ]]; then
    # shellcheck disable=SC1090
    set -a; source "$f"; set +a
  fi
}

# 1) Cargar envs (orden pro)
_load_env_file ".env"
_load_env_file ".env.${_service}"
_load_env_file ".env.${_service}.secrets"
_load_env_file ".env.secrets"  # opcional

# 2) Variables requeridas para token password-grant (dev)
: "${KC_TOKEN_URL:=}"
: "${KC_CLIENT_ID:=}"
: "${KC_CLIENT_SECRET:=}"

[[ -n "${KC_TOKEN_URL}" ]]      || _die "Falta KC_TOKEN_URL (define en .env.${_service}.secrets o .env.secrets)"
[[ -n "${KC_CLIENT_ID}" ]]      || _die "Falta KC_CLIENT_ID"
[[ -n "${KC_CLIENT_SECRET}" ]]  || _die "Falta KC_CLIENT_SECRET"

# 2.1) Credenciales por modo
if [[ "${_mode}" == "reader" ]]; then
  : "${READER_USER:=}"
  : "${READER_PASS:=}"
  [[ -n "${READER_USER}" ]] || _die "Falta READER_USER"
  [[ -n "${READER_PASS}" ]] || _die "Falta READER_PASS"
  _kc_user="${READER_USER}"
  _kc_pass="${READER_PASS}"
  _export_var="READER_TOKEN"
else
  : "${WRITER_USER:=}"
  : "${WRITER_PASS:=}"
  [[ -n "${WRITER_USER}" ]] || _die "Falta WRITER_USER"
  [[ -n "${WRITER_PASS}" ]] || _die "Falta WRITER_PASS"
  _kc_user="${WRITER_USER}"
  _kc_pass="${WRITER_PASS}"
  _export_var="WRITER_TOKEN"
fi

command -v docker >/dev/null 2>&1  || _die "docker no está disponible en PATH"
command -v python3 >/dev/null 2>&1 || _die "python3 no está disponible en PATH"

# 3) Determinar red Docker (override + autodetección)
_docker_net="${ASRP_DOCKER_NETWORK:-asrp-python_backend}"

if ! docker network inspect "${_docker_net}" >/dev/null 2>&1; then
  _kc_cid="$(docker compose ps -q keycloak 2>/dev/null | head -n 1 || true)"
  if [[ -n "${_kc_cid}" ]]; then
    _docker_net="$(docker inspect -f '{{range $k,$v := .NetworkSettings.Networks}}{{println $k}}{{end}}' "${_kc_cid}" | head -n 1)"
  fi
fi

[[ -n "${_docker_net}" ]] || _die "No pude determinar la red Docker (define ASRP_DOCKER_NETWORK)"
docker network inspect "${_docker_net}" >/dev/null 2>&1 || _die "Red Docker no existe: ${_docker_net}"

# 4) Obtener token desde la red Docker
_token_json="$(
  docker run --rm --network "${_docker_net}" curlimages/curl:8.6.0 -sS \
    -X POST "${KC_TOKEN_URL}" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "grant_type=password" \
    -d "client_id=${KC_CLIENT_ID}" \
    -d "client_secret=${KC_CLIENT_SECRET}" \
    -d "username=${_kc_user}" \
    -d "password=${_kc_pass}"
)" || _die "No pude contactar con KC_TOKEN_URL desde la red Docker (${_docker_net})"

# ---------------------------------------------------------------------
# [FIX] Parseo correcto del JSON:
#       NO usar heredoc + <<< (stdin se pisa). Usamos pipe a python3 -c.
# ---------------------------------------------------------------------
_token="$(
  printf '%s' "${_token_json}" | python3 -c '
import sys, json
raw = sys.stdin.read().strip()
try:
    data = json.loads(raw) if raw else {}
except Exception:
    data = {}
tok = data.get("access_token", "")
if not tok:
    # Si Keycloak devuelve {"error": "..."} lo mostramos para diagnóstico
    err = data.get("error")
    desc = data.get("error_description")
    if err or desc:
        print(f"__ERROR__:{err}:{desc}", end="")
    else:
        print("__ERROR__:no_access_token", end="")
else:
    print(tok, end="")
'
)"

if [[ "${_token}" == __ERROR__:* ]]; then
  # Extraer error legible
  _die "No pude extraer access_token. Respuesta Keycloak: ${_token_json}"
fi

[[ -n "${_token}" ]] || _die "Token vacío (respuesta: ${_token_json})"

# Exportar variable según modo
# shellcheck disable=SC2034
export "${_export_var}=${_token}"

_token_len="$(printf %s "${_token}" | wc -c | tr -d ' ')"
_info "OK root=${_root} service=${_service} mode=${_mode} ${_export_var}_len=${_token_len} docker_net=${_docker_net}"

return 0
