import logging
from datetime import datetime, timedelta, timezone
from typing import List, Optional, Dict, Any
import uuid

from dateutil import parser
import pytz

from .supabase_client import get_supabase_client

logger = logging.getLogger(__name__)

async def create_reminder(data: dict) -> Optional[Dict[str, Any]]:
    """Create a new reminder in the database."""
    # Convert UUIDs to strings if needed
    user_id = str(data["user_id"]) if isinstance(data["user_id"], uuid.UUID) else data["user_id"]
    visit_id = str(data["visit_id"]) if data.get("visit_id") and isinstance(data["visit_id"], uuid.UUID) else data.get("visit_id")

    reminder_data = {
        "user_id": user_id,
        "visit_id": visit_id,
        "reminder_type": data["reminder_type"],
        "title": data["title"],
        "message": data["message"],
        "scheduled_time": data["scheduled_time"].isoformat(),
        "timezone": data["timezone"],
        "recurrence": data.get("recurrence", "once"),
        "status": "pending"
    }

    supabase = get_supabase_client()
    response = supabase.table("reminders").insert(reminder_data).execute()
    return response.data[0] if response.data else None


async def insert_ai_reminders(
    ai_summary_result: Dict,
    user_id: str,
    visit_id: str
) -> List[Optional[Dict[str, Any]]]:
    """Transform AI-generated reminders into database format and insert them."""
    USER_TIMEZONE = 'America/New_York'
    reminders_to_insert = ai_summary_result.get("reminders", [])
    inserted_reminders = []
    
    for reminder_item in reminders_to_insert:
        scheduled_datetime_utc = None

        # Extract reminder data
        title = ai_summary_result.get("title", "Doctor Office Visit")
        message = reminder_item["text"]
        reminder_type = reminder_item["type"]
        recurrence = reminder_item.get("recurrence", "once")

        # Parse scheduled time
        scheduled_date_str = reminder_item.get("scheduled_date", "")
        scheduled_time_str = reminder_item.get("scheduled_time", "")

        if scheduled_date_str:
            try:
                datetime_str = f"{scheduled_date_str} {scheduled_time_str or '00:00'}"
                dt_naive = parser.parse(datetime_str)

                # Convert NY time to UTC
                ny_tz = pytz.timezone(USER_TIMEZONE)
                dt_ny_aware = ny_tz.localize(dt_naive)
                scheduled_datetime_utc = dt_ny_aware.astimezone(timezone.utc)

            except Exception as e:
                logger.warning(f"Failed to parse date/time for reminder '{message}': {e}")
                continue 

        # Handle recurring reminders without specific dates
        elif recurrence != 'once':
            # Schedule first instance for tomorrow at 8 AM NY time
            ny_tz = pytz.timezone(USER_TIMEZONE)
            tomorrow_ny = datetime.now(ny_tz) + timedelta(days=1)
            tomorrow_8am_ny = tomorrow_ny.replace(hour=8, minute=0, second=0, microsecond=0)
            scheduled_datetime_utc = tomorrow_8am_ny.astimezone(timezone.utc)

        # Insert reminder if we have a valid scheduled time
        if scheduled_datetime_utc is not None:
            db_data = {
                "user_id": user_id,
                "visit_id": visit_id,
                "reminder_type": reminder_type,
                "title": title,
                "message": message,
                "scheduled_time": scheduled_datetime_utc,
                "timezone": USER_TIMEZONE,
                "recurrence": recurrence,
            }

            try:
                inserted = await create_reminder(db_data)
                inserted_reminders.append(inserted)
            except Exception as e:
                logger.error(f"Error inserting reminder '{message}': {e}")
                inserted_reminders.append(None)
                
    return inserted_reminders

async def get_reminder(reminder_id: str, user_id: str) -> Optional[Dict[str, Any]]:
    """Fetch a single reminder by ID."""
    supabase = get_supabase_client()
    
    response = (
        supabase.table("reminders")
        .select("*")
        .eq("id", reminder_id)
        .eq("user_id", user_id)
        .single()
        .execute()
    )
    
    return response.data if response.data else None

async def get_all_reminders(user_id: str) -> List[Dict[str, Any]]:
    """Fetch all reminders for a patient."""
    supabase = get_supabase_client()
    
    response = (
        supabase.table("reminders")
        .select("*")
        .eq("user_id", user_id)
        .order("scheduled_time", desc=False)
        .execute()
    )
    
    return response.data or []


async def update_reminder(reminder_id: str, user_id: str, updates: dict) -> Optional[Dict[str, Any]]:
    """Update a reminder."""
    supabase = get_supabase_client()
    
    # Convert datetime to ISO string if present
    if "scheduled_time" in updates and isinstance(updates["scheduled_time"], datetime):
        updates["scheduled_time"] = updates["scheduled_time"].isoformat()
    
    response = (
        supabase.table("reminders")
        .update(updates)
        .eq("id", reminder_id)
        .eq("user_id", user_id)
        .execute()
    )
    
    return response.data[0] if response.data else None


async def delete_reminder(reminder_id: str, user_id: str) -> bool:
    """Delete a reminder."""
    supabase = get_supabase_client()
    
    response = (
        supabase.table("reminders")
        .delete()
        .eq("id", reminder_id)
        .eq("user_id", user_id)
        .execute()
    )
    
    return len(response.data) > 0 if response.data else False


# ============================================================================
# REMINDER STATUS UPDATES
# ============================================================================

async def mark_reminder_complete(reminder_id: str, user_id: str, notes: Optional[str] = None) -> Optional[Dict[str, Any]]:
    """Mark a reminder as completed."""
    now = datetime.now(timezone.utc)

    # Update reminder status and reset skip count
    reminder = await update_reminder(
        reminder_id,
        user_id,
        {
            "status": "completed",
            "completed_at": now.isoformat(),
            "consecutive_skips": 0
        }
    )

    # Create next recurring instance if needed
    if reminder and reminder.get("recurrence") and reminder["recurrence"] != "once":
        await create_recurring_reminder(reminder)

    # Log the action
    if reminder:
        await log_reminder_action(reminder_id, user_id, "completed", notes)

    return reminder


async def snooze_reminder(reminder_id: str, user_id: str, snooze_minutes: int = 30) -> Optional[Dict[str, Any]]:
    """Snooze a reminder once."""
    supabase = get_supabase_client()
    
    # Get current reminder
    reminder = await get_reminder(reminder_id, user_id)
    if not reminder:
        return None
    
    # Check if already snoozed once (MVP: only allow one snooze)
    if reminder.get("snoozed_count", 0) >= 1:
        return None  # Already snoozed once
    
    now = datetime.now(timezone.utc)
    new_scheduled_time = now + timedelta(minutes=snooze_minutes)
    updated = await update_reminder(
        reminder_id, user_id,
        {
            "status": "snoozed",
            "snoozed_count": reminder.get("snoozed_count", 0) + 1,
            "scheduled_time": new_scheduled_time.isoformat(),
            "snooze_until": None  # Clear it
        }
    )    

    if updated:
        # Log the action
        await log_reminder_action(reminder_id, user_id, "snoozed", f"Snoozed for {snooze_minutes} minutes")
    
    return updated


async def skip_reminder(reminder_id: str, user_id: str, reason: Optional[str] = None) -> Optional[Dict[str, Any]]:
    """Skip a reminder."""
    supabase = get_supabase_client()
    
    # Update reminder status
    reminder = await update_reminder(
        reminder_id,
        user_id,
        {"status": "skipped"}
    )

    current_skips = reminder.get("consecutive_skips", 0)
    await update_reminder(
        reminder_id, user_id,
        {"consecutive_skips": current_skips + 1}
    )

    # If recurring, create next instance
    if reminder.get("recurrence") and reminder["recurrence"] != "once":
        await create_recurring_reminder(reminder)    

    if reminder:
        # Log the action with reason
        await log_reminder_action(reminder_id, user_id, "skipped", reason)
    
    return reminder


# ============================================================================
# REMINDER LOGS
# ============================================================================

async def log_reminder_action(
    reminder_id: str,
    user_id: str,
    action: str,
    notes: Optional[str] = None
) -> Optional[Dict[str, Any]]:
    """Log a reminder action to reminder_logs table."""
    # Convert UUIDs to strings if needed
    reminder_id = str(reminder_id) if isinstance(reminder_id, uuid.UUID) else reminder_id
    user_id = str(user_id) if isinstance(user_id, uuid.UUID) else user_id

    log_data = {
        "reminder_id": reminder_id,
        "user_id": user_id,
        "action": action,
        "notes": notes
    }

    supabase = get_supabase_client()
    response = supabase.table("reminder_logs").insert(log_data).execute()
    return response.data[0] if response.data else None


async def get_reminder_logs(reminder_id: str) -> List[Dict[str, Any]]:
    """Fetch all logs for a specific reminder."""
    supabase = get_supabase_client()
    
    response = (
        supabase.table("reminder_logs")
        .select("*")
        .eq("reminder_id", reminder_id)
        .order("timestamp", desc=True)
        .execute()
    )
    
    return response.data or []


# ============================================================================
# SCHEDULER QUERIES
# ============================================================================

async def get_pending_reminders() -> List[Dict[str, Any]]:
    """Fetch all pending reminders that are due now (for scheduler)."""
    supabase = get_supabase_client()
    
    now = datetime.now(timezone.utc).isoformat()

    response = (
        supabase.table("reminders")
        .select("*")
        .eq("status", "pending")
        .lte("scheduled_time", now)
        .lt("retry_count", 2)  # Only retry up to 2 times
        .is_("snooze_until", "null")  # Not snoozed
        .execute()
    )    
    # Also check snoozed reminders that are ready
    snoozed_response = (
        supabase.table("reminders")
        .select("*")
        .eq("status", "snoozed")
        .lte("scheduled_time", now)  # Use scheduled_time now, not snooze_until
        .lt("retry_count", 2)
        .execute()
    )

    all_reminders = (response.data or []) + (snoozed_response.data or [])
    return all_reminders


async def get_missed_reminders_for_auto_skip() -> List[Dict[str, Any]]:
    """
    Fetch reminders that are 1+ days overdue and still pending.
    These will be auto-skipped by the scheduler.
    """
    supabase = get_supabase_client()
    
    # Calculate cutoff: 24 hours ago
    cutoff_time = (datetime.now(timezone.utc) - timedelta(days=1)).isoformat()
    
    response = (
        supabase.table("reminders")
        .select("*")
        .eq("status", "pending")
        .lte("scheduled_time", cutoff_time)
        .execute()
    )
    
    return response.data or []

async def create_recurring_reminder(original_reminder: dict) -> Optional[Dict[str, Any]]:
    """Create a new reminder for recurring schedule (used by scheduler)."""
    supabase = get_supabase_client()
    
    # Parse original scheduled time
    original_time = datetime.fromisoformat(original_reminder["scheduled_time"].replace("Z", "+00:00"))
    
    # Calculate next scheduled time based on recurrence
    if original_reminder["recurrence"] == "daily":
        next_time = original_time + timedelta(days=1)
    elif original_reminder["recurrence"] == "weekly":
        next_time = original_time + timedelta(weeks=1)
    else:
        return None  # No recurrence
    
    # Create new reminder (copy of original with new time)
    new_reminder_data = {
        "user_id": original_reminder["user_id"],
        "visit_id": original_reminder.get("visit_id"),
        "reminder_type": original_reminder["reminder_type"],
        "title": original_reminder["title"],
        "message": original_reminder["message"],
        "scheduled_time": next_time.isoformat(),
        "timezone": original_reminder["timezone"],
        "recurrence": original_reminder["recurrence"],
        "status": "pending"
    }
    
    response = supabase.table("reminders").insert(new_reminder_data).execute()
    return response.data[0] if response.data else None


# ============================================================================
# CAREGIVER QUERIES
# ============================================================================

async def get_patient_info(user_id: str) -> Optional[Dict[str, Any]]:
    """Get patient name and email."""
    supabase = get_supabase_client()
    
    response = (
        supabase.table("users")
        .select("id, full_name, email")
        .eq("id", user_id)
        .single()
        .execute()
    )
    
    return response.data if response.data else None


async def get_next_reminders_for_patient(user_id: str, limit: int = 5) -> List[Dict[str, Any]]:
    """Get next upcoming reminders for caregiver dashboard."""
    supabase = get_supabase_client()
    
    now = datetime.now(timezone.utc).isoformat()
    
    response = (
        supabase.table("reminders")
        .select("id, title, scheduled_time, reminder_type, status")
        .eq("user_id", user_id)
        .eq("status", "pending")
        .gte("scheduled_time", now)
        .order("scheduled_time", desc=False)
        .limit(limit)
        .execute()
    )
    
    return response.data or []


async def get_recent_activity_for_patient(user_id: str, hours: int = 24) -> List[Dict[str, Any]]:
    """Get recent reminder activity for caregiver dashboard."""
    supabase = get_supabase_client()
    
    cutoff_time = (datetime.now(timezone.utc) - timedelta(hours=hours)).isoformat()
    
    response = (
        supabase.table("reminder_logs")
        .select("reminder_id, action, timestamp, reminders(title)")
        .eq("user_id", user_id)
        .gte("timestamp", cutoff_time)
        .order("timestamp", desc=True)
        .execute()
    )
    
    return response.data or []


async def create_caregiver_alert(
    caregiver_id: str,
    user_id: str,
    reminder_id: str,
    alert_type: str,
    message: str
) -> Optional[Dict[str, Any]]:
    """Create a caregiver alert."""
    # Convert UUIDs to strings if needed
    caregiver_id = str(caregiver_id) if isinstance(caregiver_id, uuid.UUID) else caregiver_id
    user_id = str(user_id) if isinstance(user_id, uuid.UUID) else user_id
    reminder_id = str(reminder_id) if isinstance(reminder_id, uuid.UUID) else reminder_id

    alert_data = {
        "caregiver_id": caregiver_id,
        "user_id": user_id,
        "reminder_id": reminder_id,
        "alert_type": alert_type,
        "message": message
    }

    supabase = get_supabase_client()
    response = supabase.table("caregiver_alerts").insert(alert_data).execute()
    from services.cache_service import invalidate, invalidate_prefix
    invalidate_prefix(f"caregiver_alerts:{caregiver_id}:")
    invalidate(f"caregiver_dashboard:{caregiver_id}:{user_id}")
    return response.data[0] if response.data else None


async def get_caregiver_alerts(caregiver_id: str, unread_only: bool = False) -> List[Dict[str, Any]]:
    """Get alerts for a caregiver."""
    supabase = get_supabase_client()
    
    query = (
        supabase.table("caregiver_alerts")
        .select("*")
        .eq("caregiver_id", caregiver_id)
        .order("sent_at", desc=True)
    )
    
    if unread_only:
        query = query.eq("read", False)
    
    response = query.execute()
    return response.data or []


async def mark_alert_as_read(alert_id: str, caregiver_id: str) -> Optional[Dict[str, Any]]:
    """Mark a caregiver alert as read."""
    supabase = get_supabase_client()
    
    response = (
        supabase.table("caregiver_alerts")
        .update({"read": True})
        .eq("id", alert_id)
        .eq("caregiver_id", caregiver_id)
        .execute()
    )
    
    return response.data[0] if response.data else None


async def get_alerts_summary(caregiver_id: str, user_id: str) -> Dict[str, int]:
    """Get alert summary counts for caregiver dashboard."""
    supabase = get_supabase_client()
    
    # Count unread alerts
    unread_response = (
        supabase.table("caregiver_alerts")
        .select("id", count="exact")
        .eq("caregiver_id", caregiver_id)
        .eq("user_id", user_id)
        .eq("read", False)
        .execute()
    )
    
    # Count missed today
    today_start = datetime.now(timezone.utc).replace(hour=0, minute=0, second=0, microsecond=0).isoformat()
    missed_response = (
        supabase.table("reminder_logs")
        .select("id", count="exact")
        .eq("user_id", user_id)
        .eq("action", "skipped")
        .gte("timestamp", today_start)
        .execute()
    )
    
    # Count multiple snoozes
    snoozed_response = (
        supabase.table("caregiver_alerts")
        .select("id", count="exact")
        .eq("caregiver_id", caregiver_id)
        .eq("user_id", user_id)
        .eq("alert_type", "multiple_snoozes")
        .eq("read", False)
        .execute()
    )
    
    return {
        "unread_alerts": unread_response.count or 0,
        "missed_today": missed_response.count or 0,
        "snoozed_multiple": snoozed_response.count or 0
    }


# ============================================================================
# TEMPLATE QUERIES
# ============================================================================

async def get_reminder_template(template_id: str) -> Optional[Dict[str, Any]]:
    """Fetch a reminder message template."""
    supabase = get_supabase_client()
    
    response = (
        supabase.table("reminder_templates")
        .select("*")
        .eq("id", template_id)
        .single()
        .execute()
    )
    
    return response.data if response.data else None


async def get_templates_by_type(reminder_type: str) -> List[Dict[str, Any]]:
    """Get all templates for a specific reminder type."""
    supabase = get_supabase_client()
    
    response = (
        supabase.table("reminder_templates")
        .select("*")
        .eq("reminder_type", reminder_type)
        .execute()
    )
    
    return response.data or []

