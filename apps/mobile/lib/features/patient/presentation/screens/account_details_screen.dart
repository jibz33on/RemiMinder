import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/services/backend_api_service.dart';
import '../../../../l10n/app_localizations.dart';
import 'upgrade_screen.dart';

class AccountDetailsScreen extends ConsumerStatefulWidget {
  const AccountDetailsScreen({super.key});

  @override
  ConsumerState<AccountDetailsScreen> createState() =>
      _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends ConsumerState<AccountDetailsScreen> {
  bool _isUpdatingPhone = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);
    final l10n = AppLocalizations.of(context);

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
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      l10n?.accountDetailsTitle ?? 'Account Details',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48), // Balance for back button
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
                    _buildDetailItem(
                      theme,
                      l10n?.accountDetailsNameLabel ?? 'Name',
                      authState.profile?.fullName ??
                          (l10n?.accountDetailsNotSet ?? 'Not set'),
                      Icons.person,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailItem(
                      theme,
                      l10n?.accountDetailsEmailLabel ?? 'Email',
                      authState.profile?.email ??
                          (l10n?.accountDetailsNotSet ?? 'Not set'),
                      Icons.email,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailItem(
                      theme,
                      l10n?.accountDetailsAccountTypeLabel ?? 'Account Type',
                      authState.profile?.role == 'patient'
                          ? (l10n?.accountDetailsAccountTypePatient ??
                              'Patient')
                          : (l10n?.accountDetailsAccountTypeCaregiver ??
                              'Caregiver'),
                      Icons.account_circle,
                    ),
                    const SizedBox(height: 16),
                    _buildPhoneDetailItem(
                        theme, authState.profile?.phone, l10n),
                    const SizedBox(height: 16),
                    _buildPlanDetailItem(
                        theme, authState.profile?.plan ?? "free", l10n),
                    const SizedBox(height: 16),
                    _buildUsageDetailItem(
                        theme, authState.profile?.plan ?? "free", l10n),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(
      ThemeData theme, String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneDetailItem(
      ThemeData theme, String? phone, AppLocalizations? l10n) {
    final isPhoneSet = phone != null && phone.isNotEmpty;
    final displayValue =
        isPhoneSet ? phone : (l10n?.accountDetailsNotSet ?? 'Not set');
    final actionText = isPhoneSet
        ? (l10n?.accountDetailsPhoneEdit ?? 'Edit')
        : (l10n?.accountDetailsPhoneAdd ?? 'Add');

    return InkWell(
      onTap: _showPhoneEditDialog,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.phone,
                color: theme.colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        l10n?.accountDetailsPhoneLabel ?? 'Phone',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        actionText,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: theme.colorScheme.primary.withOpacity(0.6),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    displayValue,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanDetailItem(
      ThemeData theme, String plan, AppLocalizations? l10n) {
    final isFreePlan = plan == "free";
    final displayValue = isFreePlan
        ? (l10n?.accountDetailsPlanFree ?? 'Free')
        : (l10n?.accountDetailsPlanPremium ?? 'Premium');
    final actionText = isFreePlan
        ? (l10n?.accountDetailsPlanUpgrade ?? 'Upgrade')
        : (l10n?.accountDetailsPlanManage ?? 'Manage');

    return InkWell(
      onTap: isFreePlan ? () => _navigateToUpgrade() : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.star,
                color: theme.colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        l10n?.accountDetailsPlanLabel ?? 'Plan',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (isFreePlan) ...[
                        const Spacer(),
                        Text(
                          actionText,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: theme.colorScheme.primary.withOpacity(0.6),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    displayValue,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageDetailItem(
      ThemeData theme, String plan, AppLocalizations? l10n) {
    // Hardcoded values for now
    const int used = 1;
    const int limit = 2;

    final isFreePlan = plan == "free";
    final displayValue = isFreePlan
        ? (l10n?.accountDetailsUsageFreePlan(used, limit) ??
            'Free plan — $used / $limit summaries used')
        : (l10n?.accountDetailsUsageUnlimited ?? 'Unlimited');
    final actionText =
        isFreePlan ? (l10n?.accountDetailsPlanUpgrade ?? 'Upgrade') : null;

    return InkWell(
      onTap: isFreePlan ? () => _navigateToUpgrade() : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.bar_chart,
                color: theme.colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        l10n?.accountDetailsUsageLabel ?? 'Usage',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (isFreePlan) ...[
                        const Spacer(),
                        Text(
                          actionText!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: theme.colorScheme.primary.withOpacity(0.6),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    displayValue,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToUpgrade() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UpgradeScreen()),
    );
  }

  void _showPhoneEditDialog() {
    final authState = ref.read(authNotifierProvider);
    final currentPhone = authState.profile?.phone ?? '';
    final controller = TextEditingController(text: currentPhone);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final l10n = AppLocalizations.of(context);
          return AlertDialog(
          title:
              Text(l10n?.accountDetailsPhoneEditTitle ?? 'Edit Phone Number'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText:
                  l10n?.accountDetailsPhoneLabel ?? 'Phone Number',
              hintText:
                  l10n?.accountDetailsPhoneHint ?? '+1 (555) 123-4567',
            ),
            keyboardType: TextInputType.phone,
            enabled: !_isUpdatingPhone,
          ),
          actions: [
            TextButton(
              onPressed:
                  _isUpdatingPhone ? null : () => Navigator.of(context).pop(),
              child: Text(l10n?.commonCancel ?? 'Cancel'),
            ),
            ElevatedButton(
              onPressed: _isUpdatingPhone
                  ? null
                  : () => _savePhoneNumber(controller.text.trim(), setState),
              child: _isUpdatingPhone
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n?.commonSave ?? 'Save'),
            ),
          ],
        );
        },
      ),
    );
  }

  Future<void> _savePhoneNumber(String phoneInput, StateSetter setState) async {
    // Validate input
    if (phoneInput.isNotEmpty && phoneInput.length < 8) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(l10n?.accountDetailsPhoneMinLengthError ??
                'Phone number must be at least 8 characters long')),
      );
      return;
    }

    // Convert empty string to null
    final phoneToSave = phoneInput.isEmpty ? null : phoneInput;

    setState(() => _isUpdatingPhone = true);

    try {
      final backendApiService = BackendApiService();
      final updatedPhone = await backendApiService.updateMyPhone(phoneToSave);

      // Update Riverpod state
      final authState = ref.read(authNotifierProvider);
      final updatedProfile = authState.profile?.copyWith(phone: updatedPhone);
      ref.read(authNotifierProvider.notifier).updateProfile(updatedProfile);

      if (mounted) {
        Navigator.of(context).pop(); // Close dialog
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(l10n?.accountDetailsPhoneUpdated ??
                  'Phone number updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(l10n?.accountDetailsPhoneUpdateFailed(e.toString()) ??
                  'Failed to update phone number: $e')),
        );
      }
    } finally {
      setState(() => _isUpdatingPhone = false);
    }
  }
}
