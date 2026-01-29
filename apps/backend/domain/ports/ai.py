from typing import Any, Callable

_visit_summary_provider: Callable[[str, str], Any] | None = None
_model_name_provider: Callable[[], str] | None = None
_reminder_message_provider: Callable[[str, str], Any] | None = None


def set_visit_summary_provider(provider: Callable[[str, str], Any]) -> None:
    global _visit_summary_provider
    _visit_summary_provider = provider


def set_model_name_provider(provider: Callable[[], str]) -> None:
    global _model_name_provider
    _model_name_provider = provider


def set_reminder_message_provider(provider: Callable[[str, str], Any]) -> None:
    global _reminder_message_provider
    _reminder_message_provider = provider


async def generate_visit_summary(transcript_text: str, language: str):
    if _visit_summary_provider is None:
        raise RuntimeError("AI summary provider not configured")
    return await _visit_summary_provider(transcript_text, language)


def get_model_name() -> str:
    if _model_name_provider is None:
        raise RuntimeError("AI model name provider not configured")
    return _model_name_provider()


async def generate_reminder_message(prompt: str, title: str) -> str:
    if _reminder_message_provider is None:
        raise RuntimeError("AI reminder provider not configured")
    return await _reminder_message_provider(prompt, title)
