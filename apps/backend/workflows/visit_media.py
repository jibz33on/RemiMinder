"""
Workflow helpers for visit media handling (audio/image/OCR).
"""

from domain.ports.storage import upload_audio_file as port_upload_audio_file
from domain.ports.storage import upload_image_file as port_upload_image_file
from workflows.ocr_processing import run_ocr_for_visit


async def upload_audio_file(visit_id: str, file) -> dict:
    return await port_upload_audio_file(visit_id, file)


async def upload_image_file(visit_id: str, file) -> dict:
    return await port_upload_image_file(visit_id, file)


async def run_ocr_for_visit_media(visit_id: str) -> dict:
    return await run_ocr_for_visit(visit_id)
