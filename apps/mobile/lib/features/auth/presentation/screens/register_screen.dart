import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/user.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  /// Convert technical errors to user-friendly messages
  String _getUserFriendlyErrorMessage(
      dynamic error, AppLocalizations? l10n) {
    final errorString = error.toString().toLowerCase();

    // Authentication errors
    if (errorString.contains('user already registered') ||
        errorString.contains('account with this email already exists')) {
      return l10n?.registerAccountExists ??
          'An account with this email already exists. Please sign in instead.';
    }

    if (errorString.contains('weak password') ||
        errorString.contains('password')) {
      return l10n?.registerWeakPassword ??
          'Password is too weak. Please use at least 8 characters with letters and numbers.';
    }

    if (errorString.contains('invalid email')) {
      return l10n?.registerEmailInvalid ?? 'Please enter a valid email address.';
    }

    // Network/API errors
    if (errorString.contains('connection refused') ||
        errorString.contains('network')) {
      return l10n?.registerConnectionError ??
          'Connection error. Please check your internet connection and try again.';
    }

    if (errorString.contains('timeout')) {
      return l10n?.registerRequestTimedOut ??
          'Request timed out. Please try again.';
    }

    // Generic fallback
    return l10n?.registerFailedGeneric ??
        'Registration failed. Please try again or contact support if the problem persists.';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
          onPressed: () => context.go('/login'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Title
                Text(
                  l10n?.registerTitle ?? 'Create Account',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                ),

                const SizedBox(height: 12),

                // Subtitle
                Text(
                  l10n?.registerSubtitle ?? 'Join RemiMinder to get started',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 18,
                      ),
                ),

                const SizedBox(height: 48),

                // Name Fields (Row)
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstNameController,
                        decoration: InputDecoration(
                          labelText:
                              l10n?.registerFirstNameLabel ?? 'First Name',
                          hintText: l10n?.registerFirstNameHint ?? 'John',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n?.registerFirstNameRequired ??
                                'Please enter your first name';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          labelText: l10n?.registerLastNameLabel ?? 'Last Name',
                          hintText: l10n?.registerLastNameHint ?? 'Doe',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n?.registerLastNameRequired ??
                                'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: l10n?.registerEmailLabel ?? 'Email',
                    hintText:
                        l10n?.registerEmailHint ?? 'john.doe@example.com',
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n?.registerEmailRequired ??
                          'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return l10n?.registerEmailInvalid ??
                          'Please enter a valid email';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: l10n?.registerPasswordLabel ?? 'Password',
                    hintText:
                        l10n?.registerPasswordHint ?? 'Create a strong password',
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n?.registerPasswordRequired ??
                          'Please enter a password';
                    }
                    if (value.length < 8) {
                      return l10n?.registerPasswordTooShort ??
                          'Password must be at least 8 characters';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Confirm Password Field
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText:
                        l10n?.registerConfirmPasswordLabel ?? 'Confirm Password',
                    hintText: l10n?.registerConfirmPasswordHint ??
                        'Re-enter your password',
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n?.registerConfirmPasswordRequired ??
                          'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return l10n?.registerPasswordMismatch ??
                          'Passwords do not match';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Terms and Conditions
                Row(
                  children: [
                    Checkbox(
                      value: _acceptTerms,
                      onChanged: (value) {
                        setState(() {
                          _acceptTerms = value ?? false;
                        });
                      },
                      activeColor: Theme.of(context).colorScheme.primary,
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                                text: l10n?.registerTermsIntro ??
                                    'By creating an account, you agree to our '),
                            TextSpan(
                              text: l10n?.registerTermsOfService ??
                                  'Terms of Service',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = _showTermsOfService,
                            ),
                            TextSpan(
                                text: l10n?.registerAnd ?? ' and '),
                            TextSpan(
                              text: l10n?.registerPrivacyPolicy ??
                                  'Privacy Policy',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = _showPrivacyPolicy,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _acceptTerms ? _registerWithEmail : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: _acceptTerms
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).disabledColor,
                    ),
                    child: Text(
                      l10n?.registerCreateAccountButton ?? 'Create Account',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Sign In Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n?.registerAlreadyHaveAccount ??
                          'Already have an account? ',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: Text(
                        l10n?.registerSignIn ?? 'Sign In',
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _IndicatorDot(isActive: false),
                    SizedBox(width: 8),
                    _IndicatorDot(isActive: false),
                    SizedBox(width: 8),
                    _IndicatorDot(isActive: false),
                    SizedBox(width: 8),
                    _IndicatorDot(isActive: true),
                  ],
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void _showTermsOfService() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n?.registerTermsTitle ?? 'Terms of Service'),
          content: SingleChildScrollView(
            child: Text(
              l10n?.registerTermsBody ??
                  'Terms of Service for RemiMinder\n\n'
                      '1. Acceptance of Terms\n'
                      'By using RemiMinder, you agree to these terms.\n\n'
                      '2. Use of Service\n'
                      'RemiMinder is designed to help manage healthcare and medication reminders.\n\n'
                      '3. Privacy\n'
                      'Your privacy is important to us. All health data is handled securely.\n\n'
                      '4. Account Responsibility\n'
                      'You are responsible for maintaining the confidentiality of your account.\n\n'
                      '5. Limitation of Liability\n'
                      'RemiMinder is not a substitute for professional medical advice.\n\n'
                      'For the complete Terms of Service, please visit our website.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n?.commonClose ?? 'Close'),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyPolicy() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n?.registerPrivacyTitle ?? 'Privacy Policy'),
          content: SingleChildScrollView(
            child: Text(
              l10n?.registerPrivacyBody ??
                  'Privacy Policy for RemiMinder\n\n'
                      '1. Information We Collect\n'
                      'We collect information you provide and usage data to improve our service.\n\n'
                      '2. How We Use Information\n'
                      'Information is used to provide healthcare management services and improve user experience.\n\n'
                      '3. Information Sharing\n'
                      'We do not sell your personal information. Data is only shared with healthcare providers you authorize.\n\n'
                      '4. Data Security\n'
                      'We implement industry-standard security measures to protect your health data.\n\n'
                      '5. Your Rights\n'
                      'You have the right to access, correct, or delete your personal information.\n\n'
                      'For the complete Privacy Policy, please visit our website.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n?.commonClose ?? 'Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _registerWithEmail() async {
    final l10n = AppLocalizations.of(context);
    if (_formKey.currentState?.validate() ?? false) {
      if (!_acceptTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(l10n?.registerAcceptTermsError ??
                  'Please accept the Terms and Conditions')),
        );
        return;
      }

      final email = _emailController.text.trim();
      final password = _passwordController.text;
      final firstName = _firstNameController.text.trim();
      final lastName = _lastNameController.text.trim();
      final fullName = '$firstName $lastName'.trim();

      // Role is chosen after login; default to patient for signup.
      final selectedRole = ref.read(selectedRoleProvider) ?? UserRole.patient;

      try {
        await ref.read(authNotifierProvider.notifier).signUp(
              email: email,
              password: password,
              role: selectedRole,
              fullName: fullName,
            );

        final authState = ref.read(authNotifierProvider);
        if (authState.hasError) {
          final errorMessage = _getUserFriendlyErrorMessage(
              authState.errorMessage ?? 'Registration failed', l10n);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(errorMessage)),
            );
          }
          return;
        }

        if (authState.isAuthenticated && authState.user != null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(l10n?.registerAccountCreatedTitle ??
                      'Account created')),
            );
          }
          await _navigateAfterRegister();
          return;
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(l10n?.registerFailedGeneric ??
                    'Registration failed. Please try again.')),
          );
        }
      } catch (e) {
        if (mounted) {
          final errorMessage = _getUserFriendlyErrorMessage(e, l10n);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      }
    }
  }

  Future<void> _navigateAfterRegister() async {
    if (!mounted) return;
    context.go('/login');
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
