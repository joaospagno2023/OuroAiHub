from fastapi import APIRouter
from sqlalchemy.exc import SQLAlchemyError

from app.core.database import test_database_connection


router = APIRouter(
    prefix="/health",
    tags=["Health"],
)


@router.get("")
def health() -> dict[str, str]:
    return {
        "status": "ok",
        "application": "OuroAI Hub",
    }


@router.get("/database")
def database_health() -> dict[str, str]:
    try:
        test_database_connection()

        return {
            "status": "ok",
            "database": "connected",
        }

    except SQLAlchemyError as error:
        return {
            "status": "error",
            "database": "disconnected",
            "error": str(error),
        }