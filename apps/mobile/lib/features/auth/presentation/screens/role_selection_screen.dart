import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? _selectedRole;

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
          onPressed: () => context.go('/welcome'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Choose Your Role',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight
                          .w700, // Explicit bold weight for Merriweather
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                'Select how you\'ll be using RemiMinder',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 18,
                    ),
              ),
              const SizedBox(height: 48),
              Expanded(
                child: Column(
                  children: [
                    _RoleCard(
                      title: 'Patient',
                      description:
                          'Manage your own medications, appointments, and health records',
                      icon: Icons.person,
                      isSelected: _selectedRole == 'patient',
                      onTap: () => setState(() => _selectedRole = 'patient'),
                    ),
                    const SizedBox(height: 24),
                    _RoleCard(
                      title: 'Caregiver',
                      description:
                          'Help manage medications and care for family members or patients',
                      icon: Icons.favorite,
                      isSelected: _selectedRole == 'caregiver',
                      onTap: () => setState(() => _selectedRole = 'caregiver'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedRole != null ? _onContinue : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: _selectedRole != null
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).disabledColor,
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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

  void _onContinue() {
    if (_selectedRole == 'patient') {
      context.go('/login?role=patient'); // Navigate to login for patients
    } else if (_selectedRole == 'caregiver') {
      context.go('/login?role=caregiver'); // Navigate to login for caregivers
    }
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.primary.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.secondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
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
