import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/config/environment.dart';
import '../../data/services/patient_api_service.dart';
import '../../data/models/summary_item.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Summaries state
  List<SummaryItem> _summaries = [];
  bool _isLoadingSummaries = true;
  String? _summariesError;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchController.addListener(_onSearchChanged);
    _fetchSummaries();
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

  Future<void> _fetchSummaries() async {
    try {
      setState(() {
        _isLoadingSummaries = true;
        _summariesError = null;
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

      setState(() {
        _summaries = summaries;
        _isLoadingSummaries = false;
      });
    } catch (e) {
      setState(() {
        _summariesError = e.toString();
        _isLoadingSummaries = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Overview',
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
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search summaries...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Tabs
            TabBar(
              controller: _tabController,
              isScrollable: false,
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Theme.of(context).colorScheme.secondary,
              indicatorColor: Theme.of(context).colorScheme.primary,
              indicatorWeight: 3,
              tabs: const [
                Tab(text: 'SUMMARIES'),
                Tab(text: 'LAB RESULTS'),
                Tab(text: 'SCANNED DOCS'),
              ],
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildSummariesTab(),
                  _buildLabResultsTab(),
                  _buildScannedDocsTab(),
                ],
              ),
            ),

            // Extra space for bottom navigation
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildSummariesTab() {
    if (_isLoadingSummaries) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_summariesError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load summaries',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _summariesError!,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchSummaries,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_summaries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No summaries yet',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your visit summaries will appear here',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    final filteredSummaries = _searchQuery.isEmpty
        ? _summaries
        : _summaries.where((summary) {
            return summary.doctorName.toLowerCase().contains(_searchQuery) ||
                summary.specialty.toLowerCase().contains(_searchQuery) ||
                summary.summaryPreview.toLowerCase().contains(_searchQuery);
          }).toList();

    return Container(
      constraints: const BoxConstraints(minHeight: 200),
      child: RefreshIndicator(
        onRefresh: _fetchSummaries,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          itemCount: filteredSummaries.length,
          itemBuilder: (context, index) {
            final summary = filteredSummaries[index];
            return _buildSummaryCard(summary);
          },
        ),
      ),
    );
  }

  Widget _buildSummaryCard(SummaryItem summary) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          print("🧨 Tapping summary card for visitId = ${summary.visitId}");
          context.go('/patient/visit-details?visitId=${summary.visitId}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor info
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      summary.doctorName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Text(
                    summary.specialty,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Visit date
              if (summary.visitDate != null)
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _formatDate(summary.visitDate!),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 12),

              // Summary preview
              Text(
                summary.summaryPreview,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 14,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // Created date
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 12,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Generated ${_formatDateTime(summary.summaryCreatedAt)}',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.month}/${date.day}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  String _formatDateTime(String dateTimeString) {
    try {
      final date = DateTime.parse(dateTimeString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'today';
      } else if (difference.inDays == 1) {
        return 'yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return '${date.month}/${date.day}/${date.year}';
      }
    } catch (e) {
      return 'recently';
    }
  }

  Widget _buildLabResultsTab() {
    return const Center(
      child: Text('Lab Results - Coming Soon'),
    );
  }

  Widget _buildScannedDocsTab() {
    return const Center(
      child: Text('Scanned Documents - Coming Soon'),
    );
  }
}
