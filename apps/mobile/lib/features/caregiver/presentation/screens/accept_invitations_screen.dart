import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AcceptInvitationsScreen extends StatefulWidget {
  const AcceptInvitationsScreen({super.key});

  @override
  State<AcceptInvitationsScreen> createState() =>
      _AcceptInvitationsScreenState();
}

class _AcceptInvitationsScreenState extends State<AcceptInvitationsScreen> {
  // Mock pending invitations data
  final List<Map<String, dynamic>> _pendingInvitations = [
    {
      'id': 'inv1',
      'patientName': 'John Doe',
      'patientAge': 68,
      'relationship': 'Father',
      'message':
          'Hi! I\'d like to invite you to help manage my medications and health appointments. Your support would mean the world to me.',
      'sentDate': DateTime.now().subtract(const Duration(days: 2)),
      'patientAvatar': null, // Would be image URL in real app
      'conditions': ['Hypertension', 'Diabetes'],
      'phone': '+1 (555) 123-4567',
    },
    {
      'id': 'inv2',
      'patientName': 'Mary Smith',
      'patientAge': 72,
      'relationship': 'Mother',
      'message':
          'Hello! I need some help keeping track of my medications and doctor appointments. Would you be able to assist me?',
      'sentDate': DateTime.now().subtract(const Duration(days: 5)),
      'patientAvatar': null,
      'conditions': ['Arthritis', 'High Cholesterol'],
      'phone': '+1 (555) 234-5678',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () => context.go('/caregiver/home'),
        ),
        title: const Text(
          'Caregiver Invitations',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _pendingInvitations.isEmpty
          ? _buildEmptyState()
          : _buildInvitationsList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.mail_outline,
            size: 80,
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'No pending invitations',
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'When family members invite you to help\nwith their healthcare, they\'ll appear here',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => context.go('/caregiver/home'),
            icon: const Icon(Icons.home),
            label: const Text('Go to Dashboard'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvitationsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _pendingInvitations.length,
      itemBuilder: (context, index) {
        final invitation = _pendingInvitations[index];
        return _buildInvitationCard(invitation);
      },
    );
  }

  Widget _buildInvitationCard(Map<String, dynamic> invitation) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with patient info
            Row(
              children: [
                // Patient Avatar
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.primary,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                // Patient Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        invitation['patientName'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Text(
                        '${invitation['relationship']} • Age ${invitation['patientAge']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Conditions
                      Wrap(
                        spacing: 6,
                        children: (invitation['conditions'] as List<String>)
                            .map((condition) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              condition,
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Invitation Message
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.blue.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.mail,
                        size: 16,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Invitation Message',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatDate(invitation['sentDate']),
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
                  const SizedBox(height: 12),
                  Text(
                    '"${invitation['message']}"',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.secondary,
                      height: 1.4,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Caregiver Responsibilities Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.amber.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Colors.amber[700],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'What you\'ll be helping with:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.amber[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildResponsibilityItem(
                      'Medication reminders and adherence tracking'),
                  _buildResponsibilityItem(
                      'Appointment scheduling and reminders'),
                  _buildResponsibilityItem('Health monitoring and vital signs'),
                  _buildResponsibilityItem(
                      'Emergency contact and coordination'),
                  _buildResponsibilityItem(
                      'Communication with healthcare providers'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _declineInvitation(invitation),
                    icon: const Icon(Icons.close),
                    label: const Text('Decline'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: Colors.red),
                      foregroundColor: Colors.red,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _acceptInvitation(invitation),
                    icon: const Icon(Icons.check),
                    label: const Text('Accept Invitation'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Contact Info
            Row(
              children: [
                Icon(
                  Icons.phone,
                  size: 16,
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                ),
                const SizedBox(width: 8),
                Text(
                  'Contact: ${invitation['phone']}',
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
          ],
        ),
      ),
    );
  }

  Widget _buildResponsibilityItem(String responsibility) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '•',
            style: TextStyle(
              color: Colors.amber[700],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              responsibility,
              style: TextStyle(
                fontSize: 13,
                color: Colors.amber[700],
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _acceptInvitation(Map<String, dynamic> invitation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
            SizedBox(width: 8),
            Text('Accept Invitation'),
          ],
        ),
        content: Text(
          'Are you sure you want to accept the invitation from ${invitation['patientName']}? '
          'You will become their caregiver and have access to their health information.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _confirmAcceptInvitation(invitation);
            },
            child: const Text('Accept'),
          ),
        ],
      ),
    );
  }

  void _declineInvitation(Map<String, dynamic> invitation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(
              Icons.help_outline,
              color: Colors.orange,
            ),
            SizedBox(width: 8),
            Text('Decline Invitation'),
          ],
        ),
        content: Text(
          'Are you sure you want to decline the invitation from ${invitation['patientName']}? '
          'You can always accept it later if they send another invitation.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _confirmDeclineInvitation(invitation);
            },
            child: const Text('Decline', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _confirmAcceptInvitation(Map<String, dynamic> invitation) {
    setState(() {
      _pendingInvitations.remove(invitation);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Successfully accepted invitation from ${invitation['patientName']}!'),
        action: SnackBarAction(
          label: 'View Patient',
          onPressed: () => context.go('/caregiver/patients'),
        ),
      ),
    );

    // In a real app, this would:
    // 1. Call API to accept invitation
    // 2. Add patient to caregiver's patient list
    // 3. Set up notifications and access permissions
    // 4. Navigate to patient overview or home
  }

  void _confirmDeclineInvitation(Map<String, dynamic> invitation) {
    setState(() {
      _pendingInvitations.remove(invitation);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Invitation from ${invitation['patientName']} declined'),
      ),
    );

    // In a real app, this would call API to decline invitation
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
}
