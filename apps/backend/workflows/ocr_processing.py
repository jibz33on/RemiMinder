import logging
from typing import Any, Dict

from domain.ports.storage import build_image_reference
from domain.ports.vision import get_ocr_provider_name, run_ocr_for_image
from domain.transcripts.repo import (
    get_image_metadata_and_status,
    mark_ocr_processing,
    save_ocr_error,
    save_ocr_result,
)

logger = logging.getLogger(__name__)


async def run_ocr_for_visit(visit_id: str) -> Dict[str, Any]:
    """
    Run OCR pipeline for a visit's image file.
    Preserves legacy behavior while routing through ports/providers.
    """
    try:
        image_metadata, ocr_status = await get_image_metadata_and_status(visit_id)

        if not image_metadata:
            raise ValueError(f"No image uploaded for visit {visit_id}")

        if ocr_status == "completed":
            logger.info("OCR already completed for visit %s - returning existing result", visit_id)
            return {
                "status": "completed",
                "visit_id": visit_id,
                "text_length": 0,
                "confidence": None,
                "pages": 0,
            }

        if ocr_status == "processing":
            logger.info("OCR already in progress for visit %s - returning processing status", visit_id)
            return {
                "status": "processing",
                "visit_id": visit_id,
            }

        if not isinstance(image_metadata, dict):
            raise ValueError(f"image_metadata is not a dict for visit {visit_id}")

        blob_name = image_metadata.get("blob_name")
        if not blob_name:
            raise ValueError(f"Blob name not found in image metadata for visit {visit_id}")

        await mark_ocr_processing(visit_id)

        image_reference = build_image_reference(blob_name)
        logger.info("Processing OCR for visit %s: %s", visit_id, image_reference)

        ocr_result = await run_ocr_for_image(image_reference)

        metadata = {
            "pages": ocr_result["pages"],
            "confidence": ocr_result["confidence"],
            "language": ocr_result["language"],
        }

        await save_ocr_result(
            visit_id=visit_id,
            ocr_text=ocr_result["text"],
            provider_name=get_ocr_provider_name(),
            metadata=metadata,
        )

        logger.info(
            "OCR completed for visit %s: %d characters",
            visit_id,
            len(ocr_result["text"]),
        )

        return {
            "status": "completed",
            "visit_id": visit_id,
            "text_length": len(ocr_result["text"]),
            "confidence": ocr_result["confidence"],
            "pages": ocr_result["pages"],
        }
    except Exception as e:
        try:
            await save_ocr_error(visit_id, str(e))
        except Exception as db_error:
            logger.error("Failed to update OCR error status: %s", db_error)
        logger.exception("OCR pipeline failed for visit %s", visit_id)
        raise
