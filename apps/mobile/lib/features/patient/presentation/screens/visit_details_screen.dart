import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/config/environment.dart';
import '../../data/services/patient_api_service.dart';

class VisitDetailsScreen extends StatefulWidget {
  final String visitId;

  VisitDetailsScreen({
    super.key,
    required this.visitId,
  }) {
    print("🧨🧨🧨 Opening VisitDetailsScreen with visitId = $visitId");
  }

  @override
  State<VisitDetailsScreen> createState() => _VisitDetailsScreenState();
}

class _VisitDetailsScreenState extends State<VisitDetailsScreen> {
  // AI Summary state
  String? _aiSummary;
  bool _isLoadingSummary = true;
  String _summaryStatus =
      'loading'; // 'loading', 'processing', 'ready', 'error'

  @override
  void initState() {
    super.initState();
    _fetchAISummary();
  }

  Future<void> _fetchAISummary() async {
    print("🔍 _fetchAISummary called for visitId: ${widget.visitId}");

    setState(() {
      _isLoadingSummary = true;
      _summaryStatus = 'loading';
    });

    try {
      final authToken = await AuthService().getAccessToken();
      print("🔍 Auth token available: ${authToken != null}");

      final apiService = PatientApiService(
        baseUrl: Environment.apiBaseUrl,
        authToken: authToken ?? '',
      );

      print("🔥🔥🔥 Calling GET /api/visits/${widget.visitId}/summary");
      final data = await apiService.getVisitSummary(widget.visitId);
      print("🔍 API response: $data");

      if (data.containsKey('summary')) {
        print("🔍 Found summary, setting to ready state");
        setState(() {
          _aiSummary = data['summary'];
          _summaryStatus = 'ready';
          _isLoadingSummary = false;
        });
      } else if (data['status'] == 'processing') {
        print("🔍 Summary still processing, setting processing state");
        setState(() {
          _summaryStatus = 'processing';
          _isLoadingSummary = false;
        });
      } else {
        print("🔍 Unexpected response format: $data");
        setState(() {
          _summaryStatus = 'error';
          _isLoadingSummary = false;
        });
      }
    } catch (e) {
      print("🔍 Error fetching summary: $e");
      setState(() {
        _summaryStatus = 'error';
        _isLoadingSummary = false;
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
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchAISummary,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // AI Summary Card
                _buildAISummaryCard(),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAISummaryCard() {
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
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.smart_toy,
                  color: Colors.blue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: const Text(
                  'AI Visit Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ),
              IconButton(
                onPressed: _fetchAISummary,
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh summary',
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isLoadingSummary)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_summaryStatus == 'processing')
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.orange.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.psychology,
                    color: Colors.orange,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '🧠 Generating summary...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'This may take a minute.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else if (_summaryStatus == 'ready' && _aiSummary != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.green.withOpacity(0.2),
                ),
              ),
              child: Text(
                _aiSummary!,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.secondary,
                  height: 1.5,
                ),
              ),
            )
          else if (_summaryStatus == 'error')
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.red.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: const Text(
                      'Failed to load AI summary',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _fetchAISummary,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.grey,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Unable to load AI summary',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
