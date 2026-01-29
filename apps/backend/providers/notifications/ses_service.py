
from typing import Optional

from domain.ports.logging import get_logger

logger = get_logger()

"""
Email notification provider (no-op stub).

External email providers can be wired through infra when needed.
"""


async def send_reminder_email(
    to_email: str,
    subject: str,
    message_body: str,
    reminder_id: Optional[str] = None
) -> bool:
    """
    Send a reminder email via configured provider.
    """
    logger.info(
        "Email provider not configured; skipping reminder email to=%s reminder_id=%s",
        to_email,
        reminder_id,
    )
    return False


async def send_caregiver_alert_email(
    to_email: str,
    patient_name: str,
    alert_message: str,
    alert_id: Optional[str] = None
) -> bool:
    """
    Send a caregiver alert email.
    """
    subject = f"Alert: {patient_name} - Reminder Update"
    return await send_reminder_email(
        to_email=to_email,
        subject=subject,
        message_body=alert_message,
        reminder_id=alert_id,
    )


async def verify_email_configuration() -> bool:
    """
    Verify that a provider is configured (currently not supported).
    """
    logger.info("Email provider not configured")
    return False
    
