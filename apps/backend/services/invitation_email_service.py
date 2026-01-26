import logging

logger = logging.getLogger(__name__)


def send_invite_email(to_email: str, invite_token: str, patient_name: str) -> bool:
    logger.info(
        f"📧 Invite email stub (no-op). to={to_email}, token={invite_token}, patient={patient_name}"
    )
    return True