from pydantic import BaseModel
from datetime import datetime
from typing import Optional
from uuid import UUID


class VisitTranscript(BaseModel):
    transcript_id: Optional[UUID] = None
    visit_id: Optional[UUID] = None
    user_id: str
    audio_url: Optional[str] = None
    transcript_text: Optional[str] = None
    created_at: Optional[datetime] = None
