import json
import logging
from datetime import datetime
from fastapi import APIRouter, HTTPException, Depends, File, UploadFile
# REMOVED: Legacy summary functions deleted during Supabase cleanup
# from services.db_service import (
#     fetch_visit_transcript,
#     fetch_visit_summary,
#     insert_visit_summary,
#     fetch_all_visit_summaries,
# )
from services.gcs_service import upload_audio, upload_image
from services.auth_gateway import get_current_user_jwt as get_current_user

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api", tags=["Visit Summaries"])


def get_user_id(current_user=Depends(get_current_user)) -> str:
    """Extract firebase_uid from authenticated user"""
    # Firebase UID is the canonical user identity
    return current_user["sub"]

# DISABLED: Legacy summary generation route - functions removed during Supabase cleanup
# @router.post("/generate-summary/{visit_id}", response_model=VisitSummaryPayload)
# async def create_visit_summary(visit_id: str, user_id: str, transcript_id: str):
#     visit = await fetch_visit_transcript(visit_id, user_id, transcript_id)
#     if not visit or not visit.get("transcript_text"):
#         raise HTTPException(status_code=404, detail="Transcript not found")

#     ai_output = await generate_ai_summary({
#         "transcript": visit["transcript_text"],
#         "visit_id": visit_id,
#         "user_id": user_id,
#         "transcript_id": visit["transcript_id"]
#     })

#     await insert_visit_summary(visit_id, user_id, visit["transcript_id"], ai_output)

#     return {
#         "message": "Summary generated successfully",
#         "data": {
#             "visit_id": visit_id,
#             "user_id": user_id,
#             "transcript_id": transcript_id,
#             **ai_output,
#         }
#     }

# DISABLED: Legacy summary retrieval route - functions removed during Supabase cleanup
# @router.get("/visit-summaries/{visit_id}", response_model=VisitSummary)
# async def get_visit_summary(visit_id: int, user_id: int):
#     row = await fetch_visit_summary(visit_id, user_id)
#     if not row:
#         raise HTTPException(status_code=404, detail="Summary not found")
#     return row

# DISABLED: Legacy all summaries route - functions removed during Supabase cleanup
# @router.get("/visit-summaries")
# async def get_all_summaries(user_id: str = Depends(get_user_id)):
#     logger.info(f"Fetching visit summaries for user_id: {user_id}")
#     summaries = await fetch_all_visit_summaries(user_id)
#     logger.info(f"Found {len(summaries)} raw summaries from database")
#     formatted_summaries = []

#     for item in summaries:
#         visit_data = item.get('visits', {})
#         date_source = item.get('created_at')
#         visit_dt = datetime.now() if not date_source else datetime.fromisoformat(date_source.replace('Z', '+00:00'))

#         formatted_summaries.append({
#             "id": item.get('visit_id'),
#             "title": visit_data.get('title', 'Untitled Visit'),
#             "status": visit_data.get('status', 'Completed'),
#             "doctor": visit_data.get('doctor', 'N/A'),
#             "specialty": visit_data.get('specialty', 'General'),
#             "date": visit_dt.strftime("%b %d, %Y"),
#             "time": visit_dt.strftime("%I:%M %p"),
#             "duration": visit_data.get('duration', 'N/A'),
#             "summary": item.get('summary', 'No summary available.'),
#             "keyPoints": item.get('action_items', '').split(', ') if item.get('action_items') else [],
#         })

#     return formatted_summaries


@router.post("/visits/{visit_id}/audio/upload")
async def upload_audio_for_visit(
    visit_id: str,
    file: UploadFile = File(...),
    user_id: str = Depends(get_user_id)
):
    """
    Upload audio file with transactional database consistency.
    Creates visit and visit_transcripts rows if needed, then persists audio_url.
    """
    try:
        # Step 1: Resolve Firebase UID to Cloud SQL user UUID
        from services.db_service import get_user_uuid
        user_uuid = await get_user_uuid(user_id)

        # Step 2: Upload to GCS first (fail fast if storage fails)
        audio_url = await upload_audio(file, visit_id)

        # Step 3: Single transaction for all database operations
        from services.cloud_sql_engine import get_cloud_sql_engine
        from sqlalchemy import text

        engine = get_cloud_sql_engine()
        with engine.begin() as conn:
            # Create visit if it doesn't exist
            visit_query = text("""
                INSERT INTO visits (id, user_id, title, status)
                VALUES (:visit_id, :user_uuid, 'Audio Visit', 'active')
                ON CONFLICT (id) DO NOTHING
            """)
            conn.execute(visit_query, {
                "visit_id": visit_id,
                "user_uuid": user_uuid
            })

            # Create visit_transcripts row if it doesn't exist
            transcript_query = text("""
                INSERT INTO visit_transcripts (visit_id, user_id)
                VALUES (:visit_id, :user_uuid)
                ON CONFLICT (visit_id, user_id) DO NOTHING
            """)
            conn.execute(transcript_query, {
                "visit_id": visit_id,
                "user_uuid": user_uuid
            })

            # Update audio_url - this MUST affect exactly 1 row
            update_query = text("""
                UPDATE visit_transcripts
                SET audio_url = :audio_url
                WHERE visit_id = :visit_id AND user_id = :user_uuid
            """)
            result = conn.execute(update_query, {
                "audio_url": audio_url,
                "visit_id": visit_id,
                "user_uuid": user_uuid
            })

            # Verify exactly 1 row was updated
            if result.rowcount != 1:
                raise Exception(f"Expected 1 row updated, got {result.rowcount}")

        # Step 4: Log success
        logger.info(f"Audio upload completed: visit={visit_id}, user={user_uuid}")

        return {
            "message": "Audio uploaded successfully",
            "audio_url": audio_url,
            "expires_in": "24 hours"
        }

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Audio upload failed for visit {visit_id}: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Audio upload failed: {str(e)}")


@router.post("/visits/{visit_id}/image/upload")
async def upload_image_for_visit(
    visit_id: str,
    file: UploadFile = File(...),
    user_id: str = Depends(get_user_id)
):
    """
    Upload image file with transactional database consistency.
    Creates visit and visit_transcripts rows if needed, then persists image_url and metadata.
    """
    try:
        # Step 1: Resolve Firebase UID to Cloud SQL user UUID
        from services.db_service import get_user_uuid
        user_uuid = await get_user_uuid(user_id)

        # Step 2: Upload to GCS first (fail fast if storage fails)
        image_result = await upload_image(file, visit_id)

        metadata = {
            "blob_name": image_result["blob_name"],
            "content_type": image_result["content_type"],
            "file_size": image_result["file_size"],
            "uploaded_at": datetime.now().isoformat()
        }

        # Step 3: Single transaction for all database operations
        from services.cloud_sql_engine import get_cloud_sql_engine
        from sqlalchemy import text

        engine = get_cloud_sql_engine()
        with engine.begin() as conn:
            # Create visit if it doesn't exist
            visit_query = text("""
                INSERT INTO visits (id, user_id, title, status)
                VALUES (:visit_id, :user_uuid, 'Image Visit', 'active')
                ON CONFLICT (id) DO NOTHING
            """)
            conn.execute(visit_query, {
                "visit_id": visit_id,
                "user_uuid": user_uuid
            })

            # Create visit_transcripts row if it doesn't exist
            transcript_query = text("""
                INSERT INTO visit_transcripts (visit_id, user_id)
                VALUES (:visit_id, :user_uuid)
                ON CONFLICT (visit_id, user_id) DO NOTHING
            """)
            conn.execute(transcript_query, {
                "visit_id": visit_id,
                "user_uuid": user_uuid
            })

            # Update image_url, metadata, and OCR status - this MUST affect exactly 1 row
            update_query = text("""
                UPDATE visit_transcripts
                SET image_url = :image_url, image_metadata = :metadata, ocr_status = 'pending'
                WHERE visit_id = :visit_id AND user_id = :user_uuid
            """)
            result = conn.execute(update_query, {
                "image_url": image_result["signed_url"],
                "metadata": json.dumps(metadata),
                "visit_id": visit_id,
                "user_uuid": user_uuid
            })

            # Verify exactly 1 row was updated
            if result.rowcount != 1:
                raise Exception(f"Expected 1 row updated, got {result.rowcount}")

        # Step 4: Log success
        logger.info(f"Image upload completed: visit={visit_id}, user={user_uuid}")

        return {
            "image_url": image_result["signed_url"],
            "expires_in_hours": 24
        }

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Image upload failed for visit {visit_id}: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Image upload failed: {str(e)}")


@router.post("/visits/{visit_id}/ocr")
async def process_visit_ocr(
    visit_id: str,
    user_id: str = Depends(get_user_id)
):
    """
    Process uploaded image with OCR using Google Vision API.
    Thin route that delegates to image pipeline.
    """
    logger.info("OCR requested for visit_id=%s", visit_id)
    try:
        # Step 1: Resolve user UUID (for future validation if needed)
        from services.db_service import get_user_uuid
        await get_user_uuid(user_id)  # Validate user exists

        # Step 2: Run OCR pipeline
        from services.media.image_pipeline import run_ocr_for_visit
        result = await run_ocr_for_visit(visit_id)

        return result

    except ValueError as e:
        # Pipeline validation errors
        if "not found" in str(e):
            raise HTTPException(status_code=404, detail=str(e))
        elif "already" in str(e):
            raise HTTPException(status_code=409, detail=str(e))
        else:
            raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        logger.exception(f"OCR route failed for visit {visit_id}")
        raise HTTPException(status_code=500, detail=f"OCR processing failed: {str(e)}")


@router.post("/visits/{visit_id}/process-audio")
async def process_visit_audio(
    visit_id: str,
    user_id: str = Depends(get_user_id)
):
    """
    Process uploaded audio file with Speech-to-Text and save transcript.
    Simple synchronous pipeline: GCS -> STT -> Cloud SQL.
    """
    try:
        # Step 1: Get user UUID from Firebase UID
        from services.db_service import get_user_uuid
        user_uuid = await get_user_uuid(user_id)  # user_id is Firebase UID from JWT

        # Step 2: Run STT pipeline
        from services.media.audio_pipeline import run_audio_stt_pipeline
        stt_result = await run_audio_stt_pipeline(visit_id, user_id)

        # Step 3: Save transcript to database
        from services.db_service import save_raw_transcript
        transcript_id = await save_raw_transcript(
            visit_id=visit_id,
            user_id=user_uuid,  # Use UUID for database operations
            transcript=stt_result["transcript"],
            confidence=stt_result["confidence"],
            language=stt_result["language"]
        )

        # Step 4: Trigger AI summary pipeline
        logger.info(f"Triggering AI summary pipeline for visit {visit_id}")
        from services.ai_pipeline import run_ai_summary_pipeline
        await run_ai_summary_pipeline(
            visit_id=visit_id,
            transcript_id=transcript_id,
            user_id=user_uuid,
        )

        # Step 5: Return simple success response
        return {
            "status": "completed",
            "visit_id": visit_id,
            "has_transcript": True
        }

    except ValueError as e:
        # Audio not found or STT failed
        if "No audio file found" in str(e):
            raise HTTPException(status_code=404, detail=f"Audio file not found for visit {visit_id}")
        raise HTTPException(status_code=500, detail=f"Speech-to-text failed: {str(e)}")

    except Exception as e:
        logger.error(f"Audio processing failed for visit {visit_id}: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Audio processing failed: {str(e)}")


@router.get("/visits/{visit_id}/audio")
async def get_visit_audio_url_endpoint(
    visit_id: str,
    user_id: str = Depends(get_user_id)
):
    try:
        # Get user UUID from Firebase UID
        from services.db_service import get_user_uuid
        user_uuid = await get_user_uuid(user_id)  # user_id is Firebase UID from JWT

        from services.db_service import get_audio_gcs_url
        audio_url = await get_audio_gcs_url(visit_id, user_uuid)

        return {
            "visit_id": visit_id,
            "audio_url": audio_url
        }

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to retrieve audio: {str(e)}")


@router.get("/visits/{visit_id}/summary")
async def get_visit_summary(
    visit_id: str,
    user_id: str = Depends(get_user_id)
):
    """
    Get the latest AI-generated summary for a visit.
    Returns processing status if not ready, or summary text if available.
    """
    try:
        logger.info(f"Getting summary for visit_id={visit_id}, firebase_uid={user_id}")

        # Step 1: Resolve Firebase UID to Cloud SQL user UUID
        from services.db_service import get_user_uuid, get_latest_ai_summary_for_visit
        user_uuid = await get_user_uuid(user_id)

        logger.info(f"Resolved firebase_uid={user_id} to user_uuid={user_uuid}")

        # Step 2: Fetch latest summary for this visit
        summary_text = await get_latest_ai_summary_for_visit(visit_id, user_uuid)

        logger.info(f"DB query result for visit_id={visit_id}, user_uuid={user_uuid}: summary_text={summary_text is not None}")

        # Step 3: Return appropriate response
        if summary_text:
            logger.info(f"Returning summary: {summary_text[:100]}...")
            return {"summary": summary_text}
        else:
            logger.info("Returning processing status")
            return {"status": "processing"}

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Failed to get summary for visit {visit_id}: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Failed to retrieve summary: {str(e)}")


@router.get("/summaries")
async def get_user_summaries_endpoint(
    user_id: str = Depends(get_user_id)
):
    """
    Get all summaries for the current user by joining summaries_log and visits tables.
    Returns list of summaries with visit metadata, ordered by newest first.
    """
    try:
        logger.info(f"Getting summaries list for firebase_uid={user_id}")

        # Step 1: Resolve Firebase UID to Cloud SQL user UUID
        from services.db_service import get_user_uuid, get_user_summaries
        user_uuid = await get_user_uuid(user_id)

        logger.info(f"Resolved firebase_uid={user_id} to user_uuid={user_uuid}")

        # Step 2: Fetch user summaries
        summaries = await get_user_summaries(user_uuid)

        logger.info(f"Returning {len(summaries)} summaries for user_uuid={user_uuid}")
        return summaries

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Failed to get summaries for user {user_id}: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Failed to retrieve summaries: {str(e)}")
