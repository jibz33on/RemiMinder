import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();

    // Simulate loading, then navigate to welcome
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        context.go('/welcome');
      }
      // Navigator.pushReplacementNamed(context, '/welcome');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F4E8), // Warm off-white background

      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo
            Image.asset(
              'assets/images/remiminder_logo.png',
              width: 160,
              height: 160,
            ),

            const SizedBox(height: 20),

            // App Name
            const Text(
              "RemiMinder.ai",
              style: TextStyle(
                fontSize: 36, // Increased from 28 to match logo prominence
                fontWeight: FontWeight.bold,
                color: Color(0xff1B4E59),
                letterSpacing: 0.5,
              ),
            ),

            const SizedBox(height: 6),

            // Tagline
            const Text(
              "Smart AI for Health & Care Coordination",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xff557A7F),
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

    Future.delayed(Duration(milliseconds: widget.delay), () {
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
    _controller.dispose();
    super.dispose();
  }
}
