import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing user consent acknowledgments for media features
///
/// Stores non-PHI consent flags locally to avoid repeated consent prompts
/// for microphone and camera usage in healthcare contexts.
class ConsentService {
  static const String _audioConsentKey = 'hasAcceptedAudioConsent';
  static const String _cameraConsentKey = 'hasAcceptedCameraConsent';

  /// Check if user has accepted audio recording consent
  Future<bool> hasAcceptedAudioConsent() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_audioConsentKey) ?? false;
  }

  /// Mark audio consent as accepted
  Future<void> acceptAudioConsent() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_audioConsentKey, true);
  }

  /// Check if user has accepted camera scanning consent
  Future<bool> hasAcceptedCameraConsent() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_cameraConsentKey) ?? false;
  }

  /// Mark camera consent as accepted
  Future<void> acceptCameraConsent() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_cameraConsentKey, true);
  }

  /// Clear all consent flags (optional, for logout scenarios)
  Future<void> clearAllConsents() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_audioConsentKey);
    await prefs.remove(_cameraConsentKey);
  }
}
