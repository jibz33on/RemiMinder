import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PatientOverviewScreen extends StatefulWidget {
  const PatientOverviewScreen({super.key});

  @override
  State<PatientOverviewScreen> createState() => _PatientOverviewScreenState();
}

class _PatientOverviewScreenState extends State<PatientOverviewScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock patient data (would come from navigation params)
  final Map<String, dynamic> _patientData = {
    'id': '1',
    'name': 'John Doe',
    'age': 68,
    'relationship': 'Father',
    'condition': 'Hypertension, Diabetes',
    'status': 'active',
    'phone': '+1 (555) 123-4567',
    'emergencyContact': 'Jane Doe (Daughter) - +1 (555) 123-4568',
    'address': '123 Main St, Springfield, IL 62701',
    'primaryCarePhysician': 'Dr. Sarah Johnson',
    'lastVisit': DateTime.now().subtract(const Duration(days: 7)),
    'medicationAdherence': 85,
    'upcomingAppointments': 2,
  };

  // Mock visits data
  final List<Map<String, dynamic>> _visits = [
    {
      'id': 'v1',
      'doctor': 'Dr. Sarah Johnson',
      'specialty': 'Cardiology',
      'date': DateTime.now().subtract(const Duration(days: 7)),
      'type': 'Follow-up',
      'summary': 'Blood pressure stable, medication adjustment discussed',
      'nextAppointment': DateTime.now().add(const Duration(days: 30)),
    },
    {
      'id': 'v2',
      'doctor': 'Dr. Michael Chen',
      'specialty': 'Endocrinology',
      'date': DateTime.now().subtract(const Duration(days: 45)),
      'type': 'Diabetes Management',
      'summary': 'HbA1c improved, metformin dosage optimized',
      'nextAppointment': DateTime.now().add(const Duration(days: 90)),
    },
    {
      'id': 'v3',
      'doctor': 'Dr. Emily Davis',
      'specialty': 'General Practice',
      'date': DateTime.now().subtract(const Duration(days: 120)),
      'type': 'Annual Physical',
      'summary': 'Overall health good, routine checkup completed',
      'nextAppointment': DateTime.now().add(const Duration(days: 245)),
    },
  ];

  // Mock reminders data
  final List<Map<String, dynamic>> _reminders = [
    {
      'id': 'r1',
      'title': 'Lisinopril 10mg',
      'type': 'medication',
      'dosage': '10mg',
      'frequency': 'Once daily',
      'nextDue': DateTime.now().add(const Duration(hours: 2)),
      'adherence': 85,
      'status': 'active',
    },
    {
      'id': 'r2',
      'title': 'Metformin 500mg',
      'type': 'medication',
      'dosage': '500mg',
      'frequency': 'Twice daily',
      'nextDue': DateTime.now().add(const Duration(hours: 6)),
      'adherence': 90,
      'status': 'active',
    },
    {
      'id': 'r3',
      'title': 'Blood Pressure Check',
      'type': 'measurement',
      'dosage': null,
      'frequency': 'Twice weekly',
      'nextDue': DateTime.now().add(const Duration(days: 1)),
      'adherence': 75,
      'status': 'active',
    },
    {
      'id': 'r4',
      'title': 'Blood Work',
      'type': 'appointment',
      'dosage': null,
      'frequency': 'Every 3 months',
      'nextDue': DateTime.now().add(const Duration(days: 14)),
      'adherence': 100,
      'status': 'upcoming',
    },
  ];

  // Mock notes data
  final List<Map<String, dynamic>> _notes = [
    {
      'id': 'n1',
      'title': 'Morning Medication Routine',
      'content':
          'Patient reports difficulty remembering morning medications. Suggested using pill organizer and setting phone reminders.',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'author': 'Caregiver',
      'priority': 'medium',
    },
    {
      'id': 'n2',
      'title': 'Blood Pressure Improvement',
      'content':
          'Blood pressure readings have improved since last visit. Continue monitoring twice weekly.',
      'date': DateTime.now().subtract(const Duration(days: 7)),
      'author': 'Dr. Sarah Johnson',
      'priority': 'low',
    },
    {
      'id': 'n3',
      'title': 'Emergency Contact Update',
      'content':
          'Updated emergency contact information. Daughter Jane is primary contact.',
      'date': DateTime.now().subtract(const Duration(days: 14)),
      'author': 'Caregiver',
      'priority': 'high',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              title: const Text(
                'Patient Overview',
                style: TextStyle(
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
                  tabs: const [
                    Tab(text: 'Visits', icon: Icon(Icons.medical_services)),
                    Tab(text: 'Reminders', icon: Icon(Icons.notifications)),
                    Tab(text: 'Notes', icon: Icon(Icons.note)),
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
                'Adherence',
                '${_patientData['medicationAdherence']}%',
                _patientData['medicationAdherence'] >= 80
                    ? Colors.green
                    : Colors.orange,
              ),
              _buildStatItem(
                'Appointments',
                _patientData['upcomingAppointments'].toString(),
                Colors.blue,
              ),
              _buildStatItem(
                'Last Visit',
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
    // TODO: Navigate to edit patient screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit Patient - Coming Soon!')),
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
            title: const Text('Call Patient'),
            onTap: () {
              Navigator.of(context).pop();
              // TODO: Call patient
            },
          ),
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text('Send Message'),
            onTap: () {
              Navigator.of(context).pop();
              // TODO: Send message
            },
          ),
          ListTile(
            leading: const Icon(Icons.emergency),
            title: const Text('Emergency Contact'),
            onTap: () {
              Navigator.of(context).pop();
              // TODO: Call emergency contact
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share Patient Info'),
            onTap: () {
              Navigator.of(context).pop();
              // TODO: Share patient information
            },
          ),
        ],
      ),
    );
  }

  void _addNewItem() {
    switch (_tabController.index) {
      case 0: // Visits
        // TODO: Schedule new appointment
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Schedule New Appointment - Coming Soon!')),
        );
        break;
      case 1: // Reminders
        // TODO: Add new reminder
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Add New Reminder - Coming Soon!')),
        );
        break;
      case 2: // Notes
        // TODO: Add new note
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Add New Note - Coming Soon!')),
        );
        break;
    }
  }

  void _viewVisitDetails(Map<String, dynamic> visit) {
    // TODO: Navigate to visit details
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('View ${visit['type']} details - Coming Soon!')),
    );
  }

  void _viewReminderDetails(Map<String, dynamic> reminder) {
    // TODO: Navigate to reminder details
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('View ${reminder['title']} details - Coming Soon!')),
    );
  }

  void _viewNoteDetails(Map<String, dynamic> note) {
    // TODO: Navigate to note details
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('View ${note['title']} details - Coming Soon!')),
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
    final now = DateTime.now();
    final difference = now.difference(lastVisit).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else if (difference < 30) {
      final weeks = (difference / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else {
      final months = (difference / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.isNegative) {
      return 'Overdue';
    } else if (difference.inHours < 24) {
      return 'In ${difference.inHours} hours';
    } else {
      return '${dateTime.month}/${dateTime.day} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
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
