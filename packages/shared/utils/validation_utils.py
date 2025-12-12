# Shared Validation Utilities for MediMinder Backend
# Cross-platform validation rules extracted from Phase 1

import re
from typing import Optional

class ValidationUtils:
    @staticmethod
    def is_valid_email(email: str) -> bool:
        """Email validation (from Phase 1 PatientRegistration.js)"""
        pattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+'
        return bool(re.match(pattern, email))

    @staticmethod
    def is_valid_password(password: str) -> bool:
        """Password validation (from Phase 1 auth components)"""
        if len(password) < 8:
            return False
        # At least 8 characters, 1 uppercase, 1 lowercase, 1 number
        pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$'
        return bool(re.match(pattern, password))

    @staticmethod
    def is_valid_medication_name(name: str) -> bool:
        """Medication name validation (from Phase 1 reminder forms)"""
        if not name or len(name.strip()) < 2 or len(name) > 100:
            return False
        # Allow letters, numbers, spaces, hyphens, parentheses
        pattern = r'^[a-zA-Z0-9\s\-\(\)]+$'
        return bool(re.match(pattern, name))

    @staticmethod
    def is_valid_dosage(dosage: str) -> bool:
        """Dosage validation (from Phase 1 reminder forms)"""
        if not dosage.strip():
            return False
        # Allow formats like: 10mg, 5ml, 1-0-1, etc.
        pattern = r'^[0-9]+(\.[0-9]+)?\s*(mg|ml|g|mcg|units?|tablets?|capsules?|drops?|[0-9\-]+)$'
        return bool(re.match(pattern, dosage, re.IGNORECASE))

    @staticmethod
    def is_valid_phone_number(phone: str) -> bool:
        """Phone number validation (from Phase 1 user profiles)"""
        # Allow various formats: +1234567890, 123-456-7890, (123) 456-7890
        pattern = r'^\+?1?[-.\s]?\(?([0-9]{3})\)?[-.\s]?([0-9]{3})[-.\s]?([0-9]{4})$'
        return bool(re.match(pattern, phone))

    @staticmethod
    def is_valid_reminder_title(title: str) -> bool:
        """Reminder title validation (from Phase 1 reminder modal)"""
        if not title.strip() or len(title) > 200:
            return False
        # Allow most characters but prevent script injection
        pattern = r'^[^<>{}]*$'
        return bool(re.match(pattern, title))

    # Error message methods
    @staticmethod
    def get_email_error(email: str) -> Optional[str]:
        if not email:
            return 'Email is required'
        if not ValidationUtils.is_valid_email(email):
            return 'Please enter a valid email address'
        return None

    @staticmethod
    def get_password_error(password: str) -> Optional[str]:
        if not password:
            return 'Password is required'
        if len(password) < 8:
            return 'Password must be at least 8 characters'
        if not ValidationUtils.is_valid_password(password):
            return 'Password must contain uppercase, lowercase, and number'
        return None

    @staticmethod
    def get_medication_name_error(name: str) -> Optional[str]:
        if not name.strip():
            return 'Medication name is required'
        if not ValidationUtils.is_valid_medication_name(name):
            return 'Medication name contains invalid characters'
        return None

    @staticmethod
    def get_dosage_error(dosage: str) -> Optional[str]:
        if not dosage.strip():
            return 'Dosage is required'
        if not ValidationUtils.is_valid_dosage(dosage):
            return 'Please enter a valid dosage (e.g., 10mg, 5ml, 1-0-1)'
        return None

# Pydantic validators for use with FastAPI models
from pydantic import validator

class PydanticValidators:
    @validator('email')
    def validate_email(cls, v):
        if not ValidationUtils.is_valid_email(v):
            raise ValueError('Invalid email format')
        return v

    @validator('password')
    def validate_password(cls, v):
        if not ValidationUtils.is_valid_password(v):
            raise ValueError('Password must be at least 8 characters with uppercase, lowercase, and number')
        return v

    @validator('medication_name')
    def validate_medication_name(cls, v):
        if not ValidationUtils.is_valid_medication_name(v):
            raise ValueError('Invalid medication name')
        return v

    @validator('dosage')
    def validate_dosage(cls, v):
        if not ValidationUtils.is_valid_dosage(v):
            raise ValueError('Invalid dosage format')
        return v