from typing import Any, Callable

_send_caregiver_alert_email: Callable[[str, str, str, str], Any] | None = None


def set_caregiver_alert_email_sender(
    provider: Callable[[str, str, str, str], Any]
) -> None:
    global _send_caregiver_alert_email
    _send_caregiver_alert_email = provider


async def send_caregiver_alert_email(
    to_email: str,
    patient_name: str,
    alert_message: str,
    alert_id: str,
):
    if _send_caregiver_alert_email is None:
        raise RuntimeError("Notification provider not configured")
    return await _send_caregiver_alert_email(
        to_email=to_email,
        patient_name=patient_name,
        alert_message=alert_message,
        alert_id=alert_id,
    )
