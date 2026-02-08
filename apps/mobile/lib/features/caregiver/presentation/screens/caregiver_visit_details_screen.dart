import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import '../../../../core/services/auth_service.dart';
import '../../../../core/config/environment.dart';
import '../../../patient/data/services/patient_api_service.dart';
import '../../../../l10n/app_localizations.dart';

class CaregiverVisitDetailsScreen extends StatefulWidget {
  final String visitId;
  final String? visitDate;
  final String patientId;

  const CaregiverVisitDetailsScreen({
    super.key,
    required this.visitId,
    required this.patientId,
    this.visitDate,
  });

  @override
  State<CaregiverVisitDetailsScreen> createState() => _CaregiverVisitDetailsScreenState();
}

class _CaregiverVisitDetailsScreenState extends State<CaregiverVisitDetailsScreen> {
  // Final narrative summary state
  String? _finalSummaryText;
  bool _isLoadingSummary = true;
  String _summaryStatus = 'loading'; // 'loading', 'processing', 'ready', 'error'

  // Visit metadata state
  bool _isLoadingVisit = true;
  String? _visitDoctor;
  String? _visitSpecialty;
  String? _visitTitle;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchVisitMetadata();
    _fetchFinalSummary();
  }

  Future<void> _fetchVisitMetadata() async {
    try {
      final authToken = await AuthService().getAccessToken();
      if (authToken == null) {
        throw Exception('Authentication required');
      }

      final uri = Uri.parse('${Environment.apiBaseUrl}/api/visits/${widget.visitId}');
      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $authToken'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _visitDoctor = data['doctor'];
          _visitSpecialty = data['specialty'];
          _visitTitle = data['title'];
          _isLoadingVisit = false;
        });
      } else if (response.statusCode == 403 || response.statusCode == 404) {
        setState(() {
          _errorMessage = 'This visit is not shared with you';
          _isLoadingVisit = false;
        });
      } else {
        throw Exception('Failed to load visit: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load visit details';
        _isLoadingVisit = false;
      });
    }
  }

  Future<void> _fetchFinalSummary() async {
    setState(() {
      _isLoadingSummary = true;
    });
    try {
      final authToken = await AuthService().getAccessToken();
      if (authToken == null) {
        throw Exception('Authentication required');
      }
      final apiService = PatientApiService(
        baseUrl: Environment.apiBaseUrl,
        authToken: authToken,
      );
      final data = await apiService.getVisitSummary(widget.visitId);
      if (data['status'] == 'processing') {
        setState(() {
          _summaryStatus = 'processing';
          _finalSummaryText = null;
        });
      } else if (data.containsKey('summary')) {
        setState(() {
          _summaryStatus = 'ready';
          _finalSummaryText = data['summary'];
        });
      } else {
        setState(() {
          _summaryStatus = 'ready';
          _finalSummaryText = null;
        });
      }
    } catch (e) {
      if (e.toString().contains('403') || e.toString().contains('404')) {
        setState(() {
          _summaryStatus = 'error';
          _finalSummaryText = 'This visit summary is not shared with you';
        });
      } else {
        setState(() {
          _summaryStatus = 'error';
          _finalSummaryText = 'Failed to load summary';
        });
      }
    } finally {
      setState(() {
        _isLoadingSummary = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Visit Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/caregiver/patient-overview?patientId=${widget.patientId}'),
        ),
      ),
      body: _buildBody(context, l10n),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations? l10n) {
    if (_isLoadingVisit) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'This visit has not been shared by the patient.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Visit header
          _buildVisitHeader(context),

          const SizedBox(height: 24),

          // Summary section
          _buildSummarySection(context, l10n),
        ],
      ),
    );
  }

  Widget _buildVisitHeader(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_visitTitle != null && _visitTitle!.isNotEmpty)
              Text(
                _visitTitle!,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (_visitTitle != null && _visitTitle!.isNotEmpty)
              const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person, size: 20),
                const SizedBox(width: 8),
                Text(
                  _visitDoctor ?? 'Unknown Doctor',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            if (_visitSpecialty != null && _visitSpecialty!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.medical_services, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    _visitSpecialty!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Shared by patient',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context, AppLocalizations? l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Visit Summary',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            if (_isLoadingSummary)
              const Center(child: CircularProgressIndicator())
            else if (_summaryStatus == 'processing')
              _buildProcessingState(l10n)
            else if (_summaryStatus == 'ready' && _finalSummaryText != null && _finalSummaryText!.isNotEmpty)
              Text(
                _finalSummaryText!,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.5,
                ),
              )
            else if (_summaryStatus == 'error')
              _buildErrorState()
            else
              Text(
                'No summary available for this visit.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessingState(AppLocalizations? l10n) {
    return Column(
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
        Text(
          'Summary is being generated...',
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Column(
      children: [
        const Icon(Icons.error_outline, size: 48, color: Colors.orange),
        const SizedBox(height: 16),
        Text(
          _finalSummaryText ?? 'Unable to load summary',
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}