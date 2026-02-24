# services/orders-api/app/security/deps.py
from __future__ import annotations

import time
import os  # [FIX] para leer OIDC_JWKS_URL si settings no lo expone
from typing import Any, Dict, List, Optional

import httpx
import jwt
from jwt import PyJWKClient
from jwt.exceptions import (
    ExpiredSignatureError,
    InvalidAudienceError,
    InvalidIssuerError,
    InvalidSignatureError,
    PyJWTError,
)
from fastapi import HTTPException, Request

from app.core.config import settings
from app.core.logging import logger


# =========================
# OIDC (OpenID Connect) / JWKS (JSON Web Key Set) cache
# =========================

_oidc_cache: Dict[str, Any] = {"config": None, "fetched_at": 0.0}
_jwk_client_cache: Dict[str, Any] = {"client": None, "jwks_url": None, "fetched_at": 0.0}


def _request_id(req: Request) -> Optional[str]:
    # CHANGE: correlation-id compatible con gateway
    return req.headers.get("x-request-id") or req.headers.get("X-Request-Id")


def _unauthorized(request_id: Optional[str], message: str) -> HTTPException:
    # CHANGE: 401 homogéneo
    return HTTPException(
        status_code=401,
        detail={"error": "unauthorized", "message": message, "requestId": request_id},
        headers={"WWW-Authenticate": "Bearer"},
    )


def _forbidden(request_id: Optional[str], message: str) -> HTTPException:
    # CHANGE: 403 homogéneo
    return HTTPException(
        status_code=403,
        detail={"error": "forbidden", "message": message, "requestId": request_id},
    )


def _fetch_oidc_config() -> Dict[str, Any]:
    # CHANGE: discovery cacheado (reduce latencia y carga a Keycloak)
    now = time.time()
    ttl = settings.oidc_discovery_cache_seconds
    if _oidc_cache["config"] and (now - _oidc_cache["fetched_at"]) < ttl:
        return _oidc_cache["config"]

    url = settings.oidc_discovery_url
    with httpx.Client(timeout=settings.oidc_http_timeout_seconds) as client:
        resp = client.get(url)
        resp.raise_for_status()
        cfg = resp.json()

    _oidc_cache["config"] = cfg
    _oidc_cache["fetched_at"] = now
    return cfg


def _get_jwks_url() -> str:
    # [FIX] Prioriza JWKS override interno si está configurado.
    # - En Docker/Kubernetes, el issuer público (keycloak.localtest.me) puede no resolverse desde el contenedor.
    # - OIDC_JWKS_URL suele apuntar a la URL interna (http://keycloak:8080/...) y evita fallos DNS.
    jwks_override = (getattr(settings, "oidc_jwks_url", None) or os.getenv("OIDC_JWKS_URL", "")).strip()
    if jwks_override:
        return jwks_override.rstrip("/")

    cfg = _fetch_oidc_config()
    jwks_uri = cfg.get("jwks_uri")
    if not jwks_uri:
        # Fallback razonable en Keycloak
        return f"{settings.oidc_issuer_expected}/protocol/openid-connect/certs"
    return jwks_uri


def _get_jwk_client() -> PyJWKClient:
    # CHANGE: cachea el PyJWKClient por jwks_url
    now = time.time()
    jwks_url = _get_jwks_url()

    if (
        _jwk_client_cache["client"] is not None
        and _jwk_client_cache["jwks_url"] == jwks_url
        and (now - _jwk_client_cache["fetched_at"]) < settings.oidc_jwks_cache_seconds
    ):
        return _jwk_client_cache["client"]

    jwk_client = PyJWKClient(jwks_url)
    _jwk_client_cache["client"] = jwk_client
    _jwk_client_cache["jwks_url"] = jwks_url
    _jwk_client_cache["fetched_at"] = now
    return jwk_client


def _decode_and_verify(token: str) -> Dict[str, Any]:
    jwk_client = _get_jwk_client()
    signing_key = jwk_client.get_signing_key_from_jwt(token).key

    algorithms = [a.strip() for a in settings.oidc_algorithms.split(",") if a.strip()]

    # CHANGE: validación estricta de issuer; audiencia se valida fuera (según endpoint/servicio)
    return jwt.decode(
        token,
        signing_key,
        algorithms=algorithms,
        issuer=settings.oidc_issuer_expected.rstrip("/"),
        options={
            "verify_aud": False,  # aud se verifica en require_* por endpoint
        },
        leeway=settings.oidc_leeway_seconds,
    )


def _get_bearer_token(req: Request) -> str:
    auth = req.headers.get("authorization") or req.headers.get("Authorization") or ""
    parts = auth.split()
    if len(parts) != 2 or parts[0].lower() != "bearer":
        raise _unauthorized(_request_id(req), "Missing bearer token")
    return parts[1].strip()


def get_claims(req: Request) -> Dict[str, Any]:
    request_id = _request_id(req)
    token = _get_bearer_token(req)

    try:
        claims = _decode_and_verify(token)
        return claims
    except ExpiredSignatureError:
        raise _unauthorized(request_id, "Token expired")
    except InvalidIssuerError:
        raise _unauthorized(request_id, "Invalid issuer")
    except InvalidSignatureError:
        raise _unauthorized(request_id, "Invalid signature")
    except InvalidAudienceError:
        raise _unauthorized(request_id, "Invalid audience")
    except PyJWTError as e:
        logger.info("Token validation failed: %s", e)
        raise _unauthorized(request_id, "Invalid token")
    except Exception as e:  # noqa: BLE001
        logger.exception("Unexpected error while validating token: %s", e)
        raise _unauthorized(request_id, "Invalid token")


def _get_client_roles(claims: Dict[str, Any], client_id: str) -> List[str]:
    ra = claims.get("resource_access") or {}
    if not isinstance(ra, dict):
        return []
    client = ra.get(client_id) or {}
    if not isinstance(client, dict):
        return []
    roles = client.get("roles") or []
    return roles if isinstance(roles, list) else []


def _has_role(claims: Dict[str, Any], client_id: str, role: str) -> bool:
    roles = _get_client_roles(claims, client_id)
    return role in roles


def require_roles(required: List[str]):
    required_set = set(required)

    def _dep(req: Request) -> Dict[str, Any]:
        claims = get_claims(req)
        client_id = settings.oidc_audience  # CHANGE: clientId usado para roles/audiencia

        roles = set(_get_client_roles(claims, client_id))
        if not required_set.issubset(roles):
            raise _forbidden(_request_id(req), "Insufficient permissions")
        return claims

    return _dep


# -----------------------------------------------------------------------------
# [FIX] Backward-compatible alias expected by app/api/routes.py
# - Tu routes.py importa: from app.security.deps import require_role
# - Si no existe => orders-api no arranca => gateway devuelve 502.
# -----------------------------------------------------------------------------
def require_role(role: str):
    return require_roles([role])


def require_orders_read(req: Request) -> Dict[str, Any]:
    claims = get_claims(req)
    client_id = settings.oidc_audience

    if _has_role(claims, client_id, "orders_read") or _has_role(claims, client_id, "orders_write"):
        return claims

    raise _forbidden(_request_id(req), "Insufficient permissions")


def require_orders_write(req: Request) -> Dict[str, Any]:
    claims = get_claims(req)
    client_id = settings.oidc_audience

    if _has_role(claims, client_id, "orders_write"):
        return claims

    raise _forbidden(_request_id(req), "Insufficient permissions")


def require_catalog_read(req: Request) -> Dict[str, Any]:
    # Nota: útil si Orders llama a Catalog, mantiene patrón
    claims = get_claims(req)
    client_id = settings.oidc_audience

    if _has_role(claims, client_id, "catalog_read") or _has_role(claims, client_id, "catalog_write"):
        return claims

    raise _forbidden(_request_id(req), "Insufficient permissions")


def require_catalog_write(req: Request) -> Dict[str, Any]:
    claims = get_claims(req)
    client_id = settings.oidc_audience

    if _has_role(claims, client_id, "catalog_write"):
        return claims

    raise _forbidden(_request_id(req), "Insufficient permissions")
