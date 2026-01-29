from pydantic import BaseModel, Field
from datetime import datetime
from typing import List, Optional
from uuid import UUID


class VisitSummary(BaseModel):
    visit_id: UUID  # FK to visits.id
    transcript_id: UUID  # FK to visit_transcripts.transcript_id
    user_id: str  # external_auth_id
    summary: str
    action_items: Optional[List[str]] = Field(default_factory=list)
    questions_next_visit: Optional[List[str]] = Field(default_factory=list)
    key_diagnoses: Optional[List[str]] = Field(default_factory=list)
    medications: Optional[List[str]] = Field(default_factory=list)
    created_at: Optional[datetime] = None


class VisitSummaryPayload(BaseModel):
    message: str
    data: VisitSummary


class AIUsage(BaseModel):
    timestamp: Optional[datetime] = None
    input_tokens: Optional[int] = None
    output_tokens: Optional[int] = None
    total_cost: Optional[float] = None
    visit_id: Optional[UUID] = None
    transcript_id: Optional[UUID] = None
    user_id: Optional[str] = None
