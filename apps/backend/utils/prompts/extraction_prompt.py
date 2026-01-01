EXTRACTION_PROMPT = """Extract facts from this medical visit transcript.

RULES:
- Extract ONLY information directly stated in the transcript
- Do NOT infer, assume, normalize, or rephrase medical information
- If something is not mentioned, use: "Not mentioned in transcript"
- If no items exist for a list, return an empty list []
- Keep it simple and factual

OUTPUT: JSON with these sections:

{
  "symptoms": [
    {
      "description": "what symptom was mentioned",
      "duration": "how long or 'Not mentioned in transcript'",
      "severity": "exact severity as stated (e.g., '6–7/10') or 'Not mentioned in transcript'"
    }
  ],
  "diagnosis": {
    "stated_diagnosis": "diagnosis mentioned or 'Not mentioned in transcript'",
    "doctor_assessment": "what doctor said or 'Not mentioned in transcript'"
  },
  "medications": [
    {
      "name": "medication name",
      "dose": "dose amount",
      "timing": "when/how often to take",
      "duration": "how long to take"
    }
  ],
  "warnings": ["any warnings mentioned"],
  "follow_up": {
    "timeframe": "when to follow up or 'Not mentioned in transcript'",
    "instructions": "follow up instructions or 'Not mentioned in transcript'"
  }
}

TRANSCRIPT:
{transcript}

Output only valid JSON.
"""
