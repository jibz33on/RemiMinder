"""
Simple synchronous OCR pipeline for image files.
Reads images from Google Cloud Storage, processes with Google Vision, returns extracted text.
"""

import logging
import json

logger = logging.getLogger(__name__)


async def run_ocr_for_visit(visit_id: str) -> dict:
    """
    Run synchronous OCR pipeline for a visit's image file.
    Validates preconditions, processes with Google Vision, stores results.

    Args:
        visit_id: The visit identifier

    Returns:
        Dictionary with OCR processing results
    """
    try:
        # Step 1: Get database connection
        from services.cloud_sql_engine import get_cloud_sql_engine
        from sqlalchemy import text

        engine = get_cloud_sql_engine()

        # Step 2: Validate preconditions and get blob info
        with engine.begin() as conn:
            check_query = text("""
                SELECT image_metadata, ocr_status
                FROM visit_transcripts
                WHERE visit_id = :visit_id
            """)

            result = conn.execute(check_query, {"visit_id": visit_id})
            row = result.fetchone()

            if not row:
                raise ValueError(f"Visit {visit_id} not found")

            image_metadata = row[0]
            ocr_status = row[1]

            # Validate image exists
            if not image_metadata:
                raise ValueError(f"No image uploaded for visit {visit_id}")

            # Handle idempotent states gracefully
            if ocr_status == 'completed':
                logger.info(f"OCR already completed for visit {visit_id} - returning existing result")
                return {
                    "status": "completed",
                    "visit_id": visit_id,
                    "text_length": 0,  # We don't have the text length without querying
                    "confidence": None,
                    "pages": 0
                }

            if ocr_status == 'processing':
                logger.info(f"OCR already in progress for visit {visit_id} - returning processing status")
                return {
                    "status": "processing",
                    "visit_id": visit_id
                }

            # Extract blob_name from metadata (already parsed as dict from JSONB)
            if not isinstance(image_metadata, dict):
                raise ValueError(f"image_metadata is not a dict for visit {visit_id}")

            metadata_dict = image_metadata
            blob_name = metadata_dict.get("blob_name")
            if not blob_name:
                raise ValueError(f"Blob name not found in image metadata for visit {visit_id}")

        # Step 3: Mark as processing
        with engine.begin() as conn:
            processing_query = text("""
                UPDATE visit_transcripts
                SET ocr_status = 'processing'
                WHERE visit_id = :visit_id
            """)
            conn.execute(processing_query, {"visit_id": visit_id})

        # Step 4: Construct GCS URI from bucket env var and blob_name from metadata
        import os
        bucket_name = os.getenv("GCS_BUCKET_NAME")
        if not bucket_name:
            raise RuntimeError("GCS_BUCKET_NAME environment variable not set")

        gcs_uri = f"gs://{bucket_name}/{blob_name}"

        logger.info(f"Processing OCR for visit {visit_id}: {gcs_uri}")

        # Step 5: Perform OCR
        from services.vision_service import extract_text_from_gcs_uri
        ocr_result = await extract_text_from_gcs_uri(gcs_uri)

        # Step 6: Store success results
        with engine.begin() as conn:
            metadata = {
                "pages": ocr_result["pages"],
                "confidence": ocr_result["confidence"],
                "language": ocr_result["language"]
            }

            success_query = text("""
                UPDATE visit_transcripts
                SET ocr_text = :ocr_text,
                    ocr_provider = 'google_vision',
                    ocr_metadata = :ocr_metadata,
                    ocr_status = 'completed'
                WHERE visit_id = :visit_id
            """)

            conn.execute(success_query, {
                "ocr_text": ocr_result["text"],
                "ocr_metadata": json.dumps(metadata),
                "visit_id": visit_id
            })

        logger.info(f"OCR completed for visit {visit_id}: {len(ocr_result['text'])} characters")

        return {
            "status": "completed",
            "visit_id": visit_id,
            "text_length": len(ocr_result["text"]),
            "confidence": ocr_result["confidence"],
            "pages": ocr_result["pages"]
        }

    except Exception as e:
        # Step 7: Store error on failure
        try:
            with engine.begin() as conn:
                error_query = text("""
                    UPDATE visit_transcripts
                    SET ocr_error = :error_message,
                        ocr_status = 'failed'
                    WHERE visit_id = :visit_id
                """)

                conn.execute(error_query, {
                    "error_message": str(e),
                    "visit_id": visit_id
                })
        except Exception as db_error:
            logger.error(f"Failed to update OCR error status: {db_error}")

        logger.exception(f"OCR pipeline failed for visit {visit_id}")
        raise
