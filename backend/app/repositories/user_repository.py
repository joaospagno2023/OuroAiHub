from sqlalchemy import text
from sqlalchemy.orm import Session


def get_user_by_id(
    db: Session,
    user_id: int,
) -> dict | None:
    query = text(
        """
        SELECT
            u.id,
            u.username,
            u.email,
            u.full_name,
            u.password_hash,
            u.department_id,
            d.name AS department_name
        FROM users u
        INNER JOIN departments d
            ON d.id = u.department_id
        WHERE
            u.id = :user_id
            AND u.is_active = 1
            AND d.is_active = 1
        """
    )

    result = db.execute(
        query,
        {
            "user_id": user_id,
        },
    ).mappings().first()

    if result is None:
        return None

    return dict(result)


def get_user_by_username(
    db: Session,
    username: str,
) -> dict | None:
    query = text(
        """
        SELECT
            u.id,
            u.username,
            u.email,
            u.full_name,
            u.password_hash,
            u.department_id,
            d.name AS department_name
        FROM users u
        INNER JOIN departments d
            ON d.id = u.department_id
        WHERE
            u.username = :username
            AND u.is_active = 1
            AND d.is_active = 1
        """
    )

    result = db.execute(
        query,
        {
            "username": username,
        },
    ).mappings().first()

    if result is None:
        return None

    return dict(result)


def get_user_roles(
    db: Session,
    user_id: int,
) -> list[str]:
    query = text(
        """
        SELECT
            r.name
        FROM user_roles ur
        INNER JOIN roles r
            ON r.id = ur.role_id
        WHERE
            ur.user_id = :user_id
            AND r.is_active = 1
        ORDER BY r.name
        """
    )

    result = db.execute(
        query,
        {
            "user_id": user_id,
        },
    ).mappings().all()

    return [
        row["name"]
        for row in result
    ]


def get_user_permissions(
    db: Session,
    user_id: int,
) -> list[str]:
    query = text(
        """
        SELECT DISTINCT
            p.name
        FROM user_roles ur
        INNER JOIN roles r
            ON r.id = ur.role_id
        INNER JOIN role_permissions rp
            ON rp.role_id = r.id
        INNER JOIN permissions p
            ON p.id = rp.permission_id
        WHERE
            ur.user_id = :user_id
        ORDER BY p.name
        """
    )

    result = db.execute(
        query,
        {
            "user_id": user_id,
        },
    ).mappings().all()

    return [
        row["name"]
        for row in result
    ]