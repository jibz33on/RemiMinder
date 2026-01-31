import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/locale_provider.dart';
import '../../../../core/services/preferences_service.dart';
import '../../../../l10n/app_localizations.dart';

class OnboardingAppLanguageScreen extends ConsumerWidget {
  const OnboardingAppLanguageScreen({super.key});

  static const _languageCodes = ['en', 'es', 'hi', 'ar', 'de'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = PreferencesService();
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final languageLabels = {
      'en': l10n?.languageEnglish ?? 'English',
      'es': l10n?.languageSpanish ?? 'Spanish',
      'hi': l10n?.languageHindi ?? 'Hindi',
      'ar': l10n?.languageArabic ?? 'Arabic',
      'de': l10n?.languageGerman ?? 'German',
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
                  onPressed: () => context.go('/onboarding/country'),
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
                l10n?.onboardingAppLanguageTitle ??
                    'Choose your app language',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n?.onboardingAppLanguageSubtitle ??
                    'This updates the UI language.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: _languageCodes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final code = _languageCodes[index];
                    return SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () async {
                          await prefs.setAppLanguage(code);
                          ref
                              .read(localeProvider.notifier)
                              .setLocaleFromString(code);
                          if (!context.mounted) return;
                          context.go('/onboarding/country');
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          languageLabels[code] ?? code,
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
