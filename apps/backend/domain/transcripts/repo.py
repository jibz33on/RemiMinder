import hashlib
import json

from sqlalchemy import text

from domain.ports.db import get_db_engine
from domain.errors import DomainError, NotFoundError
from domain.ports.logging import get_logger

logger = get_logger()


def _hash_transcript(text: str) -> str:
    return hashlib.sha256((text or "").encode("utf-8")).hexdigest()


async def save_raw_transcript(
    visit_id: str,
    user_id: str,
    transcript: str,
    confidence: float | None = None,
    language: str | None = None,
    stt_engine: str | None = None,
) -> str:
    """Save raw STT transcript to raw_stt_transcripts table.

    Returns the transcript_id of the visit_transcripts record.
    """
    if not stt_engine:
        raise ValueError("stt_engine is required for raw transcript persistence")
    try:
        engine = get_db_engine()
        with engine.begin() as conn:
            # Idempotency: if a raw transcript already exists, exit cleanly
            exists_query = text("""
                SELECT 1 FROM raw_stt_transcripts
                WHERE visit_id = :visit_id
                LIMIT 1
            """)
            existing = conn.execute(exists_query, {"visit_id": visit_id}).fetchone()
            if existing:
                select_query = text("""
                    SELECT transcript_id FROM visit_transcripts
                    WHERE visit_id = :visit_id
                """)
                result = conn.execute(select_query, {"visit_id": visit_id})
                row = result.fetchone()
                if not row:
                    raise NotFoundError(f"No transcript record found for visit {visit_id}")
                transcript_id = str(row[0])
                logger.info(
                    "Raw STT transcript already exists for visit %s; skipping insert",
                    visit_id,
                )
                return transcript_id

            # Append raw STT artifact (never overwrite)
            transcript_hash = _hash_transcript(transcript)
            insert_query = text("""
                INSERT INTO raw_stt_transcripts (
                    visit_id,
                    transcript_text,
                    transcript_hash,
                    stt_engine,
                    stt_provider,
                    stt_model_version,
                    language,
                    confidence
                )
                VALUES (
                    :visit_id,
                    :transcript,
                    :transcript_hash,
                    :stt_engine,
                    :stt_provider,
                    :stt_model_version,
                    :language,
                    :confidence
                )
                ON CONFLICT (visit_id) DO NOTHING
            """)
            conn.execute(insert_query, {
                "visit_id": visit_id,
                "transcript": transcript,
                "transcript_hash": transcript_hash,
                "stt_engine": stt_engine,
                "stt_provider": stt_engine,  # Use same value as stt_engine for now
                "stt_model_version": "latest",  # Default model version for Google STT
                "language": language,
                "confidence": confidence,
            })

            # Get the transcript_id for the visit record
            select_query = text("""
                SELECT transcript_id FROM visit_transcripts
                WHERE visit_id = :visit_id
            """)
            result = conn.execute(select_query, {"visit_id": visit_id})
            row = result.fetchone()

            if not row:
                raise NotFoundError(f"No transcript record found for visit {visit_id}")

            transcript_id = str(row[0])
            logger.info(
                "Saved raw STT transcript for visit %s: %s chars, transcript_id: %s",
                visit_id,
                len(transcript),
                transcript_id,
            )

            return transcript_id

    except DomainError:
        raise
    except Exception as e:
        logger.error(f"Error saving transcript for visit {visit_id}: {e}")
        raise


async def save_raw_stt_transcript(
    visit_id: str,
    transcript: str,
    stt_engine: str,
    language: str | None = None,
    confidence: float | None = None,
) -> None:
    """
    Append a raw STT transcript artifact for a visit.
    """
    try:
        engine = get_db_engine()
        with engine.begin() as conn:
            insert_query = text("""
                INSERT INTO raw_stt_transcripts (
                    visit_id,
                    transcript_text,
                    stt_engine,
                    language,
                    confidence
                )
                VALUES (
                    :visit_id,
                    :transcript,
                    :stt_engine,
                    :language,
                    :confidence
                )
                ON CONFLICT (visit_id) DO NOTHING
            """)
            conn.execute(insert_query, {
                "visit_id": visit_id,
                "transcript": transcript,
                "stt_engine": stt_engine,
                "language": language,
                "confidence": confidence,
            })
    except Exception as e:
        logger.error(f"Error saving raw STT transcript for visit {visit_id}: {e}")
        raise


async def ensure_transcript_exists(visit_id: str, user_id: str) -> None:
    """
    Ensure a visit_transcripts row exists for the visit/user pair.
    """
    try:
        engine = get_db_engine()
        with engine.begin() as conn:
            query = text("""
                INSERT INTO visit_transcripts (visit_id, user_id)
                VALUES (:visit_id, :user_id)
                ON CONFLICT (visit_id, user_id) DO NOTHING
            """)
            conn.execute(query, {"visit_id": visit_id, "user_id": user_id})
    except Exception as e:
        logger.error(f"Error ensuring transcript row for visit {visit_id}: {e}")
        raise


async def get_transcript_id(visit_id: str, user_id: str) -> str:
    """
    Fetch transcript_id for a visit/user pair.
    """
    try:
        engine = get_db_engine()
        with engine.connect() as conn:
            query = text("""
                SELECT transcript_id
                FROM visit_transcripts
                WHERE visit_id = :visit_id AND user_id = :user_id
            """)
            result = conn.execute(query, {
                "visit_id": visit_id,
                "user_id": user_id,
            })
            row = result.fetchone()
            if not row:
                raise NotFoundError(f"Transcript not found for visit {visit_id}")
            return str(row[0])
    except Exception as e:
        logger.error(f"Error fetching transcript_id for visit {visit_id}: {e}")
        raise


async def update_audio_url(visit_id: str, user_id: str, audio_url: str) -> None:
    """
    Update the audio_url for a visit transcript. Expects exactly one row updated.
    """
    try:
        engine = get_db_engine()
        with engine.begin() as conn:
            update_query = text("""
                UPDATE visit_transcripts
                SET audio_url = :audio_url
                WHERE visit_id = :visit_id AND user_id = :user_id
            """)
            result = conn.execute(update_query, {
                "audio_url": audio_url,
                "visit_id": visit_id,
                "user_id": user_id,
            })
            if result.rowcount != 1:
                raise RuntimeError(f"Expected 1 row updated, got {result.rowcount}")
    except Exception as e:
        logger.error(f"Error updating audio_url for visit {visit_id}: {e}")
        raise


async def update_audio_artifacts(
    visit_id: str,
    user_id: str,
    audio_url: str,
    canonical_audio_path: str,
) -> None:
    """
    Update audio_url and canonical_audio_path for a visit transcript.
    Expects exactly one row updated.
    """
    logger.info(f"[AUDIO] Updating audio artifacts for visit {visit_id}, user {user_id}, path {canonical_audio_path}")
    try:
        engine = get_db_engine()
        with engine.begin() as conn:
            update_query = text("""
                UPDATE visit_transcripts
                SET audio_url = :audio_url,
                    canonical_audio_path = :canonical_audio_path
                WHERE visit_id = :visit_id AND user_id = :user_id
            """)
            result = conn.execute(update_query, {
                "audio_url": audio_url,
                "canonical_audio_path": canonical_audio_path,
                "visit_id": visit_id,
                "user_id": user_id,
            })
            if result.rowcount != 1:
                raise RuntimeError(f"Expected 1 row updated, got {result.rowcount}")

            logger.info(f"[AUDIO] Canonical audio path persisted for visit {visit_id}: {canonical_audio_path}")
    except Exception as e:
        logger.error(f"Error updating audio artifacts for visit {visit_id}: {e}")
        raise


async def update_image_data(
    visit_id: str,
    user_id: str,
    image_url: str,
    metadata: dict,
) -> None:
    """
    Update the image_url, metadata, and OCR status for a visit transcript.
    Expects exactly one row updated.
    """
    try:
        engine = get_db_engine()
        with engine.begin() as conn:
            update_query = text("""
                UPDATE visit_transcripts
                SET image_url = :image_url,
                    image_metadata = :metadata,
                    ocr_status = 'pending'
                WHERE visit_id = :visit_id AND user_id = :user_id
            """)
            result = conn.execute(update_query, {
                "image_url": image_url,
                "metadata": json.dumps(metadata),
                "visit_id": visit_id,
                "user_id": user_id,
            })
            if result.rowcount != 1:
                raise RuntimeError(f"Expected 1 row updated, got {result.rowcount}")
    except Exception as e:
        logger.error(f"Error updating image data for visit {visit_id}: {e}")
        raise


async def get_image_metadata_and_status(visit_id: str) -> tuple[dict | None, str | None]:
    """
    Fetch image_metadata and ocr_status for a visit transcript.
    """
    try:
        engine = get_db_engine()
        with engine.connect() as conn:
            query = text("""
                SELECT image_metadata, ocr_status
                FROM visit_transcripts
                WHERE visit_id = :visit_id
            """)
            result = conn.execute(query, {"visit_id": visit_id})
            row = result.fetchone()

            if not row:
                raise NotFoundError(f"Visit {visit_id} not found")

            image_metadata = row[0]
            ocr_status = row[1]
            return image_metadata, ocr_status
    except Exception as e:
        logger.error(f"Error fetching image metadata for visit {visit_id}: {e}")
        raise


async def mark_ocr_processing(visit_id: str) -> None:
    """
    Mark OCR as processing for a visit transcript.
    """
    try:
        engine = get_db_engine()
        with engine.begin() as conn:
            query = text("""
                UPDATE visit_transcripts
                SET ocr_status = 'processing'
                WHERE visit_id = :visit_id
            """)
            conn.execute(query, {"visit_id": visit_id})
    except Exception as e:
        logger.error(f"Error updating OCR status to processing for visit {visit_id}: {e}")
        raise


async def save_ocr_result(
    visit_id: str,
    ocr_text: str,
    provider_name: str,
    metadata: dict,
) -> None:
    """
    Save OCR results to the visit transcript.
    """
    try:
        engine = get_db_engine()
        with engine.begin() as conn:
            query = text("""
                UPDATE visit_transcripts
                SET ocr_text = :ocr_text,
                    ocr_provider = :ocr_provider,
                    ocr_metadata = :ocr_metadata,
                    ocr_status = 'completed'
                WHERE visit_id = :visit_id
            """)
            conn.execute(
                query,
                {
                    "ocr_text": ocr_text,
                    "ocr_provider": provider_name,
                    "ocr_metadata": json.dumps(metadata),
                    "visit_id": visit_id,
                },
            )
    except Exception as e:
        logger.error(f"Error saving OCR result for visit {visit_id}: {e}")
        raise


async def save_ocr_error(visit_id: str, error_message: str) -> None:
    """
    Persist OCR error state for a visit transcript.
    """
    try:
        engine = get_db_engine()
        with engine.begin() as conn:
            query = text("""
                UPDATE visit_transcripts
                SET ocr_error = :error_message,
                    ocr_status = 'failed'
                WHERE visit_id = :visit_id
            """)
            conn.execute(query, {"error_message": error_message, "visit_id": visit_id})
    except Exception as e:
        logger.error(f"Error saving OCR error for visit {visit_id}: {e}")
        raise


async def get_audio_gcs_url(visit_id: str, user_id: str) -> str:
    """
    Fetch audio_url for a visit from Cloud SQL only.
    No Supabase.
    """
    try:
        engine = get_db_engine()
        with engine.connect() as conn:
            # Query visit_transcripts table for audio_url
            query = text("""
                SELECT audio_url FROM visit_transcripts
                WHERE visit_id = :visit_id AND user_id = :user_id
            """)

            result = conn.execute(query, {"visit_id": visit_id, "user_id": user_id})
            row = result.fetchone()

            if not row or not row[0]:
                raise NotFoundError(f"No audio file found for visit {visit_id}")

            return str(row[0])

    except DomainError:
        raise


async def get_canonical_audio_path(visit_id: str, user_id: str) -> str:
    """
    Fetch canonical_audio_path for a visit from Cloud SQL only.
    """
    logger.info(f"[AUDIO] Getting canonical audio path for visit {visit_id}, user {user_id}")
    try:
        engine = get_db_engine()
        with engine.connect() as conn:
            query = text("""
                SELECT canonical_audio_path FROM visit_transcripts
                WHERE visit_id = :visit_id AND user_id = :user_id
            """)
            result = conn.execute(query, {"visit_id": visit_id, "user_id": user_id})
            row = result.fetchone()

            if not row or not row[0]:
                raise NotFoundError(f"No canonical audio path found for visit {visit_id}")

            return str(row[0])

    except DomainError:
        raise
    except Exception as e:
        logger.error(f"Error fetching canonical audio path for visit {visit_id}: {e}")
        raise
    except Exception as e:
        logger.error(f"Error fetching audio URL for visit {visit_id}: {e}")
        raise


async def get_transcript_text(transcript_id: str) -> str:
    """
    Fetch raw transcript text from visit_transcripts table.
    Used by AI pipeline to get text for summarization.
    """
    try:
        engine = get_db_engine()
        with engine.connect() as conn:
            query = text("""
                SELECT transcript_text FROM visit_transcripts
                WHERE transcript_id = :transcript_id
            """)

            result = conn.execute(query, {"transcript_id": transcript_id})
            row = result.fetchone()

            if not row or not row[0]:
                raise NotFoundError(f"No transcript text found for transcript_id {transcript_id}")

            return str(row[0])

    except DomainError:
        raise
    except Exception as e:
        logger.error(f"Error fetching transcript text for transcript_id {transcript_id}: {e}")
        raise
