from fastapi import APIRouter, status, Body, Depends, Request
from typing import List

from domain.reminders.models import (
    ReminderCreate,
    ReminderUpdate,
    ReminderAction,
    ReminderResponse,
    ReminderListResponse,
    CaregiverAlertResponse,
    CaregiverDashboardResponse
)
from domain.reminders.service import (
    complete_reminder_for_user,
    create_reminder_for_user,
    delete_reminder_for_user,
    get_caregiver_activity,
    get_reminder_for_user,
    list_caregiver_alerts,
    list_reminders_for_user,
    mark_alert_read,
    skip_reminder_for_user,
    snooze_reminder_for_user,
    update_reminder_for_user,
)
from domain.auth import get_current_user as get_current_user_port

router = APIRouter(prefix="/api", tags=["reminders"])


def get_current_user(request: Request) -> str:
    return get_current_user_port(request)

@router.post("/reminders", response_model=ReminderResponse, status_code=status.HTTP_201_CREATED)
async def create_reminder(data: ReminderCreate, user_id: str = Depends(get_current_user)):
    """
    Create a new reminder with AI-generated personalized message.
    """
    return await create_reminder_for_user(user_id, data)

# Get user_id from JWT token instead of query param
@router.get("/reminders", response_model=ReminderListResponse)
async def get_patient_reminders(user_id: str = Depends(get_current_user)):
    """
    Get all reminders for a patient, organized by category (today, upcoming, past).
    """
    return await list_reminders_for_user(user_id)

@router.get("/reminders/{reminder_id}", response_model=ReminderResponse)
async def get_reminder(reminder_id: str, user_id: str = Depends(get_current_user)):
    """
    Get a single reminder by ID.
    """
    return await get_reminder_for_user(reminder_id, user_id)


@router.put("/reminders/{reminder_id}", response_model=ReminderResponse)
async def update_reminder(reminder_id: str, user_id: str = Depends(get_current_user), updates: ReminderUpdate = Body(...)):
    """
    Update a reminder (time, title, status, etc.).
    """
    return await update_reminder_for_user(reminder_id, user_id, updates)


@router.delete("/reminders/{reminder_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_reminder(reminder_id: str, user_id: str = Depends(get_current_user)):
    """
    Cancel/delete a reminder.
    """
    return await delete_reminder_for_user(reminder_id, user_id)


@router.post("/reminders/{reminder_id}/complete", response_model=ReminderResponse)
async def mark_complete(
    reminder_id: str, 
    user_id: str = Depends(get_current_user),
    action: ReminderAction = Body(default=ReminderAction())
):
    """
    Mark a reminder as completed.
    """
    return await complete_reminder_for_user(reminder_id, user_id, action)

@router.post("/reminders/{reminder_id}/snooze", response_model=ReminderResponse)
async def snooze_reminder_post(
    reminder_id: str,
    user_id: str = Depends(get_current_user),
    snooze_minutes: int = 30
):
    """
    Snooze a reminder. The snooze count is incremented, and the scheduled time is pushed forward.
    """
    return await snooze_reminder_for_user(reminder_id, user_id, snooze_minutes)

@router.post("/reminders/{reminder_id}/skip", response_model=ReminderResponse)
async def skip_reminder_post(
    reminder_id: str, 
    user_id: str = Depends(get_current_user),
    action: ReminderAction = Body(default=ReminderAction())
):
    
    """
    Skip a reminder with optional reason.
    """
    return await skip_reminder_for_user(reminder_id, user_id, action)


# ============================================================================
# CAREGIVER
# ============================================================================

@router.get("/caregivers/{caregiver_id}/activity", response_model=CaregiverDashboardResponse)
async def get_caregiver_activity(caregiver_id: str, user_id: str = Depends(get_current_user)):
    """
    Get aggregated activity data for caregiver dashboard.
    Shows next reminders, recent activity, and alert summary.
    """
    return await get_caregiver_activity(caregiver_id, user_id)

@router.get("/caregivers/{caregiver_id}/alerts", response_model=List[CaregiverAlertResponse])
async def get_alerts(caregiver_id: str, unread_only: bool = False):
    """
    Get all alerts for a caregiver.
    """
    return await list_caregiver_alerts(caregiver_id, unread_only)


@router.patch("/caregivers/alerts/{alert_id}/read", response_model=CaregiverAlertResponse)
async def mark_alert_read(alert_id: str, caregiver_id: str):
    """
    Mark a caregiver alert as read.
    """
    return await mark_alert_read(alert_id, caregiver_id)


# High-accuracy speech-to-text processing
# TODO: Implement SpeechToTextService
# @router.post("/process-audio-transcription")
# async def process_audio_transcription(
#     audio_file: UploadFile = File(..., description="Audio file to transcribe"),
#     patient_id: str = Form(..., description="Patient ID"),
#     visit_id: str = Form(..., description="Visit ID")
# ):
#     """
#     Process uploaded audio file with high-accuracy Whisper transcription.
#     Use this for critical medical conversations requiring maximum accuracy.
#     """
#     try:
#         stt_service = SpeechToTextService()

#         # Save uploaded file temporarily
#         temp_dir = "/tmp"  # Use appropriate temp directory
#         file_extension = os.path.splitext(audio_file.filename)[1] or ".wav"
#         temp_path = f"{temp_dir}/audio_{patient_id}_{visit_id}{file_extension}"

#         with open(temp_path, "wb") as buffer:
#             shutil.copyfileobj(audio_file.file, buffer)

#         # Transcribe with Whisper
#         transcript = await stt_service.transcribe_audio_file(temp_path)

#         # Clean up temp file
#         os.remove(temp_path)

#         if not transcript:
#             raise HTTPException(
#                 status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
#                 detail="Failed to transcribe audio file"
#             )

#         # Process with AI summary
#         ai_summary_data = {
#             "transcript": transcript,
#             "summary": f"High-accuracy transcription processed for patient {patient_id}",
#             "action_items": ["Review transcription for accuracy"],
#             "medications": [],
#             "patient_id": patient_id,
#             "visit_id": visit_id
#         }

#         return {
#             "status": "success",
#             "transcript": transcript,
#             "accuracy_method": "whisper_high_accuracy",
#             "data": ai_summary_data
#         }

#     except Exception as e:
#         logger.error(f"Error processing audio transcription: {str(e)}")
#         raise HTTPException(
#             status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
#             detail=f"Failed to process audio transcription: {str(e)}"
#         )
