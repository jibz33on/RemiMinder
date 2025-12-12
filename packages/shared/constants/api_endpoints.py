# Shared API Endpoints for MediMinder
# Used by FastAPI backend

from typing import Dict, Optional

class ApiEndpoints:
    # Base URLs
    BASE_URL = "https://api.mediminder.com"
    STAGING_URL = "https://staging-api.mediminder.com"
    DEV_URL = "http://localhost:8000"

    # Authentication endpoints
    LOGIN = "/auth/login"
    REGISTER = "/auth/register"
    REFRESH_TOKEN = "/auth/refresh"
    LOGOUT = "/auth/logout"

    # User management
    USER_PROFILE = "/users/profile"
    UPDATE_PROFILE = "/users/profile"

    # Patient endpoints
    PATIENT_DASHBOARD = "/patients/dashboard"
    PATIENT_REMINDERS = "/patients/reminders"
    PATIENT_VISITS = "/patients/visits"

    # Caregiver endpoints
    CAREGIVER_DASHBOARD = "/caregivers/dashboard"
    CAREGIVER_PATIENTS = "/caregivers/patients"
    CAREGIVER_INVITATIONS = "/caregivers/invitations"

    # Reminder management
    CREATE_REMINDER = "/reminders"
    UPDATE_REMINDER = "/reminders/{id}"
    DELETE_REMINDER = "/reminders/{id}"
    COMPLETE_REMINDER = "/reminders/{id}/complete"
    SNOOZE_REMINDER = "/reminders/{id}/snooze"

    # Visit management
    UPLOAD_VISIT = "/visits/upload"
    GET_VISIT_SUMMARY = "/visits/{id}/summary"
    VISIT_HISTORY = "/visits/history"

    # RemiScan endpoints
    SCAN_PRESCRIPTION = "/remiscan/prescription"
    SCAN_LAB_REPORT = "/remiscan/lab-report"
    PROCESS_SCAN = "/remiscan/process"

    # File upload
    UPLOAD_FILE = "/files/upload"
    GET_FILE = "/files/{id}"

    # Notifications
    REGISTER_DEVICE = "/notifications/register"
    SEND_NOTIFICATION = "/notifications/send"

    @staticmethod
    def build_url(endpoint: str, params: Optional[Dict[str, str]] = None) -> str:
        """Build full URL with parameter substitution"""
        url = f"{ApiEndpoints.BASE_URL}{endpoint}"
        if params:
            for key, value in params.items():
                url = url.replace(f"{{{key}}}", value)
        return url

    @classmethod
    def get_base_url(cls, environment: str = "development") -> str:
        """Get base URL based on environment"""
        if environment == "production":
            return cls.BASE_URL
        elif environment == "staging":
            return cls.STAGING_URL
        else:
            return cls.DEV_URL

# Environment-based URL selection
def get_api_base_url(environment: str = "development") -> str:
    """Get API base URL for the given environment"""
    return ApiEndpoints.get_base_url(environment)