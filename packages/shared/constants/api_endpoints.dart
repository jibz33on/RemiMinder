// Shared API Endpoints for MediMinder
// Used by both Flutter mobile and FastAPI backend

class ApiEndpoints {
  // Base URLs
  static const String baseUrl = 'https://api.mediminder.com';
  static const String stagingUrl = 'https://staging-api.mediminder.com';
  static const String devUrl = 'http://localhost:8000';

  // Authentication endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';

  // User management
  static const String userProfile = '/users/profile';
  static const String updateProfile = '/users/profile';

  // Patient endpoints
  static const String patientDashboard = '/patients/dashboard';
  static const String patientReminders = '/patients/reminders';
  static const String patientVisits = '/patients/visits';

  // Caregiver endpoints
  static const String caregiverDashboard = '/caregivers/dashboard';
  static const String caregiverPatients = '/caregivers/patients';
  static const String caregiverInvitations = '/caregivers/invitations';

  // Reminder management
  static const String createReminder = '/reminders';
  static const String updateReminder = '/reminders/{id}';
  static const String deleteReminder = '/reminders/{id}';
  static const String completeReminder = '/reminders/{id}/complete';
  static const String snoozeReminder = '/reminders/{id}/snooze';

  // Visit management
  static const String uploadVisit = '/visits/upload';
  static const String getVisitSummary = '/visits/{id}/summary';
  static const String visitHistory = '/visits/history';

  // RemiScan endpoints
  static const String scanPrescription = '/remiscan/prescription';
  static const String scanLabReport = '/remiscan/lab-report';
  static const String processScan = '/remiscan/process';

  // File upload
  static const String uploadFile = '/files/upload';
  static const String getFile = '/files/{id}';

  // Notifications
  static const String registerDevice = '/notifications/register';
  static const String sendNotification = '/notifications/send';

  // Helper method to build full URLs
  static String buildUrl(String endpoint, [Map<String, String>? params]) {
    String url = '$baseUrl$endpoint';
    if (params != null) {
      params.forEach((key, value) {
        url = url.replaceAll('{$key}', value);
      });
    }
    return url;
  }
}

// Environment-based URL selection
String getApiBaseUrl(String environment) {
  switch (environment) {
    case 'production':
      return ApiEndpoints.baseUrl;
    case 'staging':
      return ApiEndpoints.stagingUrl;
    case 'development':
    default:
      return ApiEndpoints.devUrl;
  }
}