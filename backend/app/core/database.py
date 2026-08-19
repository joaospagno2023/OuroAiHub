from collections.abc import Generator
from urllib.parse import quote_plus

from sqlalchemy import create_engine, text
from sqlalchemy.orm import Session, sessionmaker

from app.core.settings import get_settings


settings = get_settings()


connection_string = (
    f"DRIVER={{{settings.database_driver}}};"
    f"SERVER={settings.database_server},{settings.database_port};"
    f"DATABASE={settings.database_name};"
    f"UID={settings.database_user};"
    f"PWD={settings.database_password};"
    f"TrustServerCertificate="
    f"{str(settings.database_trust_server_certificate).lower()};"
)

database_url = (
    "mssql+pyodbc:///?odbc_connect="
    + quote_plus(connection_string)
)


engine = create_engine(
    database_url,
    pool_pre_ping=True,
    future=True,
)


SessionLocal = sessionmaker(
    bind=engine,
    autocommit=False,
    autoflush=False,
)


def get_db() -> Generator[Session, None, None]:
    db = SessionLocal()

    try:
        yield db
    finally:
        db.close()


def test_database_connection() -> bool:
    with engine.connect() as connection:
        connection.execute(text("SELECT 1"))

    return True