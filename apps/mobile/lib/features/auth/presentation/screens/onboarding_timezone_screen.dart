import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/preferences_service.dart';
import '../../../../l10n/app_localizations.dart';

class OnboardingTimezoneScreen extends StatefulWidget {
  const OnboardingTimezoneScreen({super.key});

  @override
  State<OnboardingTimezoneScreen> createState() => _OnboardingTimezoneScreenState();
}

class _OnboardingTimezoneScreenState extends State<OnboardingTimezoneScreen> {
  late String _selectedTimezone;

  static const _timezones = [
    'UTC',
    'America/New_York',
    'America/Chicago',
    'America/Denver',
    'America/Los_Angeles',
    'Europe/London',
    'Europe/Berlin',
    'Asia/Kolkata',
    'Asia/Dubai',
    'Asia/Tokyo',
  ];

  @override
  void initState() {
    super.initState();
    _selectedTimezone = DateTime.now().timeZoneName;
    if (!_timezones.contains(_selectedTimezone)) {
      _selectedTimezone = _timezones.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final prefs = PreferencesService();
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: TextButton(
                  onPressed: () => context.go('/role-selection'),
                  child: Text(
                    l10n?.commonSkip ?? 'Skip',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n?.onboardingTimezoneTitle ?? 'Confirm your timezone',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n?.onboardingTimezoneDetected(_selectedTimezone) ??
                    'We detected: $_selectedTimezone',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                value: _selectedTimezone,
                items: _timezones
                    .map((timezone) => DropdownMenuItem<String>(
                          value: timezone,
                          child: Text(timezone),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _selectedTimezone = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: l10n?.onboardingTimezoneLabel ?? 'Timezone',
                  border: const OutlineInputBorder(),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await prefs.setTimezone(_selectedTimezone);
                    if (!context.mounted) return;
                    context.go('/role-selection');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    l10n?.onboardingTimezoneConfirm ?? 'Confirm',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
