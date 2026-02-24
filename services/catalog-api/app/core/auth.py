# services/catalog-api/app/core/auth.py
from __future__ import annotations

from typing import Any, Dict, Iterable, Optional

from fastapi import Depends, HTTPException, Request, status
from jwt.exceptions import (
    ExpiredSignatureError,
    InvalidAudienceError,
    InvalidIssuerError,
    PyJWTError,
)

from app.core.config import settings
from app.core.logging import get_logger
from app.core.security import OIDCJWKSVerifier

logger = get_logger(__name__)


def _normalize_discovery_url(raw: str) -> str:
    raw = (raw or "").rstrip("/")
    if raw.endswith("/.well-known/openid-configuration"):
        return raw
    return f"{raw}/.well-known/openid-configuration"


# [FIX] Verificador PyJWT unificado con Orders, soporta OIDC_JWKS_URL (interno)
_verifier = OIDCJWKSVerifier(
    _normalize_discovery_url(settings.oidc_discovery_url),
    jwks_url_override=getattr(settings, "oidc_jwks_url", None),
)


def _parse_bearer(auth_header: Optional[str]) -> Optional[str]:
    if not auth_header:
        return None
    parts = auth_header.strip().split(None, 1)
    if len(parts) != 2:
        return None
    scheme, token = parts[0], parts[1]
    if scheme.lower() != "bearer":
        return None
    return token.strip() or None


async def get_bearer_token(request: Request) -> str:
    token = _parse_bearer(request.headers.get("Authorization"))
    if not token:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Missing bearer token",
            headers={"WWW-Authenticate": "Bearer"},
        )
    return token


async def get_current_claims(token: str = Depends(get_bearer_token)) -> Dict[str, Any]:
    try:
        return await _verifier.decode_and_verify(
            token,
            audience_expected=settings.oidc_audience,
            issuer_expected=settings.oidc_issuer_expected,
            leeway_seconds=settings.oidc_leeway_seconds,
            algorithms=settings.oidc_algorithms_list,
        )
    except (ExpiredSignatureError, InvalidIssuerError, InvalidAudienceError, PyJWTError) as e:
        logger.info("Token validation failed: %s", e)
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token",
            headers={"WWW-Authenticate": "Bearer"},
        ) from e
    except Exception as e:  # noqa: BLE001
        logger.exception("Unexpected error while validating token: %s", e)
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token",
            headers={"WWW-Authenticate": "Bearer"},
        ) from e


def get_client_roles(claims: Dict[str, Any], client_id: str) -> set[str]:
    resource_access = claims.get("resource_access", {}) or {}
    client_access = resource_access.get(client_id, {}) if isinstance(resource_access, dict) else {}
    roles = client_access.get("roles", []) if isinstance(client_access, dict) else []
    if not isinstance(roles, list):
        return set()
    return {str(r) for r in roles}


def require_roles(required: Iterable[str]):
    required_set = {str(r) for r in required}

    async def _dependency(claims: Dict[str, Any] = Depends(get_current_claims)) -> Dict[str, Any]:
        roles = get_client_roles(claims, settings.oidc_audience)
        if not required_set.issubset(roles):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions",
            )
        return claims

    return _dependency
