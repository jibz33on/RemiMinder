import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Mock reminders data
  final List<Map<String, dynamic>> _allReminders = [
    {
      'id': '1',
      'title': 'Lisinopril 10mg',
      'description': 'Blood pressure medication',
      'scheduledTime': DateTime.now().add(const Duration(hours: 2)),
      'status': 'pending',
      'type': 'medication',
      'dosage': '10mg',
      'frequency': 'Once daily',
      'snoozeCount': 0,
      'snoozeUntil': null,
      'createdAt': DateTime.now().subtract(const Duration(days: 7)),
    },
    {
      'id': '2',
      'title': 'Metformin 500mg',
      'description': 'Diabetes medication',
      'scheduledTime': DateTime.now().add(const Duration(hours: 6)),
      'status': 'pending',
      'type': 'medication',
      'dosage': '500mg',
      'frequency': 'Twice daily',
      'snoozeCount': 1,
      'snoozeUntil': null,
      'createdAt': DateTime.now().subtract(const Duration(days: 5)),
    },
    {
      'id': '3',
      'title': 'Blood Pressure Check',
      'description': 'Home blood pressure monitoring',
      'scheduledTime': DateTime.now().subtract(const Duration(hours: 1)),
      'status': 'completed',
      'type': 'measurement',
      'dosage': null,
      'frequency': 'Twice weekly',
      'snoozeCount': 0,
      'snoozeUntil': null,
      'createdAt': DateTime.now().subtract(const Duration(days: 3)),
    },
    {
      'id': '4',
      'title': 'Atorvastatin 20mg',
      'description': 'Cholesterol medication',
      'scheduledTime': DateTime.now().add(const Duration(hours: 12)),
      'status': 'snoozed',
      'type': 'medication',
      'dosage': '20mg',
      'frequency': 'Once daily',
      'snoozeCount': 2,
      'snoozeUntil': DateTime.now().add(const Duration(hours: 1)),
      'createdAt': DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      'id': '5',
      'title': 'Cardiology Appointment',
      'description': 'Follow-up with Dr. Johnson',
      'scheduledTime': DateTime.now().add(const Duration(days: 2)),
      'status': 'pending',
      'type': 'appointment',
      'dosage': null,
      'frequency': 'Every 3 months',
      'snoozeCount': 0,
      'snoozeUntil': null,
      'createdAt': DateTime.now().subtract(const Duration(days: 1)),
    },
  ];

  List<Map<String, dynamic>> get _filteredReminders {
    var reminders = _allReminders;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      reminders = reminders.where((reminder) {
        final title = reminder['title'].toLowerCase();
        final description = reminder['description'].toLowerCase();
        final query = _searchQuery.toLowerCase();
        return title.contains(query) || description.contains(query);
      }).toList();
    }

    // Apply tab filter
    switch (_tabController.index) {
      case 0: // All
        return reminders;
      case 1: // Today
        return reminders.where((reminder) {
          final scheduledTime = reminder['scheduledTime'] as DateTime;
          final today = DateTime.now();
          return scheduledTime.year == today.year &&
              scheduledTime.month == today.month &&
              scheduledTime.day == today.day;
        }).toList();
      case 2: // Pending
        return reminders
            .where((reminder) => reminder['status'] == 'pending')
            .toList();
      case 3: // Completed
        return reminders
            .where((reminder) => reminder['status'] == 'completed')
            .toList();
      default:
        return reminders;
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          onPressed: () => context.go('/patient/home'),
        ),
        title: const Text(
          'Reminders',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: _toggleSearch,
          ),
          IconButton(
            icon: Icon(
              Icons.bar_chart,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () => _showAdherenceStats(),
          ),
        ],
        bottom: _searchQuery.isEmpty
            ? TabBar(
                controller: _tabController,
                isScrollable: false,
                tabs: const [
                  Tab(text: 'All'),
                  Tab(text: 'Today'),
                  Tab(text: 'Pending'),
                  Tab(text: 'Completed'),
                ],
              )
            : null,
      ),
      body: Column(
        children: [
          // Search Bar (when active)
          if (_searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search reminders...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearSearch,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),

          // Reminders List
          Expanded(
            child: _filteredReminders.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredReminders.length,
                    itemBuilder: (context, index) {
                      final reminder = _filteredReminders[index];
                      return _buildReminderCard(reminder);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewReminder,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildReminderCard(Map<String, dynamic> reminder) {
    final scheduledTime = reminder['scheduledTime'] as DateTime;
    final status = reminder['status'] as String;
    final type = reminder['type'] as String;

    return Dismissible(
      key: Key(reminder['id']),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Reminder'),
            content:
                const Text('Are you sure you want to delete this reminder?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        _deleteReminder(reminder['id']);
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () => _editReminder(reminder),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with type icon and status
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getTypeColor(type).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getTypeIcon(type),
                        color: _getTypeColor(type),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reminder['title'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary,
                              decoration: status == 'completed'
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          Text(
                            reminder['description'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusBadge(status),
                  ],
                ),

                const SizedBox(height: 12),

                // Time and dosage info
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 16,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatTime(scheduledTime),
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    if (reminder['dosage'] != null) ...[
                      const SizedBox(width: 16),
                      Icon(
                        Icons.medication,
                        size: 16,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        reminder['dosage'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ],
                ),

                if (status == 'snoozed' && reminder['snoozeUntil'] != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Snoozed until ${_formatTime(reminder['snoozeUntil'])}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ],

                // Action buttons
                if (status == 'pending' || status == 'snoozed') ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _markAsCompleted(reminder['id']),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          child: const Text('Mark Done'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _snoozeReminder(reminder['id']),
                          child: const Text('Snooze'),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String text;
    IconData icon;

    switch (status) {
      case 'completed':
        color = Colors.green;
        text = 'Done';
        icon = Icons.check_circle;
        break;
      case 'pending':
        color = Colors.blue;
        text = 'Pending';
        icon = Icons.schedule;
        break;
      case 'snoozed':
        color = Colors.orange;
        text = 'Snoozed';
        icon = Icons.snooze;
        break;
      default:
        color = Colors.grey;
        text = 'Unknown';
        icon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty
                ? 'No reminders found'
                : 'No reminders match your search',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty
                ? 'Create your first reminder to get started'
                : 'Try adjusting your search terms',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          if (_searchQuery.isEmpty) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _addNewReminder,
              icon: const Icon(Icons.add),
              label: const Text('Create Reminder'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getTypeColor(String type) {
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

  IconData _getTypeIcon(String type) {
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

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.isNegative) {
      // Past
      final hours = difference.inHours.abs();
      final minutes = difference.inMinutes.abs() % 60;

      if (hours > 24) {
        return '${dateTime.day}/${dateTime.month} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
      } else if (hours > 0) {
        return '$hours hours ago';
      } else {
        return '$minutes minutes ago';
      }
    } else {
      // Future
      final hours = difference.inHours;
      final minutes = difference.inMinutes % 60;

      if (hours > 24) {
        return '${dateTime.day}/${dateTime.month} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
      } else if (hours > 0) {
        return 'In $hours hours';
      } else if (minutes > 0) {
        return 'In $minutes minutes';
      } else {
        return 'Now';
      }
    }
  }

  void _toggleSearch() {
    setState(() {
      if (_searchQuery.isEmpty) {
        _searchQuery = ' '; // Trigger search mode
      } else {
        _clearSearch();
      }
    });
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
    });
  }

  void _addNewReminder() {
    // TODO: Navigate to create reminder screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create New Reminder - Coming Soon!')),
    );
  }

  void _editReminder(Map<String, dynamic> reminder) {
    // TODO: Navigate to edit reminder screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit ${reminder['title']} - Coming Soon!')),
    );
  }

  void _markAsCompleted(String id) {
    setState(() {
      final index = _allReminders.indexWhere((r) => r['id'] == id);
      if (index != -1) {
        _allReminders[index]['status'] = 'completed';
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reminder marked as completed!')),
    );
  }

  void _snoozeReminder(String id) {
    setState(() {
      final index = _allReminders.indexWhere((r) => r['id'] == id);
      if (index != -1) {
        _allReminders[index]['status'] = 'snoozed';
        _allReminders[index]['snoozeUntil'] =
            DateTime.now().add(const Duration(hours: 1));
        _allReminders[index]['snoozeCount'] =
            (_allReminders[index]['snoozeCount'] ?? 0) + 1;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reminder snoozed for 1 hour')),
    );
  }

  void _deleteReminder(String id) {
    setState(() {
      _allReminders.removeWhere((r) => r['id'] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reminder deleted')),
    );
  }

  void _showAdherenceStats() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.bar_chart,
                    color: Theme.of(context).colorScheme.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Medication Adherence',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Stats Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Overall adherence
                    _buildAdherenceStat('This Week', 0.85, '6/7 days'),
                    const SizedBox(height: 16),
                    _buildAdherenceStat('This Month', 0.92, '28/30 days'),
                    const SizedBox(height: 16),
                    _buildAdherenceStat('Overall', 0.88, '89/101 doses'),

                    const SizedBox(height: 32),

                    // Medication breakdown
                    Text(
                      'By Medication',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildMedicationAdherence(
                        'Lisinopril 10mg', 0.95, '19/20 doses'),
                    const SizedBox(height: 12),
                    _buildMedicationAdherence(
                        'Metformin 500mg', 0.80, '16/20 doses'),
                    const SizedBox(height: 12),
                    _buildMedicationAdherence(
                        'Atorvastatin 20mg', 0.90, '18/20 doses'),

                    const SizedBox(height: 32),

                    // Tips
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.lightbulb,
                                color: Colors.blue,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Adherence Tips',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '• Set phone reminders for medication times\n• Keep medications in a visible location\n• Use a pill organizer for daily doses\n• Track your progress to stay motivated',
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdherenceStat(String period, double adherence, String detail) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  period,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  detail,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  value: adherence,
                  backgroundColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    adherence >= 0.9
                        ? Colors.green
                        : Theme.of(context).colorScheme.primary,
                  ),
                  strokeWidth: 6,
                ),
              ),
              Text(
                '${(adherence * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationAdherence(
      String medication, double adherence, String detail) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medication,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  detail,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: adherence >= 0.9
                  ? Colors.green.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${(adherence * 100).toInt()}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: adherence >= 0.9 ? Colors.green : Colors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
