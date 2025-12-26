import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/widgets.dart';

class HistoryListScreen extends StatefulWidget {
  const HistoryListScreen({super.key});

  @override
  State<HistoryListScreen> createState() => _HistoryListScreenState();
}

class _HistoryListScreenState extends State<HistoryListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'History',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              // TODO: Implement advanced filters
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // Search Box
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search events, documents, visits...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                ),

                // Tabs
                TabBar(
                  controller: _tabController,
                  isScrollable: false,
                  labelColor: Theme.of(context).colorScheme.primary,
                  unselectedLabelColor: Theme.of(context).colorScheme.secondary,
                  indicatorColor: Theme.of(context).colorScheme.primary,
                  indicatorWeight: 3,
                  tabs: const [
                    Tab(text: 'ALL'),
                    Tab(text: 'SCANNED DOCS'),
                    Tab(text: 'LAB RESULTS'),
                  ],
                ),

                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildAllEvents(),
                      _buildScannedDocuments(),
                      _buildLabResults(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Rounded Navigation Bar
          const RoundedNavigationBar(currentItem: NavigationItem.history),
        ],
      ),
    );
  }

  Widget _buildAllEvents() {
    final events = _getAllEvents();
    final filteredEvents = _searchQuery.isEmpty
        ? events
        : events
            .where((event) =>
                event.title.toLowerCase().contains(_searchQuery) ||
                event.description.toLowerCase().contains(_searchQuery) ||
                event.type.toLowerCase().contains(_searchQuery))
            .toList();

    return _buildEventList(filteredEvents);
  }

  Widget _buildScannedDocuments() {
    final events = _getAllEvents()
        .where((event) =>
            event.category == 'document' || event.type.contains('scan'))
        .toList();
    final filteredEvents = _searchQuery.isEmpty
        ? events
        : events
            .where((event) =>
                event.title.toLowerCase().contains(_searchQuery) ||
                event.description.toLowerCase().contains(_searchQuery))
            .toList();

    return _buildEventList(filteredEvents);
  }

  Widget _buildLabResults() {
    final events = _getAllEvents()
        .where((event) => event.category == 'lab' || event.type.contains('lab'))
        .toList();
    final filteredEvents = _searchQuery.isEmpty
        ? events
        : events
            .where((event) =>
                event.title.toLowerCase().contains(_searchQuery) ||
                event.description.toLowerCase().contains(_searchQuery))
            .toList();

    return _buildEventList(filteredEvents);
  }

  Widget _buildEventList(List<HistoryEvent> events) {
    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No events found for "$_searchQuery"'
                  : 'No events yet',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return _buildEventCard(event);
      },
    );
  }

  Widget _buildEventCard(HistoryEvent event) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _onEventTap(event),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: event.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  event.icon,
                  color: event.color,
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
                        Expanded(
                          child: Text(
                            event.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: event.categoryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            event.category.toUpperCase(),
                            style: TextStyle(
                              color: event.categoryColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.date,
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
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onEventTap(HistoryEvent event) {
    // Navigate based on event type
    switch (event.type) {
      case 'visit_recording':
        context.go('/patient/visit-details');
        break;
      case 'document_scan':
      case 'lab_report':
        // TODO: Show document viewer
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening ${event.title}')),
        );
        break;
      case 'medication_taken':
        context.go('/patient/reminders');
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening ${event.title}')),
        );
    }
  }

  List<HistoryEvent> _getAllEvents() {
    return [
      // Visit Recordings
      HistoryEvent(
        title: 'Cardiology Follow-up Visit',
        description: 'Audio recording with Dr. Sarah Johnson',
        date: '2 days ago',
        type: 'visit_recording',
        category: 'visit',
        icon: Icons.mic,
        color: Colors.blue,
        categoryColor: Colors.blue,
      ),
      HistoryEvent(
        title: 'Blood Work Review',
        description: 'Audio recording with Dr. Michael Chen',
        date: '1 week ago',
        type: 'visit_recording',
        category: 'visit',
        icon: Icons.mic,
        color: Colors.blue,
        categoryColor: Colors.blue,
      ),

      // Scanned Documents
      HistoryEvent(
        title: 'Lisinopril Prescription',
        description: 'Scanned prescription document',
        date: '3 days ago',
        type: 'document_scan',
        category: 'document',
        icon: Icons.receipt,
        color: Colors.green,
        categoryColor: Colors.green,
      ),
      HistoryEvent(
        title: 'Medical Insurance Card',
        description: 'Scanned insurance information',
        date: '2 weeks ago',
        type: 'document_scan',
        category: 'document',
        icon: Icons.credit_card,
        color: Colors.purple,
        categoryColor: Colors.green,
      ),

      // Lab Results
      HistoryEvent(
        title: 'Complete Blood Count',
        description: 'LabCorp - Comprehensive blood panel',
        date: '1 week ago',
        type: 'lab_report',
        category: 'lab',
        icon: Icons.science,
        color: Colors.purple,
        categoryColor: Colors.red,
      ),
      HistoryEvent(
        title: 'Lipid Panel Results',
        description: 'Cholesterol and triglyceride levels',
        date: '2 weeks ago',
        type: 'lab_report',
        category: 'lab',
        icon: Icons.science,
        color: Colors.purple,
        categoryColor: Colors.red,
      ),

      // Medication Events
      HistoryEvent(
        title: 'Lisinopril Taken',
        description: '10mg dose recorded',
        date: 'Today, 8:00 AM',
        type: 'medication_taken',
        category: 'medication',
        icon: Icons.check_circle,
        color: Colors.teal,
        categoryColor: Colors.teal,
      ),
      HistoryEvent(
        title: 'Metformin Missed',
        description: '500mg dose not taken',
        date: 'Yesterday',
        type: 'medication_missed',
        category: 'medication',
        icon: Icons.cancel,
        color: Colors.red,
        categoryColor: Colors.teal,
      ),
    ];
  }
}

class HistoryEvent {
  final String title;
  final String description;
  final String date;
  final String type;
  final String category;
  final IconData icon;
  final Color color;
  final Color categoryColor;

  HistoryEvent({
    required this.title,
    required this.description,
    required this.date,
    required this.type,
    required this.category,
    required this.icon,
    required this.color,
    required this.categoryColor,
  });
}
