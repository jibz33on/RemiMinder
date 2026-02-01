import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../shared/utilities/greeting_utils.dart';
import '../../../patient/presentation/widgets/widgets.dart';
import '../../../care_team/data/models/care_team_invitation.dart';
import '../../../care_team/data/services/care_team_api_service.dart';
import '../../../../core/services/preferences_service.dart';
import '../../../../core/models/user.dart';

class CaregiverHomeScreen extends ConsumerStatefulWidget {
  const CaregiverHomeScreen({super.key});

  @override
  ConsumerState<CaregiverHomeScreen> createState() =>
      _CaregiverHomeScreenState();
}

class _CaregiverHomeScreenState extends ConsumerState<CaregiverHomeScreen> {
  List<CareTeamInvitation> _invitations = [];
  bool _isLoadingInvitations = true;

  @override
  void initState() {
    super.initState();
    _loadInvitations();
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

  Future<void> _switchContext(ActiveContext targetContext) async {
    await PreferencesService().setLastActiveContext(targetContext);
    if (!mounted) return;
    context.go('/loading');
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final userName = authState.profile?.fullName ?? 'Caregiver';
    final greeting = GreetingUtils.getTimeBasedGreeting();
    final firstName = userName.split(' ').first;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Container(
            color: Colors.transparent,
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0)
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
                    Icons.favorite,
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
                        'Caregiver dashboard',
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
                IconButton(
                  icon: Icon(
                    Icons.notifications_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () => context.go('/caregiver/alerts'),
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
                  if (!_isLoadingInvitations && _invitations.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _buildInvitationsSection(),
                    const SizedBox(height: 32),
                  ],
                  const SectionHeader(
                    title: 'Recent Alerts',
                    icon: Icons.notifications,
                  ),
                  const SizedBox(height: 16),
                  _buildAlertsSection(),
                  const SizedBox(height: 32),
                  const SectionHeader(
                    title: 'My Patients',
                    icon: Icons.people,
                  ),
                  const SizedBox(height: 16),
                  _buildPatientList(),
                  const SizedBox(height: 32),
                  const SectionHeader(
                    title: 'Today\'s Care Tasks',
                    icon: Icons.task,
                  ),
                  const SizedBox(height: 16),
                  _buildCareTasks(),
                  const SizedBox(height: 32),
                  const SectionHeader(
                    title: 'Upcoming Appointments',
                    icon: Icons.calendar_today,
                  ),
                  const SizedBox(height: 16),
                  _buildUpcomingAppointments(),
                  const SizedBox(height: 32),
                  const SectionHeader(
                    title: 'Quick Actions',
                    icon: Icons.flash_on,
                  ),
                  const SizedBox(height: 16),
                  _buildQuickActions(),
                  const SizedBox(height: 32),
                  const SectionHeader(
                    title: 'Care Summary',
                    icon: Icons.analytics,
                  ),
                  const SizedBox(height: 16),
                  _buildCaregiverStats(),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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

  Widget _buildAlertsSection() {
    // Mock alerts data
    final alerts = [
      {
        'id': '1',
        'type': 'medication',
        'message': 'John Doe missed Lisinopril 10mg medication',
        'patient': 'John Doe',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        'priority': 'high',
        'isRead': false,
      },
      {
        'id': '2',
        'type': 'appointment',
        'message': 'Sarah Johnson has appointment tomorrow at 2:30 PM',
        'patient': 'Sarah Johnson',
        'timestamp': DateTime.now().add(const Duration(hours: 6)),
        'priority': 'medium',
        'isRead': true,
      },
      {
        'id': '3',
        'type': 'measurement',
        'message': 'Mike Chen blood pressure reading is due',
        'patient': 'Mike Chen',
        'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
        'priority': 'low',
        'isRead': false,
      },
    ];

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.notifications_active,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Recent Alerts',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  context.go('/caregiver/alerts');
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...alerts.take(3).map((alert) => _buildAlertItem(alert)),
        ],
      ),
    );
  }

  Widget _buildAlertItem(Map<String, dynamic> alert) {
    final isRead = alert['isRead'] as bool;
    final priority = alert['priority'] as String;

    Color priorityColor;
    switch (priority) {
      case 'high':
        priorityColor = Colors.red;
        break;
      case 'medium':
        priorityColor = Colors.orange;
        break;
      case 'low':
        priorityColor = Colors.green;
        break;
      default:
        priorityColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isRead
            ? Colors.grey.withOpacity(0.05)
            : Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isRead
              ? Colors.grey.withOpacity(0.2)
              : Colors.red.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: priorityColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert['message'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Patient: ${alert['patient']} • ${_formatAlertTime(alert['timestamp'])}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
          if (!isRead)
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  String _formatAlertTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.isNegative) {
      final hours = difference.inHours.abs();
      return 'In $hours hours';
    } else {
      final hours = difference.inHours;
      if (hours < 1) {
        return '${difference.inMinutes} min ago';
      } else if (hours < 24) {
        return '$hours hours ago';
      } else {
        return '${difference.inDays} days ago';
      }
    }
  }

  // Section headers use shared SectionHeader widget for consistency

  Widget _buildPatientList() {
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
            _buildPatientCard(
              'John Doe',
              'Father',
              '85% medication adherence',
              'active',
              null,
            ),
            const Divider(height: 16),
            _buildPatientCard(
              'Mary Smith',
              'Mother',
              'Needs medication reminder',
              'attention',
              null,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                context.go('/caregiver/patients');
              },
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

  Widget _buildPatientCard(String name, String relationship, String status,
      String statusType, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            // Patient Avatar with Status Indicator
            Stack(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _getStatusColor(statusType).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    Icons.person,
                    color: _getStatusColor(statusType),
                    size: 24,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: _getStatusIndicatorColor(statusType),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(
                      _getStatusIcon(statusType),
                      color: Colors.white,
                      size: 8,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            // Patient Info
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
                    relationship,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        status,
                        style: TextStyle(
                          fontSize: 12,
                          color: _getStatusTextColor(statusType),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.5),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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

  Color _getStatusIndicatorColor(String statusType) {
    switch (statusType) {
      case 'active':
        return Colors.green;
      case 'attention':
        return Colors.orange;
      case 'critical':
        return Colors.red;
      default:
        return Colors.grey;
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

  IconData _getStatusIcon(String statusType) {
    switch (statusType) {
      case 'active':
        return Icons.check;
      case 'attention':
        return Icons.warning;
      case 'critical':
        return Icons.error;
      default:
        return Icons.info;
    }
  }

  Widget _buildCareTasks() {
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
          _buildTaskItem(
            'Give John his morning medication',
            'Lisinopril 10mg',
            '8:00 AM',
            true, // completed
          ),
          const Divider(height: 16),
          _buildTaskItem(
            'Remind Mary about doctor appointment',
            'Cardiology checkup',
            '10:30 AM',
            false, // pending
          ),
          const Divider(height: 16),
          _buildTaskItem(
            'Check medication supply',
            'Refill needed for John',
            '2:00 PM',
            false, // pending
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(
      String task, String details, String time, bool isCompleted) {
    return Row(
      children: [
        // Checkbox
        Checkbox(
          value: isCompleted,
          onChanged: (value) {},
          activeColor: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        // Task Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
              Text(
                details,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Text(
                time,
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

  Widget _buildUpcomingAppointments() {
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
          _buildAppointmentItem(
            'John Doe',
            'Cardiology Checkup',
            'Tomorrow, 2:30 PM',
            'City Medical Center',
          ),
          const SizedBox(height: 16),
          _buildAppointmentItem(
            'Mary Smith',
            'Blood Work',
            'Friday, 9:00 AM',
            'LabCorp Downtown',
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentItem(String patient, String appointmentType,
      String dateTime, String location) {
    return Row(
      children: [
        // Calendar Icon
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.calendar_today,
            color: Theme.of(context).colorScheme.secondary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        // Appointment Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                patient,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Text(
                appointmentType,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Text(
                '$dateTime • $location',
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

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildQuickActionItem(
          'Add Patient',
          Icons.person_add,
          () {},
        ),
        _buildQuickActionItem(
          'Schedule',
          Icons.schedule,
          () {},
        ),
        _buildQuickActionItem(
          'Messages',
          Icons.message,
          () {},
        ),
        _buildQuickActionItem(
          'Reports',
          Icons.bar_chart,
          () {},
        ),
      ],
    );
  }

  Widget _buildQuickActionItem(
      String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCaregiverStats() {
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStat('Active Patients', '2', Icons.people),
          _buildStat('Tasks Today', '8', Icons.task),
          _buildStat('This Week', '24/28', Icons.check_circle),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.secondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
