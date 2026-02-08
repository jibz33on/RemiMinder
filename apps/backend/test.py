# apps/backend/tests/test_summary_pipeline.py

# STT3 removed - using STT2 pipeline now

def run_test():
    transcript_text = """
    Patient reports mild headache for two days.
    Doctor advised hydration and paracetamol if needed.
    Follow-up suggested if pain persists beyond 3 days.
    """

    structured_json = {
        "summary": "Mild headache for two days; advised hydration and paracetamol.",
        "actions": ["Stay hydrated", "Take paracetamol if needed"],
        "doctor_name": "",
        "specialty": "",
        "visit_display_title": "Headache follow-up",
        "action_items": ["Stay hydrated", "Take paracetamol if needed"],
        "questions_next_visit": ["Should I come back if pain persists?"],
        "key_diagnoses": [],
        "medications": ["paracetamol"],
    }

    result = generate_summary(transcript_text, structured_json)

    print("\n===== SUMMARY RESULT =====\n")
    print(result["summary_text"])

    print("\n===== META =====")
    print("Model:", result["model_name"])
    print("Prompt Version:", result["prompt_version"])
    print("Pipeline Version:", result["pipeline_version"])
    print("Latency:", result["latency_ms"])

if __name__ == "__main__":
    run_test()