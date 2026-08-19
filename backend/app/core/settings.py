from functools import lru_cache

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    app_name: str = "OuroAI Hub"
    app_version: str = "1.0.0"
    app_environment: str = "development"

    database_server: str
    database_port: int = 1433
    database_name: str
    database_user: str
    database_password: str
    database_driver: str = "ODBC Driver 18 for SQL Server"
    database_trust_server_certificate: bool = True

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
        extra="ignore",
    )


@lru_cache
def get_settings() -> Settings:
    return Settings()