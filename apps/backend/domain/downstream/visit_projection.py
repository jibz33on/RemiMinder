from typing import Any


def normalize_summary_for_ui(summary_json: dict) -> dict:
    normalized: dict[str, Any] = {}
    for key, value in (summary_json or {}).items():
        if isinstance(value, str):
            normalized[key] = value.strip() or None
        elif isinstance(value, list):
            normalized[key] = [item for item in value if isinstance(item, str) and item.strip()]
        else:
            normalized[key] = value
    return normalized


def build_summary_preview(summary_text: str, max_length: int = 160) -> str:
    cleaned = (summary_text or "").strip()
    if len(cleaned) <= max_length:
        return cleaned
    return f"{cleaned[: max_length - 3]}..."
