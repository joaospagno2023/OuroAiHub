from fastapi import FastAPI

from app.core.settings import get_settings
from app.routers.auth import router as auth_router
from app.routers.health import router as health_router


settings = get_settings()


app = FastAPI(
    title=settings.app_name,
    description=(
        "Portal corporativo de templates de "
        "Inteligência Artificial da OuroWeb."
    ),
    version=settings.app_version,
)


app.include_router(health_router)
app.include_router(auth_router)