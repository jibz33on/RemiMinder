// Shared Validation Utilities for MediMinder
// Cross-platform validation rules extracted from Phase 1

class ValidationUtils {
  // Email validation (from Phase 1 PatientRegistration.js)
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    return emailRegex.hasMatch(email);
  }

  // Password validation (from Phase 1 auth components)
  static bool isValidPassword(String password) {
    // At least 8 characters, 1 uppercase, 1 lowercase, 1 number
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$',
    );
    return passwordRegex.hasMatch(password);
  }

  // Medication name validation (from Phase 1 reminder forms)
  static bool isValidMedicationName(String name) {
    if (name.trim().isEmpty) return false;
    if (name.length < 2 || name.length > 100) return false;
    // Allow letters, numbers, spaces, hyphens, parentheses
    final medNameRegex = RegExp(r'^[a-zA-Z0-9\s\-\(\)]+$');
    return medNameRegex.hasMatch(name);
  }

  // Dosage validation (from Phase 1 reminder forms)
  static bool isValidDosage(String dosage) {
    if (dosage.trim().isEmpty) return false;
    // Allow formats like: 10mg, 5ml, 1-0-1, etc.
    final dosageRegex = RegExp(
      r'^[0-9]+(\.[0-9]+)?\s*(mg|ml|g|mcg|units?|tablets?|capsules?|drops?|[0-9\-]+)$',
      caseSensitive: false,
    );
    return dosageRegex.hasMatch(dosage);
  }

  // Phone number validation (from Phase 1 user profiles)
  static bool isValidPhoneNumber(String phone) {
    // Allow various formats: +1234567890, 123-456-7890, (123) 456-7890
    final phoneRegex = RegExp(
      r'^\+?1?[-.\s]?\(?([0-9]{3})\)?[-.\s]?([0-9]{3})[-.\s]?([0-9]{4})$',
    );
    return phoneRegex.hasMatch(phone);
  }

  // Reminder title validation (from Phase 1 reminder modal)
  static bool isValidReminderTitle(String title) {
    if (title.trim().isEmpty) return false;
    if (title.length > 200) return false;
    // Allow most characters but prevent script injection
    final titleRegex = RegExp(r'^[^<>{}]*$');
    return titleRegex.hasMatch(title);
  }

  // Get validation error messages
  static String? getEmailError(String email) {
    if (email.isEmpty) return 'Email is required';
    if (!isValidEmail(email)) return 'Please enter a valid email address';
    return null;
  }

  static String? getPasswordError(String password) {
    if (password.isEmpty) return 'Password is required';
    if (password.length < 8) return 'Password must be at least 8 characters';
    if (!isValidPassword(password)) {
      return 'Password must contain uppercase, lowercase, and number';
    }
    return null;
  }

  static String? getMedicationNameError(String name) {
    if (name.trim().isEmpty) return 'Medication name is required';
    if (!isValidMedicationName(name)) {
      return 'Medication name contains invalid characters';
    }
    return null;
  }

  static String? getDosageError(String dosage) {
    if (dosage.trim().isEmpty) return 'Dosage is required';
    if (!isValidDosage(dosage)) {
      return 'Please enter a valid dosage (e.g., 10mg, 5ml, 1-0-1)';
    }
    return null;
  }
}

// Python version for backend validation
class ValidationUtils:
    @staticmethod
    def is_valid_email(email: str) -> bool:
        import re
        pattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+'
        return bool(re.match(pattern, email))

    @staticmethod
    def is_valid_password(password: str) -> bool:
        # At least 8 characters, 1 uppercase, 1 lowercase, 1 number
        import re
        if len(password) < 8:
            return False
        pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$'
        return bool(re.match(pattern, password))

    @staticmethod
    def is_valid_medication_name(name: str) -> bool:
        if not name or len(name.strip()) < 2 or len(name) > 100:
            return False
        import re
        pattern = r'^[a-zA-Z0-9\s\-\(\)]+$'
        return bool(re.match(pattern, name))

    @staticmethod
    def is_valid_dosage(dosage: str) -> bool:
        if not dosage.strip():
            return False
        import re
        pattern = r'^[0-9]+(\.[0-9]+)?\s*(mg|ml|g|mcg|units?|tablets?|capsules?|drops?|[0-9\-]+)$'
        return bool(re.match(pattern, dosage, re.IGNORECASE))