# services/orders-api/app/core/config.py
from __future__ import annotations

from typing import List, Optional

from pydantic import Field, AliasChoices
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """
    Enterprise Settings (Orders API)

    Goals:
    - Same contract as catalog-api (support OIDC_* overrides + legacy defaults)
    - Deterministic behavior in Docker/Kubernetes:
        - issuer_expected (public) can differ from internal Keycloak DNS
        - JWKS/discovery should be fetched via internal address (keycloak:8080)
    - Keep backward compatibility with existing variable names and defaults.
    """

    model_config = SettingsConfigDict(env_file=None, extra="ignore")  # keeps behavior stable in Docker

    # -------------------------------------------------------------------------
    # App
    # -------------------------------------------------------------------------
    app_name: str = Field(default="orders-api", validation_alias=AliasChoices("APP_NAME"))
    service_name: str = Field(default="orders-api", validation_alias=AliasChoices("SERVICE_NAME"))  # [FIX] homogéneo
    environment: str = Field(default="local", validation_alias=AliasChoices("ASRP_ENV", "ENVIRONMENT"))  # [FIX] prodlike/local
    log_level: str = Field(default="INFO", validation_alias=AliasChoices("LOG_LEVEL"))
    log_format: str = Field(default="json", validation_alias=AliasChoices("LOG_FORMAT"))  # [FIX] homogéneo con gateway
    request_id_header: str = Field(
        default="X-Request-Id",
        validation_alias=AliasChoices("REQUEST_ID_HEADER"),
    )  # [FIX] correlation-id

    # Versión declarativa (para /health y trazabilidad)
    app_version: str = Field(default="0.1.0", validation_alias=AliasChoices("APP_VERSION"))

    # -------------------------------------------------------------------------
    # CORS (Cross-Origin Resource Sharing)
    # -------------------------------------------------------------------------
    cors_allowed_origins: str = Field(
        default="http://localhost:5173",
        validation_alias=AliasChoices("CORS_ALLOWED_ORIGINS"),
    )
    cors_allow_credentials: bool = Field(
        default=False,
        validation_alias=AliasChoices("CORS_ALLOW_CREDENTIALS"),
    )

    def cors_origins_list(self) -> List[str]:
        return [x.strip() for x in self.cors_allowed_origins.split(",") if x.strip()]

    # -------------------------------------------------------------------------
    # Database
    # -------------------------------------------------------------------------
    db_host: str = Field(default="orders-db", validation_alias=AliasChoices("DB_HOST"))
    db_port: int = Field(default=5432, validation_alias=AliasChoices("DB_PORT"))
    db_name: str = Field(default="orders_db", validation_alias=AliasChoices("DB_NAME"))
    db_user: str = Field(default="orders_app", validation_alias=AliasChoices("DB_USER"))
    db_password: str = Field(default="", validation_alias=AliasChoices("DB_PASSWORD"))  # [SECURITY] de secretos

    def sqlalchemy_url(self) -> str:
        # [SECURITY] No loguear password nunca
        return (
            f"postgresql+psycopg://{self.db_user}:{self.db_password}"
            f"@{self.db_host}:{self.db_port}/{self.db_name}"
        )

    # -------------------------------------------------------------------------
    # OIDC (OpenID Connect) / JWT (JSON Web Token)
    # -------------------------------------------------------------------------
    oidc_realm: str = Field(
        default="asrp",
        validation_alias=AliasChoices("KEYCLOAK_REALM", "OIDC_REALM"),
    )

    # Internal URL (reachable from Docker network)
    oidc_internal_base_url: str = Field(
        default="http://keycloak:8080",
        validation_alias=AliasChoices("KEYCLOAK_INTERNAL_BASE_URL", "OIDC_INTERNAL_BASE_URL"),
    )

    # Public URL base (issuer used by tokens minted via public URL)
    oidc_public_base_url: str = Field(
        default="http://localhost:8080",
        validation_alias=AliasChoices("KEYCLOAK_PUBLIC_BASE_URL", "OIDC_PUBLIC_BASE_URL"),
    )

    # [FIX] OIDC overrides (enterprise/prod-like)
    oidc_issuer_url: Optional[str] = Field(
        default=None,
        validation_alias=AliasChoices("OIDC_ISSUER_URL"),
    )
    oidc_issuer_expected_override: Optional[str] = Field(
        default=None,
        validation_alias=AliasChoices("OIDC_ISSUER_EXPECTED"),
    )
    oidc_discovery_url_override: Optional[str] = Field(
        default=None,
        validation_alias=AliasChoices("OIDC_DISCOVERY_URL"),
    )
    oidc_jwks_url_override: Optional[str] = Field(
        default=None,
        validation_alias=AliasChoices("OIDC_JWKS_URL"),
    )

    # Audience (clientId of the API)
    oidc_audience: str = Field(
        default="asrp-orders",
        validation_alias=AliasChoices("OIDC_AUDIENCE", "KEYCLOAK_CLIENT_ID"),
    )
    oidc_leeway_seconds: int = Field(default=10, validation_alias=AliasChoices("OIDC_LEEWAY_SECONDS"))

    # Algorithms accepted for JWT signature verification
    oidc_algorithms: str = Field(default="RS256", validation_alias=AliasChoices("OIDC_ALGORITHMS"))

    def oidc_algorithms_list(self) -> List[str]:
        return [x.strip() for x in self.oidc_algorithms.split(",") if x.strip()]

    # Cache/timeout OIDC (enterprise)
    oidc_discovery_cache_seconds: int = Field(default=300, validation_alias=AliasChoices("OIDC_DISCOVERY_CACHE_SECONDS"))
    oidc_jwks_cache_seconds: int = Field(default=300, validation_alias=AliasChoices("OIDC_JWKS_CACHE_SECONDS"))
    oidc_http_timeout_seconds: float = Field(default=3.0, validation_alias=AliasChoices("OIDC_HTTP_TIMEOUT_SECONDS"))

    @property
    def oidc_discovery_url(self) -> str:
        # [FIX] Allow explicit override (used in prod-like / K8s).
        if self.oidc_discovery_url_override and self.oidc_discovery_url_override.strip():
            return self.oidc_discovery_url_override.strip().rstrip("/")

        base = self.oidc_internal_base_url.rstrip("/")
        return f"{base}/realms/{self.oidc_realm}/.well-known/openid-configuration"

    @property
    def oidc_issuer_expected(self) -> str:
        # [FIX] Allow explicit override (matches token "iss" strictly).
        if self.oidc_issuer_expected_override and self.oidc_issuer_expected_override.strip():
            return self.oidc_issuer_expected_override.strip().rstrip("/")

        # If OIDC_ISSUER_URL is provided, it is already the full realm URL.
        if self.oidc_issuer_url and self.oidc_issuer_url.strip():
            return self.oidc_issuer_url.strip().rstrip("/")

        base = self.oidc_public_base_url.rstrip("/")
        return f"{base}/realms/{self.oidc_realm}"

    @property
    def oidc_jwks_url(self) -> Optional[str]:
        # [FIX] Optional direct JWKS override (internal URL) to bypass discovery jwks_uri.
        if self.oidc_jwks_url_override and self.oidc_jwks_url_override.strip():
            return self.oidc_jwks_url_override.strip().rstrip("/")
        return None

    # -------------------------------------------------------------------------
    # RBAC (Role-Based Access Control)
    # -------------------------------------------------------------------------
    rbac_client_id: str = Field(
        default="asrp-orders",
        validation_alias=AliasChoices("RBAC_CLIENT_ID"),
    )  # resource_access.<client>.roles


settings = Settings()
