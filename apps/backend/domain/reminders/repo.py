from datetime import datetime, timedelta, timezone
from typing import List, Optional, Dict, Any
import uuid

from dateutil import parser
import pytz
from sqlalchemy import text

from domain.ports.db import get_db_engine
from domain.ports.logging import get_logger

logger = get_logger()


def _row_to_dict(row: Any) -> Optional[Dict[str, Any]]:
    if not row:
        return None
    if hasattr(row, "_mapping"):
        return dict(row._mapping)
    return dict(row)


def _rows_to_dicts(rows: List[Any]) -> List[Dict[str, Any]]:
    return [dict(row._mapping) if hasattr(row, "_mapping") else dict(row) for row in rows]


async def create_reminder(data: dict) -> Optional[Dict[str, Any]]:
    """Create a new reminder in the database."""
    # Convert UUIDs to strings if needed (exclude user_id, which is external_auth_id)
    user_id = data["user_id"]
    visit_id = str(data["visit_id"]) if data.get("visit_id") and isinstance(data["visit_id"], uuid.UUID) else data.get("visit_id")

    engine = get_db_engine()
    with engine.begin() as conn:
        result = conn.execute(
            text("""
                INSERT INTO reminders
                (user_id, visit_id, reminder_type, title, message, scheduled_time, timezone, recurrence, status)
                VALUES (:user_id, :visit_id, :reminder_type, :title, :message, :scheduled_time, :timezone, :recurrence, :status)
                RETURNING *
            """),
            {
                "user_id": user_id,
                "visit_id": visit_id,
                "reminder_type": data["reminder_type"],
                "title": data["title"],
                "message": data["message"],
                "scheduled_time": data["scheduled_time"],
                "timezone": data["timezone"],
                "recurrence": data.get("recurrence", "once"),
                "status": "pending",
            },
        )
        return _row_to_dict(result.fetchone())


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
    engine = get_db_engine()
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                SELECT *
                FROM reminders
                WHERE id = :reminder_id
                  AND user_id = :user_id
                LIMIT 1
            """),
            {"reminder_id": reminder_id, "user_id": user_id},
        )
        return _row_to_dict(result.fetchone())

async def get_all_reminders(user_id: str) -> List[Dict[str, Any]]:
    """Fetch all reminders for a patient."""
    engine = get_db_engine()
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                SELECT *
                FROM reminders
                WHERE user_id = :user_id
                ORDER BY scheduled_time ASC
            """),
            {"user_id": user_id},
        )
        return _rows_to_dicts(result.fetchall())


async def update_reminder(reminder_id: str, user_id: str, updates: dict) -> Optional[Dict[str, Any]]:
    """Update a reminder."""
    # Convert datetime to ISO string if present
    if "scheduled_time" in updates and isinstance(updates["scheduled_time"], datetime):
        updates["scheduled_time"] = updates["scheduled_time"]

    if not updates:
        return await get_reminder(reminder_id, user_id)

    set_clauses = []
    params = {"reminder_id": reminder_id, "user_id": user_id}
    for key, value in updates.items():
        set_clauses.append(f"{key} = :{key}")
        params[key] = value

    engine = get_db_engine()
    with engine.begin() as conn:
        result = conn.execute(
            text(f"""
                UPDATE reminders
                SET {', '.join(set_clauses)}
                WHERE id = :reminder_id
                  AND user_id = :user_id
                RETURNING *
            """),
            params,
        )
        return _row_to_dict(result.fetchone())


async def delete_reminder(reminder_id: str, user_id: str) -> bool:
    """Delete a reminder."""
    engine = get_db_engine()
    with engine.begin() as conn:
        result = conn.execute(
            text("""
                DELETE FROM reminders
                WHERE id = :reminder_id
                  AND user_id = :user_id
                RETURNING id
            """),
            {"reminder_id": reminder_id, "user_id": user_id},
        )
        return result.fetchone() is not None


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
    # Convert UUIDs to strings if needed (exclude user_id, which is external_auth_id)
    reminder_id = str(reminder_id) if isinstance(reminder_id, uuid.UUID) else reminder_id
    user_id = user_id

    engine = get_db_engine()
    with engine.begin() as conn:
        result = conn.execute(
            text("""
                INSERT INTO reminder_logs
                (reminder_id, user_id, action, notes)
                VALUES (:reminder_id, :user_id, :action, :notes)
                RETURNING *
            """),
            {
                "reminder_id": reminder_id,
                "user_id": user_id,
                "action": action,
                "notes": notes,
            },
        )
        return _row_to_dict(result.fetchone())


async def get_reminder_logs(reminder_id: str) -> List[Dict[str, Any]]:
    """Fetch all logs for a specific reminder."""
    engine = get_db_engine()
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                SELECT *
                FROM reminder_logs
                WHERE reminder_id = :reminder_id
                ORDER BY created_at DESC
            """),
            {"reminder_id": reminder_id},
        )
        return _rows_to_dicts(result.fetchall())


# ============================================================================
# SCHEDULER QUERIES
# ============================================================================

async def get_pending_reminders() -> List[Dict[str, Any]]:
    """Fetch all pending reminders that are due now (for scheduler)."""
    now = datetime.now(timezone.utc).isoformat()
    engine = get_db_engine()
    with engine.connect() as conn:
        pending = conn.execute(
            text("""
                SELECT *
                FROM reminders
                WHERE status = 'pending'
                  AND scheduled_time <= :now
                  AND retry_count < 2
                  AND snooze_until IS NULL
            """),
            {"now": now},
        ).fetchall()
        snoozed = conn.execute(
            text("""
                SELECT *
                FROM reminders
                WHERE status = 'snoozed'
                  AND scheduled_time <= :now
                  AND retry_count < 2
            """),
            {"now": now},
        ).fetchall()
        return _rows_to_dicts(pending + snoozed)


async def get_missed_reminders_for_auto_skip() -> List[Dict[str, Any]]:
    """
    Fetch reminders that are 1+ days overdue and still pending.
    These will be auto-skipped by the scheduler.
    """
    # Calculate cutoff: 24 hours ago
    cutoff_time = (datetime.now(timezone.utc) - timedelta(days=1)).isoformat()
    engine = get_db_engine()
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                SELECT *
                FROM reminders
                WHERE status = 'pending'
                  AND scheduled_time <= :cutoff
            """),
            {"cutoff": cutoff_time},
        )
        return _rows_to_dicts(result.fetchall())

async def create_recurring_reminder(original_reminder: dict) -> Optional[Dict[str, Any]]:
    """Create a new reminder for recurring schedule (used by scheduler)."""
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
    
    engine = get_db_engine()
    with engine.begin() as conn:
        result = conn.execute(
            text("""
                INSERT INTO reminders
                (user_id, visit_id, reminder_type, title, message, scheduled_time, timezone, recurrence, status)
                VALUES (:user_id, :visit_id, :reminder_type, :title, :message, :scheduled_time, :timezone, :recurrence, :status)
                RETURNING *
            """),
            new_reminder_data,
        )
        return _row_to_dict(result.fetchone())


# ============================================================================
# CAREGIVER QUERIES
# ============================================================================

async def get_patient_info(user_id: str) -> Optional[Dict[str, Any]]:
    """Get patient name and email."""
    engine = get_db_engine()
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                SELECT id, full_name, email
                FROM users
                WHERE external_auth_id = :user_id
                LIMIT 1
            """),
            {"user_id": user_id},
        )
        return _row_to_dict(result.fetchone())


async def get_next_reminders_for_patient(user_id: str, limit: int = 5) -> List[Dict[str, Any]]:
    """Get next upcoming reminders for caregiver dashboard."""
    now = datetime.now(timezone.utc).isoformat()
    engine = get_db_engine()
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                SELECT id, title, scheduled_time, reminder_type, status
                FROM reminders
                WHERE user_id = :user_id
                  AND status = 'pending'
                  AND scheduled_time >= :now
                ORDER BY scheduled_time ASC
                LIMIT :limit
            """),
            {"user_id": user_id, "now": now, "limit": limit},
        )
        return _rows_to_dicts(result.fetchall())


async def get_recent_activity_for_patient(user_id: str, hours: int = 24) -> List[Dict[str, Any]]:
    """Get recent reminder activity for caregiver dashboard."""
    cutoff_time = (datetime.now(timezone.utc) - timedelta(hours=hours)).isoformat()
    engine = get_db_engine()
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                SELECT rl.reminder_id, rl.action, rl.created_at AS timestamp, r.title
                FROM reminder_logs rl
                LEFT JOIN reminders r ON r.id = rl.reminder_id
                WHERE rl.user_id = :user_id
                  AND rl.created_at >= :cutoff
                ORDER BY rl.created_at DESC
            """),
            {"user_id": user_id, "cutoff": cutoff_time},
        )
        rows = result.fetchall()
        activity = []
        for row in rows:
            mapping = row._mapping if hasattr(row, "_mapping") else row
            activity.append({
                "reminder_id": mapping[0],
                "action": mapping[1],
                "timestamp": mapping[2],
                "reminders": {"title": mapping[3]},
            })
        return activity


async def create_caregiver_alert(
    caregiver_id: str,
    user_id: str,
    reminder_id: str,
    alert_type: str,
    message: str
) -> Optional[Dict[str, Any]]:
    """Create a caregiver alert."""
    # Convert UUIDs to strings if needed (exclude user_id, which is external_auth_id)
    caregiver_id = str(caregiver_id) if isinstance(caregiver_id, uuid.UUID) else caregiver_id
    user_id = user_id
    reminder_id = str(reminder_id) if isinstance(reminder_id, uuid.UUID) else reminder_id

    engine = get_db_engine()
    with engine.begin() as conn:
        result = conn.execute(
            text("""
                INSERT INTO caregiver_alerts
                (caregiver_id, user_id, reminder_id, alert_type, message)
                VALUES (:caregiver_id, :user_id, :reminder_id, :alert_type, :message)
                RETURNING *
            """),
            {
                "caregiver_id": caregiver_id,
                "user_id": user_id,
                "reminder_id": reminder_id,
                "alert_type": alert_type,
                "message": message,
            },
        )
        response_row = _row_to_dict(result.fetchone())
    return response_row


async def get_caregiver_alerts(caregiver_id: str, unread_only: bool = False) -> List[Dict[str, Any]]:
    """Get alerts for a caregiver."""
    engine = get_db_engine()
    with engine.connect() as conn:
        if unread_only:
            result = conn.execute(
                text("""
                    SELECT *
                    FROM caregiver_alerts
                    WHERE caregiver_id = :caregiver_id
                      AND read = false
                    ORDER BY sent_at DESC
                """),
                {"caregiver_id": caregiver_id},
            )
        else:
            result = conn.execute(
                text("""
                    SELECT *
                    FROM caregiver_alerts
                    WHERE caregiver_id = :caregiver_id
                    ORDER BY sent_at DESC
                """),
                {"caregiver_id": caregiver_id},
            )
        return _rows_to_dicts(result.fetchall())


async def mark_alert_as_read(alert_id: str, caregiver_id: str) -> Optional[Dict[str, Any]]:
    """Mark a caregiver alert as read."""
    engine = get_db_engine()
    with engine.begin() as conn:
        result = conn.execute(
            text("""
                UPDATE caregiver_alerts
                SET read = true
                WHERE id = :alert_id
                  AND caregiver_id = :caregiver_id
                RETURNING *
            """),
            {"alert_id": alert_id, "caregiver_id": caregiver_id},
        )
        return _row_to_dict(result.fetchone())


async def get_alerts_summary(caregiver_id: str, user_id: str) -> Dict[str, int]:
    """Get alert summary counts for caregiver dashboard."""
    engine = get_db_engine()
    with engine.connect() as conn:
        unread_count = conn.execute(
            text("""
                SELECT COUNT(*) FROM caregiver_alerts
                WHERE caregiver_id = :caregiver_id
                  AND user_id = :user_id
                  AND read = false
            """),
            {"caregiver_id": caregiver_id, "user_id": user_id},
        ).scalar() or 0

        today_start = datetime.now(timezone.utc).replace(hour=0, minute=0, second=0, microsecond=0)
        missed_count = conn.execute(
            text("""
                SELECT COUNT(*) FROM reminder_logs
                WHERE user_id = :user_id
                  AND action = 'skipped'
                  AND created_at >= :today_start
            """),
            {"user_id": user_id, "today_start": today_start},
        ).scalar() or 0

        snoozed_count = conn.execute(
            text("""
                SELECT COUNT(*) FROM caregiver_alerts
                WHERE caregiver_id = :caregiver_id
                  AND user_id = :user_id
                  AND alert_type = 'multiple_snoozes'
                  AND read = false
            """),
            {"caregiver_id": caregiver_id, "user_id": user_id},
        ).scalar() or 0

    return {
        "unread_alerts": int(unread_count),
        "missed_today": int(missed_count),
        "snoozed_multiple": int(snoozed_count),
    }


# ============================================================================
# TEMPLATE QUERIES
# ============================================================================

async def get_reminder_template(template_id: str) -> Optional[Dict[str, Any]]:
    """Fetch a reminder message template."""
    engine = get_db_engine()
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                SELECT *
                FROM reminder_templates
                WHERE id = :template_id
                LIMIT 1
            """),
            {"template_id": template_id},
        )
        return _row_to_dict(result.fetchone())


async def get_templates_by_type(reminder_type: str) -> List[Dict[str, Any]]:
    """Get all templates for a specific reminder type."""
    engine = get_db_engine()
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                SELECT *
                FROM reminder_templates
                WHERE reminder_type = :reminder_type
            """),
            {"reminder_type": reminder_type},
        )
        return _rows_to_dicts(result.fetchall())


async def get_prompt_text_by_name(template_name: str) -> Optional[str]:
    """Fetch prompt text from reminder_templates by template_name."""
    engine = get_db_engine()
    with engine.connect() as conn:
        row = conn.execute(
            text("""
                SELECT template_content
                FROM reminder_templates
                WHERE template_name = :template_name
                LIMIT 1
            """),
            {"template_name": template_name},
        ).fetchone()

    if not row:
        return None
    if hasattr(row, "_mapping"):
        return row._mapping.get("template_content")
    return row[0]

