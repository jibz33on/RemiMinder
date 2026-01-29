from typing import Any, Callable

_ocr_provider: Callable[[str], Any] | None = None
_ocr_provider_name: Callable[[], str] | None = None


def set_ocr_provider(provider: Callable[[str], Any]) -> None:
    global _ocr_provider
    _ocr_provider = provider


def set_ocr_provider_name(provider_name: Callable[[], str]) -> None:
    global _ocr_provider_name
    _ocr_provider_name = provider_name


async def run_ocr_for_image(image_reference: str) -> Any:
    if _ocr_provider is None:
        raise RuntimeError("OCR provider not configured")
    return await _ocr_provider(image_reference)


def get_ocr_provider_name() -> str:
    if _ocr_provider_name is None:
        raise RuntimeError("OCR provider name not configured")
    return _ocr_provider_name()
