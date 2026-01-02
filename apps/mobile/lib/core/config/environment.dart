import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration for MediMinder Flutter app
class Environment {
  // Track if environment has been loaded
  static bool _isLoaded = false;

  // Auth Provider Configuration
  static String get authProvider =>
      _isLoaded ? (dotenv.env['AUTH_PROVIDER'] ?? 'firebase') : 'firebase';

  // API Configuration
  static String get apiBaseUrl => _isLoaded
      ? (dotenv.env['MOBILE_API_BASE_URL'] ??
          dotenv.env['API_BASE_URL'] ??
          'http://localhost:8000')
      : 'http://localhost:8000';

  // App Environment
  static String get flutterEnv =>
      _isLoaded ? (dotenv.env['FLUTTER_ENV'] ?? 'development') : 'development';

  // Environment checks
  static bool get isProduction => flutterEnv == 'production';
  static bool get isStaging => flutterEnv == 'staging';
  static bool get isDevelopment => flutterEnv == 'development';

  /// Load environment variables from .env file
  static Future<void> load() async {
    try {
      // Load the .env inside the mobile folder FIRST
      await dotenv.load(fileName: '.env');
      _isLoaded = true;
      return;
    } catch (e) {
      // Fallback to root .env ONLY if mobile .env missing
    }

    try {
      await dotenv.load(
          fileName: '/Users/jibinkunjumon/developments/MediMinder/.env');
      _isLoaded = true;
    } catch (e) {
      // No .env found. Running with defaults.
      _isLoaded = false;
    }
  }

  /// Validate that required environment variables are set
  static void validate() {
    // Skip validation if not loaded - we're in development mode
    if (!_isLoaded) {
      return;
    }

    final requiredVars = <String>[];

    final missing = requiredVars.where((String varName) =>
        dotenv.env[varName] == null || dotenv.env[varName]!.isEmpty);

    if (missing.isNotEmpty) {
      // Don't throw exception in development - use defaults
      if (flutterEnv == 'production') {
        throw Exception(
            'Missing required environment variables: ${missing.join(', ')}');
      }
    }
  }
}
