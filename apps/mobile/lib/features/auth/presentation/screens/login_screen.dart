import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../../data/models/auth_state.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String? _userRole;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get role from navigation parameters
    final uri = Uri.parse(GoRouterState.of(context).uri.toString());
    _userRole = uri.queryParameters['role'];
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    print('🔐 Login: _signIn method called');

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    print('🔐 Login: Email: "$email", Password length: ${password.length}');

    if (email.isEmpty || password.isEmpty) {
      print('🔐 Login: Email or password is empty - showing validation error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    print('🔐 Login: Validation passed, calling auth provider...');

    try {
      print('🔐 Login: Starting sign in process...');
      await ref.read(authNotifierProvider.notifier).signIn(email, password);
      print('🔐 Login: Auth provider call completed');

      // Check auth state after login attempt
      final authState = ref.read(authNotifierProvider);
      print('🔐 Login: Auth state - isAuthenticated: ${authState.isAuthenticated}');

      if (authState.isAuthenticated) {
        final user = authState.user;
        print('🔐 Login: User data - email: ${user?.email}, role: ${user?.role}, isPatient: ${user?.isPatient}, isCaregiver: ${user?.isCaregiver}');

        if (user?.isPatient ?? false) {
          print('🔐 Login: Navigating to patient home...');
          if (mounted) {
            context.go('/patient/home');
            print('🔐 Login: Navigation to /patient/home completed');
          } else {
            print('🔐 Login: Widget not mounted, cannot navigate');
          }
        } else if (user?.isCaregiver ?? false) {
          print('🔐 Login: Navigating to caregiver home...');
          if (mounted) {
            context.go('/caregiver/home');
            print('🔐 Login: Navigation to /caregiver/home completed');
          } else {
            print('🔐 Login: Widget not mounted, cannot navigate');
          }
        } else {
          print('🔐 Login: User role not recognized or null - staying on login screen');
        }
      } else {
        print('🔐 Login: Authentication failed or auth state not set');
      }
    } catch (e) {
      print('🔐 Login: Exception caught: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  void _navigateToEmailForm() {
    // For now, show a simple dialog with email form
    // In a real app, you might want to scroll to a form section
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign in with Email'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              obscureText: !_isPasswordVisible,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _signIn();
            },
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () => context.go('/role-selection'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // Logo Section - No circular container, bigger logo
              Image.asset(
                'assets/images/RemiMinder_logo.png',
                width: 140, // Made bigger without container
                height: 140,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.medical_services,
                  color: Color(0xff1B4E59),
                  size: 80, // Larger fallback icon
                ),
              ),

              const SizedBox(height: 24),

              // Brand Name
              Text(
                'RemiMinder.ai',
                style: const TextStyle(
                  fontFamily: 'Merriweather', // Merriweather-Bold font
                  fontWeight: FontWeight.w700, // Bold weight
                  fontSize: 28, // Increased size for more prominence
                  color: Color(0xFF1B4E59), // Dark teal
                  letterSpacing: -0.5, // Better spacing for serif font
                ),
              ),

              const SizedBox(height: 8),

              // Tagline
              Text(
                'Smart AI for Health & Care Coordination',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Poppins', // Poppins-Regular
                  fontWeight: FontWeight.w400, // Regular
                  fontSize: 13, // 13-14sp
                  color: Color(0xFF5A5A5A), // Gray
                ),
              ),

              const SizedBox(height: 48),

              // Heading - "Login"
              Text(
                'Login',
                style: const TextStyle(
                  fontFamily:
                      'Merriweather', // Merriweather-Bold for consistency
                  fontWeight: FontWeight.w700, // Bold weight
                  fontSize: 28, // Reduced size for better hierarchy
                  color: Color(0xFF1A4D4D), // Dark teal
                ),
              ),

              const SizedBox(height: 48),

              // Google Button
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white, // White background
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.3), // Gray border
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _signInWithGoogle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation:
                        0, // Remove default elevation since we have shadow
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Google logo (currently JPEG - replace with SVG for better quality)
                      Image.asset(
                        'assets/images/google_logo.svg', // Currently a JPEG file
                        width: 22,
                        height: 22,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.g_mobiledata,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Continue with Google',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Apple Button
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black, // Black background
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _signInWithApple,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    elevation:
                        0, // Remove default elevation since we have shadow
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Apple logo placeholder (add SVG file for real logo)
                      Container(
                        width: 20,
                        height: 24,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.apple,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Continue with Apple',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Email Button
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1B4E59), // Teal background
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _navigateToEmailForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B4E59),
                    foregroundColor: Colors.white,
                    elevation:
                        0, // Remove default elevation since we have shadow
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.email,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Continue with Email',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Create Account Link
              Center(
                child: TextButton(
                  onPressed: () => context.go('/register'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Create an Account',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xFF1B4E59), // Teal
                      decoration: TextDecoration.underline, // Underlined
                      decorationColor: Color(0xFF1B4E59),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Forgot Password Link
              Center(
                child: TextButton(
                  onPressed: () => context.go('/forgot-password'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xFF1B4E59), // Teal
                      decoration: TextDecoration.underline, // Underlined
                      decorationColor: Color(0xFF1B4E59),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    try {
      await ref.read(authNotifierProvider.notifier).signInWithGoogle();

      // Check auth state after login attempt
      final authState = ref.read(authNotifierProvider);

      if (authState.status == AuthStatus.authenticated) {
        // Navigate to appropriate home screen based on role
        final user = authState.user;
        if (user?.isPatient ?? false) {
          context.go('/patient/home');
        } else if (user?.isCaregiver ?? false) {
          context.go('/caregiver/home');
        } else {
          context.go('/welcome'); // Fallback
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign In failed: ${e.toString()}')),
      );
    }
  }

  void _signInWithApple() {
    // TODO: Implement Apple Sign In with Supabase
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Apple Sign In - Coming Soon!')),
    );
  }
}
