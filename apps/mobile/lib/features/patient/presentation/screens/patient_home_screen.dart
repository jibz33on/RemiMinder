import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/services/preferences_service.dart';
import '../../../../core/models/user.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/patient_home_providers.dart';
import '../widgets/widgets.dart';

class PatientHomeScreen extends ConsumerStatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  ConsumerState<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends ConsumerState<PatientHomeScreen> {
  Future<void> _switchContext(ActiveContext targetContext) async {
    await PreferencesService().setLastActiveContext(targetContext);
    if (!mounted) return;
    context.go('/loading');
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final remindersState = ref.watch(remindersNotifierProvider);
    final tasksState = ref.watch(patientTasksNotifierProvider);
    final l10n = AppLocalizations.of(context);
    final userName = authState.profile?.fullName ??
        (l10n?.rolePatient ?? 'Patient');
    final greeting = _getTimeBasedGreeting(l10n);
    final firstName = userName.split(' ').first; // Extract first name only

    return Column(
      children: [
        // App Bar equivalent - convert to a regular Container
        Container(
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0)
              .copyWith(top: MediaQuery.of(context).padding.top + 16.0),
          child: Row(
            children: [
              // Enhanced User Avatar with Gradient (compact)
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
              // Enhanced Welcome Text (greeting + name layout)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Greeting line
                    Text(
                      greeting,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                      ),
                    ),
                    // First name with sparkle
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
                    // Subtitle
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
              IconButton(
                icon: Icon(
                  Icons.notifications_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  context.go('/patient/notifications');
                },
              ),
            ],
          ),
        ),

        // Main content
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await Future.wait([
                ref
                    .read(remindersNotifierProvider.notifier)
                    .refresh(userInitiated: true),
                ref
                    .read(patientTasksNotifierProvider.notifier)
                    .refresh(userInitiated: true),
              ]);
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // Up Next Card
                  _buildUpNextCard(remindersState),

                const SizedBox(height: 32),

                // Today's Schedule
                SectionHeader(
                  title: l10n?.patientHomeTodaysSchedule ??
                      'Today\'s Schedule',
                  icon: Icons.schedule,
                ),
                const SizedBox(height: 16),
                _buildTodaysSchedule(remindersState),

                const SizedBox(height: 32),

                // To-do List
                SectionHeader(
                  title: l10n?.patientHomeTodoList ?? 'To-do List',
                  icon: Icons.checklist,
                ),
                const SizedBox(height: 16),
                _buildTodoList(tasksState),

                // Extra space for bottom navigation - this will be handled by the app shell
                const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpNextCard(RemindersState remindersState) {
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
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: reminder == null
                      ? null
                      : () {
                    // TODO: Mark as taken
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(l10n?.patientHomeMarkedAsTaken ??
                              'Marked as taken!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    l10n?.patientHomeTakeNow ?? 'Take Now',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: reminder == null
                    ? null
                    : () {
                  // TODO: Snooze reminder
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(l10n?.patientHomeReminderSnoozed ??
                            'Reminder snoozed for 1 hour')),
                  );
                },
                icon: const Icon(Icons.snooze, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  padding: const EdgeInsets.all(12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTodaysSchedule(RemindersState remindersState) {
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
                                      .secondary
                                      .withOpacity(0.7),
                ),
              ),
            ],
          ),
                        ),
                      ],
                    ),
                    const Divider(height: 12),
                  ],
                );
              }).toList(),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context.go('/patient/reminders');
                  },
                  child: Text(l10n?.patientHomeViewAll ?? 'View All'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Add new item
                  },
                  child: Text(l10n?.patientHomeAddItem ?? 'Add Item'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTodoList(PatientTasksState tasksState) {
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
          _buildTodoItem(
                            task.title,
                            _formatTaskCreatedAt(task.createdAt),
            false,
          ),
          const Divider(height: 12),
                        ],
                      );
                    }),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: Navigate to full todo list
              },
              icon: const Icon(Icons.add),
              label: Text(l10n?.patientHomeAddTask ?? 'Add Task'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodoItem(String title, String dueDate, bool isCompleted) {
    return Row(
      children: [
        Checkbox(
          value: isCompleted,
          onChanged: (value) {
            // TODO: Update todo status
          },
          activeColor: Theme.of(context).colorScheme.primary,
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
                  color: isCompleted
                      ? Theme.of(context).colorScheme.secondary.withOpacity(0.6)
                      : Theme.of(context).colorScheme.primary,
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
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
        if (isCompleted)
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 20,
          ),
      ],
    );
  }

  String _formatTaskCreatedAt(DateTime? createdAt) {
    final l10n = AppLocalizations.of(context);
    if (createdAt == null) {
      return l10n?.patientHomeAddedRecently ?? 'Added recently';
    }
    final dateText = MaterialLocalizations.of(context)
        .formatMediumDate(createdAt);
    return l10n?.patientHomeAddedDate(dateText) ?? 'Added $dateText';
  }

  String _formatDueText(String? scheduledTime) {
    final l10n = AppLocalizations.of(context);
    if (scheduledTime == null || scheduledTime.trim().isEmpty) {
      return l10n?.patientHomeUpcoming ?? 'Upcoming';
    }
    final scheduled = DateTime.tryParse(scheduledTime);
    if (scheduled == null) {
      return l10n?.patientHomeUpcoming ?? 'Upcoming';
    }
    final now = DateTime.now();
    final diff = scheduled.difference(now);
    if (diff.inMinutes <= 0) {
      return l10n?.patientHomeDueNow ?? 'Due now';
    }
    if (diff.inMinutes < 60) {
      return l10n?.patientHomeDueInMinutes(diff.inMinutes) ??
          'Due in ${diff.inMinutes} min';
    }
    if (diff.inHours < 24) {
      return l10n?.patientHomeDueInHours(diff.inHours) ??
          'Due in ${diff.inHours} hours';
    }
    if (diff.inDays < 7) {
      return l10n?.patientHomeDueInDays(diff.inDays) ??
          'Due in ${diff.inDays} days';
    }
    final dateText = MaterialLocalizations.of(context)
        .formatMediumDate(scheduled);
    return l10n?.patientHomeDueOnDate(dateText) ?? 'Due $dateText';
  }

  String _formatScheduleTime(String? scheduledTime) {
    if (scheduledTime == null || scheduledTime.trim().isEmpty) {
      return '';
    }
    final scheduled = DateTime.tryParse(scheduledTime);
    if (scheduled == null) {
      return scheduledTime;
    }
    final timeOfDay = TimeOfDay.fromDateTime(scheduled);
    return MaterialLocalizations.of(context).formatTimeOfDay(
      timeOfDay,
      alwaysUse24HourFormat: MediaQuery.of(context).alwaysUse24HourFormat,
    );
  }

  String _getTimeBasedGreeting(AppLocalizations? l10n) {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return l10n?.patientHomeGreetingMorning ?? 'Good morning';
    }
    if (hour >= 12 && hour < 17) {
      return l10n?.patientHomeGreetingAfternoon ?? 'Good afternoon';
    }
    if (hour >= 17 && hour < 22) {
      return l10n?.patientHomeGreetingEvening ?? 'Good evening';
    }
    return l10n?.patientHomeGreetingNight ?? 'Good night';
  }

}
