import 'dart:developer' as logger;
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

  // Selection and sharing state
  bool _isSelectionMode = false;
  Set<String> _selectedSummaryIds = {};
  Map<String, bool> _shareStates = {};

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
      appBar: _buildAppBar(),
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

  PreferredSizeWidget _buildAppBar() {
    if (_isSelectionMode) {
      // Selection mode AppBar
      return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: _exitSelectionMode,
        ),
        title: Text(
          'Select summaries',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _deleteSelectedSummaries,
            child: Text(
              'Delete Selected',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    } else {
      // Normal mode AppBar
      return AppBar(
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
              Icons.delete_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: _enterSelectionMode,
          ),
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
      );
    }
  }

  void _enterSelectionMode() {
    setState(() {
      _isSelectionMode = true;
      _selectedSummaryIds.clear();
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedSummaryIds.clear();
    });
  }

  void _deleteSelectedSummaries() {
    if (_selectedSummaryIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select at least one summary')),
      );
      return;
    }

    final count = _selectedSummaryIds.length;
    final isSingular = count == 1;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isSingular ? 'Delete summary?' : 'Delete summaries?'),
        content: Text(
          isSingular
              ? 'Are you sure you want to delete this summary? This cannot be undone.'
              : 'Are you sure you want to delete $count summaries? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _confirmDelete();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete() async {
    try {
      // Get authentication token
      final authToken = await AuthService().getAccessToken();
      if (authToken == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Authentication error. Please log in again.')),
        );
        return;
      }

      // Create API service
      final apiService = PatientApiService(
        baseUrl: Environment.apiBaseUrl,
        authToken: authToken,
      );

      // Delete each selected summary
      final summariesToDelete = _selectedSummaryIds
          .toSet(); // Copy to avoid modification during iteration

      for (final summaryId in summariesToDelete) {
        try {
          await apiService.deleteSummary(summaryId);
          // Remove from local list on successful deletion
          setState(() {
            _summaries.removeWhere((summary) => summary.summaryId == summaryId);
            _selectedSummaryIds.remove(summaryId);
          });
        } catch (e) {
          logger.log('Failed to delete summary $summaryId: $e');
          // Continue with other deletions even if one fails
        }
      }

      // Show success message
      final deletedCount =
          summariesToDelete.length - _selectedSummaryIds.length;
      if (deletedCount > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Successfully deleted $deletedCount summary${deletedCount == 1 ? '' : 'ies'}')),
        );
      }
    } catch (e) {
      logger.log('Error during delete operation: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to delete summaries. Please try again.')),
      );
    } finally {
      _exitSelectionMode();
    }
  }

  void _toggleShare(String summaryId, bool value) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(value ? 'Share summary?' : 'Stop sharing?'),
        content: Text(
          value
              ? 'You are about to share this summary with your caregivers. They will be able to view this visit summary.'
              : 'Caregivers will no longer be able to view this summary.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _confirmShareToggle(summaryId, value);
            },
            style: TextButton.styleFrom(
              foregroundColor:
                  value ? Theme.of(context).colorScheme.primary : Colors.red,
            ),
            child: Text(value ? 'Share' : 'Stop Sharing'),
          ),
        ],
      ),
    );
  }

  void _confirmShareToggle(String summaryId, bool value) {
    setState(() {
      _shareStates[summaryId] = value;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value
            ? 'Caregiver sharing coming soon'
            : 'Sharing settings will be available soon'),
      ),
    );
  }

  void _toggleSummarySelection(String summaryId) {
    logger.log("Toggling selection for summaryId = $summaryId");
    setState(() {
      if (_selectedSummaryIds.contains(summaryId)) {
        logger.log("Removing summaryId = $summaryId from selection");
        _selectedSummaryIds.remove(summaryId);
      } else {
        logger.log("Adding summaryId = $summaryId to selection");
        _selectedSummaryIds.add(summaryId);
      }
    });
    logger.log("Current selected IDs: $_selectedSummaryIds");
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
    final summaryId = summary.summaryId;
    final isSelected = _selectedSummaryIds.contains(summaryId);
    final isShared = _shareStates[summaryId] ?? false;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: _isSelectionMode && isSelected
          ? Theme.of(context).colorScheme.primary.withOpacity(0.05)
          : null,
      child: InkWell(
        onTap: _isSelectionMode
            ? () => _toggleSummarySelection(summaryId)
            : () {
                print(
                    "🧨 Tapping summary card for visitId = ${summary.visitId}");
          context.go('/patient/visit-details?visitId=${summary.visitId}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with doctor info and action
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
                  // Action widget (Share toggle or Checkbox)
                  if (_isSelectionMode) ...[
                    Checkbox(
                      value: isSelected,
                      onChanged: (value) => _toggleSummarySelection(summaryId),
                      activeColor: Theme.of(context).colorScheme.primary,
                    ),
                  ] else ...[
                    // Share toggle
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                  Text(
                          'Share',
                    style: TextStyle(
                      fontSize: 12,
                            color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                        Switch(
                          value: isShared,
                          onChanged: (value) => _toggleShare(summaryId, value),
                          activeColor: Theme.of(context).colorScheme.primary,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ],
                    ),
                  ],
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
