def build_medical_summary_prompt_v2(transcript: str, language_name: str) -> str:
    return f"""You are a careful medical assistant.

Please respond entirely in {language_name}.
Return a JSON object with these keys:
- summary (string)
- action_items (array of strings)
- questions_next_visit (array of strings)
- key_diagnoses (array of strings)
- medications (array of strings)
- reminders (array of strings)
- title (string)

Prefer short, clear items and avoid medical jargon where possible.

Transcript:
{transcript}
"""
