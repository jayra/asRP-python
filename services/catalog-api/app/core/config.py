from __future__ import annotations

from functools import lru_cache
from typing import Optional

from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """
    Configuration for catalog-api.

    Two Keycloak base URLs are intentionally supported:

    - Internal (container-to-container): used to reach Keycloak/JWKS from inside Docker.
    - Public (host/browser): used as the expected issuer in the tokens (iss claim).

    This avoids a very common mismatch where the API container cannot reach http://localhost:8080
    but the tokens are minted with issuer http://localhost:8080/realms/<realm>.
    """

    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8", extra="ignore")

    # --- Service ---
    app_name: str = Field(default="catalog-api", validation_alias="APP_NAME")
    app_version: str = Field(default="0.1.0", validation_alias="APP_VERSION")  # --- FIX: requerido por app/main.py ---

    # --- OIDC (OpenID Connect) / Keycloak ---
    oidc_realm: str = Field(default="asrp", validation_alias="KEYCLOAK_REALM")

    # Internal URL (reachable from Docker network)
    oidc_internal_base_url: str = Field(
        default="http://keycloak:8080",
        validation_alias="KEYCLOAK_INTERNAL_BASE_URL",
    )

    # Public URL (issuer used by tokens minted via host URL)
    oidc_public_base_url: str = Field(
        default="http://localhost:8080",
        validation_alias="KEYCLOAK_PUBLIC_BASE_URL",
    )

    # Client used as audience and to extract client roles
    oidc_audience: str = Field(default="asrp-catalog", validation_alias="KEYCLOAK_CLIENT_ID")

    # Clock skew tolerance (seconds)
    oidc_leeway_seconds: int = Field(default=10, validation_alias="OIDC_LEEWAY_SECONDS")

    # Algorithms accepted for JWT (JSON Web Token) signature verification
    oidc_algorithms: str = Field(default="RS256", validation_alias="OIDC_ALGORITHMS")

    @property
    def oidc_discovery_url(self) -> str:
        # Discovery is called from inside the container, so use INTERNAL base URL.
        base = self.oidc_internal_base_url.rstrip("/")
        return f"{base}/realms/{self.oidc_realm}/.well-known/openid-configuration"

    @property
    def oidc_issuer_expected(self) -> str:
        # Issuer must match the iss claim in the access token; usually minted via PUBLIC base URL.
        base = self.oidc_public_base_url.rstrip("/")
        return f"{base}/realms/{self.oidc_realm}"

    @property
    def oidc_algorithms_list(self) -> list[str]:
        return [a.strip() for a in self.oidc_algorithms.split(",") if a.strip()]

    # -------------------------
    # Database (PRO)
    # -------------------------
    # Opción A: URL completa (si se define, se usa tal cual).
    database_url: Optional[str] = Field(default=None, validation_alias="DATABASE_URL")

    # Opción B: piezas (recomendado para producción)
    db_dialect: str = Field(default="postgresql+psycopg", validation_alias="DB_DIALECT")
    db_host: str = Field(default="catalog-db", validation_alias="DB_HOST")
    db_port: int = Field(default=5432, validation_alias="DB_PORT")
    db_name: str = Field(default="catalog_db", validation_alias="DB_NAME")
    db_user: str = Field(default="catalog_app", validation_alias="DB_USER")
    db_password: Optional[str] = Field(default=None, validation_alias="DB_PASSWORD")

    @property
    def database_url_resolved(self) -> str:
        """
        Devuelve DATABASE_URL si viene definido; si no, lo construye desde DB_*.

        Nota: si DB_PASSWORD no viene definido, la URL se construye igualmente,
        pero la conexión puede fallar si Postgres exige contraseña (lo normal en prod).
        """
        if self.database_url and self.database_url.strip():
            return self.database_url.strip()

        pwd = self.db_password or ""
        return f"{self.db_dialect}://{self.db_user}:{pwd}@{self.db_host}:{self.db_port}/{self.db_name}"

    @property
    def DATABASE_URL(self) -> str:
        """
        --- FIX de compatibilidad ---
        Permite que código existente que use settings.DATABASE_URL no reviente.
        """
        return self.database_url_resolved


@lru_cache(maxsize=1)
def get_settings() -> Settings:
    # --- FIX: db.py importa get_settings(); lo proveemos de forma estable/cached ---
    return Settings()


settings = get_settings()  # --- FIX: mantiene compatibilidad con imports previos ---
