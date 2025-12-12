import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

/// App entry point with Riverpod state management
void main() {
  runApp(
    const ProviderScope(
      child: RemiMinderApp(),
    ),
  );
}
