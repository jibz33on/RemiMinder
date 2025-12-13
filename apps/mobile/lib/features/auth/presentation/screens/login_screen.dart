import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
    super.dispose();
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
                  onPressed: () {}, // Will scroll to email form
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

  void _signInWithGoogle() {
    // TODO: Implement Google Sign In
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google Sign In - Coming Soon!')),
    );
  }

  void _signInWithApple() {
    // TODO: Implement Apple Sign In
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Apple Sign In - Coming Soon!')),
    );
  }
}
