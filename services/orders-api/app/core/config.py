from __future__ import annotations

from typing import List
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=None, extra="ignore")

    # App
    app_name: str = "orders-api"
    environment: str = "local"
    log_level: str = "INFO"

    # CHANGE: versión declarativa (para /health y trazabilidad)
    app_version: str = "0.1.0"

    # CHANGE: CORS (Cross-Origin Resource Sharing) allowlist (CSV)
    cors_allowed_origins: str = "http://localhost:5173"
    cors_allow_credentials: bool = False

    def cors_origins_list(self) -> List[str]:
        return [x.strip() for x in self.cors_allowed_origins.split(",") if x.strip()]

    # DB
    db_host: str = "orders-db"
    db_port: int = 5432
    db_name: str = "orders_db"
    db_user: str = "orders_app"
    db_password: str = ""  # [SECURITY] viene de .env.orders-api.secrets

    # OIDC / JWT
    oidc_discovery_url: str = "http://keycloak.localtest.me:8080/realms/asrp/.well-known/openid-configuration"
    oidc_issuer_expected: str = "http://keycloak.localtest.me:8080/realms/asrp"
    oidc_audience: str = "asrp-orders"
    oidc_leeway_seconds: int = 10

    # CHANGE: algoritmos como CSV pero con helper a lista (enterprise)
    oidc_algorithms: str = "RS256"  # Comma-separated, e.g. "RS256,PS256"

    def oidc_algorithms_list(self) -> List[str]:
        return [x.strip() for x in self.oidc_algorithms.split(",") if x.strip()]

    # CHANGE: cache/timeout OIDC (enterprise)
    oidc_discovery_cache_seconds: int = 300
    oidc_jwks_cache_seconds: int = 300
    oidc_http_timeout_seconds: float = 3.0

    # RBAC
    rbac_client_id: str = "asrp-orders"  # resource_access.<client>.roles

    def sqlalchemy_url(self) -> str:
        # [SECURITY] No loguear password nunca
        return (
            f"postgresql+psycopg://{self.db_user}:{self.db_password}"
            f"@{self.db_host}:{self.db_port}/{self.db_name}"
        )


settings = Settings()
