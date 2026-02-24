# services/catalog-api/app/core/security.py
from __future__ import annotations

import os
import time
from typing import Any, Dict, List, Optional

import httpx
import jwt
from jwt import PyJWKClient
from jwt.exceptions import PyJWTError

from app.core.config import settings
from app.core.logging import get_logger

logger = get_logger(__name__)


class OIDCJWKSVerifier:
    """
    Verifies JWT (JSON Web Token) access tokens signed by Keycloak using the realm JWKS (JSON Web Key Set).

    A1 (PyJWT):
    - Use PyJWT + PyJWKClient to unify behavior with orders-api.
    - Prefer OIDC_JWKS_URL (internal, e.g. http://keycloak:8080/...) to avoid DNS issues inside Docker/K8s.
    - Validate issuer (iss) strictly against settings.oidc_issuer_expected.
    - Validate audience (aud) against settings.oidc_audience.
    """

    def __init__(self, discovery_url: str, *, jwks_url_override: Optional[str] = None) -> None:
        self._discovery_url = (discovery_url or "").strip()
        self._jwks_url_override = (jwks_url_override or "").strip() or None

        self._oidc_cache: Dict[str, Any] = {"config": None, "fetched_at": 0.0}
        self._jwk_cache: Dict[str, Any] = {"client": None, "jwks_url": None, "fetched_at": 0.0}

    async def _fetch_oidc_config(self) -> Dict[str, Any]:
        # [FIX] discovery cacheado
        now = time.time()
        ttl = getattr(settings, "oidc_discovery_cache_seconds", 300)

        if self._oidc_cache["config"] and (now - self._oidc_cache["fetched_at"]) < ttl:
            return self._oidc_cache["config"]

        async with httpx.AsyncClient(timeout=getattr(settings, "oidc_http_timeout_seconds", 3.0)) as client:
            r = await client.get(self._discovery_url)
            r.raise_for_status()
            cfg = r.json()

        self._oidc_cache["config"] = cfg
        self._oidc_cache["fetched_at"] = now
        return cfg

    async def _get_jwks_url(self) -> str:
        # [FIX] Prioriza override explícito (env OIDC_JWKS_URL típico en prodlike)
        override = self._jwks_url_override or (os.getenv("OIDC_JWKS_URL", "").strip() or None)
        if override:
            return override.rstrip("/")

        cfg = await self._fetch_oidc_config()
        jwks_uri = cfg.get("jwks_uri")
        if isinstance(jwks_uri, str) and jwks_uri.strip():
            return jwks_uri.strip().rstrip("/")

        # Fallback razonable
        return f"{settings.oidc_issuer_expected.rstrip('/')}/protocol/openid-connect/certs"

    async def _get_jwk_client(self) -> PyJWKClient:
        # [FIX] cache PyJWKClient por jwks_url + TTL
        now = time.time()
        ttl = getattr(settings, "oidc_jwks_cache_seconds", 300)
        jwks_url = await self._get_jwks_url()

        if (
            self._jwk_cache["client"] is not None
            and self._jwk_cache["jwks_url"] == jwks_url
            and (now - self._jwk_cache["fetched_at"]) < ttl
        ):
            return self._jwk_cache["client"]

        client = PyJWKClient(jwks_url)
        self._jwk_cache["client"] = client
        self._jwk_cache["jwks_url"] = jwks_url
        self._jwk_cache["fetched_at"] = now
        return client

    async def decode_and_verify(
        self,
        token: str,
        *,
        audience_expected: str,
        issuer_expected: str,
        leeway_seconds: int = 10,
        algorithms: Optional[List[str]] = None,
    ) -> Dict[str, Any]:
        token = (token or "").strip()
        if not token:
            raise PyJWTError("Empty token")

        algorithms = algorithms or settings.oidc_algorithms_list
        issuer_expected = (issuer_expected or "").rstrip("/")

        jwk_client = await self._get_jwk_client()
        signing_key = jwk_client.get_signing_key_from_jwt(token).key

        # PyJWT valida aud/iss/exp con leeway nativo (enterprise-friendly)
        claims = jwt.decode(
            token,
            signing_key,
            algorithms=algorithms,
            audience=audience_expected,
            issuer=issuer_expected,
            leeway=leeway_seconds,
            options={"verify_signature": True, "verify_aud": True, "verify_iss": True, "verify_exp": True},
        )
        return claims
