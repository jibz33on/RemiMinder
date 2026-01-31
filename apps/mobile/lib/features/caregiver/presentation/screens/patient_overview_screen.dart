import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../patient/data/models/summary_item.dart';
import '../../../patient/data/services/patient_api_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/config/environment.dart';
import '../../../../l10n/app_localizations.dart';

class PatientOverviewScreen extends StatefulWidget {
  const PatientOverviewScreen({super.key});

  @override
  State<PatientOverviewScreen> createState() => _PatientOverviewScreenState();
}

class _PatientOverviewScreenState extends State<PatientOverviewScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _patientId;
  bool _hasLoaded = false;
  bool _isLoading = true;
  String? _error;

  Map<String, dynamic> _patientData = {
    'id': '',
    'name': '',
    'age': 0,
    'relationship': 'Care Team',
    'condition': 'Authorized access',
    'status': 'active',
    'phone': '',
    'emergencyContact': '',
    'address': '',
    'primaryCarePhysician': '',
    'lastVisit': DateTime.now(),
    'medicationAdherence': 0,
    'upcomingAppointments': 0,
  };

  List<Map<String, dynamic>> _visits = [];

  List<Map<String, dynamic>> _reminders = [];

  List<Map<String, dynamic>> _notes = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_hasLoaded) return;
    _patientId = GoRouterState.of(context).uri.queryParameters['patientId'];
    _hasLoaded = true;
    _loadPatientData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadPatientData() async {
    if (_patientId == null || _patientId!.isEmpty) {
      final l10n = AppLocalizations.of(context);
      setState(() {
        _error = l10n?.caregiverPatientOverviewMissingPatientId ??
            'Missing patientId';
        _isLoading = false;
      });
      return;
    }

    try {
      setState(() {
        _isLoading = true;
        _error = null;
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
      final visits = summaries.map(_mapSummaryToVisit).toList();

      setState(() {
        _visits = visits;
        _patientData = _buildPatientData(visits);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // App Bar
            SliverAppBar(
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
                l10n?.caregiverPatientOverviewTitle ?? 'Patient Overview',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: _editPatient,
                ),
                IconButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: _showMoreOptions,
                ),
              ],
            ),

            // Patient Header
            SliverToBoxAdapter(
              child: _buildPatientHeader(),
            ),

            // Tab Bar
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(
                        text: l10n?.caregiverPatientOverviewTabVisits ?? 'Visits',
                        icon: const Icon(Icons.medical_services)),
                    Tab(
                        text: l10n?.caregiverPatientOverviewTabReminders ??
                            'Reminders',
                        icon: const Icon(Icons.notifications)),
                    Tab(
                        text:
                            l10n?.caregiverPatientOverviewTabNotes ?? 'Notes',
                        icon: const Icon(Icons.note)),
                  ],
                  labelColor: Theme.of(context).colorScheme.primary,
                  unselectedLabelColor: Theme.of(context).colorScheme.secondary,
                  indicatorColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildVisitsTab(),
            _buildRemindersTab(),
            _buildNotesTab(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewItem,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(_getFabIcon()),
      ),
    );
  }

  Widget _buildPatientHeader() {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.all(16),
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
          // Avatar and Basic Info
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: _getStatusColor(_patientData['status'])
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Icon(
                      Icons.person,
                      color: _getStatusColor(_patientData['status']),
                      size: 40,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: _getStatusColor(_patientData['status']),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(
                        _getStatusIcon(_patientData['status']),
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _patientData['name'],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      l10n?.caregiverPatientsRelationshipAge(
                              _patientData['relationship'], _patientData['age']) ??
                          '${_patientData['relationship']} • Age ${_patientData['age']}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _patientData['condition'],
                      style: TextStyle(
                        fontSize: 14,
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
          ),

          const SizedBox(height: 20),

          // Health Stats
          Row(
            children: [
              _buildStatItem(
                l10n?.caregiverPatientsStatAdherence ?? 'Adherence',
                '${_patientData['medicationAdherence']}%',
                _patientData['medicationAdherence'] >= 80
                    ? Colors.green
                    : Colors.orange,
              ),
              _buildStatItem(
                l10n?.caregiverPatientsStatAppointments ?? 'Appointments',
                _patientData['upcomingAppointments'].toString(),
                Colors.blue,
              ),
              _buildStatItem(
                l10n?.caregiverPatientsStatLastVisit ?? 'Last Visit',
                _formatLastVisit(_patientData['lastVisit']),
                Colors.purple,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Contact Info
          Row(
            children: [
              Icon(
                Icons.phone,
                size: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _patientData['phone'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.emergency,
                size: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _patientData['emergencyContact'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVisitsTab() {
    final l10n = AppLocalizations.of(context);
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text(_error!));
    }
    if (_visits.isEmpty) {
      return Center(
          child: Text(
              l10n?.caregiverPatientOverviewNoVisits ??
                  'No visits available'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _visits.length,
      itemBuilder: (context, index) {
        final visit = _visits[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.medical_services,
                color: Colors.white,
              ),
            ),
            title: Text(
              '${visit['doctor']} - ${visit['type']}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(visit['date']),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Text(
                  visit['summary'],
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.8),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
            ),
            onTap: () => _viewVisitDetails(visit),
          ),
        );
      },
    );
  }

  Widget _buildRemindersTab() {
    final l10n = AppLocalizations.of(context);
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text(_error!));
    }
    if (_reminders.isEmpty) {
      return Center(
          child: Text(
              l10n?.caregiverPatientOverviewNoReminders ??
                  'No reminders available'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _reminders.length,
      itemBuilder: (context, index) {
        final reminder = _reminders[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getReminderTypeColor(reminder['type']).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getReminderTypeIcon(reminder['type']),
                color: _getReminderTypeColor(reminder['type']),
              ),
            ),
            title: Text(
              reminder['title'],
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (reminder['dosage'] != null)
                  Text(
                    '${reminder['dosage']} • ${reminder['frequency']}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                Text(
                  'Next: ${_formatDateTime(reminder['nextDue'])} • ${reminder['adherence']}% adherence',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.8),
                  ),
                ),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getReminderStatusColor(reminder['status'])
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                reminder['status'].toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  color: _getReminderStatusColor(reminder['status']),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            onTap: () => _viewReminderDetails(reminder),
          ),
        );
      },
    );
  }

  Widget _buildNotesTab() {
    final l10n = AppLocalizations.of(context);
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text(_error!));
    }
    if (_notes.isEmpty) {
      return Center(
          child: Text(
              l10n?.caregiverPatientOverviewNoNotes ??
                  'No notes available'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _notes.length,
      itemBuilder: (context, index) {
        final note = _notes[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getNotePriorityColor(note['priority']).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.note,
                color: _getNotePriorityColor(note['priority']),
              ),
            ),
            title: Text(
              note['title'],
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note['content'],
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      note['author'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '•',
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatDate(note['date']),
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
              ],
            ),
            trailing: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: _getNotePriorityColor(note['priority']),
                shape: BoxShape.circle,
              ),
            ),
            onTap: () => _viewNoteDetails(note),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _editPatient() {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(l10n?.caregiverPatientOverviewEditComingSoon ??
              'Edit Patient - Coming Soon!')),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.phone),
            title: Text(
                AppLocalizations.of(context)?.caregiverPatientOverviewCallPatient ??
                    'Call Patient'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.message),
            title: Text(
                AppLocalizations.of(context)?.caregiverPatientOverviewSendMessage ??
                    'Send Message'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.emergency),
            title: Text(
                AppLocalizations.of(context)?.caregiverPatientOverviewEmergencyContact ??
                    'Emergency Contact'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: Text(
                AppLocalizations.of(context)?.caregiverPatientOverviewSharePatientInfo ??
                    'Share Patient Info'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _addNewItem() {
    final l10n = AppLocalizations.of(context);
    switch (_tabController.index) {
      case 0: // Visits
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(l10n?.caregiverPatientOverviewScheduleAppointment ??
                  'Schedule New Appointment - Coming Soon!')),
        );
        break;
      case 1: // Reminders
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(l10n?.caregiverPatientOverviewAddReminder ??
                  'Add New Reminder - Coming Soon!')),
        );
        break;
      case 2: // Notes
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(l10n?.caregiverPatientOverviewAddNote ??
                  'Add New Note - Coming Soon!')),
        );
        break;
    }
  }

  void _viewVisitDetails(Map<String, dynamic> visit) {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(l10n?.caregiverPatientOverviewViewVisitDetails(
                  visit['type']) ??
              'View ${visit['type']} details - Coming Soon!')),
    );
  }

  void _viewReminderDetails(Map<String, dynamic> reminder) {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(l10n?.caregiverPatientOverviewViewReminderDetails(
                  reminder['title']) ??
              'View ${reminder['title']} details - Coming Soon!')),
    );
  }

  void _viewNoteDetails(Map<String, dynamic> note) {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(l10n?.caregiverPatientOverviewViewNoteDetails(
                  note['title']) ??
              'View ${note['title']} details - Coming Soon!')),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
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

  IconData _getStatusIcon(String status) {
    switch (status) {
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

  Color _getReminderTypeColor(String type) {
    switch (type) {
      case 'medication':
        return Colors.blue;
      case 'appointment':
        return Colors.purple;
      case 'measurement':
        return Colors.green;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  IconData _getReminderTypeIcon(String type) {
    switch (type) {
      case 'medication':
        return Icons.medication;
      case 'appointment':
        return Icons.calendar_today;
      case 'measurement':
        return Icons.monitor_heart;
      default:
        return Icons.notifications;
    }
  }

  Color _getReminderStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'upcoming':
        return Colors.blue;
      case 'overdue':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getNotePriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  IconData _getFabIcon() {
    switch (_tabController.index) {
      case 0:
        return Icons.add_alarm; // For scheduling appointments
      case 1:
        return Icons.notification_add; // For adding reminders
      case 2:
        return Icons.note_add; // For adding notes
      default:
        return Icons.add;
    }
  }

  String _formatLastVisit(DateTime lastVisit) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final difference = now.difference(lastVisit).inDays;

    if (difference == 0) {
      return l10n?.caregiverPatientsLastVisitToday ?? 'Today';
    } else if (difference == 1) {
      return l10n?.caregiverPatientsLastVisitYesterday ?? 'Yesterday';
    } else if (difference < 7) {
      return l10n?.caregiverPatientsLastVisitDays(difference) ??
          '$difference days ago';
    } else if (difference < 30) {
      final weeks = (difference / 7).floor();
      return l10n?.caregiverPatientsLastVisitWeeks(weeks) ??
          '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else {
      final months = (difference / 30).floor();
      return l10n?.caregiverPatientsLastVisitMonths(months) ??
          '$months month${months > 1 ? 's' : ''} ago';
    }
  }

  String _formatDate(DateTime date) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return l10n?.caregiverPatientsLastVisitToday ?? 'Today';
    } else if (difference == 1) {
      return l10n?.caregiverPatientsLastVisitYesterday ?? 'Yesterday';
    } else if (difference < 7) {
      return l10n?.caregiverPatientsLastVisitDays(difference) ??
          '$difference days ago';
    } else {
      return MaterialLocalizations.of(context).formatMediumDate(date);
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.isNegative) {
      return l10n?.caregiverPatientOverviewOverdue ?? 'Overdue';
    } else if (difference.inHours < 24) {
      return l10n?.caregiverPatientOverviewInHours(difference.inHours) ??
          'In ${difference.inHours} hours';
    } else {
      final dateText =
          MaterialLocalizations.of(context).formatMediumDate(dateTime);
      final timeText = MaterialLocalizations.of(context).formatTimeOfDay(
        TimeOfDay.fromDateTime(dateTime),
        alwaysUse24HourFormat: MediaQuery.of(context).alwaysUse24HourFormat,
      );
      return '$dateText $timeText';
    }
  }

  Map<String, dynamic> _buildPatientData(List<Map<String, dynamic>> visits) {
    final l10n = AppLocalizations.of(context);
    return {
      'id': _patientId ?? '',
      'name': _patientId ?? '',
      'age': 0,
      'relationship': l10n?.caregiverPatientOverviewDefaultRelationship ??
          'Care Team',
      'condition': l10n?.caregiverPatientOverviewDefaultCondition ??
          'Authorized access',
      'status': 'active',
      'phone': '',
      'emergencyContact': '',
      'address': '',
      'primaryCarePhysician': '',
      'lastVisit': visits.isNotEmpty ? visits.first['date'] : DateTime.now(),
      'medicationAdherence': 0,
      'upcomingAppointments': 0,
    };
  }

  Map<String, dynamic> _mapSummaryToVisit(SummaryItem summary) {
    final dateSource = summary.visitDate ?? summary.summaryCreatedAt;
    final parsedDate = DateTime.tryParse(dateSource) ?? DateTime.now();
    return {
      'id': summary.visitId,
      'doctor': summary.doctorName,
      'specialty': summary.specialty,
      'date': parsedDate,
      'type': summary.specialty.isNotEmpty ? summary.specialty : 'Visit',
      'summary': summary.summaryPreview,
      'nextAppointment': parsedDate,
    };
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverAppBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
