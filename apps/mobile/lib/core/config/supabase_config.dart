import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'environment.dart';

/// Supabase configuration and initialization
class SupabaseConfig {
  static supabase.SupabaseClient? get client {
    try {
      return supabase.Supabase.instance.client;
    } catch (e) {
      return null; // Return null if not initialized
    }
  }

  /// Initialize Supabase with environment variables
  static Future<void> initialize() async {
    final url = Environment.supabaseUrl;
    final anonKey = Environment.supabaseAnonKey;

    // For development, use placeholder values if not configured
    if (url.isEmpty || anonKey.isEmpty) {
      print('Supabase: Using development mode - Supabase not configured');
      print(
          'Supabase: Authentication features will not work without proper .env setup');
      return;
    }

    await supabase.Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
    print('Supabase initialized successfully');
  }

  /// Get current Supabase client instance
  static supabase.SupabaseClient get instance =>
      supabase.Supabase.instance.client;
}
