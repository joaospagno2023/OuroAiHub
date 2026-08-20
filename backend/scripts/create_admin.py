from getpass import getpass

from sqlalchemy import text

from app.core.database import SessionLocal
from app.services.password_service import hash_password


def main() -> None:
    username = input("Usuário administrador: ").strip()
    full_name = input("Nome completo: ").strip()
    email = input("E-mail: ").strip()
    password = getpass("Senha: ")

    if not username:
        raise ValueError("O usuário é obrigatório.")

    if not full_name:
        raise ValueError("O nome completo é obrigatório.")

    if not email:
        raise ValueError("O e-mail é obrigatório.")

    if not password:
        raise ValueError("A senha é obrigatória.")

    db = SessionLocal()

    try:
        department = db.execute(
            text(
                """
                SELECT id
                FROM departments
                WHERE name = N'TI'
                  AND is_active = 1
                """
            )
        ).scalar_one_or_none()

        if department is None:
            raise RuntimeError(
                "Departamento TI não encontrado."
            )

        existing_user = db.execute(
            text(
                """
                SELECT id
                FROM users
                WHERE username = :username
                """
            ),
            {
                "username": username,
            },
        ).scalar_one_or_none()

        if existing_user is not None:
            raise RuntimeError(
                f"O usuário '{username}' já existe."
            )

        password_hash = hash_password(password)

        user_id = db.execute(
            text(
                """
                INSERT INTO users
                (
                    department_id,
                    username,
                    email,
                    password_hash,
                    full_name
                )
                OUTPUT INSERTED.id
                VALUES
                (
                    :department_id,
                    :username,
                    :email,
                    :password_hash,
                    :full_name
                )
                """
            ),
            {
                "department_id": department,
                "username": username,
                "email": email,
                "password_hash": password_hash,
                "full_name": full_name,
            },
        ).scalar_one()

        role_id = db.execute(
            text(
                """
                SELECT id
                FROM roles
                WHERE name = N'ADMIN'
                """
            )
        ).scalar_one()

        db.execute(
            text(
                """
                INSERT INTO user_roles
                (
                    user_id,
                    role_id
                )
                VALUES
                (
                    :user_id,
                    :role_id
                )
                """
            ),
            {
                "user_id": user_id,
                "role_id": role_id,
            },
        )

        db.commit()

        print()
        print("Administrador criado com sucesso.")
        print(f"ID: {user_id}")
        print(f"Usuário: {username}")
        print(f"Departamento: TI")
        print(f"Perfil: ADMIN")

    except Exception:
        db.rollback()
        raise

    finally:
        db.close()


if __name__ == "__main__":
    main()