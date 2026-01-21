"""
Summary Normalizer V2

Purpose:
- Take raw, untrusted JSON output from Gemini
- Enforce the V2 schema:
    {
      "summary": str,
      "decisions": list[str],
      "medications": list[str],
      "actions": list[str]
    }
- Fix missing fields, wrong types, empty lists
- Remove any extra keys
- Guarantee the backend and UI always receive safe, predictable data
"""

import logging
from typing import Any, Dict, List, Tuple

logger = logging.getLogger(__name__)


# Fallback texts (single source of truth). Non-English locales default to English.
FALLBACKS_BY_LANGUAGE: Dict[str, Tuple[str, str, str, str]] = {
    "en": (
        "Routine visit with no major treatment changes discussed.",
        "No clinical decisions mentioned in the conversation",
        "No medications mentioned or changed in the conversation",
        "No follow-up actions mentioned in the conversation",
    )
}


def _ensure_string_list(value: Any) -> List[str]:
    """
    Ensure the value becomes a list of non-empty strings.
    - If value is a list: keep only non-empty strings
    - If value is a string: wrap it into a list
    - Otherwise: return empty list
    """
    if isinstance(value, list):
        cleaned: List[str] = []
        for item in value:
            if isinstance(item, str):
                text = item.strip()
                if text:
                    cleaned.append(text)
        return cleaned

    if isinstance(value, str):
        text = value.strip()
        if text:
            return [text]

    return []


def _get_fallbacks(language_code: str) -> Tuple[str, str, str, str]:
    normalized_code = (language_code or "en").lower()
    fallbacks = FALLBACKS_BY_LANGUAGE.get(normalized_code)
    if fallbacks is None:
        logger.warning(
            "V2 summary normalizer missing locale fallbacks for '%s'. Using English.",
            normalized_code,
        )
        fallbacks = FALLBACKS_BY_LANGUAGE["en"]
    return fallbacks


def normalize_v2_summary(raw: Dict[str, Any], language_code: str = "en") -> Dict[str, Any]:
    """
    Normalize and validate V2 medical summary output.

    Input:
        raw: dict coming from Gemini (untrusted)

    Output:
        dict with guaranteed safe structure:
        {
          "summary": str,
          "decisions": list[str],
          "medications": list[str],
          "actions": list[str]
        }
    """

    if not isinstance(raw, dict):
        logger.warning("V2 summary normalizer received non-dict input. Using empty dict.")
        raw = {}

    safe: Dict[str, Any] = {}
    fallback_summary, fallback_decisions, fallback_medications, fallback_actions = _get_fallbacks(language_code)

    # -----------------------
    # 1. Summary
    # -----------------------
    summary = raw.get("summary")
    if isinstance(summary, str):
        summary = summary.strip()

    if not isinstance(summary, str) or not summary:
        summary = fallback_summary

    safe["summary"] = summary

    # -----------------------
    # 2. Decisions
    # -----------------------
    decisions_list = _ensure_string_list(raw.get("decisions"))

    if not decisions_list:
        decisions_list = [fallback_decisions]

    safe["decisions"] = decisions_list

    # -----------------------
    # 3. Medications
    # -----------------------
    medications_list = _ensure_string_list(raw.get("medications"))

    if not medications_list:
        medications_list = [fallback_medications]

    safe["medications"] = medications_list

    # -----------------------
    # 4. Actions
    # -----------------------
    actions_list = _ensure_string_list(raw.get("actions"))

    if not actions_list:
        actions_list = [fallback_actions]

    safe["actions"] = actions_list

    # -----------------------
    # Done. We intentionally DO NOT copy any other keys.
    # -----------------------

    return safe
