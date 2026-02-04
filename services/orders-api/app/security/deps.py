from fastapi import Depends, HTTPException, Request, status

from app.core.config import settings
from app.security.oidc import TokenClaims, oidc_verifier


def get_bearer_token(request: Request) -> str:
    auth = request.headers.get("authorization", "")
    if not auth.lower().startswith("bearer "):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Missing bearer token")
    return auth.split(" ", 1)[1].strip()


def get_claims(token: str = Depends(get_bearer_token)) -> TokenClaims:
    try:
        return oidc_verifier.verify_bearer(token)
    except Exception:
        # [SECURITY] No filtramos detalles de validación al cliente
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid token")


def require_role(role_name: str):
    def _inner(claims: TokenClaims = Depends(get_claims)) -> TokenClaims:
        roles = claims.client_roles(settings.rbac_client_id)
        if role_name not in roles:
            raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Insufficient permissions")
        return claims

    return _inner
