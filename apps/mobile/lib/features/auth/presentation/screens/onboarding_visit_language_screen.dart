import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/preferences_service.dart';
import '../../../../l10n/app_localizations.dart';

class OnboardingVisitLanguageScreen extends StatelessWidget {
  const OnboardingVisitLanguageScreen({super.key});

  static const _visitLanguageCodes = [
    'en',
    'es',
    'hi',
    'zh',
    'ar',
    'fr',
    'de',
  ];

  @override
  Widget build(BuildContext context) {
    final prefs = PreferencesService();
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final nextRoute =
        GoRouterState.of(context).uri.queryParameters['next'] ?? '/patient/home';
    final languageLabels = {
      'en': l10n?.languageEnglish ?? 'English',
      'es': l10n?.languageSpanish ?? 'Spanish',
      'hi': l10n?.languageHindi ?? 'Hindi',
      'zh': l10n?.languageMandarin ?? 'Mandarin',
      'ar': l10n?.languageArabic ?? 'Arabic',
      'fr': l10n?.languageFrench ?? 'French',
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
                  onPressed: () async {
                    await prefs.setDefaultVisitLanguage('en');
                    await prefs.setVisitLanguageOnboardingComplete(true);
                    if (!context.mounted) return;
                    context.go(nextRoute);
                  },
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
                l10n?.onboardingVisitLanguageTitle ??
                    'Choose your visit language',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n?.onboardingVisitLanguageSubtitle ??
                    'This will be used for recording visits and generating summaries',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: _visitLanguageCodes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final code = _visitLanguageCodes[index];
                    return SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () async {
                          await prefs.setDefaultVisitLanguage(code);
                          await prefs.setVisitLanguageOnboardingComplete(true);
                          if (!context.mounted) return;
                          context.go(nextRoute);
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
