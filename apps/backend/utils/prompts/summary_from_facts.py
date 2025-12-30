"""
Simple summary generation from extracted facts.

Keep it straightforward for experimentation.
"""

SUMMARY_FROM_FACTS_PROMPT = """Generate a patient-friendly medical visit summary from these extracted facts.

RULES:
- Use ONLY the provided facts
- Skip anything marked "Not mentioned in transcript"
- Keep it concise and clear
- Write in third person

OUTPUT: JSON with:
{{
  "title": "brief visit type (2-4 words)",
  "summary": "patient-friendly summary using only facts",
  "action_items": ["clear instructions from facts"],
  "questions_next_visit": ["2-3 follow-up questions"],
  "key_diagnoses": ["diagnoses from facts"],
  "medications": ["medications with doses"]
}}

FACTS:
{facts_json}

Output only valid JSON.
"""

