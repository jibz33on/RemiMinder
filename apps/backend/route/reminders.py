from fastapi import APIRouter, HTTPException, status, Body, Depends, UploadFile, File, Form
from typing import List, Optional
import logging
import os
import shutil

from schemas.reminder_schemas import (
    ReminderCreate,
    ReminderUpdate,
    ReminderAction,
    ReminderResponse,
    ReminderListResponse,
    CaregiverAlertResponse,
    CaregiverDashboardResponse
)
from services.reminder_service import (
    create_new_reminder,
    get_reminder_by_id,
    list_patient_reminders,
    update_reminder_details,
    cancel_reminder,
    complete_reminder,
    snooze_reminder,
    skip_reminder,
    get_caregiver_dashboard_data
)
# from services.speech_to_text_service import SpeechToTextService  # TODO: Implement this service
from utils.n8n_helper import send_to_extraction_agent
from services.db_reminders import (
    get_caregiver_alerts,
    mark_alert_as_read
)
from services.auth import get_current_user

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api", tags=["reminders"])

@router.post("/reminders", response_model=ReminderResponse, status_code=status.HTTP_201_CREATED)
async def create_reminder(data: ReminderCreate, user_id: str = Depends(get_current_user)):
    """
    Create a new reminder with AI-generated personalized message.
    """
    try:
        # associate with authenticated user
        data.user_id = user_id
        reminder = await create_new_reminder(data)
        
        if not reminder:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail="Failed to create reminder"
            )
        
        return reminder
        
    except Exception as e:
        logger.error(f"Error in create_reminder endpoint: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to create reminder: {str(e)}"
        )

# Get user_id from JWT token instead of query param
@router.get("/reminders", response_model=ReminderListResponse)
async def get_patient_reminders(user_id: str = Depends(get_current_user)):
    """
    Get all reminders for a patient, organized by category (today, upcoming, past).
    """
    try:
        reminders = await list_patient_reminders(user_id)
        return reminders
        
    except Exception as e:
        logger.error(f"Error in get_patient_reminders: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to fetch reminders: {str(e)}"
        )

@router.get("/reminders/{reminder_id}", response_model=ReminderResponse)
async def get_reminder(reminder_id: str, user_id: str = Depends(get_current_user)):
    """
    Get a single reminder by ID.
    """
    try:
        reminder = await get_reminder_by_id(reminder_id, user_id)

        if not reminder:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Reminder not found"
            )
        
        return reminder

    except Exception as e:
        logger.error(f"Error in get_reminder: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to fetch reminder: {str(e)}"
        )


@router.put("/reminders/{reminder_id}", response_model=ReminderResponse)
async def update_reminder(reminder_id: str, user_id: str = Depends(get_current_user), updates: ReminderUpdate = Body(...)):
    """
    Update a reminder (time, title, status, etc.).
    """
    try:
        reminder = await update_reminder_details(reminder_id, user_id, updates)

        if not reminder:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Reminder not found"
            )
        
        return reminder
    
    except Exception as e:
        logger.error(f"Error in update_reminder: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to update reminder: {str(e)}"
        )


@router.delete("/reminders/{reminder_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_reminder(reminder_id: str, user_id: str = Depends(get_current_user)):
    """
    Cancel/delete a reminder.
    """
    try:
        success = await cancel_reminder(reminder_id, user_id)

        if not success:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Reminder not found"
            )
        
        return None
    
    except Exception as e:
        logger.error(f"Error in delete_reminder: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to delete reminder: {str(e)}"
        )


@router.post("/reminders/{reminder_id}/complete", response_model=ReminderResponse)
async def mark_complete(
    reminder_id: str, 
    user_id: str = Depends(get_current_user),
    action: ReminderAction = Body(default=ReminderAction())
):
    """
    Mark a reminder as completed.
    """
    try:
        reminder = await complete_reminder(reminder_id, user_id, action)
        
        if not reminder:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Reminder not found"
            )
        
        return reminder
    
    except Exception as e:
        logger.error(f"Error in mark_complete: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to complete reminder: {str(e)}"
        )

@router.post("/reminders/{reminder_id}/snooze", response_model=ReminderResponse)
async def snooze_reminder_post(
    reminder_id: str,
    user_id: str = Depends(get_current_user),
    snooze_minutes: int = 30
):
    """
    Snooze a reminder. The snooze count is incremented, and the scheduled time is pushed forward.
    """
    try:
        reminder = await snooze_reminder(reminder_id, user_id, snooze_minutes)
        
        if not reminder:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Cannot snooze: Reminder not found or is already completed/cancelled." 
            )
        
        return reminder
    
    except Exception as e:
        logger.error(f"Error in snooze_reminder: {str(e)}")
        raise HTTPException(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        detail=f"Failed to snooze reminder: {str(e)}"
)

@router.post("/reminders/{reminder_id}/skip", response_model=ReminderResponse)
async def skip_reminder_post(
    reminder_id: str, 
    user_id: str = Depends(get_current_user),
    action: ReminderAction = Body(default=ReminderAction())
):
    
    """
    Skip a reminder with optional reason.
    """
    try:
        reminder = await skip_reminder(reminder_id, user_id, action)

        if not reminder:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Reminder not found"
            )
        
        return reminder

    except Exception as e:
        logger.error(f"Error in skip_reminder: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to skip reminder: {str(e)}"
        )


# ============================================================================
# CAREGIVER
# ============================================================================

@router.get("/caregivers/{caregiver_id}/activity", response_model=CaregiverDashboardResponse)
async def get_caregiver_activity(caregiver_id: str, user_id: str = Depends(get_current_user)):
    """
    Get aggregated activity data for caregiver dashboard.
    Shows next reminders, recent activity, and alert summary.
    """
    try:
        dashboard_data = await get_caregiver_dashboard_data(caregiver_id, user_id)
        return dashboard_data
    
    except Exception as e:
        logger.error(f"Error in get_caregiver_activity: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to fetch caregiver activity: {str(e)}"
        )

@router.get("/caregivers/{caregiver_id}/alerts", response_model=List[CaregiverAlertResponse])
async def get_alerts(caregiver_id: str, unread_only: bool = False):
    """
    Get all alerts for a caregiver.
    """
    try:
        alerts = await get_caregiver_alerts(caregiver_id, unread_only)
        return alerts
        
    except Exception as e:
        logger.error(f"Error in get_alerts: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to fetch alerts: {str(e)}"
        )


@router.patch("/caregivers/alerts/{alert_id}/read", response_model=CaregiverAlertResponse)
async def mark_alert_read(alert_id: str, caregiver_id: str):
    """
    Mark a caregiver alert as read.
    """
    try:
        alert = await mark_alert_as_read(alert_id, caregiver_id)

        if not alert:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Alert not found"
            )
        
        return alert
    
    except Exception as e:
        logger.error(f"Error in mark_alert_read: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to mark alert as read: {str(e)}"
        )


# Voice Recording & AI Agent Integration
@router.post("/process-visit-transcription")
async def process_visit_transcription(
    transcription_data: dict = Body(..., description="AI summary data from voice recording")
):
    """
    Process transcription data from voice recordings and send to N8N extraction agent.

    Expected payload:
    {
        "transcript": "full conversation text",
        "summary": "AI generated summary",
        "action_items": ["item1", "item2"],
        "medications": ["med1", "med2"],
        "patient_id": "patient123",
        "visit_id": "visit456"
    }
    """
    try:
        logger.info(f"Processing visit transcription for patient: {transcription_data.get('patient_id')}")

        # Send to N8N extraction agent
        success = await send_to_extraction_agent(transcription_data)

        if success:
            return {
                "status": "success",
                "message": "Transcription sent to extraction agent successfully",
                "data": transcription_data
            }
        else:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail="Failed to send data to extraction agent"
            )

    except Exception as e:
        logger.error(f"Error processing visit transcription: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to process transcription: {str(e)}"
        )


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

#         # Send to N8N agent
#         success = await send_to_extraction_agent(ai_summary_data)

#         return {
#             "status": "success",
#             "transcript": transcript,
#             "accuracy_method": "whisper_high_accuracy",
#             "n8n_processed": success,
#             "data": ai_summary_data
#         }

#     except Exception as e:
#         logger.error(f"Error processing audio transcription: {str(e)}")
#         raise HTTPException(
#             status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
#             detail=f"Failed to process audio transcription: {str(e)}"
#         )
