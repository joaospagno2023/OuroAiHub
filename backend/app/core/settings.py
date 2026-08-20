from functools import lru_cache
from pathlib import Path

from pydantic_settings import BaseSettings, SettingsConfigDict


PROJECT_ROOT = Path(__file__).resolve().parents[3]
ENV_FILE = PROJECT_ROOT / ".env"


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
    database_trust_server_certificate: str = "Yes"

    jwt_secret_key: str
    jwt_algorithm: str = "HS256"
    jwt_access_token_expire_minutes: int = 60

    model_config = SettingsConfigDict(
        env_file=ENV_FILE,
        env_file_encoding="utf-8",
        case_sensitive=False,
        extra="ignore",
    )


@lru_cache
def get_settings() -> Settings:
    return Settings()