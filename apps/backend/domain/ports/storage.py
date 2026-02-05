from typing import Any, Callable, Dict

_upload_audio: Callable[[str, Any], Dict[str, Any]] | None = None
_upload_image: Callable[[str, Any], Dict[str, Any]] | None = None
_image_reference_builder: Callable[[str], str] | None = None


def set_storage_providers(
    upload_audio: Callable[[str, Any], Dict[str, Any]],
    upload_image: Callable[[str, Any], Dict[str, Any]],
) -> None:
    global _upload_audio, _upload_image
    _upload_audio = upload_audio
    _upload_image = upload_image


def set_image_reference_builder(builder: Callable[[str], str]) -> None:
    global _image_reference_builder
    _image_reference_builder = builder


async def upload_audio_file(visit_id: str, file) -> Dict[str, Any]:
    if _upload_audio is None:
        raise RuntimeError("Storage provider not configured")
    return await _upload_audio(visit_id, file)


async def upload_image_file(visit_id: str, file) -> Dict[str, Any]:
    if _upload_image is None:
        raise RuntimeError("Storage provider not configured")
    return await _upload_image(visit_id, file)


def build_image_reference(blob_name: str) -> str:
    if _image_reference_builder is None:
        raise RuntimeError("Storage reference builder not configured")
    return _image_reference_builder(blob_name)
