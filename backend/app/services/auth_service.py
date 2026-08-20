from fastapi import HTTPException, status
from sqlalchemy.orm import Session

from app.repositories.user_repository import (
    get_user_by_username,
    get_user_permissions,
    get_user_roles,
)
from app.schemas.auth import LoginRequest, LoginResponse, UserResponse
from app.services.jwt_service import create_access_token
from app.services.password_service import verify_password


def authenticate_user(
    db: Session,
    request: LoginRequest,
) -> LoginResponse:
    user = get_user_by_username(
        db,
        request.username,
    )

    if user is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Usuário ou senha inválidos.",
        )

    password_valid = verify_password(
        request.password,
        user["password_hash"],
    )

    if not password_valid:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Usuário ou senha inválidos.",
        )

    roles = get_user_roles(
        db,
        user["id"],
    )

    permissions = get_user_permissions(
        db,
        user["id"],
    )

    access_token = create_access_token(
        user_id=user["id"],
        username=user["username"],
    )

    user_response = UserResponse(
        id=user["id"],
        username=user["username"],
        email=user["email"],
        full_name=user["full_name"],
        department_id=user["department_id"],
        department_name=user["department_name"],
        roles=roles,
        permissions=permissions,
    )

    return LoginResponse(
        access_token=access_token,
        token_type="bearer",
        user=user_response,
    )