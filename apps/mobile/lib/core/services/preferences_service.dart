import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class PreferencesService {
  static const _appLanguageKey = 'pref_app_language';
  static const _countryKey = 'pref_country';
  static const _timezoneKey = 'pref_timezone';
  static const _defaultVisitLanguageKey = 'pref_default_visit_language';
  static const _visitLanguageOnboardingCompleteKey =
      'pref_visit_language_onboarding_complete';
  static const _cachedUserRoleKey = 'pref_cached_user_role';
  static const _lastActiveContextKey = 'pref_last_active_context';
  static const _contextCapabilitiesKey = 'pref_context_capabilities';
  static const _activePatientIdKey = 'pref_active_patient_id';

  Future<String?> getAppLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_appLanguageKey);
  }

  Future<void> setAppLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_appLanguageKey, languageCode);
  }

  Future<String?> getCountry() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_countryKey);
  }

  Future<void> setCountry(String countryCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_countryKey, countryCode);
  }

  Future<String?> getTimezone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_timezoneKey);
  }

  Future<void> setTimezone(String timezone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_timezoneKey, timezone);
  }

  Future<String?> getDefaultVisitLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_defaultVisitLanguageKey);
  }

  Future<void> setDefaultVisitLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_defaultVisitLanguageKey, languageCode);
  }

  Future<bool> isVisitLanguageOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_visitLanguageOnboardingCompleteKey) ?? false;
  }

  Future<void> setVisitLanguageOnboardingComplete(bool isComplete) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_visitLanguageOnboardingCompleteKey, isComplete);
  }

  Future<void> setCachedUserRole(UserRole role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cachedUserRoleKey, role.name);
  }

  Future<UserRole?> getCachedUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString(_cachedUserRoleKey);
    if (role == null || role.isEmpty) return null;
    try {
      return UserRole.fromString(role);
    } catch (_) {
      return null;
    }
  }

  Future<void> setLastActiveContext(ActiveContext? context) async {
    final prefs = await SharedPreferences.getInstance();
    if (context == null) {
      await prefs.remove(_lastActiveContextKey);
      return;
    }
    await prefs.setString(_lastActiveContextKey, context.name);
  }

  Future<ActiveContext?> getLastActiveContext() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_lastActiveContextKey);
    if (value == null || value.isEmpty) return null;
    return ActiveContext.fromString(value);
  }

  Future<void> setContextCapabilities(Set<ActiveContext> contexts) async {
    final prefs = await SharedPreferences.getInstance();
    final values = contexts.map((context) => context.name).toList();
    await prefs.setStringList(_contextCapabilitiesKey, values);
  }

  Future<Set<ActiveContext>> getContextCapabilities() async {
    final prefs = await SharedPreferences.getInstance();
    final values = prefs.getStringList(_contextCapabilitiesKey) ?? const [];
    return values
        .map(ActiveContext.fromString)
        .whereType<ActiveContext>()
        .toSet();
  }

  Future<void> setActivePatientId(String? patientId) async {
    final prefs = await SharedPreferences.getInstance();
    if (patientId == null || patientId.isEmpty) {
      await prefs.remove(_activePatientIdKey);
      return;
    }
    await prefs.setString(_activePatientIdKey, patientId);
  }

  Future<String?> getActivePatientId() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_activePatientIdKey);
    if (value == null || value.isEmpty) return null;
    return value;
  }
}
