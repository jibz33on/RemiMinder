from typing import Any

from domain.ports.logging import get_logger

logger = get_logger()

STT2_REQUIRED_FIELDS = {
    "summary": str,
    "actions": list,
    "doctor_name": str,
    "specialty": str,
    "visit_display_title": str,
    "action_items": list,
    "questions_next_visit": list,
    "key_diagnoses": list,
    "medications": list,
}


SUMMARY_MAX_LENGTH = 2000
LIST_ITEM_MAX_LENGTH = 300


def _normalize_string(value: Any) -> str:
    if value is None:
        return ""
    if not isinstance(value, str):
        raise ValueError("Expected a string value")
    trimmed = value.strip()
    if not trimmed:
        return ""
    if len(trimmed) > SUMMARY_MAX_LENGTH:
        logger.warning(
            f"Truncating summary field from {len(trimmed)} to {SUMMARY_MAX_LENGTH} characters"
        )
        return trimmed[:SUMMARY_MAX_LENGTH]
    return trimmed


def _normalize_list(value: Any, field_name: str) -> list[str]:
    if value is None:
        return []
    if not isinstance(value, list):
        raise ValueError(f"Field '{field_name}' must be a list")
    normalized: list[str] = []
    seen: set[str] = set()
    for item in value:
        if item is None:
            continue
        if not isinstance(item, str):
            raise ValueError(f"Field '{field_name}' must contain only strings")
        trimmed = item.strip()
        if not trimmed:
            continue
        if len(trimmed) > LIST_ITEM_MAX_LENGTH:
            logger.warning(
                f"Truncating {field_name} item from {len(trimmed)} to {LIST_ITEM_MAX_LENGTH} characters"
            )
            trimmed = trimmed[:LIST_ITEM_MAX_LENGTH]
        if trimmed in seen:
            continue
        seen.add(trimmed)
        normalized.append(trimmed)
    return normalized


def validate_summary_json(payload: Any) -> dict:
    if not isinstance(payload, dict):
        raise ValueError("Summary payload must be a JSON object")

    payload_keys = set(payload.keys())
    required_keys = set(STT2_REQUIRED_FIELDS.keys())
    missing_keys = required_keys - payload_keys
    extra_keys = payload_keys - required_keys
    if missing_keys:
        raise ValueError(f"Missing required fields: {sorted(missing_keys)}")
    if extra_keys:
        raise ValueError(f"Unexpected fields present: {sorted(extra_keys)}")

    normalized: dict[str, Any] = {}
    for field, expected_type in STT2_REQUIRED_FIELDS.items():
        value = payload.get(field)
        if expected_type is list:
            normalized[field] = _normalize_list(value, field)
        else:
            normalized[field] = _normalize_string(value)

    return normalized
