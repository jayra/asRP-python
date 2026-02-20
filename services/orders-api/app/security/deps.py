from __future__ import annotations

import time
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


def _get_request_id(request: Request) -> Optional[str]:
    return getattr(request.state, "request_id", None)


def _unauthorized(request_id: Optional[str], message: str) -> HTTPException:
    # CHANGE: 401 homogéneo + WWW-Authenticate (enterprise API hygiene)
    return HTTPException(
        status_code=401,
        detail={"error": "unauthorized", "message": message, "requestId": request_id},
        headers={"WWW-Authenticate": 'Bearer realm="asrp"'},
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


def _extract_roles(payload: Dict[str, Any]) -> List[str]:
    """
    Keycloak típico:
      resource_access: { "<client>": { roles: [...] } }
    """
    roles: List[str] = []

    ra = payload.get("resource_access") or {}
    if isinstance(ra, dict):
        client_block = ra.get(settings.rbac_client_id) or {}
        if isinstance(client_block, dict):
            r = client_block.get("roles") or []
            if isinstance(r, list):
                roles.extend([str(x) for x in r])

    # Opcional: realm roles (si algún día decides usarlos)
    realm_access = payload.get("realm_access") or {}
    if isinstance(realm_access, dict):
        rr = realm_access.get("roles") or []
        if isinstance(rr, list):
            roles.extend([str(x) for x in rr])

    # De-dup manteniendo orden
    seen = set()
    out = []
    for r in roles:
        if r not in seen:
            seen.add(r)
            out.append(r)
    return out


def _get_bearer_token(request: Request) -> str:
    auth = request.headers.get("authorization") or ""
    if not auth.lower().startswith("bearer "):
        raise _unauthorized(_get_request_id(request), "Missing Bearer token")
    token = auth.split(" ", 1)[1].strip()
    if not token:
        raise _unauthorized(_get_request_id(request), "Empty Bearer token")
    return token


def _verify_jwt(token: str, request: Request) -> Dict[str, Any]:
    request_id = _get_request_id(request)

    try:
        jwk_client = _get_jwk_client()
        signing_key = jwk_client.get_signing_key_from_jwt(token).key

        options = {
            "require": ["exp", "iat", "iss"],
            "verify_signature": True,
            "verify_exp": True,
            "verify_iat": True,
            "verify_iss": True,
            "verify_aud": bool(settings.oidc_audience),
        }

        payload = jwt.decode(
            token,
            signing_key,
            algorithms=settings.oidc_algorithms_list(),  # CHANGE: lista de algoritmos permitidos
            issuer=settings.oidc_issuer_expected,
            audience=settings.oidc_audience if settings.oidc_audience else None,
            options=options,
            leeway=settings.oidc_leeway_seconds,
        )

        if not isinstance(payload, dict):
            raise _unauthorized(request_id, "Invalid token payload")

        return payload

    except ExpiredSignatureError:
        raise _unauthorized(request_id, "Token expired")
    except InvalidAudienceError:
        # CHANGE: token válido pero no para esta API -> 403 (audience mismatch)
        raise _forbidden(request_id, "Token audience not allowed for this API")
    except InvalidIssuerError:
        raise _unauthorized(request_id, "Invalid token issuer")
    except InvalidSignatureError:
        raise _unauthorized(request_id, "Invalid token signature")
    except PyJWTError:
        raise _unauthorized(request_id, "Invalid token")
    except Exception:
        logger.exception("JWT verification error", extra={"requestId": request_id})
        raise _unauthorized(request_id, "Invalid token")


def require_role(role: str):
    """
    Dependency factory.
    - 401: token missing/invalid
    - 403: token ok pero sin rol
    """

    def _dep(request: Request) -> Dict[str, Any]:
        token = _get_bearer_token(request)
        payload = _verify_jwt(token, request)
        roles = _extract_roles(payload)

        # Guardamos en request.state para logs/handlers (enterprise observability)
        request.state.jwt = payload
        request.state.roles = roles

        if role not in roles:
            raise _forbidden(_get_request_id(request), f"Missing required role: {role}")

        return payload

    return _dep
