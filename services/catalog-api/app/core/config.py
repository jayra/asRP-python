from functools import lru_cache

from pydantic import AliasChoices, Field
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    # --- FIX (Pydantic v2): sin campos que empiecen por "_" (rompen el modelo) ---
    model_config = SettingsConfigDict(env_file=".env", extra="ignore")

    # --- FIX (settings): environment/env con aliases compatibles ---
    environment: str = Field(
        default="local",
        validation_alias=AliasChoices("ENVIRONMENT", "ENV", "APP_ENV"),
    )

    # Mantengo `env` por compatibilidad con tus respuestas /health anteriores.
    # Se rellena desde las mismas variables.
    env: str = Field(
        default="local",
        validation_alias=AliasChoices("ENVIRONMENT", "ENV", "APP_ENV"),
    )

    app_name: str = Field(default="catalog-api", validation_alias=AliasChoices("APP_NAME"))
    app_version: str = Field(default="0.1.0", validation_alias=AliasChoices("APP_VERSION"))

    log_level: str = Field(
        default="INFO",
        validation_alias=AliasChoices("LOG_LEVEL"),
    )

    # Nota: en Docker suele ser el hostname del servicio (p.ej. catalog-db).
    database_url: str = Field(
        default="postgresql+psycopg://catalog_app:catalog_app_pwd@catalog-db:5432/catalog_db",
        validation_alias=AliasChoices("DATABASE_URL"),
    )


@lru_cache
def get_settings() -> Settings:
    return Settings()


# Nota: dejamos el objeto `settings` para no tocar imports en el resto del código.
# El control del "timing" en tests debe hacerse en conftest.py (ver indicación abajo).
settings = get_settings()
