import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/data/models/auth_state.dart';
import '../../../../shared/utilities/greeting_utils.dart';
import '../../../patient/presentation/widgets/widgets.dart';
import '../../../care_team/data/models/care_team_invitation.dart';
import '../../../care_team/data/models/care_team_member.dart';
import '../../../care_team/data/services/care_team_api_service.dart';
import '../../../../core/services/preferences_service.dart';
import '../../../../core/models/user.dart';
import '../../../patient/data/models/summary_item.dart';
import '../../../patient/data/services/patient_api_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/config/environment.dart';
import '../../../../l10n/app_localizations.dart';

class CaregiverHomeScreen extends ConsumerStatefulWidget {
  const CaregiverHomeScreen({super.key});

  @override
  ConsumerState<CaregiverHomeScreen> createState() =>
      _CaregiverHomeScreenState();
}

class _CaregiverHomeScreenState extends ConsumerState<CaregiverHomeScreen> {
  List<CareTeamInvitation> _invitations = [];
  bool _isLoadingInvitations = true;
  List<CareTeamMember> _patients = [];
  bool _isLoadingPatients = true;
  String? _patientsError;
  List<SummaryItem> _summaries = [];
  bool _isLoadingSummaries = true;
  String? _summariesError;

  @override
  void initState() {
    super.initState();
    _loadInvitations();
    _loadPatients();
    _loadSummaries();
  }

  Future<void> _loadInvitations() async {
    try {
      if (!mounted) return;
      setState(() {
        _isLoadingInvitations = true;
      });
      final invitations = await CareTeamApiService().getMyInvitations();
      if (!mounted) return;
      setState(() {
        _invitations = invitations;
        _isLoadingInvitations = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingInvitations = false;
      });
    }
  }

  Future<void> _loadPatients() async {
    try {
      if (!mounted) return;
      setState(() {
        _isLoadingPatients = true;
        _patientsError = null;
      });
      final patients = await CareTeamApiService().getCareTeam();
      if (!mounted) return;
      setState(() {
        _patients = patients;
        _isLoadingPatients = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _patientsError = e.toString();
        _isLoadingPatients = false;
      });
    }
  }

  Future<void> _loadSummaries() async {
    try {
      if (!mounted) return;
      setState(() {
        _isLoadingSummaries = true;
        _summariesError = null;
      });
      final authToken = await AuthService().getAccessToken();
      if (authToken == null) {
        throw Exception('Authentication required');
      }
      final apiService = PatientApiService(
        baseUrl: Environment.apiBaseUrl,
        authToken: authToken,
      );
      final summaries = await apiService.getSummaries();
      if (!mounted) return;
      setState(() {
        _summaries = summaries;
        _isLoadingSummaries = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _summariesError = e.toString();
        _isLoadingSummaries = false;
      });
    }
  }

  Future<void> _switchContext(ActiveContext targetContext) async {
    await PreferencesService().setLastActiveContext(targetContext);
    if (!mounted) return;
    context.go('/loading');
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final l10n = AppLocalizations.of(context);
    final userName = _resolveDisplayName(authState) ?? 'Caregiver';
    final greeting = GreetingUtils.getTimeBasedGreeting();
    final firstName = userName.split(' ').first;

    return Column(
      children: [
        Container(
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0)
              .copyWith(top: MediaQuery.of(context).padding.top + 16.0),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      greeting,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            firstName,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          '✨',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Text(
                      l10n?.patientHomeFeelingToday ??
                          'How are you feeling today?',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              PopupMenuButton<ActiveContext>(
                icon: Icon(
                  Icons.swap_horiz,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onSelected: _switchContext,
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: ActiveContext.patient,
                    child: Text('Patient'),
                  ),
                  PopupMenuItem(
                    value: ActiveContext.caregiver,
                    child: Text('Caregiver'),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                if (!_isLoadingInvitations && _invitations.isNotEmpty) ...[
                  _buildInvitationsSection(),
                  const SizedBox(height: 32),
                ],
                const SectionHeader(
                  title: 'My Patients',
                  icon: Icons.people,
                ),
                const SizedBox(height: 16),
                _buildPatientsSection(),
                const SizedBox(height: 32),
                const SectionHeader(
                  title: 'Recent Summaries',
                  icon: Icons.description,
                ),
                const SizedBox(height: 16),
                _buildSummariesSection(),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String? _resolveDisplayName(AuthState authState) {
    final profileName = authState.profile?.fullName;
    if (profileName != null && profileName.trim().isNotEmpty) {
      return profileName.trim();
    }
    final user = authState.user;
    final displayName = user?.displayName;
    if (displayName != null && displayName.trim().isNotEmpty) {
      return displayName.trim();
    }
    final fullName = user?.fullName;
    if (fullName != null && fullName.trim().isNotEmpty) {
      return fullName.trim();
    }
    final email = user?.email;
    if (email != null && email.contains('@')) {
      return email.split('@').first;
    }
    return null;
  }

  Widget _buildInvitationsSection() {
    final pendingInvitations = _invitations.length;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1A4D4D), // Dark teal-green
            Color(0xFF051818), // Very dark green/black
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: const Border(
          top: BorderSide(
            color: Colors.white,
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.mail,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Pending Invitations',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '$pendingInvitations invitation${pendingInvitations > 1 ? 's' : ''} waiting',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Review and accept caregiver invitations.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => context.go('/caregiver/accept-invitations'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'View Invitations',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientsSection() {
    if (_isLoadingPatients) {
      return _buildLoadingCard();
    }

    if (_patientsError != null || _patients.isEmpty) {
      return _buildEmptyCard(
        title: 'No patients linked yet',
        subtitle:
            'You will see patients here once you accept an invitation.',
      );
    }

    final previewPatients = _patients.take(3).toList();

    return InkWell(
      onTap: () => context.go('/caregiver/patients'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            for (var i = 0; i < previewPatients.length; i++) ...[
              _buildPatientRow(previewPatients[i]),
              if (i != previewPatients.length - 1)
            const Divider(height: 16),
            ],
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.go('/caregiver/patients'),
              child: Text(
                'View All Patients',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientRow(CareTeamMember patient) {
    final name = patient.fullName ?? patient.email ?? 'Patient';
    final role = patient.role;
    final status = patient.status;

    return Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
            color: _getStatusColor(status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    Icons.person,
            color: _getStatusColor(status),
                    size: 24,
                  ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                role,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                      Text(
                status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                  color: _getStatusTextColor(status),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
            ],
          ),
        ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
        ),
      ],
    );
  }

  Color _getStatusColor(String statusType) {
    switch (statusType) {
      case 'active':
        return Colors.green;
      case 'attention':
        return Colors.orange;
      case 'critical':
        return Colors.red;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  Color _getStatusTextColor(String statusType) {
    switch (statusType) {
      case 'active':
        return Colors.green;
      case 'attention':
        return Colors.orange;
      case 'critical':
        return Colors.red;
      default:
        return Theme.of(context).colorScheme.secondary;
    }
  }

  Widget _buildSummariesSection() {
    if (_isLoadingSummaries) {
      return _buildLoadingCard();
    }

    if (_summaries.isEmpty) {
      return _buildEmptyCard(
        title: 'No summaries yet',
        subtitle: 'Visit summaries will appear here once available.',
      );
    }

    if (_summariesError != null) {
      return _buildEmptyCard(
        title: 'No summaries yet',
        subtitle: 'Visit summaries will appear here once available.',
      );
    }

    final previewSummaries = _summaries.take(3).toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          for (var i = 0; i < previewSummaries.length; i++) ...[
            _buildSummaryItem(previewSummaries[i]),
            if (i != previewSummaries.length - 1)
              const Divider(height: 16),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryItem(SummaryItem summary) {
    final title = summary.title ??
        (summary.specialty.isNotEmpty
            ? summary.specialty
            : 'Visit Summary');
    final subtitle = summary.doctorName.isNotEmpty
        ? summary.doctorName
        : 'Doctor';
    final dateText = _formatSummaryDate(summary.visitDate ?? summary.summaryCreatedAt);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.description,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$subtitle • $dateText',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                summary.summaryPreview,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
        color: Colors.white,
              borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildEmptyCard({
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
        Text(
            title,
            textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
          const SizedBox(height: 6),
        Text(
            subtitle,
            textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 13,
            color: Theme.of(context).colorScheme.secondary,
          ),
          ),
        ],
      ),
    );
  }

  String _formatSummaryDate(String dateSource) {
    final parsed = DateTime.tryParse(dateSource);
    if (parsed == null) return 'Unknown date';
    final now = DateTime.now();
    final difference = now.difference(parsed).inDays;
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    if (difference < 7) return '$difference days ago';
    return MaterialLocalizations.of(context).formatMediumDate(parsed);
  }
}
