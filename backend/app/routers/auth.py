from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.auth_dependencies import get_current_user
from app.core.database import get_db
from app.schemas.auth import LoginRequest, LoginResponse, UserResponse
from app.services.auth_service import authenticate_user


router = APIRouter(
    prefix="/auth",
    tags=["Authentication"],
)


@router.post(
    "/login",
    response_model=LoginResponse,
)
def login(
    request: LoginRequest,
    db: Session = Depends(get_db),
) -> LoginResponse:
    return authenticate_user(
        db,
        request,
    )


@router.get(
    "/me",
    response_model=UserResponse,
)
def me(
    current_user: dict = Depends(get_current_user),
) -> UserResponse:
    return UserResponse(
        id=current_user["id"],
        username=current_user["username"],
        email=current_user["email"],
        full_name=current_user["full_name"],
        department_id=current_user["department_id"],
        department_name=current_user["department_name"],
        roles=current_user["roles"],
        permissions=current_user["permissions"],
    )