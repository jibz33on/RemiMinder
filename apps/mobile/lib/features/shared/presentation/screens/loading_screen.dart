import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/data/models/auth_state.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/services/preferences_service.dart';

class LoadingScreen extends ConsumerStatefulWidget {
  const LoadingScreen({super.key});

  @override
  ConsumerState<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends ConsumerState<LoadingScreen> {
  bool _hasLoadedLocale = false;

  @override
  void initState() {
    super.initState();
    print('🔄 LoadingScreen: Initializing app...');

    Future.microtask(_ensureLocaleLoaded);

    // Explicitly trigger auth initialization
    Future.microtask(() {
      if (!mounted) return;
      ref.read(authNotifierProvider.notifier).initialize();
    });
  }

  Future<void> _ensureLocaleLoaded() async {
    if (_hasLoadedLocale) return;
    _hasLoadedLocale = true;
    try {
      final prefs = PreferencesService();
      final appLanguage = await prefs.getAppLanguage();
      if (!mounted) return;
      final languageCode =
          appLanguage?.isNotEmpty == true ? appLanguage! : 'en';
      ref.read(localeProvider.notifier).setLocaleFromString(languageCode);
    } catch (e) {
      print('🔄 LoadingScreen: Failed to load local language: $e');
      if (!mounted) return;
      ref.read(localeProvider.notifier).setLocaleFromString('en');
    }
  }

  Future<void> _handleAuthState(AuthState authState) async {
    print(
        '🔄 LoadingScreen: _handleAuthState called - Status: ${authState.status}');
    print(
        '🔄 LoadingScreen: Auth state - User: ${authState.user?.email ?? 'null'}, Role: ${authState.user?.role ?? 'null'}');

    await _ensureLocaleLoaded();

    if (!mounted) {
      print('🔄 LoadingScreen: Widget not mounted, cannot navigate');
      return;
    }

    if (!authState.isAuthenticated) {
      context.go('/welcome');
      return;
    }

    final firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;
    final isEmailVerified = firebaseUser?.emailVerified ?? true;
    final isPasswordProvider = firebaseUser?.providerData
            .any((provider) => provider.providerId == 'password') ??
        false;
    if (isPasswordProvider && !isEmailVerified) {
      context.go('/verify-email');
      return;
    }

    // Authenticated users proceed to role selection before entering homes.
    context.go('/role-selection');
  }

  @override
  Widget build(BuildContext context) {
    // Listen to auth state changes
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      _handleAuthState(next);
    });

    return Scaffold(
      backgroundColor: Theme.of(context)
          .scaffoldBackgroundColor, // Consistent with all other screens

      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo - Simple display
            Image.asset(
              'assets/images/RemiMinder_logo.png',
              width: 160,
              height: 160,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 20),

            // App Name - PM specs: Serif (Merriweather), Bold, primaryGreen
            const Text(
              "RemiMinder.ai",
              style: TextStyle(
                fontFamily: 'Merriweather', // Serif typeface as requested
                fontSize: 36,
                fontWeight: FontWeight.w700, // Bold weight
                color: Color(0xff1B4E59), // primaryGreen (primaryColor)
                letterSpacing: 0.5,
              ),
            ),

            const SizedBox(height: 6),

            // Tagline - PM specs: Sans-serif (Poppins), small size, textSecondary
            const Text(
              "Smart AI for Health & Care Coordination",
              style: TextStyle(
                fontFamily: 'Poppins', // Sans-serif as requested
                fontSize: 12, // Small size (~12-14sp) as requested
                color: Color(0xff557A7F), // textSecondary (accentColor)
              ),
            ),

            const SizedBox(height: 28),

            // Loading dots animation
            const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _LoadingDot(delay: 0),
                _LoadingDot(delay: 300),
                _LoadingDot(delay: 600),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingDot extends StatefulWidget {
  final int delay;
  const _LoadingDot({required this.delay});

  @override
  State<_LoadingDot> createState() => _LoadingDotState();
}

class _LoadingDotState extends State<_LoadingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Timer? _animationTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _animation = Tween<double>(begin: 0.3, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _animationTimer = Timer(Duration(milliseconds: widget.delay), () {
      if (!mounted) return;
      _controller.repeat(reverse: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: 10,
        height: 10,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: const BoxDecoration(
          color: Color(0xff3AA8A1),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }
}
