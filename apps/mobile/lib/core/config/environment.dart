import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration for MediMinder Flutter app
class Environment {
  // Track if environment has been loaded
  static bool _isLoaded = false;

  // Supabase Configuration
  static String get supabaseUrl =>
      _isLoaded ? (dotenv.env['SUPABASE_URL'] ?? '') : '';
  static String get supabaseAnonKey =>
      _isLoaded ? (dotenv.env['SUPABASE_ANON_KEY'] ?? '') : '';

  // Auth Provider Configuration (Phase 4.2)
  static String get authProvider =>
      _isLoaded ? (dotenv.env['AUTH_PROVIDER'] ?? 'supabase') : 'supabase';

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
      print('Environment: .env loaded from mobile folder');
      _isLoaded = true;
      return;
    } catch (e) {
      print("Environment: Failed to load mobile .env: $e");
    }

    // Fallback to root .env ONLY if mobile .env missing
    try {
      await dotenv.load(
          fileName: '/Users/jibinkunjumon/developments/MediMinder/.env');
      print('Environment: .env loaded from project root');
      _isLoaded = true;
    } catch (e) {
      print('Environment: No .env found. Running with defaults.');
      _isLoaded = false;
    }
  }

  /// Validate that required environment variables are set
  static void validate() {
    // Skip validation if not loaded - we're in development mode
    if (!_isLoaded) {
      print('Environment: Running in development mode with default values');
      return;
    }

    final requiredVars = ['SUPABASE_URL', 'SUPABASE_ANON_KEY'];

    final missing = requiredVars.where((String varName) =>
        dotenv.env[varName] == null || dotenv.env[varName]!.isEmpty);

    if (missing.isNotEmpty) {
      print(
          'Environment: Missing required environment variables: ${missing.join(', ')}');
      print('Environment: Using default values for missing variables');
      // Don't throw exception in development - use defaults
      if (flutterEnv == 'production') {
        throw Exception(
            'Missing required environment variables: ${missing.join(', ')}');
      }
    }
  }
}
