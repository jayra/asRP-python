from __future__ import annotations

import time
from typing import Any, Dict, Optional

import httpx
from jose import jwt
from jose.exceptions import JWTClaimsError, JWTError

from app.core.config import settings
from app.core.logging import get_logger

logger = get_logger(__name__)


class OIDCJWKSVerifier:
    """
    Verifies JWT (JSON Web Token) access tokens signed by Keycloak using the realm JWKS (JSON Web Key Set).

    Design notes:
    - We fetch OIDC (OpenID Connect) discovery from settings.oidc_discovery_url (internal URL).
    - We validate issuer against settings.oidc_issuer_expected (public URL) to match the token's iss claim.
    - python-jose does NOT support PyJWT's `leeway` parameter; we apply leeway manually for exp/nbf.
    """

    def __init__(self, discovery_url: str) -> None:
        self._discovery_url = discovery_url
        self._jwks_uri: Optional[str] = None
        self._jwks_cache: Optional[Dict[str, Any]] = None
        self._jwks_cache_ts: float = 0.0
        self._jwks_cache_ttl_seconds: int = 300  # 5 minutes

    async def _get_jwks_uri(self) -> str:
        if self._jwks_uri:
            return self._jwks_uri

        async with httpx.AsyncClient(timeout=10.0) as client:
            r = await client.get(self._discovery_url)
            r.raise_for_status()
            data = r.json()

        jwks_uri = data.get("jwks_uri")
        if not jwks_uri or not isinstance(jwks_uri, str):
            raise RuntimeError("OIDC discovery missing jwks_uri")

        self._jwks_uri = jwks_uri
        return jwks_uri

    async def _get_jwks(self) -> Dict[str, Any]:
        now = time.time()
        if self._jwks_cache and (now - self._jwks_cache_ts) < self._jwks_cache_ttl_seconds:
            return self._jwks_cache

        jwks_uri = await self._get_jwks_uri()
        async with httpx.AsyncClient(timeout=10.0) as client:
            r = await client.get(jwks_uri)
            r.raise_for_status()
            jwks = r.json()

        if not isinstance(jwks, dict) or "keys" not in jwks:
            raise RuntimeError("Invalid JWKS response")

        self._jwks_cache = jwks
        self._jwks_cache_ts = now
        return jwks

    @staticmethod
    def _pick_key(jwks: Dict[str, Any], kid: str) -> Dict[str, Any]:
        keys = jwks.get("keys", [])
        if not isinstance(keys, list):
            raise RuntimeError("JWKS keys is not a list")

        for k in keys:
            if isinstance(k, dict) and k.get("kid") == kid:
                return k

        raise RuntimeError(f"Signing key not found for kid={kid!r}")

    @staticmethod
    def _manual_time_claim_checks(claims: Dict[str, Any], leeway_seconds: int) -> None:
        now = int(time.time())

        # exp: token must not be expired (allow leeway)
        exp = claims.get("exp")
        if exp is not None:
            try:
                exp_i = int(exp)
            except Exception as e:  # noqa: BLE001
                raise JWTClaimsError("Invalid exp claim") from e
            if now > (exp_i + leeway_seconds):
                raise JWTClaimsError("Token has expired")

        # nbf: token must be valid yet (allow leeway)
        nbf = claims.get("nbf")
        if nbf is not None:
            try:
                nbf_i = int(nbf)
            except Exception as e:  # noqa: BLE001
                raise JWTClaimsError("Invalid nbf claim") from e
            if now < (nbf_i - leeway_seconds):
                raise JWTClaimsError("Token not yet valid (nbf)")

    async def decode_and_verify(
        self,
        token: str,
        *,
        audience_expected: str,
        issuer_expected: str,
        leeway_seconds: int = 10,
        algorithms: Optional[list[str]] = None,
    ) -> Dict[str, Any]:
        """
        Decode and verify a JWT access token, returning its claims.

        Raises jose.exceptions.JWTError/JWTClaimsError on validation errors.
        """
        token = (token or "").strip()
        if not token:
            raise JWTError("Empty token")

        algorithms = algorithms or settings.oidc_algorithms_list

        # Read header to select the correct signing key (kid).
        try:
            header = jwt.get_unverified_header(token)
        except Exception as e:  # noqa: BLE001
            raise JWTError("Invalid JWT header") from e

        kid = header.get("kid")
        if not kid:
            raise JWTError("Missing kid in JWT header")

        jwks = await self._get_jwks()
        key = self._pick_key(jwks, kid)

        # python-jose has no `leeway` kwarg; do exp/nbf checks ourselves with tolerance.
        options = {
            "verify_signature": True,
            "verify_aud": True,
            "verify_iss": True,
            "verify_exp": False,
            "verify_nbf": False,
        }

        claims = jwt.decode(
            token,
            key,
            algorithms=algorithms,
            audience=audience_expected,
            issuer=issuer_expected.rstrip("/"),
            options=options,
        )

        self._manual_time_claim_checks(claims, leeway_seconds)
        return claims
