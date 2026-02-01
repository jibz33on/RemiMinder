import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/services/preferences_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'account_details_screen.dart';
import 'account_security_screen.dart';
import 'upgrade_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final bool? forceCaregiver;
  final String? headerTitle;

  const ProfileScreen({
    super.key,
    this.forceCaregiver,
    this.headerTitle,
  });

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  // Notification toggles
  bool _mobileNotifications = true;
  bool _emailNotifications = false;
  bool _isLoadingPreferences = true;
  String? _appLanguage;
  String? _country;
  String? _timezone;
  String? _defaultVisitLanguage;

  Map<String, String> _appLanguages(AppLocalizations? l10n) {
    return {
      'en': l10n?.languageEnglish ?? 'English',
      'es': l10n?.languageSpanish ?? 'Spanish',
      'hi': l10n?.languageHindi ?? 'Hindi',
      'ar': l10n?.languageArabic ?? 'Arabic',
      'de': l10n?.languageGerman ?? 'German',
    };
  }

  Map<String, String> _visitLanguages(AppLocalizations? l10n) {
    return {
      'en': l10n?.languageEnglish ?? 'English',
      'es': l10n?.languageSpanish ?? 'Spanish',
      'hi': l10n?.languageHindi ?? 'Hindi',
      'zh': l10n?.languageMandarin ?? 'Mandarin',
      'ar': l10n?.languageArabic ?? 'Arabic',
      'fr': l10n?.languageFrench ?? 'French',
      'de': l10n?.languageGerman ?? 'German',
    };
  }

  Map<String, String> _countries(AppLocalizations? l10n) {
    return {
      '': l10n?.profileNotSet ?? 'Not set',
      'US': l10n?.countryUnitedStates ?? 'United States',
      'CA': l10n?.countryCanada ?? 'Canada',
      'GB': l10n?.countryUnitedKingdom ?? 'United Kingdom',
      'DE': l10n?.countryGermany ?? 'Germany',
      'IN': l10n?.countryIndia ?? 'India',
    };
  }

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
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = PreferencesService();
    final appLanguage = await prefs.getAppLanguage();
    final country = await prefs.getCountry();
    final timezone = await prefs.getTimezone();
    final visitLanguage = await prefs.getDefaultVisitLanguage();
    if (!mounted) return;
    setState(() {
      _appLanguage = appLanguage;
      _country = country;
      _timezone = timezone;
      _defaultVisitLanguage = visitLanguage;
      _isLoadingPreferences = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider);
    final isCaregiver = widget.forceCaregiver ?? user?.isCaregiver ?? false;
    final headerTitle = widget.headerTitle ??
        (isCaregiver
            ? 'Caregiver Settings'
            : (AppLocalizations.of(context)?.profileSettings ??
                'Profile Settings'));

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF1A4D4D), // Dark teal-green
                    Color(0xFF051818), // Very dark green/black
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Text(
                headerTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Settings Section
    _buildSettingsSection(theme, isCaregiver, l10n),

                    const SizedBox(height: 32),

                    // Bottom Buttons
    _buildBottomButtons(theme, l10n),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(
      ThemeData theme, bool isCaregiver, AppLocalizations? l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Account Details
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AccountDetailsScreen(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.06),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n?.profileAccountDetailsTitle ??
                        'Account Details',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n?.profileAccountDetailsSubtitle ??
                        'View your profile information',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: theme.colorScheme.primary.withOpacity(0.6),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Account Security
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AccountSecurityScreen()),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.06),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n?.profileAccountSecurityTitle ??
                        'Account Security',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n?.profileAccountSecuritySubtitle ??
                        'Manage password and privacy',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: theme.colorScheme.primary.withOpacity(0.6),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        if (_isLoadingPreferences)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (isCaregiver)
          Column(
            children: [
              _buildPreferenceTile(
                theme: theme,
                title: l10n?.profileAppLanguageLabel ?? 'App language',
                value: _appLanguages(l10n)[_appLanguage] ??
                    (l10n?.languageEnglish ?? 'English'),
                icon: Icons.language,
                onTap: () => _showSelectionSheet(
                  title: l10n?.profileAppLanguageLabel ?? 'App language',
                  options: _appLanguages(l10n),
                  currentValue: _appLanguage ?? 'en',
                  onSelected: (value) async {
                    await PreferencesService().setAppLanguage(value);
                    ref
                        .read(localeProvider.notifier)
                        .setLocaleFromString(value);
                    setState(() {
                      _appLanguage = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 12),
              _buildPreferenceTile(
                theme: theme,
                title: l10n?.profilePreferredSummaryLanguageLabel ??
                    'Preferred summary language',
                value: _visitLanguages(l10n)[_defaultVisitLanguage] ??
                    (l10n?.languageEnglish ?? 'English'),
                icon: Icons.mic,
                onTap: () => _showSelectionSheet(
                  title: l10n?.profilePreferredSummaryLanguageLabel ??
                      'Preferred summary language',
                  options: _visitLanguages(l10n),
                  currentValue: _defaultVisitLanguage ?? 'en',
                  onSelected: (value) async {
                    await PreferencesService()
                        .setDefaultVisitLanguage(value);
                    setState(() {
                      _defaultVisitLanguage = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 12),
              _buildNotificationsSection(theme, l10n),
            ],
          )
        else
          Column(
            children: [
              _buildPreferenceTile(
                theme: theme,
                title: l10n?.profileAppLanguageLabel ?? 'App language',
                value: _appLanguages(l10n)[_appLanguage] ??
                    (l10n?.languageEnglish ?? 'English'),
                icon: Icons.language,
                onTap: () => _showSelectionSheet(
                  title: l10n?.profileAppLanguageLabel ?? 'App language',
                  options: _appLanguages(l10n),
                  currentValue: _appLanguage ?? 'en',
                  onSelected: (value) async {
                    await PreferencesService().setAppLanguage(value);
                    ref
                        .read(localeProvider.notifier)
                        .setLocaleFromString(value);
                    setState(() {
                      _appLanguage = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 12),
              _buildPreferenceTile(
                theme: theme,
                title: l10n?.profileDefaultVisitLanguageLabel ??
                    'Default visit language',
                value: _visitLanguages(l10n)[_defaultVisitLanguage] ??
                    (l10n?.languageEnglish ?? 'English'),
                icon: Icons.mic,
                onTap: () => _showSelectionSheet(
                  title: l10n?.profileDefaultVisitLanguageLabel ??
                      'Default visit language',
                  options: _visitLanguages(l10n),
                  currentValue: _defaultVisitLanguage ?? 'en',
                  onSelected: (value) async {
                    await PreferencesService()
                        .setDefaultVisitLanguage(value);
                    setState(() {
                      _defaultVisitLanguage = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 12),
              _buildPreferenceTile(
                theme: theme,
                title: l10n?.profileTimezoneLabel ?? 'Timezone',
                value: _timezone ?? (l10n?.profileNotSet ?? 'Not set'),
                icon: Icons.public,
                onTap: () => _showTimezoneSheet(theme, l10n),
              ),
              const SizedBox(height: 12),
              _buildPreferenceTile(
                theme: theme,
                title: l10n?.profileCountryOptionalLabel ??
                    'Country (optional)',
                value: _countries(l10n)[_country ?? ''] ??
                    (l10n?.profileNotSet ?? 'Not set'),
                icon: Icons.flag,
                onTap: () => _showSelectionSheet(
                  title: l10n?.profileCountryOrRegionLabel ??
                      'Country or region',
                  options: _countries(l10n),
                  currentValue: _country ?? '',
                  onSelected: (value) async {
                    await PreferencesService().setCountry(value);
                    setState(() {
                      _country = value.isEmpty ? null : value;
                    });
                  },
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildNotificationsSection(ThemeData theme, AppLocalizations? l10n) {
    return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.06),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.notifications,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                l10n?.profileNotificationsTitle ?? 'Notifications',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                  l10n?.profileNotificationsMobile ?? 'Mobile',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  Switch(
                    value: _mobileNotifications,
                    onChanged: (value) {
                      setState(() {
                        _mobileNotifications = value;
                      });
                    },
                    activeThumbColor: theme.colorScheme.primary,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                  l10n?.profileNotificationsEmail ?? 'Email',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  Switch(
                    value: _emailNotifications,
                    onChanged: (value) {
                      setState(() {
                        _emailNotifications = value;
                      });
                    },
                    activeThumbColor: theme.colorScheme.primary,
                  ),
                ],
              ),
            ],
          ),
    );
  }

  Widget _buildPreferenceTile({
    required ThemeData theme,
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.06),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                icon,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                    title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: theme.colorScheme.primary.withOpacity(0.6),
                ),
              ],
            ),
      ),
    );
  }

  void _showSelectionSheet({
    required String title,
    required Map<String, String> options,
    required String currentValue,
    required Future<void> Function(String) onSelected,
  }) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: options.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final entry = options.entries.elementAt(index);
                    final isSelected = entry.key == currentValue;
                    return InkWell(
                      onTap: () async {
                        await onSelected(entry.key);
                        if (!mounted) return;
                        Navigator.of(context).pop();
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface.withOpacity(0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                entry.value,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight:
                                      isSelected ? FontWeight.w600 : null,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check,
                                color: theme.colorScheme.primary,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTimezoneSheet(ThemeData theme, AppLocalizations? l10n) {
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    l10n?.profileTimezoneLabel ?? 'Timezone',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _timezones.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final timezone = _timezones[index];
                    final isSelected = timezone == _timezone;
                    return InkWell(
                      onTap: () async {
                        await PreferencesService().setTimezone(timezone);
                        if (!mounted) return;
                        setState(() {
                          _timezone = timezone;
                        });
                        Navigator.of(context).pop();
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface.withOpacity(0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                timezone,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight:
                                      isSelected ? FontWeight.w600 : null,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check,
                                color: theme.colorScheme.primary,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
          ),
        ),
      ],
          ),
        );
      },
    );
  }

  Widget _buildBottomButtons(ThemeData theme, AppLocalizations? l10n) {
    return Row(
      children: [
        // Upgrade Button
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UpgradeScreen()),
              );
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: theme.colorScheme.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              l10n?.profileUpgrade ?? 'Upgrade',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Sign Out Button
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              print('👆 ProfileScreen: Sign Out button tapped');
              try {
                print(
                    '👆 ProfileScreen: Calling authNotifierProvider.notifier.signOut()');
                await ref.read(authNotifierProvider.notifier).signOut();
                print('👆 ProfileScreen: signOut() completed successfully');
              } catch (e) {
                print('👆 ProfileScreen: signOut() failed: $e');
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(l10n?.profileSignOutFailed(e.toString()) ??
                            'Sign out failed: $e')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              l10n?.profileSignOut ?? 'Sign Out',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
