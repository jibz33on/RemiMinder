from datetime import datetime

from domain.errors import NotFoundError
from domain.ports.logging import get_logger

from domain.transcripts.repo import (
    ensure_transcript_exists,
    get_transcript_id,
    get_audio_gcs_url,
    update_audio_artifacts,
    update_image_data,
)
from domain.users.repo import ensure_user_exists, get_user_uuid
from uuid import UUID
from domain.visits.repo import (
    ensure_visit_exists,
    get_latest_processing_visit_id,
    get_visit_metadata,
)
from domain.users.service import assert_patient_access
from domain.stt2.service import enqueue_stt2_extraction
from domain.ports.jobs import create_job
from workflows.visit_media import run_ocr_for_visit_media, upload_audio_file, upload_image_file

logger = get_logger()


async def upload_visit_audio(external_auth_id: str, visit_id: str, file) -> dict:
    """
    Upload audio and persist visit/transcript rows and audio URL.
    """
    # Resolve or create user UUID from external_auth_id
    # Check database directly (bypass cache to avoid stale results)
    from domain.users.repo import get_db_engine
    from sqlalchemy import text
    import uuid

    engine = get_db_engine()
    with engine.connect() as conn:
        query = text("SELECT id FROM users WHERE external_auth_id = :external_auth_id")
        result = conn.execute(query, {"external_auth_id": external_auth_id})
        row = result.fetchone()

        if row:
            user_uuid = row[0] if isinstance(row[0], UUID) else UUID(row[0])
            logger.debug(f"[USERS] user_uuid={user_uuid} type={type(user_uuid)}")
        else:
            # User doesn't exist - generate UUID and create user record
            user_uuid = uuid.uuid4()
            await ensure_user_exists(user_uuid, external_auth_id)

    # Convert to string for downstream functions
    user_uuid_str = str(user_uuid)
    await assert_patient_access(user_uuid_str, user_uuid_str, "full")

    # Ensure user exists BEFORE creating visit (required for FK constraint)
    await ensure_user_exists(user_uuid, external_auth_id)

    audio_result = await upload_audio_file(visit_id, file)
    audio_url = audio_result["signed_url"]
    canonical_audio_path = audio_result["canonical_path"]

    # Create visit with external_auth_id (not UUID) per schema design:
    # visits.user_id REFERENCES users.external_auth_id (intentional for auth integration)
    logger.info(f"Creating visit with external_auth_id={external_auth_id}")
    await ensure_visit_exists(visit_id, external_auth_id, "Audio Visit", status="active")
    await ensure_transcript_exists(visit_id, external_auth_id)
    transcript_id = await get_transcript_id(visit_id, external_auth_id)
    await update_audio_artifacts(visit_id, external_auth_id, audio_url, canonical_audio_path)

    logger.info(f"Audio upload completed: visit={visit_id}, user={user_uuid_str}, canonical_path={canonical_audio_path}")
    return {
        "status": "uploaded",
        "audio_id": transcript_id,
        "audio_url": audio_url,
        "expires_in": "24 hours",
    }


async def upload_visit_image(external_auth_id: str, visit_id: str, file) -> dict:
    """
    Upload image and persist visit/transcript rows and image metadata.
    """
    user_uuid = await get_user_uuid(external_auth_id)
    await assert_patient_access(user_uuid, user_uuid, "full")

    image_result = await upload_image_file(visit_id, file)
    metadata = {
        "blob_name": image_result["blob_name"],
        "content_type": image_result["content_type"],
        "file_size": image_result["file_size"],
        "uploaded_at": datetime.now().isoformat(),
    }

    # Create visit with external_auth_id (not UUID) per schema design
    logger.info(f"Creating visit with external_auth_id={external_auth_id}")
    await ensure_visit_exists(visit_id, external_auth_id, "Image Visit", status="active")
    await ensure_transcript_exists(visit_id, user_uuid)
    await update_image_data(visit_id, user_uuid, image_result["signed_url"], metadata)

    logger.info(f"Image upload completed: visit={visit_id}, user={user_uuid}")
    return {
        "image_url": image_result["signed_url"],
        "expires_in_hours": 24,
    }


async def process_visit_ocr(external_auth_id: str, visit_id: str) -> dict:
    user_uuid = await get_user_uuid(external_auth_id)
    await assert_patient_access(user_uuid, user_uuid, "full")
    return await run_ocr_for_visit_media(visit_id)


async def process_audio_with_stt_and_create_job(external_auth_id: str, visit_id: str) -> dict:
    """
    LEGACY: Full pipeline processing with STT + job creation.
    Used by /process-audio endpoint. Avoid for new Stage 2 implementations.
    """
    user_uuid = await get_user_uuid(external_auth_id)
    await assert_patient_access(user_uuid, user_uuid, "full")

    job_id = await enqueue_stt2_extraction(visit_id)
    return {"status": "queued", "visit_id": visit_id, "job_id": job_id}


async def generate_visit_summary(external_auth_id: str, visit_id: str) -> dict:
    """
    Stage 2: Create processing job for visit summary generation.
    Validates visit and audio exist, creates exactly one job, returns immediately.
    """
    user_uuid = await get_user_uuid(external_auth_id)
    await assert_patient_access(user_uuid, user_uuid, "full")

    # Stage 2 Invariant 1: Validate visit exists
    # visits.user_id contains external_auth_id, not UUID
    visit = await get_visit_metadata(visit_id, external_auth_id)
    if not visit:
        raise NotFoundError(f"Visit {visit_id} not found")

    # Stage 2 Invariant 2: Validate audio exists
    # visit_transcripts.user_id contains external_auth_id, not UUID
    try:
        await get_audio_gcs_url(visit_id, external_auth_id)
    except NotFoundError:
        raise NotFoundError(f"No audio found for visit {visit_id}")

    # Check for existing job (idempotency)
    existing_job = await _get_existing_processing_job(visit_id)
    if existing_job:
        return {
            "status": "already_queued",
            "visit_id": visit_id,
            "job_id": existing_job["id"],
            "job_status": existing_job["status"]
        }

    # Stage 2 Invariant 3: Create exactly ONE job
    job_id = create_job("stt2_extraction", {"visit_id": visit_id})

    logger.info(f"Stage 2: Created processing job {job_id} for visit {visit_id}")
    return {"status": "queued", "visit_id": visit_id, "job_id": job_id}


async def _get_existing_processing_job(visit_id: str) -> dict | None:
    """Check if there's already a processing job for this visit."""
    from sqlalchemy import text
    from infra.db.cloud_sql_engine import get_cloud_sql_engine

    engine = get_cloud_sql_engine()
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                SELECT id, status
                FROM jobs
                WHERE job_type = 'stt2_extraction'
                  AND payload->>'visit_id' = :visit_id
                  AND status IN ('pending', 'running')
                LIMIT 1
            """),
            {"visit_id": visit_id}
        ).fetchone()

        if result:
            return {"id": str(result[0]), "status": result[1]}
        return None


async def get_latest_visit_status(external_auth_id: str) -> dict:
    visit_id = await get_latest_processing_visit_id(external_auth_id)
    if not visit_id:
        return {"processing": False}
    return {"processing": True, "visit_id": visit_id}


async def get_visit_audio_url(external_auth_id: str, visit_id: str) -> dict:
    user_uuid = await get_user_uuid(external_auth_id)
    await assert_patient_access(user_uuid, user_uuid, "view")

    # visit_transcripts.user_id contains external_auth_id, not UUID
    audio_url = await get_audio_gcs_url(visit_id, external_auth_id)
    return {"visit_id": visit_id, "audio_url": audio_url}


async def get_visit_details(external_auth_id: str, visit_id: str) -> dict:
    user_uuid = await get_user_uuid(external_auth_id)
    await assert_patient_access(user_uuid, user_uuid, "view")

    # visits.user_id contains external_auth_id, not UUID
    visit = await get_visit_metadata(visit_id, external_auth_id)
    if not visit:
        raise NotFoundError("Visit not found")
    return visit
