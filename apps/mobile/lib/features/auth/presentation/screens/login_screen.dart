import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Title
              Text(
                'Welcome Back',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              Text(
                _userRole == 'caregiver'
                    ? 'Sign in to manage your patients'
                    : 'Sign in to continue to RemiMinder',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 18,
                    ),
              ),

              const SizedBox(height: 48),

              // Social Login Buttons
              _SocialLoginButton(
                icon: Icons.g_mobiledata, // Google icon placeholder
                label: 'Continue with Google',
                onPressed: _signInWithGoogle,
              ),

              const SizedBox(height: 16),

              _SocialLoginButton(
                icon: Icons.apple,
                label: 'Continue with Apple',
                onPressed: _signInWithApple,
              ),

              const SizedBox(height: 32),

              // Divider
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.3),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'or',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.3),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Email Field
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Password Field
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Remember Me & Forgot Password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                        activeColor: Theme.of(context).colorScheme.primary,
                      ),
                      Text(
                        'Remember me',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => context.go('/forgot-password'),
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Sign In Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _signInWithEmail,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Sign Up Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go('/register'),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Bottom indicator dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _IndicatorDot(isActive: false),
                  const SizedBox(width: 8),
                  _IndicatorDot(isActive: false),
                  const SizedBox(width: 8),
                  _IndicatorDot(isActive: true),
                  const SizedBox(width: 8),
                  _IndicatorDot(isActive: false),
                ],
              ),

              const SizedBox(height: 16),
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

  void _signInWithEmail() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // TODO: Implement email sign in
    // For now, simulate successful login and navigate to home
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login Successful!')),
    );

    // Navigate to appropriate home screen based on role
    if (_userRole == 'patient') {
      context.go('/patient/home');
    } else if (_userRole == 'caregiver') {
      context.go('/caregiver/home');
    } else {
      // Default to patient home if no role specified
      context.go('/patient/home');
    }
  }
}

class _SocialLoginButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _SocialLoginButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IndicatorDot extends StatelessWidget {
  final bool isActive;

  const _IndicatorDot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.primary.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
    );
  }
}
