import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AlertListScreen extends StatefulWidget {
  const AlertListScreen({super.key});

  @override
  State<AlertListScreen> createState() => _AlertListScreenState();
}

class _AlertListScreenState extends State<AlertListScreen> {
  String _selectedFilter = 'All';

  // Mock alerts data - comprehensive list
  final List<Map<String, dynamic>> _allAlerts = [
    {
      'id': '1',
      'type': 'medication',
      'message': 'John Doe missed Lisinopril 10mg medication - due 2 hours ago',
      'patient': 'John Doe',
      'patientId': '1',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'priority': 'high',
      'isRead': false,
      'actionRequired': true,
      'category': 'adherence',
    },
    {
      'id': '2',
      'type': 'appointment',
      'message': 'Sarah Johnson has cardiology appointment tomorrow at 2:30 PM',
      'patient': 'Sarah Johnson',
      'patientId': '2',
      'timestamp': DateTime.now().add(const Duration(hours: 6)),
      'priority': 'medium',
      'isRead': true,
      'actionRequired': false,
      'category': 'appointment',
    },
    {
      'id': '3',
      'type': 'measurement',
      'message': 'Mike Chen blood pressure reading is overdue - due yesterday',
      'patient': 'Mike Chen',
      'patientId': '3',
      'timestamp': DateTime.now().subtract(const Duration(hours: 26)),
      'priority': 'high',
      'isRead': false,
      'actionRequired': true,
      'category': 'monitoring',
    },
    {
      'id': '4',
      'type': 'medication',
      'message':
          'Elizabeth Wilson has low medication adherence - 65% this week',
      'patient': 'Elizabeth Wilson',
      'patientId': '4',
      'timestamp': DateTime.now().subtract(const Duration(hours: 4)),
      'priority': 'medium',
      'isRead': false,
      'actionRequired': true,
      'category': 'adherence',
    },
    {
      'id': '5',
      'type': 'visit',
      'message':
          'David Brown completed doctor visit - review summary available',
      'patient': 'David Brown',
      'patientId': '5',
      'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
      'priority': 'low',
      'isRead': true,
      'actionRequired': false,
      'category': 'visit',
    },
    {
      'id': '6',
      'type': 'emergency',
      'message':
          'Robert Johnson reported chest discomfort - emergency contact notified',
      'patient': 'Robert Johnson',
      'patientId': '3',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
      'priority': 'critical',
      'isRead': false,
      'actionRequired': true,
      'category': 'emergency',
    },
    {
      'id': '7',
      'type': 'lab',
      'message': 'Mary Smith lab results are ready for review',
      'patient': 'Mary Smith',
      'patientId': '2',
      'timestamp': DateTime.now().subtract(const Duration(hours: 8)),
      'priority': 'medium',
      'isRead': true,
      'actionRequired': false,
      'category': 'lab',
    },
    {
      'id': '8',
      'type': 'medication',
      'message': 'John Doe medication refill reminder - 5 days remaining',
      'patient': 'John Doe',
      'patientId': '1',
      'timestamp': DateTime.now().add(const Duration(days: 2)),
      'priority': 'low',
      'isRead': false,
      'actionRequired': false,
      'category': 'refill',
    },
  ];

  List<Map<String, dynamic>> get _filteredAlerts {
    var alerts = _allAlerts;

    switch (_selectedFilter) {
      case 'Unread':
        alerts = alerts.where((alert) => !alert['isRead']).toList();
        break;
      case 'Read':
        alerts = alerts.where((alert) => alert['isRead']).toList();
        break;
      case 'High Priority':
        alerts = alerts
            .where((alert) =>
                alert['priority'] == 'high' || alert['priority'] == 'critical')
            .toList();
        break;
      case 'Action Required':
        alerts = alerts.where((alert) => alert['actionRequired']).toList();
        break;
      case 'All':
      default:
        // Return all alerts
        break;
    }

    // Sort by priority (critical > high > medium > low) then by timestamp (newest first)
    alerts.sort((a, b) {
      final priorityOrder = {'critical': 4, 'high': 3, 'medium': 2, 'low': 1};
      final aPriority = priorityOrder[a['priority']] ?? 0;
      final bPriority = priorityOrder[b['priority']] ?? 0;

      if (aPriority != bPriority) {
        return bPriority.compareTo(aPriority); // Higher priority first
      }

      // If same priority, sort by timestamp (newest first)
      return (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime);
    });

    return alerts;
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _allAlerts.where((alert) => !alert['isRead']).length;

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
          onPressed: () => context.go('/caregiver/home'),
        ),
        title: const Text(
          'Alerts',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (unreadCount > 0)
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$unreadCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter Tabs
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                _buildFilterChip('All'),
                _buildFilterChip('Unread'),
                _buildFilterChip('Read'),
                _buildFilterChip('High Priority'),
              ],
            ),
          ),

          // Results Summary
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '${_filteredAlerts.length} ${_filteredAlerts.length == 1 ? 'Alert' : 'Alerts'}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                if (_selectedFilter != 'All') ...[
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getFilterColor(_selectedFilter).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _selectedFilter,
                      style: TextStyle(
                        fontSize: 12,
                        color: _getFilterColor(_selectedFilter),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                if (_selectedFilter != 'All')
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedFilter = 'All';
                      });
                    },
                    child: const Text('Clear Filter'),
                  ),
              ],
            ),
          ),

          // Alerts List
          Expanded(
            child: _filteredAlerts.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredAlerts.length,
                    itemBuilder: (context, index) {
                      final alert = _filteredAlerts[index];
                      return _buildAlertCard(alert);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _markAllAsRead,
        backgroundColor: Theme.of(context).colorScheme.primary,
        tooltip: 'Mark all as read',
        child: const Icon(Icons.done_all),
      ),
    );
  }

  Widget _buildFilterChip(String filter) {
    final isSelected = _selectedFilter == filter;
    final count = _getFilterCount(filter);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedFilter = filter;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                filter,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context).colorScheme.secondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              if (count > 0)
                Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 10,
                    color: isSelected
                        ? Colors.white.withOpacity(0.8)
                        : Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> alert) {
    final isRead = alert['isRead'] as bool;
    final priority = alert['priority'] as String;
    final type = alert['type'] as String;
    final actionRequired = alert['actionRequired'] as bool;

    return Dismissible(
      key: Key(alert['id']),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: isRead ? Colors.blue : Colors.green,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          isRead ? Icons.markunread : Icons.done,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          _toggleReadStatus(alert['id']);
          return false; // Don't dismiss, just toggle read status
        }
        return false;
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: isRead ? 1 : 2,
        color: isRead ? Colors.white : Colors.blue.withOpacity(0.05),
        child: InkWell(
          onTap: () => _viewAlertDetails(alert),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    // Priority Indicator
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _getPriorityColor(priority),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Alert Type Icon
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: _getTypeColor(type).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getTypeIcon(type),
                        color: _getTypeColor(type),
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Patient Name
                    Expanded(
                      child: Text(
                        alert['patient'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),

                    // Time and Status
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _formatTime(alert['timestamp']),
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.7),
                          ),
                        ),
                        if (!isRead)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Alert Message
                Text(
                  alert['message'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.secondary,
                    height: 1.4,
                    fontWeight: isRead ? FontWeight.normal : FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 12),

                // Action Indicators
                Row(
                  children: [
                    // Priority Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(priority).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        priority.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          color: _getPriorityColor(priority),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Category Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        alert['category'].toString().toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Action Required Indicator
                    if (actionRequired)
                      const Row(
                        children: [
                          Icon(
                            Icons.warning,
                            size: 14,
                            color: Colors.orange,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Action Required',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),

                // Quick Actions
                if (!isRead) ...[
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _markAsRead(alert['id']),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                          ),
                          child: const Text('Mark Read',
                              style: TextStyle(fontSize: 12)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _takeAction(alert),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                          ),
                          child: const Text('Take Action',
                              style: TextStyle(fontSize: 12)),
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
          const SizedBox(height: 24),
          Text(
            _selectedFilter == 'All'
                ? 'No alerts at this time'
                : 'No alerts match this filter',
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _selectedFilter == 'All'
                ? 'All patient activities are running smoothly'
                : 'Try adjusting your filter to see more alerts',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          if (_selectedFilter != 'All') ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedFilter = 'All';
                });
              },
              child: const Text('View All Alerts'),
            ),
          ],
        ],
      ),
    );
  }

  void _markAsRead(String alertId) {
    setState(() {
      final index = _allAlerts.indexWhere((alert) => alert['id'] == alertId);
      if (index != -1) {
        _allAlerts[index]['isRead'] = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Alert marked as read')),
    );
  }

  void _toggleReadStatus(String alertId) {
    setState(() {
      final index = _allAlerts.indexWhere((alert) => alert['id'] == alertId);
      if (index != -1) {
        final currentStatus = _allAlerts[index]['isRead'] as bool;
        _allAlerts[index]['isRead'] = !currentStatus;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Alert marked as ${!currentStatus ? 'read' : 'unread'}')),
        );
      }
    });
  }

  void _markAllAsRead() {
    final unreadAlerts = _allAlerts.where((alert) => !alert['isRead']).toList();
    if (unreadAlerts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All alerts are already read')),
      );
      return;
    }

    setState(() {
      for (var alert in unreadAlerts) {
        alert['isRead'] = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Marked ${unreadAlerts.length} alerts as read')),
    );
  }

  void _takeAction(Map<String, dynamic> alert) {
    // Navigate based on alert type and patient
    final type = alert['type'];
    final patientId = alert['patientId'];

    switch (type) {
      case 'medication':
        context
            .go('/caregiver/patient-overview'); // Navigate to patient reminders
        break;
      case 'appointment':
        context.go('/caregiver/patient-overview'); // Navigate to patient visits
        break;
      case 'measurement':
        context
            .go('/caregiver/patient-overview'); // Navigate to patient reminders
        break;
      default:
        _viewAlertDetails(alert);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Taking action on ${alert['type']} alert')),
    );
  }

  void _viewAlertDetails(Map<String, dynamic> alert) {
    // TODO: Navigate to detailed alert view
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('View details for ${alert['type']} alert')),
    );
  }

  int _getFilterCount(String filter) {
    switch (filter) {
      case 'Unread':
        return _allAlerts.where((alert) => !alert['isRead']).length;
      case 'Read':
        return _allAlerts.where((alert) => alert['isRead']).length;
      case 'High Priority':
        return _allAlerts
            .where((alert) =>
                alert['priority'] == 'high' || alert['priority'] == 'critical')
            .length;
      case 'Action Required':
        return _allAlerts.where((alert) => alert['actionRequired']).length;
      default:
        return _allAlerts.length;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'critical':
        return Colors.red;
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'medication':
        return Colors.blue;
      case 'appointment':
        return Colors.purple;
      case 'measurement':
        return Colors.green;
      case 'visit':
        return Colors.teal;
      case 'lab':
        return Colors.indigo;
      case 'emergency':
        return Colors.red;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  Color _getFilterColor(String filter) {
    switch (filter) {
      case 'Unread':
        return Colors.blue;
      case 'Read':
        return Colors.green;
      case 'High Priority':
        return Colors.red;
      case 'Action Required':
        return Colors.orange;
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
      case 'visit':
        return Icons.medical_services;
      case 'lab':
        return Icons.science;
      case 'emergency':
        return Icons.emergency;
      default:
        return Icons.notifications;
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.isNegative) {
      final hours = difference.inHours.abs();
      return 'In $hours${hours == 1 ? 'hr' : 'hrs'}';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
