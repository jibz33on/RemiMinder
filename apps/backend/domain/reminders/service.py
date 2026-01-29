import asyncio
import logging
from datetime import datetime, timezone, timedelta
from typing import Optional, List, Dict, Any

from domain.errors import InternalError, NotFoundError

from domain.reminders.models import ReminderCreate, ReminderUpdate, ReminderAction
from domain.reminders.repo import (
    create_reminder as db_create_reminder,
    get_reminder,
    get_all_reminders,
    update_reminder as db_update_reminder,
    delete_reminder as db_delete_reminder,
    mark_reminder_complete,
    snooze_reminder as db_snooze_reminder,
    skip_reminder as db_skip_reminder,
    get_next_reminders_for_patient,
    get_recent_activity_for_patient,
    get_alerts_summary,
    get_patient_info,
    get_caregiver_alerts,
    mark_alert_as_read,
)
from workflows.reminder_messages import generate_reminder_message
from workflows.reminder_alerts import check_and_send_caregiver_alerts
from domain.ports.cache import get, set, invalidate, invalidate_prefix

logger = logging.getLogger(__name__)

ICON_MAP = {
    "medication": "💊",
    "task": "❤️",
    "appointment": "🗓️"
}


def _get_display_status(reminder: dict) -> str:
    """Calculate display status based on reminder state and time."""
    now = datetime.now(timezone.utc)

    # Parse scheduled_time (handle both string and datetime)
    scheduled = reminder.get("scheduled_time")
    if isinstance(scheduled, str):
        scheduled = datetime.fromisoformat(scheduled.replace("Z", "+00:00"))

    status = reminder.get("status")
    completed_at = reminder.get("completed_at")

    # Past section statuses
    if status == "completed":
        return "Completed"
    if status == "snoozed" and completed_at:
        return "Snoozed"
    if status == "skipped":
        return "Skipped"

    # Active/Due Now (within 15 minutes of scheduled time)
    if scheduled <= now <= scheduled + timedelta(minutes=15) and status == "pending":
        return "Due Now"

    # Upcoming
    if scheduled > now and status == "pending":
        return "Upcoming"

    # Missed/Overdue
    if scheduled < now and status == "pending":
        return "Missed"

    return "Unknown"


def _format_display_time(scheduled_time: datetime, timezone_str: str) -> str:
    """Format time for display (e.g., '8:15 PM')."""
    # For MVP, just format in UTC or assume frontend handles timezone
    return scheduled_time.strftime("%I:%M %p").lstrip("0")


def _format_relative_time(scheduled_time: datetime) -> str:
    """Format relative time (e.g., 'in 2 hours', '3 days ago')."""
    now = datetime.now(timezone.utc)

    # Ensure scheduled_time is timezone-aware
    if isinstance(scheduled_time, str):
        scheduled_time = datetime.fromisoformat(scheduled_time.replace("Z", "+00:00"))

    delta = scheduled_time - now

    if delta.total_seconds() < 0:
        # Past
        delta = abs(delta)
        if delta.days > 0:
            return f"{delta.days} day{'s' if delta.days != 1 else ''} ago"
        if delta.seconds >= 3600:
            hours = delta.seconds // 3600
            return f"{hours} hour{'s' if hours != 1 else ''} ago"
        minutes = delta.seconds // 60
        return f"{minutes} minute{'s' if minutes != 1 else ''} ago"

    # Future
    if delta.days > 0:
        return f"in {delta.days} day{'s' if delta.days != 1 else ''}"
    if delta.seconds >= 3600:
        hours = delta.seconds // 3600
        return f"in {hours} hour{'s' if hours != 1 else ''}"
    minutes = delta.seconds // 60
    return f"in {minutes} minute{'s' if minutes != 1 else ''}"


def _enrich_reminder_response(reminder: dict) -> dict:
    """Add display fields to reminder for frontend."""
    scheduled_time = reminder.get("scheduled_time")
    if isinstance(scheduled_time, str):
        scheduled_time = datetime.fromisoformat(scheduled_time.replace("Z", "+00:00"))

    reminder["display_status"] = _get_display_status(reminder)
    reminder["icon_type"] = ICON_MAP.get(reminder.get("reminder_type"), "⏰")
    reminder["display_time"] = _format_display_time(scheduled_time, reminder.get("timezone", "UTC"))
    reminder["relative_time"] = _format_relative_time(scheduled_time)

    return reminder


# ============================================================================
# REMINDER BUSINESS LOGIC
# ============================================================================

async def create_new_reminder(data: ReminderCreate) -> Optional[Dict[str, Any]]:
    """Create a new reminder with AI-generated message."""
    try:
        message = await generate_reminder_message(
            reminder_type=data.reminder_type,
            title=data.title,
            context_data=data.context_data,
        )

        reminder_data = {
            "user_id": data.user_id,
            "visit_id": data.visit_id,
            "reminder_type": data.reminder_type,
            "title": data.title,
            "message": message,
            "scheduled_time": data.scheduled_time,
            "timezone": data.timezone,
            "recurrence": data.recurrence,
        }

        reminder = await db_create_reminder(reminder_data)

        if reminder:
            logger.info("✅ Created reminder %s for patient %s", reminder["id"], data.user_id)
            return _enrich_reminder_response(reminder)

        return None

    except Exception as e:
        logger.error("Error creating reminder: %s", e)
        raise


async def get_reminder_by_id(reminder_id: str, user_id: str) -> Optional[Dict[str, Any]]:
    """Get a single reminder with display fields."""
    reminder = await get_reminder(reminder_id, user_id)
    if reminder:
        return _enrich_reminder_response(reminder)
    return None


async def list_patient_reminders(user_id: str) -> Dict[str, Any]:
    """Get all reminders for a patient, organized by category."""
    all_reminders = await get_all_reminders(user_id)

    enriched = [_enrich_reminder_response(r) for r in all_reminders]

    now = datetime.now(timezone.utc)
    today_start = now.replace(hour=0, minute=0, second=0, microsecond=0)
    today_end = today_start + timedelta(days=1)

    today = []
    upcoming = []
    past = []

    for r in enriched:
        scheduled = r.get("scheduled_time")
        if isinstance(scheduled, str):
            scheduled = datetime.fromisoformat(scheduled.replace("Z", "+00:00"))

        status = r.get("status")
        display_status = r.get("display_status")

        if status in ["completed", "skipped"] or display_status in ["Completed", "Snoozed", "Skipped", "Missed"]:
            past.append(r)
        elif today_start <= scheduled < today_end and status == "pending":
            today.append(r)
        elif scheduled >= today_end and status == "pending":
            upcoming.append(r)
        else:
            if status == "pending":
                today.append(r)
            else:
                past.append(r)

    overview = {
        "total": len(enriched),
        "active_today": len(today),
        "upcoming": len(upcoming),
        "past": len(past),
    }

    return {
        "overview": overview,
        "today": today,
        "upcoming": upcoming,
        "past": past,
    }


async def update_reminder_details(
    reminder_id: str,
    user_id: str,
    updates: ReminderUpdate,
) -> Optional[Dict[str, Any]]:
    """Update reminder details."""
    update_dict = updates.model_dump(exclude_unset=True)

    if not update_dict:
        return await get_reminder_by_id(reminder_id, user_id)

    reminder = await db_update_reminder(reminder_id, user_id, update_dict)

    if reminder:
        logger.info("✅ Updated reminder %s", reminder_id)
        return _enrich_reminder_response(reminder)

    return None


async def cancel_reminder(reminder_id: str, user_id: str) -> bool:
    """Delete/cancel a reminder."""
    success = await db_delete_reminder(reminder_id, user_id)
    if success:
        logger.info("✅ Deleted reminder %s", reminder_id)
    return success


# ============================================================================
# REMINDER INTERACTIONS
# ============================================================================

async def complete_reminder(
    reminder_id: str,
    user_id: str,
    action_data: ReminderAction,
) -> Optional[Dict[str, Any]]:
    """Mark a reminder as completed and create next recurring instance."""
    reminder_data = await get_reminder(reminder_id, user_id)
    if not reminder_data:
        return None

    reminder = await mark_reminder_complete(reminder_id, user_id, action_data.notes)

    if reminder:
        logger.info("Completed reminder %s", reminder_id)

        if reminder_data.get("recurrence") and reminder_data["recurrence"] != "once":
            from domain.reminders.repo import create_recurring_reminder

            new_reminder = await create_recurring_reminder(reminder_data)
            if new_reminder:
                logger.info("Created next recurring reminder %s from %s", new_reminder["id"], reminder_id)

        return _enrich_reminder_response(reminder)

    return None


async def snooze_reminder(
    reminder_id: str,
    user_id: str,
    snooze_minutes: int = 30,
) -> Optional[Dict[str, Any]]:
    """Snooze a reminder by updating scheduled_time. Status changes to 'snoozed'."""
    reminder = await db_snooze_reminder(reminder_id, user_id, snooze_minutes)

    if reminder:
        logger.info("Snoozed reminder %s for %s minutes", reminder_id, snooze_minutes)
        asyncio.create_task(check_and_send_caregiver_alerts(reminder_id, user_id, "snoozed"))
        return _enrich_reminder_response(reminder)

    return None


async def skip_reminder(
    reminder_id: str,
    user_id: str,
    action_data: ReminderAction,
) -> Optional[Dict[str, Any]]:
    """Skip a reminder with optional reason and create next recurring instance."""
    reminder_data = await get_reminder(reminder_id, user_id)
    if not reminder_data:
        return None

    reminder = await db_skip_reminder(reminder_id, user_id, action_data.notes)

    if reminder:
        logger.info("Skipped reminder %s", reminder_id)

        if reminder_data.get("recurrence") and reminder_data["recurrence"] != "once":
            from domain.reminders.repo import create_recurring_reminder

            new_reminder = await create_recurring_reminder(reminder_data)
            if new_reminder:
                logger.info("Created next recurring reminder %s from %s", new_reminder["id"], reminder_id)

        asyncio.create_task(check_and_send_caregiver_alerts(reminder_id, user_id, "skipped"))
        return _enrich_reminder_response(reminder)

    return None


# ============================================================================
# CAREGIVER DASHBOARD
# ============================================================================

async def get_caregiver_dashboard_data(caregiver_id: str, user_id: str) -> Dict[str, Any]:
    """Get aggregated data for caregiver dashboard."""
    try:
        patient_info = await get_patient_info(user_id)
        patient_name = patient_info.get("full_name", "Patient") if patient_info else "Patient"

        next_reminders_raw = await get_next_reminders_for_patient(user_id, limit=5)
        next_reminders = [
            {
                "id": r["id"],
                "title": r["title"],
                "scheduled_time": r["scheduled_time"],
                "reminder_type": r["reminder_type"],
                "status": r["status"],
            }
            for r in next_reminders_raw
        ]

        recent_activity_raw = await get_recent_activity_for_patient(user_id, hours=24)
        recent_activity = [
            {
                "reminder_id": a["reminder_id"],
                "title": a.get("reminders", {}).get("title", "Unknown"),
                "action": a["action"],
                "timestamp": a["timestamp"],
            }
            for a in recent_activity_raw
        ]

        alerts_summary = await get_alerts_summary(caregiver_id, user_id)

        return {
            "user_id": user_id,
            "patient_name": patient_name,
            "next_reminders": next_reminders,
            "recent_activity": recent_activity,
            "alerts_summary": alerts_summary,
        }

    except Exception as e:
        logger.error("Error getting caregiver dashboard: %s", e)
        raise


# ============================================================================
# API-FACING HELPERS
# ============================================================================

async def create_reminder_for_user(user_id: str, data: ReminderCreate):
    data.user_id = user_id
    reminder = await create_new_reminder(data)
    if not reminder:
        raise InternalError("Failed to create reminder")

    invalidate(f"reminders_list:{user_id}")
    invalidate_prefix("caregiver_dashboard:")
    return reminder


async def list_reminders_for_user(user_id: str):
    cache_key = f"reminders_list:{user_id}"
    cached = get(cache_key)
    if cached is not None:
        return cached
    reminders = await list_patient_reminders(user_id)
    set(cache_key, reminders, 30)
    return reminders


async def get_reminder_for_user(reminder_id: str, user_id: str):
    reminder = await get_reminder_by_id(reminder_id, user_id)
    if not reminder:
        raise NotFoundError("Reminder not found")
    return reminder


async def update_reminder_for_user(reminder_id: str, user_id: str, updates: ReminderUpdate):
    reminder = await update_reminder_details(reminder_id, user_id, updates)
    if not reminder:
        raise NotFoundError("Reminder not found")

    invalidate(f"reminders_list:{user_id}")
    invalidate_prefix("caregiver_dashboard:")
    return reminder


async def delete_reminder_for_user(reminder_id: str, user_id: str):
    success = await cancel_reminder(reminder_id, user_id)
    if not success:
        raise NotFoundError("Reminder not found")

    invalidate(f"reminders_list:{user_id}")
    invalidate_prefix("caregiver_dashboard:")
    return None


async def complete_reminder_for_user(reminder_id: str, user_id: str, action: ReminderAction):
    reminder = await complete_reminder(reminder_id, user_id, action)
    if not reminder:
        raise NotFoundError("Reminder not found")

    invalidate(f"reminders_list:{user_id}")
    invalidate_prefix("caregiver_dashboard:")
    return reminder


async def snooze_reminder_for_user(reminder_id: str, user_id: str, snooze_minutes: int):
    reminder = await snooze_reminder(reminder_id, user_id, snooze_minutes)
    if not reminder:
        raise NotFoundError("Cannot snooze: Reminder not found or is already completed/cancelled.")

    invalidate(f"reminders_list:{user_id}")
    invalidate_prefix("caregiver_dashboard:")
    return reminder


async def skip_reminder_for_user(reminder_id: str, user_id: str, action: ReminderAction):
    reminder = await skip_reminder(reminder_id, user_id, action)
    if not reminder:
        raise NotFoundError("Reminder not found")

    invalidate(f"reminders_list:{user_id}")
    invalidate_prefix("caregiver_dashboard:")
    return reminder


async def get_caregiver_activity(caregiver_id: str, user_id: str):
    cache_key = f"caregiver_dashboard:{caregiver_id}:{user_id}"
    cached = get(cache_key)
    if cached is not None:
        return cached
    dashboard_data = await get_caregiver_dashboard_data(caregiver_id, user_id)
    set(cache_key, dashboard_data, 30)
    return dashboard_data


async def list_caregiver_alerts(caregiver_id: str, unread_only: bool):
    cache_key = f"caregiver_alerts:{caregiver_id}:{unread_only}"
    cached = get(cache_key)
    if cached is not None:
        return cached
    alerts = await get_caregiver_alerts(caregiver_id, unread_only)
    set(cache_key, alerts, 30)
    return alerts


async def mark_alert_read(alert_id: str, caregiver_id: str):
    alert = await mark_alert_as_read(alert_id, caregiver_id)
    if not alert:
        raise NotFoundError("Alert not found")

    invalidate_prefix(f"caregiver_alerts:{caregiver_id}:")
    user_id = alert.get("user_id") if alert else None
    if user_id:
        invalidate(f"caregiver_dashboard:{caregiver_id}:{user_id}")
    else:
        invalidate_prefix(f"caregiver_dashboard:{caregiver_id}:")
    return alert
