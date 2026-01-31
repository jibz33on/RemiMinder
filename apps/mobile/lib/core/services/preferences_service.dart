import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const _appLanguageKey = 'pref_app_language';
  static const _countryKey = 'pref_country';
  static const _timezoneKey = 'pref_timezone';
  static const _defaultVisitLanguageKey = 'pref_default_visit_language';
  static const _visitLanguageOnboardingCompleteKey =
      'pref_visit_language_onboarding_complete';

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
}
