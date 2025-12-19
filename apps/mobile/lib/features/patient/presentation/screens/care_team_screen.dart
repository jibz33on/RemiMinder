import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/widgets.dart';

class CareTeamScreen extends StatefulWidget {
  const CareTeamScreen({super.key});

  @override
  State<CareTeamScreen> createState() => _CareTeamScreenState();
}

class _CareTeamScreenState extends State<CareTeamScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Care Team',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.person_add,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              context.go('/patient/invitations');
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // Care Team Overview
                  Container(
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
                        Row(
                          children: [
                            Icon(
                              Icons.people,
                              color: Theme.of(context).colorScheme.primary,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Your Care Team',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildTeamStat('Active', '3', Colors.green),
                            _buildTeamStat('Pending', '1', Colors.orange),
                            _buildTeamStat('Invites', '5', Colors.blue),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Active Caregivers
                  const SectionHeader(
                    title: 'Active Caregivers',
                    icon: Icons.verified_user,
                  ),
                  const SizedBox(height: 16),

                  _buildActiveCaregivers(),

                  const SizedBox(height: 32),

                  // Pending Invitations
                  const SectionHeader(
                    title: 'Pending Invitations',
                    icon: Icons.schedule,
                  ),
                  const SizedBox(height: 16),

                  _buildPendingInvitations(),

                  const SizedBox(height: 32),

                  // Emergency Contacts
                  const SectionHeader(
                    title: 'Emergency Contacts',
                    icon: Icons.emergency,
                  ),
                  const SizedBox(height: 16),

                  Container(
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
                        ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.emergency,
                              color: Colors.red,
                            ),
                          ),
                          title: const Text('Emergency Services'),
                          subtitle: const Text('911 - Always available'),
                          trailing: IconButton(
                            icon: const Icon(Icons.call, color: Colors.red),
                            onPressed: () {
                              // TODO: Call emergency
                            },
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.person,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          title: const Text('John Doe (Spouse)'),
                          subtitle: const Text('(555) 123-4567'),
                          trailing: IconButton(
                            icon: Icon(Icons.call),
                            onPressed: () {
                              // TODO: Call contact
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),

          // Rounded Navigation Bar
          RoundedNavigationBar(currentItem: NavigationItem.careTeam),
        ],
      ),
    );
  }

  Widget _buildTeamStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
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
        ),
      ],
    );
  }

  Widget _buildActiveCaregivers() {
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
          _buildCaregiverItem(
            'Jane Doe',
            'Sister',
            'Active',
            Colors.green,
            'Last active 2h ago',
          ),
          const Divider(height: 16),
          _buildCaregiverItem(
            'Dr. Emily Chen',
            'Healthcare Professional',
            'Active',
            Colors.green,
            'Last active 6h ago',
          ),
        ],
      ),
    );
  }

  Widget _buildPendingInvitations() {
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
          _buildCaregiverItem(
            'Mike Johnson',
            'Friend',
            'Pending',
            Colors.orange,
            'Invited 5 days ago',
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                context.go('/patient/invitations');
              },
              icon: const Icon(Icons.person_add),
              label: const Text('Invite New Caregiver'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaregiverItem(
    String name,
    String relationship,
    String status,
    Color statusColor,
    String subtitle,
  ) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(
            Icons.person,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 10,
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                relationship,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            // TODO: Handle menu actions
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'permissions',
              child: Text('Manage Permissions'),
            ),
            const PopupMenuItem(
              value: 'remove',
              child: Text('Remove'),
            ),
          ],
        ),
      ],
    );
  }
}
