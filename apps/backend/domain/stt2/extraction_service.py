import json
import re
from typing import Any

from domain.ports.logging import get_logger
from domain.stt2.prompt_builder import STT2_PROMPT_VERSION, build_stt2_prompt
from domain.stt2.schema import validate_summary_json
from infra.llm.gemini_client import GeminiClient

logger = get_logger()


class STT2ExtractionService:
    """Stage 3.3: Extract structured data from transcript using LLM."""

    def __init__(self, client: GeminiClient | None = None) -> None:
        self._client = client or GeminiClient()

    def extract(self, transcript_text: str) -> dict:
        """Extract structured clinical data from transcript text."""
        prompt = build_stt2_prompt(transcript_text)
        model_name = getattr(self._client, "model_name", "unknown")
        logger.info(f"STT-2 extraction prompt_version={STT2_PROMPT_VERSION} model_name={model_name}")

        last_error: Exception | None = None
        for attempt in range(1, 3):
            response_text = self._client.generate_text(prompt=prompt, temperature=0.0)
            logger.info(f"STT-2 raw LLM output (attempt {attempt}): {response_text}")
            try:
                parsed = self._parse_json(response_text)
                return validate_summary_json(parsed)
            except ValueError as exc:
                last_error = exc
                if attempt < 2:
                    logger.warning(f"STT-2 extraction retrying after validation error: {exc}")
                    continue
                raise
        if last_error:
            raise last_error
        raise RuntimeError("STT-2 extraction failed without explicit error")

    def _parse_json(self, response_text: str) -> Any:
        raw = (response_text or "").strip()
        if "```" in raw:
            raw = self._strip_code_fence(raw)
        raw = self._extract_json_object(raw)
        raw = self._remove_trailing_commas(raw)
        try:
            return json.loads(raw)
        except json.JSONDecodeError as exc:
            repaired = self._insert_missing_commas(raw)
            if repaired != raw:
                try:
                    return json.loads(repaired)
                except json.JSONDecodeError:
                    pass
            logger.error(f"Failed to parse STT-2 JSON: {exc}")
            raise ValueError("LLM output is not valid JSON") from exc

    def _strip_code_fence(self, text: str) -> str:
        parts = text.split("```")
        if len(parts) >= 3:
            return parts[1].strip()
        return text.strip()

    def _extract_json_object(self, text: str) -> str:
        start = text.find("{")
        end = text.rfind("}")
        if start == -1 or end == -1 or end <= start:
            # Some models return JSON key/value lines without outer braces.
            if '"summary"' in text:
                logger.warning("LLM output missing JSON braces; attempting to wrap")
                return f"{{{text.strip()}}}"
            raise ValueError("LLM output does not contain a JSON object")
        return text[start : end + 1].strip()

    def _remove_trailing_commas(self, text: str) -> str:
        cleaned = text
        cleaned = re.sub(r",\s*([}\]])", r"\1", cleaned)
        return cleaned

    def _insert_missing_commas(self, text: str) -> str:
        lines = [line.rstrip() for line in text.splitlines() if line.strip()]
        if not lines:
            return text
        rebuilt: list[str] = []
        for idx, line in enumerate(lines):
            stripped = line.strip()
            rebuilt.append(line)
            if stripped in ("{", "}", "[", "]"):
                continue
            if stripped.endswith((",", "{", "[", "}", "]")):
                continue
            next_line = None
            for j in range(idx + 1, len(lines)):
                if lines[j].strip():
                    next_line = lines[j].strip()
                    break
            if next_line and next_line not in ("}", "]"):
                rebuilt[-1] = f"{line},"
        return "\n".join(rebuilt)
