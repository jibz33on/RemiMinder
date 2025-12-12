import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VisitDetailsScreen extends StatefulWidget {
  const VisitDetailsScreen({super.key});

  @override
  State<VisitDetailsScreen> createState() => _VisitDetailsScreenState();
}

class _VisitDetailsScreenState extends State<VisitDetailsScreen> {
  bool _isExpanded = false;

  // Mock visit data (would come from API/navigation params)
  final Map<String, dynamic> _visitData = {
    'id': 'visit_001',
    'doctor': 'Dr. Sarah Johnson',
    'specialty': 'Cardiology',
    'date': '2024-12-12',
    'time': '10:30 AM',
    'duration': '45 minutes',
    'location': 'City Medical Center - Room 204',
    'transcript': '''
Doctor: Good morning, John. How have you been feeling since our last visit?

Patient: I've been doing okay, but I still get tired easily and sometimes have chest discomfort.

Doctor: I see. Let's check your vitals and go over your recent test results. Your blood pressure is 128/82, which is better than last time. Your cholesterol levels have improved significantly with the medication. The Lisinopril is working well.

Patient: That's good to hear. Should I continue with the same dosage?

Doctor: Yes, continue with Lisinopril 10mg daily. I'd also like you to start monitoring your blood pressure at home twice a week. I've prescribed a home blood pressure monitor.

For your fatigue, I'd like you to increase your Metformin to 750mg twice daily. This should help with your energy levels.

Remember to take your medications at the same time each day. Call me immediately if you experience any severe chest pain or shortness of breath.

Your next appointment is in 3 months. Please don't hesitate to call if you have any concerns.
''',
    'summary':
        'Patient reports improved but still experiences fatigue and occasional chest discomfort. Blood pressure and cholesterol levels show improvement. Adjusted Metformin dosage and added home blood pressure monitoring.',
    'instructions': [
      'Continue Lisinopril 10mg daily',
      'Increase Metformin to 750mg twice daily (morning and evening)',
      'Monitor blood pressure at home twice weekly',
      'Report any severe chest pain or shortness of breath immediately',
      'Return for follow-up in 3 months'
    ],
    'keyTakeaways': [
      'Blood pressure improved to 128/82',
      'Cholesterol levels significantly better',
      'Home monitoring recommended',
      'Medication adjustments made'
    ],
    'remindersCreated': ['Blood Pressure Check', 'Medication Adjustment']
  };

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
          'Visit Details',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.share,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: _shareVisit,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Visit Header
              _buildVisitHeader(),

              const SizedBox(height: 24),

              // Summary Card
              _buildSummaryCard(),

              const SizedBox(height: 24),

              // Doctor's Instructions
              _buildInstructionsCard(),

              const SizedBox(height: 24),

              // Key Takeaways
              _buildKeyTakeawaysCard(),

              const SizedBox(height: 24),

              // Transcript Section
              _buildTranscriptSection(),

              const SizedBox(height: 32),

              // Action Buttons
              _buildActionButtons(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVisitHeader() {
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
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.medical_services,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _visitData['doctor'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      _visitData['specialty'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildHeaderItem(
                  Icons.calendar_today,
                  'Date',
                  _visitData['date'],
                ),
              ),
              Expanded(
                child: _buildHeaderItem(
                  Icons.schedule,
                  'Time',
                  _visitData['time'],
                ),
              ),
              Expanded(
                child: _buildHeaderItem(
                  Icons.timer,
                  'Duration',
                  _visitData['duration'],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _visitData['location'],
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

  Widget _buildHeaderItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard() {
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
                Icons.summarize,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Visit Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _visitData['summary'],
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.secondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionsCard() {
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
                Icons.assignment,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Doctor\'s Instructions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...(_visitData['instructions'] as List<String>).map((instruction) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      instruction,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.secondary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildKeyTakeawaysCard() {
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
                Icons.lightbulb,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Key Takeaways',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                (_visitData['keyTakeaways'] as List<String>).map((takeaway) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  takeaway,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTranscriptSection() {
    return Container(
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
          // Transcript Header
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(
                    Icons.description,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Visit Transcript',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),

          // Transcript Content
          if (_isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                _visitData['transcript'].trim(),
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.secondary,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Primary Action: Create Reminder
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _createReminder,
            icon: const Icon(Icons.add_alarm),
            label: const Text('Create Reminder from Instructions'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Secondary Actions
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _shareVisit,
                icon: const Icon(Icons.share),
                label: const Text('Share'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _exportVisit,
                icon: const Icon(Icons.download),
                label: const Text('Export'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Reminders Created
        if ((_visitData['remindersCreated'] as List).isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Reminders Created',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...(_visitData['remindersCreated'] as List<String>)
                    .map((reminder) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '• $reminder',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green.shade700,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ],
    );
  }

  void _createReminder() {
    // TODO: Navigate to create reminder screen with pre-filled data from instructions
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create Reminder - Coming Soon!')),
    );
  }

  void _shareVisit() {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share Visit Summary - Coming Soon!')),
    );
  }

  void _exportVisit() {
    // TODO: Implement export functionality (PDF, etc.)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export Visit Details - Coming Soon!')),
    );
  }
}
