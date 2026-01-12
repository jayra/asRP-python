from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    app_name: str = "Catalog API"
    app_version: str = "0.1.0"
    environment: str = "local"  # local|dev|prod
    database_url: str = "postgresql+psycopg://catalog_app:catalog_app_pwd@localhost:5433/catalog_db"

    # Logging
    log_level: str = "INFO"

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        extra="ignore",
    )

settings = Settings()
