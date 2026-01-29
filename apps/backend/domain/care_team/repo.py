import logging
import secrets
from typing import Optional

from sqlalchemy import text

from domain.ports.db import get_db_engine

logger = logging.getLogger(__name__)


async def create_care_team_invitation(
    patient_id: str,
    invitee_email: str,
    role: str,
    permission: str,
    token: str,
    invited_by_user_id: str | None = None,
    expires_at: str | None = None,
) -> str:
    """
    Create a new care team invitation.
    Returns the invitation ID.
    """
    try:
        engine = get_db_engine()
        with engine.begin() as conn:
            query = text("""
                INSERT INTO care_team_invitations
                (patient_id, invitee_email, role, permission, status, token, invited_by_user_id, expires_at)
                VALUES (:patient_id, :invitee_email, :role, :permission, 'pending', :token, :invited_by_user_id, :expires_at)
                RETURNING id
            """)
            result = conn.execute(query, {
                "patient_id": patient_id,
                "invitee_email": invitee_email,
                "role": role,
                "permission": permission,
                "token": token,
                "invited_by_user_id": invited_by_user_id,
                "expires_at": expires_at,
            })
            row = result.fetchone()
            if not row:
                raise Exception("Failed to create care team invitation")
            return str(row[0])
    except Exception as e:
        logger.error(f"Error creating care team invitation for patient_id={patient_id}: {e}")
        raise


async def get_care_team_invitation_by_token(token: str) -> Optional[dict]:
    """
    Fetch a care team invitation by token.
    Returns invitation data if found, otherwise None.
    """
    try:
        engine = get_db_engine()
        with engine.connect() as conn:
            query = text("""
                SELECT
                    id,
                    patient_id,
                    invitee_email,
                    token,
                    role,
                    permission,
                    status,
                    invited_by_user_id,
                    accepted_by_user_id,
                    expires_at,
                    created_at,
                    accepted_at
                FROM care_team_invitations
                WHERE token = :token
                LIMIT 1
            """)
            result = conn.execute(query, {"token": token})
            row = result.fetchone()
            if not row:
                return None
            if hasattr(row, "_mapping"):
                return dict(row._mapping)
            return {
                "id": row[0],
                "patient_id": row[1],
                "invitee_email": row[2],
                "token": row[3],
                "role": row[4],
                "permission": row[5],
                "status": row[6],
                "invited_by_user_id": row[7],
                "accepted_by_user_id": row[8],
                "expires_at": row[9],
                "created_at": row[10],
                "accepted_at": row[11],
            }
    except Exception as e:
        logger.error(f"Error fetching care team invitation by token: {e}")
        raise


async def mark_care_team_invitation_accepted(
    invitation_id: str,
    accepted_by_user_id: str,
) -> bool:
    """
    Mark a care team invitation as accepted.
    Returns True if update succeeded, False if not found.
    """
    try:
        engine = get_db_engine()
        with engine.begin() as conn:
            query = text("""
                UPDATE care_team_invitations
                SET status = 'accepted',
                    accepted_by_user_id = :accepted_by_user_id,
                    accepted_at = now()
                WHERE id = :invitation_id
            """)
            result = conn.execute(query, {
                "invitation_id": invitation_id,
                "accepted_by_user_id": accepted_by_user_id,
            })
            return result.rowcount > 0
    except Exception as e:
        logger.error(f"Error marking care team invitation accepted: {e}")
        raise


async def add_care_team_member(
    patient_id: str,
    member_user_id: str,
    role: str,
    permission: str,
    status: str,
    invited_by_user_id: str | None = None,
) -> Optional[str]:
    """
    Add a care team member.
    Returns the member ID if created, otherwise None.
    """
    try:
        engine = get_db_engine()
        with engine.begin() as conn:
            query = text("""
                INSERT INTO care_team_members
                (patient_id, member_user_id, role, permission, status, invited_by_user_id)
                VALUES (:patient_id, :member_user_id, :role, :permission, :status, :invited_by_user_id)
                ON CONFLICT (patient_id, member_user_id) DO NOTHING
                RETURNING id
            """)
            result = conn.execute(query, {
                "patient_id": patient_id,
                "member_user_id": member_user_id,
                "role": role,
                "permission": permission,
                "status": status,
                "invited_by_user_id": invited_by_user_id,
            })
            row = result.fetchone()
            return str(row[0]) if row else None
    except Exception as e:
        logger.error(f"Error adding care team member for patient_id={patient_id}: {e}")
        raise


async def get_care_team_membership(
    patient_id: str,
    member_user_id: str,
) -> Optional[dict]:
    """
    Fetch an active care team membership for a patient/member pair.
    Returns membership data if found, otherwise None.
    """
    try:
        engine = get_db_engine()
        with engine.connect() as conn:
            query = text("""
                SELECT
                    id,
                    patient_id,
                    member_user_id,
                    role,
                    permission,
                    status,
                    invited_by_user_id,
                    created_at,
                    revoked_at
                FROM care_team_members
                WHERE patient_id = :patient_id
                  AND member_user_id = :member_user_id
                  AND status = 'active'
                LIMIT 1
            """)
            result = conn.execute(query, {
                "patient_id": patient_id,
                "member_user_id": member_user_id,
            })
            row = result.fetchone()
            if not row:
                return None
            if hasattr(row, "_mapping"):
                return dict(row._mapping)
            return {
                "id": row[0],
                "patient_id": row[1],
                "member_user_id": row[2],
                "role": row[3],
                "permission": row[4],
                "status": row[5],
                "invited_by_user_id": row[6],
                "created_at": row[7],
                "revoked_at": row[8],
            }
    except Exception as e:
        logger.error(
            "Error fetching care team membership for patient_id=%s, member_user_id=%s: %s",
            patient_id,
            member_user_id,
            e,
        )
        raise


async def get_care_team_members(patient_id: str) -> list[dict]:
    """
    Fetch all care team members for a patient, including user info.
    """
    try:
        engine = get_db_engine()
        with engine.connect() as conn:
            query = text("""
                SELECT
                    m.id,
                    m.patient_id,
                    m.member_user_id,
                    u.full_name,
                    u.email,
                    m.role,
                    m.permission,
                    m.status,
                    m.invited_by_user_id,
                    m.created_at,
                    m.revoked_at
                FROM care_team_members m
                LEFT JOIN users u ON u.external_auth_id = m.member_user_id
                WHERE m.patient_id = :patient_id
                ORDER BY m.created_at DESC
            """)
            result = conn.execute(query, {"patient_id": patient_id})
            rows = result.fetchall()

            members = []
            for row in rows:
                if hasattr(row, "_mapping"):
                    members.append(dict(row._mapping))
                else:
                    members.append({
                        "id": row[0],
                        "patient_id": row[1],
                        "member_user_id": row[2],
                        "full_name": row[3],
                        "email": row[4],
                        "role": row[5],
                        "permission": row[6],
                        "status": row[7],
                        "invited_by_user_id": row[8],
                        "created_at": row[9],
                        "revoked_at": row[10],
                    })
            return members
    except Exception as e:
        logger.error(f"Error fetching care team members for patient_id={patient_id}: {e}")
        raise


async def get_my_care_team_invitations(user_email: str) -> list[dict]:
    """
    Fetch pending care team invitations for the given email.
    """
    try:
        engine = get_db_engine()
        with engine.connect() as conn:
            query = text("""
                SELECT
                    i.id,
                    i.patient_id,
                    i.invitee_email,
                    i.role,
                    i.permission,
                    i.status,
                    i.token,
                    i.created_at,
                    u.full_name AS patient_name
                FROM care_team_invitations i
                JOIN users u ON u.external_auth_id = i.patient_id
                WHERE i.invitee_email = :email
                  AND i.status = 'pending'
                ORDER BY i.created_at DESC;
            """)
            result = conn.execute(query, {"email": user_email})
            rows = result.fetchall()
            invitations = []
            for row in rows:
                if hasattr(row, "_mapping"):
                    invitations.append(dict(row._mapping))
                else:
                    invitations.append({
                        "id": row[0],
                        "patient_id": row[1],
                        "invitee_email": row[2],
                        "role": row[3],
                        "permission": row[4],
                        "status": row[5],
                        "token": row[6],
                        "created_at": row[7],
                        "patient_name": row[8],
                    })
            return invitations
    except Exception as e:
        logger.error(f"Error fetching care team invitations for email={user_email}: {e}")
        raise


async def get_care_team_member_by_id(member_id: str) -> Optional[dict]:
    """
    Fetch a care team member by ID.
    """
    try:
        engine = get_db_engine()
        with engine.connect() as conn:
            query = text("""
                SELECT id, patient_id, member_user_id, role, permission, status
                FROM care_team_members
                WHERE id = :member_id
                LIMIT 1
            """)
            result = conn.execute(query, {"member_id": member_id})
            row = result.fetchone()
            if not row:
                return None
            if hasattr(row, "_mapping"):
                return dict(row._mapping)
            return {
                "id": row[0],
                "patient_id": row[1],
                "member_user_id": row[2],
                "role": row[3],
                "permission": row[4],
                "status": row[5],
            }
    except Exception as e:
        logger.error(f"Error fetching care team member for member_id={member_id}: {e}")
        raise


async def update_care_team_member_permission(
    member_id: str,
    permission: str,
) -> bool:
    """
    Update a care team member's permission.
    Returns True if updated, False if not found.
    """
    try:
        engine = get_db_engine()
        with engine.begin() as conn:
            query = text("""
                UPDATE care_team_members
                SET permission = :permission
                WHERE id = :member_id
            """)
            result = conn.execute(query, {
                "permission": permission,
                "member_id": member_id,
            })
            return result.rowcount > 0
    except Exception as e:
        logger.error(
            "Error updating care team permission for member_id=%s: %s",
            member_id,
            e,
        )
        raise


async def remove_care_team_member(
    member_id: str,
) -> bool:
    """
    Delete a care team member by ID.
    Returns True if deleted, False if not found.
    """
    try:
        engine = get_db_engine()
        with engine.begin() as conn:
            query = text("""
                DELETE FROM care_team_members
                WHERE id = :member_id
            """)
            result = conn.execute(query, {
                "member_id": member_id,
            })
            return result.rowcount > 0
    except Exception as e:
        logger.error(
            "Error deleting care team member for member_id=%s: %s",
            member_id,
            e,
        )
        raise


async def get_pending_care_team_invitations(patient_id: str) -> list[dict]:
    """
    Fetch pending care team invitations for a patient.
    """
    try:
        engine = get_db_engine()
        with engine.connect() as conn:
            query = text("""
                SELECT
                    id,
                    invitee_email,
                    role,
                    permission,
                    status,
                    created_at
                FROM care_team_invitations
                WHERE patient_id = :patient_id
                  AND status = 'pending'
                ORDER BY created_at DESC
            """)
            result = conn.execute(query, {"patient_id": patient_id})
            rows = result.fetchall()
            invitations = []
            for row in rows:
                if hasattr(row, "_mapping"):
                    invitations.append(dict(row._mapping))
                else:
                    invitations.append({
                        "id": row[0],
                        "invitee_email": row[1],
                        "role": row[2],
                        "permission": row[3],
                        "status": row[4],
                        "created_at": row[5],
                    })
            return invitations
    except Exception as e:
        logger.error(
            "Error fetching pending care team invitations for patient_id=%s: %s",
            patient_id,
            e,
        )
        raise


async def cancel_care_team_invitation(
    patient_id: str,
    invitation_id: str,
) -> bool:
    """
    Mark a care team invitation as revoked for a patient.
    Returns True if updated, False if not found or not owned by patient.
    """
    try:
        engine = get_db_engine()
        with engine.begin() as conn:
            query = text("""
                UPDATE care_team_invitations
                SET status = 'revoked'
                WHERE id = :invitation_id
                  AND patient_id = :patient_id
            """)
            result = conn.execute(query, {
                "invitation_id": invitation_id,
                "patient_id": patient_id,
            })
            return result.rowcount > 0
    except Exception as e:
        logger.error(
            "Error cancelling care team invitation for patient_id=%s, invitation_id=%s: %s",
            patient_id,
            invitation_id,
            e,
        )
        raise


async def resend_care_team_invitation(
    patient_id: str,
    invitation_id: str,
) -> Optional[str]:
    """
    Regenerate token for a pending care team invitation.
    Returns new token if updated, otherwise None.
    """
    try:
        new_token = secrets.token_urlsafe(32)
        engine = get_db_engine()
        with engine.begin() as conn:
            query = text("""
                UPDATE care_team_invitations
                SET token = :token,
                    created_at = now(),
                    status = 'pending'
                WHERE id = :invitation_id
                  AND patient_id = :patient_id
                  AND status = 'pending'
                RETURNING token
            """)
            result = conn.execute(query, {
                "token": new_token,
                "invitation_id": invitation_id,
                "patient_id": patient_id,
            })
            row = result.fetchone()
            return str(row[0]) if row else None
    except Exception as e:
        logger.error(
            "Error resending care team invitation for patient_id=%s, invitation_id=%s: %s",
            patient_id,
            invitation_id,
            e,
        )
        raise
