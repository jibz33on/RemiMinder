from pydantic import BaseModel
from datetime import datetime
from typing import Optional
from uuid import UUID


class Visit(BaseModel):
    user_id: str
    transcript_id: Optional[UUID] = None
    title: Optional[str] = None
    status: Optional[str] = None
    doctor: Optional[str] = None
    specialty: Optional[str] = None
    duration: Optional[str] = None
    created_at: Optional[datetime] = None
