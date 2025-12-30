"""
Simple validation tools for extracted medical facts.

Minimal checks for experimentation. No LLM, just basic structure.
"""

from typing import Dict, List, Any


def validate_extracted_facts(facts: Dict[str, Any]) -> List[str]:
    """
    Simple validation of extracted facts.

    For experimentation - keeps it minimal and permissive.

    Args:
        facts: Dictionary of extracted facts

    Returns:
        List of error messages (empty if valid)
    """
    errors = []

    # Check it's a dict
    if not isinstance(facts, dict):
        errors.append("Facts must be a dictionary")
        return errors

    # Check required top-level keys (basic structure)
    required_keys = ["symptoms", "diagnosis", "medications", "warnings", "follow_up"]
    for key in required_keys:
        if key not in facts:
            errors.append(f"Missing key: '{key}'")

    # That's it for now - keep it simple for experimentation
    return errors


def print_validation_results(errors: List[str]) -> bool:
    """
    Print validation results in a readable format.
    
    Args:
        errors: List of validation errors
        
    Returns:
        True if valid (no errors), False otherwise
    """
    if not errors:
        print("✅ Validation passed")
        return True
    
    print(f"❌ Validation failed ({len(errors)} errors):")
    for i, error in enumerate(errors, 1):
        print(f"  {i}. {error}")
    
    return False

