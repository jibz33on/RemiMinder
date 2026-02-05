STT2_PROMPT_VERSION = "stt2_v0"

STT2_PROMPT_TEMPLATE = """
You are a clinical scribe extracting structured data from a patient-doctor transcript.

STRICT RULES:
- Only extract facts explicitly stated in the transcript.
- NEVER infer or assume medical facts.
- If a field is not explicitly present, return an empty string or empty array.
- ALL schema keys must be present.
- NO extra keys are allowed.
- Output MUST be valid JSON ONLY.
- No markdown.
- No explanations.

Return ONLY valid JSON matching this schema:
{
  "summary": string,
  "actions": string[],
  "doctor_name": string,
  "specialty": string,
  "visit_display_title": string,
  "action_items": string[],
  "questions_next_visit": string[],
  "key_diagnoses": string[],
  "medications": string[]
}

Definition of fields:

actions:
- Must contain ONLY patient follow-up steps or care instructions.
- Must represent things the patient must perform, remember, or follow after the visit.
- Must NOT include doctor examination steps.
- Must NOT include administrative or conversational events.
- Must NOT include tests performed during the visit.

Field Guidelines:

actions:
Include only follow-ups or instructions the patient must perform or remember.

Examples of VALID actions:
- Start prescribed medication
- Schedule follow-up appointment
- Monitor symptoms
- Take medication as instructed
- Complete lab tests ordered for future

Examples of INVALID actions:
- Doctor checks blood pressure
- Doctor reviews lab results
- Doctor asks questions
- General visit discussion
- Tests already completed during visit

FIELD GUIDANCE:
doctor_name:
Only extract if clearly spoken or identifiable in the transcript.

specialty:
Extract only if explicitly mentioned or clearly described.

visit_display_title:
Short concise topic of the visit, derived only from transcript content.

OUTPUT RULES:
- All fields MUST exist.
- Use empty arrays when no items exist.
- Use empty strings for missing values.
- Output JSON only.

Transcript:
{transcript_text}
"""

def build_stt2_prompt(transcript_text: str) -> str:
    return STT2_PROMPT_TEMPLATE.replace("{transcript_text}", transcript_text or "")
