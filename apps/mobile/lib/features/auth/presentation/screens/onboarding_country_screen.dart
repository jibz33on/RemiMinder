import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/preferences_service.dart';
import '../../../../l10n/app_localizations.dart';

class OnboardingCountryScreen extends StatelessWidget {
  const OnboardingCountryScreen({super.key});

  static const _countryCodes = ['US', 'CA', 'GB', 'DE', 'IN'];

  @override
  Widget build(BuildContext context) {
    final prefs = PreferencesService();
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final countryLabels = {
      'US': l10n?.countryUnitedStates ?? 'United States',
      'CA': l10n?.countryCanada ?? 'Canada',
      'GB': l10n?.countryUnitedKingdom ?? 'United Kingdom',
      'DE': l10n?.countryGermany ?? 'Germany',
      'IN': l10n?.countryIndia ?? 'India',
    };

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
                  onPressed: () => context.go('/onboarding/timezone'),
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
                l10n?.onboardingCountryTitle ??
                    'Select your country or region',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n?.onboardingCountrySubtitle ??
                    'Optional, helps tailor the experience.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: _countryCodes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final code = _countryCodes[index];
                    return SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () async {
                          await prefs.setCountry(code);
                          if (!context.mounted) return;
                          context.go('/onboarding/timezone');
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          countryLabels[code] ?? code,
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
