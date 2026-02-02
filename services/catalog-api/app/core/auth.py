from __future__ import annotations

from typing import Any, Dict, Iterable, Optional

from fastapi import Depends, HTTPException, Request, status
from jose.exceptions import JWTClaimsError, JWTError

from app.core.config import settings
from app.core.logging import get_logger
from app.core.security import OIDCJWKSVerifier

logger = get_logger(__name__)


def _normalize_discovery_url(raw: str) -> str:
    """
    Normalize OIDC discovery URL.

    Keycloak OIDC discovery endpoint is:
      <base>/realms/<realm>/.well-known/openid-configuration

    Some env_files mistakenly provide only:
      <base>/realms/<realm>

    This normalization makes the service resilient and avoids 401 "Invalid token"
    caused by failing to resolve jwks_uri.
    """
    raw = (raw or "").rstrip("/")
    if raw.endswith("/.well-known/openid-configuration"):
        return raw
    # --- FIX: si llega el realm base, añadimos el suffix estándar de OIDC discovery ---
    return f"{raw}/.well-known/openid-configuration"


# --- FIX: normalizamos el discovery URL antes de crear el verificador ---
_verifier = OIDCJWKSVerifier(_normalize_discovery_url(settings.oidc_discovery_url))


def _parse_bearer(auth_header: Optional[str]) -> Optional[str]:
    """
    Extract the bearer token from the Authorization header.

    Accepts any casing for the scheme ("Bearer", "bearer", ...).
    """
    if not auth_header:
        return None

    parts = auth_header.strip().split(None, 1)
    if len(parts) != 2:
        return None

    scheme, token = parts[0], parts[1]
    if scheme.lower() != "bearer":
        return None

    token = token.strip()
    return token or None


async def get_bearer_token(request: Request) -> str:
    """
    Dependency that returns the raw access token from the Authorization header.
    """
    token = _parse_bearer(request.headers.get("Authorization"))
    if not token:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Missing bearer token",
            headers={"WWW-Authenticate": "Bearer"},
        )
    return token


async def get_current_claims(token: str = Depends(get_bearer_token)) -> Dict[str, Any]:
    """
    Dependency that validates the access token and returns its claims.
    """
    try:
        return await _verifier.decode_and_verify(
            token,
            audience_expected=settings.oidc_audience,
            issuer_expected=settings.oidc_issuer_expected,
            leeway_seconds=settings.oidc_leeway_seconds,
            algorithms=settings.oidc_algorithms_list,
        )
    except (JWTClaimsError, JWTError) as e:
        # Keep response intentionally generic (do not leak verification details).
        logger.info("Token validation failed: %s", e)
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token",
            headers={"WWW-Authenticate": "Bearer"},
        ) from e
    except Exception as e:  # noqa: BLE001
        # Keep response generic; log retains details for operators.
        logger.exception("Unexpected error while validating token: %s", e)  # --- FIX: log más informativo ---
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token",
            headers={"WWW-Authenticate": "Bearer"},
        ) from e


def get_client_roles(claims: Dict[str, Any], client_id: str) -> set[str]:
    """
    Extract client roles from Keycloak's resource_access claim.
    """
    resource_access = claims.get("resource_access", {}) or {}
    client_access = resource_access.get(client_id, {}) if isinstance(resource_access, dict) else {}
    roles = client_access.get("roles", []) if isinstance(client_access, dict) else []
    if not isinstance(roles, list):
        return set()
    return {str(r) for r in roles}


def require_roles(required: Iterable[str]):
    """
    Dependency factory enforcing RBAC (Role-Based Access Control) using Keycloak client roles.

    Example:
        @router.get("/v1/products", dependencies=[Depends(require_roles(["catalog_read"]))])
    """
    required_set = {str(r) for r in required}

    async def _dependency(claims: Dict[str, Any] = Depends(get_current_claims)) -> Dict[str, Any]:
        roles = get_client_roles(claims, settings.oidc_audience)

        # --- FIX (RBAC): comprobar roles del cliente ---
        if not required_set.issubset(roles):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions",
            )
        return claims

    return _dependency
