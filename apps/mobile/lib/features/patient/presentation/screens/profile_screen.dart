import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
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

                  // Profile Header
                  _buildProfileHeader(),

                  const SizedBox(height: 32),

                  // Account Settings
                  const SectionHeader(
                    title: 'Account Settings',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 16),

                  _buildAccountSettings(),

                  const SizedBox(height: 32),

                  // Health Preferences
                  const SectionHeader(
                    title: 'Health Preferences',
                    icon: Icons.health_and_safety,
                  ),
                  const SizedBox(height: 16),

                  _buildHealthPreferences(),

                  const SizedBox(height: 32),

                  // Notification Settings
                  const SectionHeader(
                    title: 'Notifications',
                    icon: Icons.notifications,
                  ),
                  const SizedBox(height: 16),

                  _buildNotificationSettings(),

                  const SizedBox(height: 32),

                  // Accessibility
                  const SectionHeader(
                    title: 'Accessibility',
                    icon: Icons.accessibility,
                  ),
                  const SizedBox(height: 16),

                  _buildAccessibilitySettings(),

                  const SizedBox(height: 32),

                  // Subscription
                  const SectionHeader(
                    title: 'Subscription',
                    icon: Icons.subscriptions,
                  ),
                  const SizedBox(height: 16),

                  _buildSubscriptionInfo(),

                  const SizedBox(height: 32),

                  // Support & Legal
                  const SectionHeader(
                    title: 'Support & Legal',
                    icon: Icons.help,
                  ),
                  const SizedBox(height: 16),

                  _buildSupportSection(),

                  const SizedBox(height: 32),

                  // Sign Out
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implement sign out
                        context.go('/login');
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Sign Out'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),

          // Rounded Navigation Bar
          RoundedNavigationBar(currentItem: NavigationItem.profile),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
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
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(35),
            ),
            child: Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.primary,
              size: 35,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'John Doe',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'john.doe@email.com',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Premium Member',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: Edit profile
            },
            icon: Icon(
              Icons.edit,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSettings() {
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
          _buildSettingItem(
            'Personal Information',
            'Update your name, email, and contact details',
            Icons.person_outline,
            () {},
          ),
          const Divider(),
          _buildSettingItem(
            'Security',
            'Change password and security settings',
            Icons.security,
            () {},
          ),
          const Divider(),
          _buildSettingItem(
            'Privacy',
            'Manage data sharing and privacy preferences',
            Icons.privacy_tip,
            () {},
          ),
        ],
      ),
    );
  }

  Widget _buildHealthPreferences() {
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
          _buildSettingItem(
            'Medical Conditions',
            'Manage your health conditions and allergies',
            Icons.medical_services,
            () {},
          ),
          const Divider(),
          _buildSettingItem(
            'Emergency Information',
            'Update emergency contacts and medical info',
            Icons.emergency,
            () {
              context.go('/patient/emergency-contacts');
            },
          ),
          const Divider(),
          _buildSettingItem(
            'Medication Preferences',
            'Set medication reminders and preferences',
            Icons.medication,
            () {},
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings() {
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
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Push Notifications'),
            subtitle:
                const Text('Receive medication and appointment reminders'),
            trailing: Switch(
              value: true,
              onChanged: (value) {},
              activeColor: Theme.of(context).colorScheme.primary,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('Email Notifications'),
            subtitle: const Text('Receive updates via email'),
            trailing: Switch(
              value: false,
              onChanged: (value) {},
              activeColor: Theme.of(context).colorScheme.primary,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.sms),
            title: const Text('SMS Notifications'),
            subtitle: const Text('Receive critical alerts via SMS'),
            trailing: Switch(
              value: true,
              onChanged: (value) {},
              activeColor: Theme.of(context).colorScheme.primary,
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Advanced Settings'),
            subtitle: const Text('Customize notification preferences'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              context.go('/patient/notifications');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAccessibilitySettings() {
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
          ListTile(
            leading: const Icon(Icons.text_fields),
            title: const Text('Text Size'),
            subtitle: const Text('Large text for better readability'),
            trailing: Switch(
              value: false,
              onChanged: (value) {},
              activeColor: Theme.of(context).colorScheme.primary,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.volume_up),
            title: const Text('Voice Guidance'),
            subtitle: const Text('Audio assistance for navigation'),
            trailing: Switch(
              value: false,
              onChanged: (value) {},
              activeColor: Theme.of(context).colorScheme.primary,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.contrast),
            title: const Text('High Contrast'),
            subtitle: const Text('Enhanced contrast for better visibility'),
            trailing: Switch(
              value: false,
              onChanged: (value) {},
              activeColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionInfo() {
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Premium Plan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Active until Dec 31, 2024',
                      style: TextStyle(
                        fontSize: 14,
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
          const SizedBox(height: 16),
          const Text(
            'Features included:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '• Unlimited visit recordings\n• Advanced health analytics\n• Priority support\n• Family caregiver accounts',
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Manage Plan'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Upgrade'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection() {
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
          _buildSettingItem(
            'Help Center',
            'FAQs, tutorials, and support articles',
            Icons.help_outline,
            () {},
          ),
          const Divider(),
          _buildSettingItem(
            'Contact Support',
            'Get help from our support team',
            Icons.support_agent,
            () {},
          ),
          const Divider(),
          _buildSettingItem(
            'Privacy Policy',
            'How we protect and use your data',
            Icons.privacy_tip,
            () {},
          ),
          const Divider(),
          _buildSettingItem(
            'Terms of Service',
            'Legal terms and conditions',
            Icons.description,
            () {},
          ),
          const Divider(),
          ListTile(
            title: Text(
              'App Version',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            trailing: Text(
              '1.0.0',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
