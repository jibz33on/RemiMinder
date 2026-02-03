import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/preferences_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../patient/presentation/widgets/widgets.dart';
import '../../../patient/data/models/patient_task.dart';
import '../providers/caregiver_providers.dart';

class CaregiverPatientHomeScreen extends ConsumerStatefulWidget {
  const CaregiverPatientHomeScreen({super.key});

  @override
  ConsumerState<CaregiverPatientHomeScreen> createState() =>
      _CaregiverPatientHomeScreenState();
}

class _CaregiverPatientHomeScreenState
    extends ConsumerState<CaregiverPatientHomeScreen> {
  String? _patientId;
  bool _isLoadingPatient = true;

  @override
  void initState() {
    super.initState();
    _loadActivePatient();
  }

  Future<void> _loadActivePatient() async {
    final patientId = await PreferencesService().getActivePatientId();
    if (!mounted) return;
    ref
        .read(activePatientIdProvider.notifier)
        .setActivePatientId(patientId);
    setState(() {
      _patientId = patientId;
      _isLoadingPatient = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (_isLoadingPatient) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_patientId == null || _patientId!.isEmpty) {
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
            onPressed: () => context.go('/caregiver/patients'),
          ),
          title: Text(
            l10n?.caregiverPatientsTitle ?? 'My Patients',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        body: Center(
          child: Text(
            l10n?.caregiverPatientOverviewMissingPatientId ??
                'Select a patient to continue.',
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
        ),
      );
    }

    final patientId = _patientId!;
    final patientsState = ref.watch(caregiverPatientsProvider);
    final remindersState = ref.watch(caregiverPatientRemindersProvider);
    final tasksState = ref.watch(caregiverPatientTasksProvider);
    final selectedPatient = patientsState.patients
        .where((patient) => patient.patientId == patientId)
        .toList()
        .firstOrNull;
    final hasRemindersError =
        remindersState.errorMessage != null && !remindersState.hasData;
    final hasTasksError =
        tasksState.errorMessage != null && !tasksState.hasData;
    final showRetryBanner = hasRemindersError || hasTasksError;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait(<Future<void>>[
            ref
                .read(caregiverPatientRemindersProvider.notifier)
                .refresh(userInitiated: true),
            ref
                .read(caregiverPatientTasksProvider.notifier)
                .refresh(userInitiated: true),
          ]);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildHeader(context, selectedPatient?.fullName,
                  selectedPatient?.email),
              const SizedBox(height: 24),
              _buildReadOnlyBadge(context),
              const SizedBox(height: 8),
              _buildReadOnlyHelperText(context),
              if (showRetryBanner) ...[
                const SizedBox(height: 16),
                _buildRetryBanner(context, onRetry: () async {
                  await Future.wait(<Future<void>>[
                    ref
                        .read(caregiverPatientRemindersProvider.notifier)
                        .refresh(userInitiated: true),
                    ref
                        .read(caregiverPatientTasksProvider.notifier)
                        .refresh(userInitiated: true),
                  ]);
                }),
              ],
              const SizedBox(height: 24),
              _buildUpNextCard(remindersState),
              const SizedBox(height: 32),
              SectionHeader(
                title: l10n?.patientHomeTodaysSchedule ??
                    'Today\'s Schedule',
                icon: Icons.schedule,
              ),
              const SizedBox(height: 6),
              _buildLastUpdated(context, remindersState.lastUpdated),
              const SizedBox(height: 16),
              _buildTodaysSchedule(remindersState),
              const SizedBox(height: 32),
              SectionHeader(
                title: l10n?.patientHomeTodoList ?? 'To-do List',
                icon: Icons.checklist,
              ),
              const SizedBox(height: 6),
              _buildLastUpdated(context, tasksState.lastUpdated),
              const SizedBox(height: 16),
              _buildTodoList(tasksState),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, String? fullName, String? email) {
    final displayName = (fullName?.trim().isNotEmpty ?? false)
        ? fullName!.trim()
        : (email ?? 'Patient');
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () => context.go('/caregiver/patients'),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              if (email != null && email.isNotEmpty)
                Text(
                  email,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.8),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReadOnlyBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Read-only',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }

  Widget _buildReadOnlyHelperText(BuildContext context) {
    return Text(
      'Only the patient can make changes.',
      style: TextStyle(
        fontSize: 12,
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
      ),
    );
  }

  Widget _buildRetryBanner(BuildContext context,
      {required Future<void> Function() onRetry}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.cloud_off,
            size: 20,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Unable to load the latest data.',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => onRetry(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildLastUpdated(BuildContext context, DateTime? lastUpdated) {
    if (lastUpdated == null) return const SizedBox.shrink();
    final formatted =
        MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay.fromDateTime(lastUpdated.toLocal()),
    );
    return Text(
      'Last updated $formatted',
      style: TextStyle(
        fontSize: 11,
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
      ),
    );
  }

  Widget _buildUpNextCard(CaregiverRemindersState remindersState) {
    final l10n = AppLocalizations.of(context);
    final reminder = remindersState.upNext;
    final title = reminder?['title'] as String?;
    final message = reminder?['message'] as String?;
    final scheduledTime = reminder?['scheduled_time'] as String?;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1A4D4D),
            Color(0xFF051818),
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
                Icons.alarm,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                l10n?.patientHomeUpNext ?? 'Up Next',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (remindersState.isLoading && !remindersState.hasData)
            const Center(child: CircularProgressIndicator())
          else if (reminder == null)
            Text(
              l10n?.patientHomeNoUpcomingReminders ??
                  'No upcoming reminders',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            )
          else ...[
            Text(
              title?.trim().isNotEmpty == true ? title! : (message ?? ''),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatDueText(scheduledTime),
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTodaysSchedule(CaregiverRemindersState remindersState) {
    final l10n = AppLocalizations.of(context);
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
          if (remindersState.isLoading && !remindersState.hasData)
            const Center(child: CircularProgressIndicator())
          else if (remindersState.today.isEmpty)
            Text(
              l10n?.patientHomeNothingScheduled ??
                  'Nothing scheduled for today',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.secondary,
              ),
            )
          else
            Column(
              children: remindersState.today.map((reminder) {
                final title = reminder['title'] as String?;
                final message = reminder['message'] as String?;
                final scheduledTime = reminder['scheduled_time'] as String?;
                return Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.schedule,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title?.trim().isNotEmpty == true
                                    ? title!
                                    : (message ?? ''),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              Text(
                                _formatScheduleTime(scheduledTime),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 12),
                  ],
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildTodoList(CaregiverTasksState tasksState) {
    final l10n = AppLocalizations.of(context);
    // TODO: Add collaborative notes or shared tasks in a future phase.
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
      child: tasksState.isLoading && !tasksState.hasData
          ? const Center(child: CircularProgressIndicator())
          : tasksState.tasks.isEmpty
              ? Center(
                  child: Text(
                    l10n?.patientHomeNoTasksYet ?? 'No tasks yet',
                    style: const TextStyle(fontSize: 14),
                  ),
                )
              : Column(
                  children: [
                    ...tasksState.tasks.map((task) {
                      return Column(
                        children: [
                          _buildTodoItem(task),
                          const Divider(height: 12),
                        ],
                      );
                    }),
                  ],
                ),
    );
  }

  Widget _buildTodoItem(PatientTask task) {
    final title = task.title;
    final dueDate = _formatTaskCreatedAt(task.createdAt);
    return Row(
      children: [
        Icon(
          Icons.check_circle_outline,
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Text(
                dueDate,
                style: TextStyle(
                  fontSize: 12,
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDueText(String? scheduledTime) {
    if (scheduledTime == null || scheduledTime.isEmpty) return '';
    final parsed = DateTime.tryParse(scheduledTime);
    if (parsed == null) return '';
    final now = DateTime.now();
    final difference = parsed.difference(now);
    if (difference.inMinutes < 1) return 'Due now';
    if (difference.inMinutes < 60) {
      return 'In ${difference.inMinutes} min';
    }
    if (difference.inHours < 24) {
      return 'In ${difference.inHours} hrs';
    }
    return 'In ${difference.inDays} days';
  }

  String _formatScheduleTime(String? scheduledTime) {
    if (scheduledTime == null || scheduledTime.isEmpty) return '';
    final parsed = DateTime.tryParse(scheduledTime);
    if (parsed == null) return '';
    return MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay.fromDateTime(parsed.toLocal()),
    );
  }

  String _formatTaskCreatedAt(DateTime? createdAt) {
    if (createdAt == null) return 'No due date';
    return MaterialLocalizations.of(context)
        .formatMediumDate(createdAt.toLocal());
  }
}

extension _FirstOrNullExtension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
