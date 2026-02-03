MEDICAL_SUMMARY_PROMPT = """You are a helpful medical assistant.

Current date and time: {current_datetime}

Please produce a concise, patient-friendly visit summary based on the transcript
below. Your response MUST be valid JSON with these keys:
- summary (string)
- action_items (array of strings)
- questions_next_visit (array of strings)
- key_diagnoses (array of strings)
- medications (array of strings)
- reminders (array of strings)
- title (string)

Transcript:
{transcript}
"""


def build_medical_summary_prompt(transcript: str, language_name: str) -> str:
    return f"""You are a helpful medical assistant.

Please respond entirely in {language_name}.
Return a JSON object with these keys:
- summary (string)
- action_items (array of strings)
- questions_next_visit (array of strings)
- key_diagnoses (array of strings)
- medications (array of strings)
- reminders (array of strings)
- title (string)

Transcript:
{transcript}
"""
