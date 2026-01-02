import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app.dart';
import 'core/config/environment.dart';
import 'core/config/supabase_config.dart';

/// App entry point with Riverpod state management
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await Environment.load();
  Environment.validate(); // Ensure required vars are set

  // Initialize Supabase
  await SupabaseConfig.initialize();

  // Initialize Firebase
  await Firebase.initializeApp();

  runApp(
    const ProviderScope(
      child: RemiMinderApp(),
    ),
  );
}
