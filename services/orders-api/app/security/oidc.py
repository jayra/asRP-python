import time
from dataclasses import dataclass
from typing import Any, Dict, List, Optional

import httpx
import jwt  # PyJWT
from jwt import PyJWKClient

from app.core.config import settings


@dataclass(frozen=True)
class TokenClaims:
    raw: Dict[str, Any]

    @property
    def issuer(self) -> str:
        return str(self.raw.get("iss", ""))

    @property
    def audience(self) -> Any:
        return self.raw.get("aud")

    @property
    def resource_access(self) -> Dict[str, Any]:
        return self.raw.get("resource_access") or {}

    def client_roles(self, client_id: str) -> List[str]:
        roles = (self.resource_access.get(client_id) or {}).get("roles")
        return roles if isinstance(roles, list) else []


class OIDCVerifier:
    """
    [ENTERPRISE] Verificador OIDC con discovery + JWKS caching.
    """

    def __init__(self) -> None:
        self._jwks_client: Optional[PyJWKClient] = None
        self._jwks_uri: Optional[str] = None
        self._last_discovery_ts: float = 0.0

    def _ensure_discovery(self) -> None:
        # [ENTERPRISE] Cache discovery por 5 min para evitar golpear Keycloak
        now = time.time()
        if self._jwks_uri and (now - self._last_discovery_ts) < 300:
            return

        resp = httpx.get(settings.oidc_discovery_url, timeout=5.0)
        resp.raise_for_status()
        doc = resp.json()
        jwks_uri = doc.get("jwks_uri")
        if not jwks_uri:
            raise RuntimeError("OIDC discovery missing jwks_uri")

        self._jwks_uri = jwks_uri
        self._jwks_client = PyJWKClient(jwks_uri)
        self._last_discovery_ts = now

    def verify_bearer(self, token: str) -> TokenClaims:
        self._ensure_discovery()
        assert self._jwks_client is not None

        signing_key = self._jwks_client.get_signing_key_from_jwt(token).key

        claims = jwt.decode(
            token,
            signing_key,
            algorithms=[a.strip() for a in settings.oidc_algorithms.split(",") if a.strip()],
            issuer=settings.oidc_issuer_expected,
            audience=None,  # [ENTERPRISE] Validamos roles; aud la validará gateway si queremos
            leeway=settings.oidc_leeway_seconds,
            options={"verify_aud": False},
        )
        return TokenClaims(raw=claims)


oidc_verifier = OIDCVerifier()
