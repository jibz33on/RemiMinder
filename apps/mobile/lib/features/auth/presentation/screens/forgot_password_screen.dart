import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
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
          onPressed: () => context.go('/login'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: _emailSent ? _buildSuccessView() : _buildResetView(),
        ),
      ),
    );
  }

  Widget _buildResetView() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // Title
          Text(
            'Forgot Password?',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 12),

          // Subtitle
          Text(
            'No worries! Enter your email and we\'ll send you reset instructions.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 18,
                  height: 1.4,
                ),
          ),

          const SizedBox(height: 48),

          // Email Field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            enabled: !_isLoading,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email address',
              prefixIcon: Icon(
                Icons.email_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),

          const SizedBox(height: 32),

          // Send Reset Instructions Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _sendResetInstructions,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Send Reset Instructions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 24),

          // Back to Login Link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Remember your password? ',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              TextButton(
                onPressed: () => context.go('/login'),
                child: Text(
                  'Back to Login',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const Spacer(),

          // Bottom indicator dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _IndicatorDot(isActive: false),
              const SizedBox(width: 8),
              _IndicatorDot(isActive: false),
              const SizedBox(width: 8),
              _IndicatorDot(isActive: false),
              const SizedBox(width: 8),
              _IndicatorDot(isActive: false),
              const SizedBox(width: 8),
              _IndicatorDot(isActive: true),
            ],
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Success Icon
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle_outline,
            color: Theme.of(context).colorScheme.primary,
            size: 64,
          ),
        ),

        const SizedBox(height: 32),

        // Success Title
        Text(
          'Check Your Email',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 16),

        // Success Message
        Text(
          'We\'ve sent password reset instructions to ${_emailController.text}',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 16,
                height: 1.4,
              ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        Text(
          'Please check your email and follow the instructions to reset your password.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                height: 1.4,
              ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 48),

        // Back to Login Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => context.go('/login'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Back to Login',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Resend Email Button
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: _resendResetEmail,
            child: Text(
              'Didn\'t receive the email? Resend',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _sendResetInstructions() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
        _emailSent = true;
      });

      // TODO: Implement actual password reset API call
      // For now, just show success state
    }
  }

  void _resendResetEmail() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reset email sent again!')),
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
