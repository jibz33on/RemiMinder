import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/user.dart';
import '../../../../core/services/preferences_service.dart';

class ContextSetupScreen extends StatefulWidget {
  const ContextSetupScreen({super.key});

  @override
  State<ContextSetupScreen> createState() => _ContextSetupScreenState();
}

class _ContextSetupScreenState extends State<ContextSetupScreen> {
  bool _isPatient = true;
  bool _isCaregiver = false;
  bool _isSaving = false;

  Future<void> _saveContext() async {
    if (!_isPatient && !_isCaregiver) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one option.')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final prefs = PreferencesService();
    final capabilities = <ActiveContext>{
      if (_isPatient) ActiveContext.patient,
      if (_isCaregiver) ActiveContext.caregiver,
    };

    await prefs.setContextCapabilities(capabilities);
    await prefs.setLastActiveContext(ActiveContext.patient);

    if (!mounted) return;
    context.go('/loading');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              Text(
                'Choose how you want to use the app',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                'Select all that apply. You can change this later.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              CheckboxListTile(
                value: _isPatient,
                onChanged: (value) {
                  setState(() {
                    _isPatient = value ?? false;
                  });
                },
                title: const Text('Patient context — I manage my own health'),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                value: _isCaregiver,
                onChanged: (value) {
                  setState(() {
                    _isCaregiver = value ?? false;
                  });
                },
                title: const Text('Caregiver context — I care for someone else'),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveContext,
                  child: Text(_isSaving ? 'Saving...' : 'Continue'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
