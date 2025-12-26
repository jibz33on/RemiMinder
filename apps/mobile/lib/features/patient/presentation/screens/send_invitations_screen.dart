import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SendInvitationsScreen extends StatefulWidget {
  const SendInvitationsScreen({super.key});

  @override
  State<SendInvitationsScreen> createState() => _SendInvitationsScreenState();
}

class _SendInvitationsScreenState extends State<SendInvitationsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  String _selectedRelationship = 'Family Member';

  // Mock caregivers data
  final List<Map<String, dynamic>> _caregivers = [
    {
      'id': '1',
      'name': 'Jane Doe',
      'email': 'jane.doe@email.com',
      'relationship': 'Sister',
      'status': 'accepted',
      'invitedDate': DateTime.now().subtract(const Duration(days: 30)),
      'acceptedDate': DateTime.now().subtract(const Duration(days: 25)),
      'permissions': ['view_medications', 'view_visits', 'view_health_data'],
      'lastActivity': DateTime.now().subtract(const Duration(hours: 2)),
      'activityCount': 45,
    },
    {
      'id': '2',
      'name': 'Mike Johnson',
      'email': 'mike.johnson@email.com',
      'relationship': 'Friend',
      'status': 'pending',
      'invitedDate': DateTime.now().subtract(const Duration(days: 5)),
      'permissions': [],
      'lastActivity': null,
      'activityCount': 0,
    },
    {
      'id': '3',
      'name': 'Dr. Emily Chen',
      'email': 'dr.chen@hospital.com',
      'relationship': 'Healthcare Professional',
      'status': 'accepted',
      'invitedDate': DateTime.now().subtract(const Duration(days: 15)),
      'acceptedDate': DateTime.now().subtract(const Duration(days: 12)),
      'permissions': [
        'view_medications',
        'view_visits',
        'view_health_data',
        'edit_medications',
        'manage_emergency'
      ],
      'lastActivity': DateTime.now().subtract(const Duration(hours: 6)),
      'activityCount': 23,
    },
  ];

  final List<String> _relationshipOptions = [
    'Family Member',
    'Friend',
    'Spouse/Partner',
    'Parent',
    'Child',
    'Healthcare Professional',
    'Caregiver',
    'Other',
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
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
          'Caregivers',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: _showAddCaregiverDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Current Caregivers Section
            Expanded(
              child: _caregivers.isEmpty
                  ? _buildEmptyState()
                  : ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        _buildSectionHeader('My Caregivers'),
                        const SizedBox(height: 16),
                        ..._caregivers
                            .map((caregiver) => _buildCaregiverCard(caregiver)),
                      ],
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCaregiverDialog,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.person_add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'No caregivers yet',
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Invite family members or friends\nto help manage your healthcare',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _showAddCaregiverDialog,
            icon: const Icon(Icons.person_add),
            label: const Text('Invite First Caregiver'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Icon(
          Icons.people,
          color: Theme.of(context).colorScheme.primary,
          size: 24,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildCaregiverCard(Map<String, dynamic> caregiver) {
    final status = caregiver['status'] as String;
    final relationship = caregiver['relationship'] as String;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Avatar
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                // Caregiver Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        caregiver['name'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Text(
                        caregiver['email'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      Text(
                        relationship,
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
                // Status Badge
                _buildStatusBadge(status),
              ],
            ),
            if (status == 'pending') ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _resendInvitation(caregiver),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      child: const Text('Resend Invite'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _cancelInvitation(caregiver),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                ],
              ),
            ] else if (status == 'accepted') ...[
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Active Caregiver',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Permissions and Activity Row
              Row(
                children: [
                  // Permissions
                  Expanded(
                    child: InkWell(
                      onTap: () => _showPermissionsDialog(caregiver),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.security,
                              color: Colors.blue,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${(caregiver['permissions'] as List).length} perms',
                              style: const TextStyle(
                                fontSize: 9,
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Activity
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.timeline,
                            color: Colors.purple,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${caregiver['activityCount']} acts',
                            style: const TextStyle(
                              fontSize: 9,
                              color: Colors.purple,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (caregiver['lastActivity'] != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Last active: ${_formatLastActivity(caregiver['lastActivity'])}',
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.6),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String text;
    IconData icon;

    switch (status) {
      case 'accepted':
        color = Colors.green;
        text = 'Active';
        icon = Icons.check_circle;
        break;
      case 'pending':
        color = Colors.orange;
        text = 'Pending';
        icon = Icons.schedule;
        break;
      case 'declined':
        color = Colors.red;
        text = 'Declined';
        icon = Icons.cancel;
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
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddCaregiverDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.person_add,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              const Text('Invite Caregiver'),
            ],
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      hintText: 'Enter caregiver\'s full name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      hintText: 'caregiver@example.com',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedRelationship,
                    decoration: const InputDecoration(
                      labelText: 'Relationship',
                    ),
                    items: _relationshipOptions.map((relationship) {
                      return DropdownMenuItem(
                        value: relationship,
                        child: Text(relationship),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRelationship = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _sendInvitation,
              child: const Text('Send Invitation'),
            ),
          ],
        ),
      ),
    );
  }

  void _sendInvitation() {
    if (_formKey.currentState?.validate() ?? false) {
      final newCaregiver = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'relationship': _selectedRelationship,
        'status': 'pending',
        'invitedDate': DateTime.now(),
      };

      setState(() {
        _caregivers.add(newCaregiver);
      });

      // Clear form
      _nameController.clear();
      _emailController.clear();
      _selectedRelationship = 'Family Member';

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invitation sent to ${newCaregiver['name']}!'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _caregivers.remove(newCaregiver);
              });
            },
          ),
        ),
      );
    }
  }

  void _resendInvitation(Map<String, dynamic> caregiver) {
    // TODO: Implement resend invitation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Invitation resent to ${caregiver['name']}')),
    );
  }

  void _cancelInvitation(Map<String, dynamic> caregiver) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Invitation'),
        content: const Text('Are you sure you want to cancel this invitation?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Keep'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _caregivers.remove(caregiver);
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Invitation cancelled')),
              );
            },
            child: const Text('Cancel Invitation',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showPermissionsDialog(Map<String, dynamic> caregiver) {
    final currentPermissions = caregiver['permissions'] as List<String>;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.security,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Permissions for ${caregiver['name']}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPermissionItem(
                  'View Medications',
                  'Can see medication schedules and history',
                  'view_medications',
                  currentPermissions,
                  (updated) =>
                      setState(() => _updatePermissions(caregiver, updated)),
                ),
                _buildPermissionItem(
                  'View Visit Records',
                  'Can access visit summaries and transcripts',
                  'view_visits',
                  currentPermissions,
                  (updated) =>
                      setState(() => _updatePermissions(caregiver, updated)),
                ),
                _buildPermissionItem(
                  'View Health Data',
                  'Can see health metrics and trends',
                  'view_health_data',
                  currentPermissions,
                  (updated) =>
                      setState(() => _updatePermissions(caregiver, updated)),
                ),
                _buildPermissionItem(
                  'Edit Medications',
                  'Can modify medication schedules',
                  'edit_medications',
                  currentPermissions,
                  (updated) =>
                      setState(() => _updatePermissions(caregiver, updated)),
                ),
                _buildPermissionItem(
                  'Manage Emergency Contacts',
                  'Can modify emergency contact settings',
                  'manage_emergency',
                  currentPermissions,
                  (updated) =>
                      setState(() => _updatePermissions(caregiver, updated)),
                ),
                _buildPermissionItem(
                  'Receive Alerts',
                  'Gets notified of important health events',
                  'receive_alerts',
                  currentPermissions,
                  (updated) =>
                      setState(() => _updatePermissions(caregiver, updated)),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionItem(
    String title,
    String description,
    String permissionKey,
    List<String> currentPermissions,
    Function(List<String>) onChanged,
  ) {
    final hasPermission = currentPermissions.contains(permissionKey);

    return CheckboxListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      subtitle: Text(
        description,
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
        ),
      ),
      value: hasPermission,
      onChanged: (value) {
        final updated = List<String>.from(currentPermissions);
        if (value == true) {
          updated.add(permissionKey);
        } else {
          updated.remove(permissionKey);
        }
        onChanged(updated);
      },
      activeColor: Theme.of(context).colorScheme.primary,
      contentPadding: EdgeInsets.zero,
    );
  }

  void _updatePermissions(
      Map<String, dynamic> caregiver, List<String> newPermissions) {
    setState(() {
      caregiver['permissions'] = newPermissions;
    });
  }

  String _formatLastActivity(DateTime lastActivity) {
    final now = DateTime.now();
    final difference = now.difference(lastActivity);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
