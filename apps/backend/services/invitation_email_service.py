import logging
import os
from typing import Optional

import sib_api_v3_sdk
from sib_api_v3_sdk.rest import ApiException

logger = logging.getLogger(__name__)

# Global variable to cache the API instance (lazy initialization)
_api_instance: Optional[sib_api_v3_sdk.TransactionalEmailsApi] = None
FRONTEND_BASE_URL = os.getenv("REACT_APP_FRONTEND_URL", "http://localhost:3000")

def _get_brevo_api_instance() -> Optional[sib_api_v3_sdk.TransactionalEmailsApi]:
    """Lazy initialization of Brevo API client."""
    global _api_instance
    if _api_instance is not None:
        return _api_instance

    # Get API key at runtime (not import time)
    api_key = os.getenv("BREVO_API_KEY")
    if not api_key:
        logger.warning("BREVO_API_KEY not found - email functionality will be disabled")
        return None

    # Initialize Brevo API client
    configuration = sib_api_v3_sdk.Configuration()
    configuration.api_key['api-key'] = api_key
    _api_instance = sib_api_v3_sdk.TransactionalEmailsApi(
        sib_api_v3_sdk.ApiClient(configuration)
    )
    return _api_instance

def send_invite_email(to_email: str, invite_token: str, patient_name: str) -> bool:
    """Send invitation email to caregiver."""
    api_instance = _get_brevo_api_instance()
    if api_instance is None:
        logger.warning(f"Email not sent to {to_email} - BREVO_API_KEY not configured")
        return False

    invite_link = f"{FRONTEND_BASE_URL}/invitation?token={invite_token}"

    # Plain text version
    plain_content = f"""Hi,

{patient_name} has invited you to join as their caregiver on RemiMinderAI.

Click the link below to accept:
{invite_link}

If you didn't expect this, you can safely ignore this email."""

    # HTML version
    html_content = f"""<html>
  <body style="font-family: Arial, sans-serif; line-height:1.6;">
    <h2 style="color: #333;">You're invited!</h2>
    <p><strong>{patient_name}</strong> has invited you to join as their caregiver on <strong>RemiMinderAI</strong>.</p>
    <p>
      <a href="{invite_link}"
         style="display:inline-block; background-color:#4CAF50; color:white; padding:10px 20px;
                text-decoration:none; border-radius:6px; font-weight:bold;">
        Accept Invitation
      </a>
    </p>
    <hr style="border:none; border-top:1px solid #eee;" />
    <p style="font-size:0.9em; color:#555;">
      If you didn't expect this invitation, you can safely ignore this email.
    </p>
  </body>
</html>"""

    # Brevo email object
    send_smtp_email = sib_api_v3_sdk.SendSmtpEmail(
        sender={"name": "RemiMinderAI", "email": "remiminderai@gmail.com"},
        to=[{"email": to_email}],
        subject=f"{patient_name} invited you to join RemiMinderAI",
        html_content=html_content,
        text_content=plain_content
    )

    try:
        api_instance.send_transac_email(send_smtp_email)
        logger.info(f"Email sent successfully to {to_email}")
        return True
    except ApiException as e:
        logger.error(f"Error sending Brevo email to {to_email}: {e}")
        return False
