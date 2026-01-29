import logging
from datetime import datetime

from domain.errors import NotFoundError

from domain.transcripts.repo import (
    ensure_transcript_exists,
    get_audio_gcs_url,
    update_audio_url,
    update_image_data,
)
from domain.users.repo import get_user_uuid
from domain.visits.repo import (
    ensure_visit_exists,
    get_latest_processing_visit_id,
    get_visit_metadata,
)
from domain.users.service import assert_patient_access
from domain.ports.jobs import create_job
from workflows.visit_media import run_ocr_for_visit_media, upload_audio_file, upload_image_file

logger = logging.getLogger(__name__)


async def upload_visit_audio(external_auth_id: str, visit_id: str, file) -> dict:
    """
    Upload audio and persist visit/transcript rows and audio URL.
    """
    user_uuid = await get_user_uuid(external_auth_id)
    await assert_patient_access(user_uuid, user_uuid, "full")

    audio_url = await upload_audio_file(visit_id, file)

    await ensure_visit_exists(visit_id, user_uuid, "Audio Visit", status="active")
    await ensure_transcript_exists(visit_id, user_uuid)
    await update_audio_url(visit_id, user_uuid, audio_url)

    logger.info(f"Audio upload completed: visit={visit_id}, user={user_uuid}")
    return {
        "message": "Audio uploaded successfully",
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

    await ensure_visit_exists(visit_id, user_uuid, "Image Visit", status="active")
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


async def queue_audio_processing(external_auth_id: str, visit_id: str) -> dict:
    user_uuid = await get_user_uuid(external_auth_id)
    await assert_patient_access(user_uuid, user_uuid, "full")

    job_id = create_job(
        job_type="STT_JOB",
        payload={
            "visit_id": visit_id,
            "external_auth_id": external_auth_id,
        },
    )
    return {"status": "queued", "visit_id": visit_id, "job_id": job_id}


async def get_latest_visit_status(external_auth_id: str) -> dict:
    visit_id = await get_latest_processing_visit_id(external_auth_id)
    if not visit_id:
        return {"processing": False}
    return {"processing": True, "visit_id": visit_id}


async def get_visit_audio_url(external_auth_id: str, visit_id: str) -> dict:
    user_uuid = await get_user_uuid(external_auth_id)
    await assert_patient_access(user_uuid, user_uuid, "view")

    audio_url = await get_audio_gcs_url(visit_id, user_uuid)
    return {"visit_id": visit_id, "audio_url": audio_url}


async def get_visit_details(external_auth_id: str, visit_id: str) -> dict:
    user_uuid = await get_user_uuid(external_auth_id)
    await assert_patient_access(user_uuid, user_uuid, "view")

    visit = await get_visit_metadata(visit_id, user_uuid)
    if not visit:
        raise NotFoundError("Visit not found")
    return visit
