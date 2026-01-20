import 'package:flutter/material.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  // Data Sharing toggles
  bool _allowCaregiverSummaries = true;
  bool _allowCaregiverMedications = false;
  bool _allowCaregiverReminders = true;
  bool _allowAiImprovement = true;

  // Communication & Consent toggles
  bool _allowEmailNotifications = true;
  bool _allowSmsNotifications = false;
  bool _allowPushNotifications = true;

  void _showSettingUpdatedSnackBar(String setting) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$setting updated'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showComingSoonSnackBar(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature coming soon'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(
    BuildContext context,
    String title,
    String content,
    String action,
    Color actionColor,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: actionColor,
            ),
            child: Text(action),
          ),
        ],
      ),
    );

    if (result == true) {
      _showComingSoonSnackBar(action.toLowerCase());
    }
  }

  void _showTermsOfService() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Terms of Service'),
          content: const SingleChildScrollView(
            child: Text(
              'Terms of Service for RemiMinder\n\n'
              '1. Acceptance of Terms\n'
              'By using RemiMinder, you agree to these terms.\n\n'
              '2. Use of Service\n'
              'RemiMinder is designed to help manage healthcare and medication reminders.\n\n'
              '3. Privacy\n'
              'Your privacy is important to us. All health data is handled securely.\n\n'
              'For the complete Terms of Service, please visit our website.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Privacy Policy'),
          content: const SingleChildScrollView(
            child: Text(
              'Privacy Policy for RemiMinder\n\n'
              '1. Information We Collect\n'
              'We collect information you provide and usage data to improve our service.\n\n'
              '2. How We Use Information\n'
              'Information is used to provide healthcare management services.\n\n'
              '3. Information Sharing\n'
              'We do not sell your personal information.\n\n'
              'For the complete Privacy Policy, please visit our website.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Expanded(
                    child: Text(
                      'Privacy Settings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48), // Balance the back button
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Data Sharing Section
                    _buildSectionHeader('Data Sharing', Icons.share),
                    const SizedBox(height: 8),
                    _buildToggleTile(
                      'Allow caregiver to view summaries',
                      _allowCaregiverSummaries,
                      (value) {
                        setState(() => _allowCaregiverSummaries = value);
                        _showSettingUpdatedSnackBar(
                            'Caregiver summaries access');
                      },
                    ),
                    _buildToggleTile(
                      'Allow caregiver to view medications',
                      _allowCaregiverMedications,
                      (value) {
                        setState(() => _allowCaregiverMedications = value);
                        _showSettingUpdatedSnackBar(
                            'Caregiver medications access');
                      },
                    ),
                    _buildToggleTile(
                      'Allow caregiver to view reminders',
                      _allowCaregiverReminders,
                      (value) {
                        setState(() => _allowCaregiverReminders = value);
                        _showSettingUpdatedSnackBar(
                            'Caregiver reminders access');
                      },
                    ),
                    _buildToggleTile(
                      'Allow AI to use my data to improve the product',
                      _allowAiImprovement,
                      (value) {
                        setState(() => _allowAiImprovement = value);
                        _showSettingUpdatedSnackBar('AI improvement access');
                      },
                    ),

                    const SizedBox(height: 24),

                    // Communication & Consent Section
                    _buildSectionHeader(
                        'Communication & Consent', Icons.notifications),
                    const SizedBox(height: 8),
                    _buildToggleTile(
                      'Allow email notifications',
                      _allowEmailNotifications,
                      (value) {
                        setState(() => _allowEmailNotifications = value);
                        _showSettingUpdatedSnackBar('Email notifications');
                      },
                    ),
                    _buildToggleTile(
                      'Allow SMS notifications',
                      _allowSmsNotifications,
                      (value) {
                        setState(() => _allowSmsNotifications = value);
                        _showSettingUpdatedSnackBar('SMS notifications');
                      },
                    ),
                    _buildToggleTile(
                      'Allow push notifications',
                      _allowPushNotifications,
                      (value) {
                        setState(() => _allowPushNotifications = value);
                        _showSettingUpdatedSnackBar('Push notifications');
                      },
                    ),

                    const SizedBox(height: 24),

                    // Data Control Section
                    _buildSectionHeader('Data Control', Icons.storage),
                    const SizedBox(height: 8),
                    _buildActionButton(
                      'Export my data',
                      Icons.download,
                      () => _showComingSoonSnackBar('Data export'),
                    ),
                    const SizedBox(height: 8),
                    _buildActionButton(
                      'Delete all my medical records',
                      Icons.delete_forever,
                      () => _showDeleteConfirmationDialog(
                        context,
                        'Delete Medical Records',
                        'This will permanently delete all your medical records. This action cannot be undone.',
                        'Delete Records',
                        Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildDangerButton(
                      'Delete my account',
                      () => _showDeleteConfirmationDialog(
                        context,
                        'Delete Account',
                        'This will permanently delete your account and all associated data. This action cannot be undone.',
                        'Delete Account',
                        Colors.red,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Legal Section
                    _buildSectionHeader('Legal', Icons.gavel),
                    const SizedBox(height: 8),
                    _buildActionButton(
                      'View Privacy Policy',
                      Icons.policy,
                      _showPrivacyPolicy,
                    ),
                    const SizedBox(height: 8),
                    _buildActionButton(
                      'View Terms of Service',
                      Icons.description,
                      _showTermsOfService,
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildToggleTile(
      String title, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).colorScheme.primary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildActionButton(
      String title, IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDangerButton(String title, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
