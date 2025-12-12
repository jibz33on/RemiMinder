# Shared Reminder Model for MediMinder
# Used by FastAPI backend

from enum import Enum
from datetime import datetime
from typing import Optional, Dict, Any, List
from pydantic import BaseModel, Field

class ReminderType(str, Enum):
    MEDICATION = "medication"
    APPOINTMENT = "appointment"
    TASK = "task"

class ReminderStatus(str, Enum):
    PENDING = "pending"
    COMPLETED = "completed"
    SNOOZED = "snoozed"
    SKIPPED = "skipped"

class RecurrenceType(str, Enum):
    ONCE = "once"
    DAILY = "daily"
    WEEKLY = "weekly"
    MONTHLY = "monthly"
    ANNUALLY = "annually"

class Reminder(BaseModel):
    id: str
    user_id: str
    visit_id: Optional[str] = None
    reminder_type: ReminderType
    title: str
    message: str
    scheduled_time: datetime
    timezone: str = "UTC"
    recurrence: RecurrenceType = RecurrenceType.ONCE
    status: ReminderStatus = ReminderStatus.PENDING
    completed_at: Optional[datetime] = None
    snooze_count: int = 0
    snooze_until: Optional[datetime] = None
    created_at: datetime
    updated_at: datetime
    context_data: Optional[Dict[str, Any]] = None

    class Config:
        from_attributes = True
        use_enum_values = True

    # Helper properties
    @property
    def is_overdue(self) -> bool:
        return self.scheduled_time < datetime.utcnow() and self.status == ReminderStatus.PENDING

    @property
    def is_today(self) -> bool:
        now = datetime.utcnow()
        return (self.scheduled_time.day == now.day and
                self.scheduled_time.month == now.month and
                self.scheduled_time.year == now.year)

    @property
    def is_upcoming(self) -> bool:
        return self.scheduled_time > datetime.utcnow()

# Request/Response models
class CreateReminderRequest(BaseModel):
    title: str
    reminder_type: ReminderType
    scheduled_time: datetime
    timezone: str = "UTC"
    recurrence: RecurrenceType = RecurrenceType.ONCE
    context_data: Optional[Dict[str, Any]] = None

class UpdateReminderRequest(BaseModel):
    title: Optional[str] = None
    scheduled_time: Optional[datetime] = None
    timezone: Optional[str] = None
    recurrence: Optional[RecurrenceType] = None
    status: Optional[ReminderStatus] = None

class ReminderActionRequest(BaseModel):
    notes: Optional[str] = None

class SnoozeReminderRequest(BaseModel):
    snooze_minutes: int = Field(default=30, ge=1, le=1440)  # 1 minute to 24 hours

class ReminderOverview(BaseModel):
    total: int
    active_today: int
    upcoming: int
    past: int

class ReminderListResponse(BaseModel):
    overview: ReminderOverview
    today: List[Reminder]
    upcoming: List[Reminder]
    past: List[Reminder]

class ReminderResponse(BaseModel):
    id: str
    user_id: str
    visit_id: Optional[str]
    reminder_type: str
    title: str
    message: str
    scheduled_time: datetime
    timezone: str
    recurrence: Optional[str]
    status: str
    display_status: str
    completed_at: Optional[datetime]
    snooze_count: int
    snooze_until: Optional[datetime]
    icon_type: Optional[str]
    display_time: str
    relative_time: str
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True