import logging
from typing import Optional

from sqlalchemy import text

from domain.ports.cache import get_or_set
from domain.ports.db import get_db_engine
from domain.errors import DomainError, NotFoundError

logger = logging.getLogger(__name__)


async def get_user_uuid(external_auth_id: str) -> str:
    """
    Validate external_auth_id exists in users table and return it.
    """
    try:
        cache_key = f"user_uuid:{external_auth_id}"

        def _load_user_uuid() -> str:
            engine = get_db_engine()
            with engine.connect() as conn:
                query = text("""
                    SELECT external_auth_id FROM users WHERE external_auth_id = :external_auth_id
                """)

                result = conn.execute(query, {"external_auth_id": external_auth_id})
                row = result.fetchone()

                if not row:
                    raise NotFoundError(f"User not found for auth ID {external_auth_id}")

                return str(row[0])

        return get_or_set(cache_key, 1800, _load_user_uuid)

    except DomainError:
        raise
    except Exception as e:
        logger.error(f"Error validating auth ID {external_auth_id}: {e}")
        raise


async def get_user_email(user_id: str) -> str:
    """
    Get the user's email from Cloud SQL by user ID.
    """
    try:
        engine = get_db_engine()
        with engine.connect() as conn:
            query = text("""
                SELECT email FROM users WHERE external_auth_id = :user_id
            """)
            result = conn.execute(query, {"user_id": user_id})
            row = result.fetchone()
            if not row:
                raise NotFoundError("User not found")
            return str(row[0])
    except DomainError:
        raise
    except Exception as e:
        logger.error(f"Error getting user email for user_id={user_id}: {e}")
        raise


async def ensure_user_exists(
    external_auth_id: str,
    email: str,
    request_full_name: Optional[str] = None,
    auth_display_name: Optional[str] = None,
) -> bool:
    """
    Ensure a user row exists in Cloud SQL.
    Returns True if created, False if already exists.
    Populates full_name if empty using request or Firebase token data.
    """
    engine = get_db_engine()
    with engine.begin() as conn:
        # Check if user exists by external_auth_id
        result = conn.execute(
            text("SELECT id, full_name FROM users WHERE external_auth_id = :external_auth_id"),
            {"external_auth_id": external_auth_id},
        )
        existing_user = result.fetchone()

        if existing_user:
            # User exists - update full_name if empty
            user_id, current_full_name = existing_user
            if not current_full_name or current_full_name.strip() == "":
                # Determine name to use
                name_to_set = None
                if request_full_name and request_full_name.strip():
                    name_to_set = request_full_name.strip()
                elif auth_display_name and auth_display_name.strip():
                    name_to_set = auth_display_name.strip()

                # Update if we have a name to set
                if name_to_set:
                    conn.execute(
                        text("UPDATE users SET full_name = :full_name WHERE id = :user_id"),
                        {"full_name": name_to_set, "user_id": user_id},
                    )
            return False

        # User doesn't exist - create new user
        # Determine full_name for new user
        full_name = None
        if request_full_name and request_full_name.strip():
            full_name = request_full_name.strip()
        elif auth_display_name and auth_display_name.strip():
            full_name = auth_display_name.strip()

        conn.execute(
            text("""
                INSERT INTO users (external_auth_id, email, full_name, role, is_active)
                VALUES (:external_auth_id, :email, :full_name, 'user', true)
            """),
            {
                "external_auth_id": external_auth_id,
                "email": email,
                "full_name": full_name,
            },
        )
        return True


async def get_user_language_preferences(external_auth_id: str) -> dict:
    """
    Get user's language preferences.

    Returns:
    {
      "app_language": "en",
      "visit_language": "en"
    }
    """
    try:
        engine = get_db_engine()
        with engine.connect() as conn:
            query = text("""
                SELECT app_language, visit_language
                FROM users
                WHERE external_auth_id = :external_auth_id
            """)

            result = conn.execute(query, {"external_auth_id": external_auth_id})
            row = result.fetchone()

            if not row:
                return None

            # Handle both tuple and Row objects safely
            if hasattr(row, '_mapping'):
                # SQLAlchemy Row object with column names
                app_language = row._mapping.get('app_language', 'en')
                visit_language = row._mapping.get('visit_language', 'en')
            else:
                # Tuple unpacking
                app_language, visit_language = row

            preferences = {
                "app_language": app_language or 'en',
                "visit_language": visit_language or 'en'
            }

            return preferences

    except Exception as e:
        logger.error(f"Error getting language preferences for external_auth_id={external_auth_id}: {e}")
        raise


async def update_user_language_preferences(
    external_auth_id: str,
    app_language: str,
    visit_language: str,
) -> bool:
    """
    Update user's language preferences.

    Returns:
        True if update was successful, False if user not found
    """
    try:
        # Simple validation
        if not app_language or not visit_language:
            raise ValueError("App language and visit language are required")

        if len(app_language) > 10 or len(visit_language) > 10:
            raise ValueError("Language codes must be 10 characters or less")

        engine = get_db_engine()
        with engine.connect() as conn:
            query = text("""
                UPDATE users
                SET app_language = :app_language,
                    visit_language = :visit_language,
                    updated_at = now()
                WHERE external_auth_id = :external_auth_id
            """)

            result = conn.execute(query, {
                "external_auth_id": external_auth_id,
                "app_language": app_language,
                "visit_language": visit_language
            })

            success = result.rowcount > 0
            return success

    except Exception as e:
        logger.error(f"Error updating language preferences for external_auth_id={external_auth_id}: {e}")
        raise


async def get_user_profile(external_auth_id: str) -> Optional[dict]:
    """
    Fetch user profile by external_auth_id.
    """
    try:
        engine = get_db_engine()
        with engine.connect() as conn:
            row = conn.execute(
                text("""
                    SELECT id, email, full_name, phone, role
                    FROM users
                    WHERE external_auth_id = :external_auth_id
                    LIMIT 1
                """),
                {"external_auth_id": external_auth_id},
            ).fetchone()
        if not row:
            return None
        return {
            "id": str(row[0]),
            "email": row[1],
            "full_name": row[2],
            "phone": row[3],
            "db_role": row[4],
        }
    except Exception as e:
        logger.error(f"Error fetching user profile for external_auth_id={external_auth_id}: {e}")
        raise


async def update_user_role(external_auth_id: str, db_role: str) -> Optional[dict]:
    """
    Update user role and return updated user profile fields.
    """
    try:
        engine = get_db_engine()
        with engine.connect() as conn:
            update_result = conn.execute(
                text("UPDATE users SET role = :role WHERE external_auth_id = :external_auth_id"),
                {"role": db_role, "external_auth_id": external_auth_id},
            )
            conn.commit()
            if update_result.rowcount == 0:
                return None
            row = conn.execute(
                text("""
                    SELECT id, email, full_name, role
                    FROM users
                    WHERE external_auth_id = :external_auth_id
                    LIMIT 1
                """),
                {"external_auth_id": external_auth_id},
            ).fetchone()
        if not row:
            return None
        return {
            "id": str(row[0]),
            "email": row[1],
            "full_name": row[2],
            "db_role": row[3],
        }
    except Exception as e:
        logger.error(f"Error updating user role for external_auth_id={external_auth_id}: {e}")
        raise


async def update_user_phone(external_auth_id: str, phone: Optional[str]) -> bool:
    """
    Update user's phone number. Returns True if updated, False if user not found.
    """
    try:
        engine = get_db_engine()
        with engine.connect() as conn:
            result = conn.execute(
                text("UPDATE users SET phone = :phone WHERE external_auth_id = :external_auth_id"),
                {"phone": phone, "external_auth_id": external_auth_id},
            )
            conn.commit()
            return result.rowcount > 0
    except Exception as e:
        logger.error(f"Error updating phone for external_auth_id={external_auth_id}: {e}")
        raise
