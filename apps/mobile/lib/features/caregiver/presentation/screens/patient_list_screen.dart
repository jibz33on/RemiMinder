import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/preferences_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/caregiver_patient.dart';
import '../providers/caregiver_providers.dart';

class PatientListScreen extends ConsumerStatefulWidget {
  const PatientListScreen({super.key});

  @override
  ConsumerState<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends ConsumerState<PatientListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<CaregiverPatient> _filteredPatients(List<CaregiverPatient> patients) {
    if (_searchQuery.isEmpty) return patients;
    final query = _searchQuery.toLowerCase();
    return patients.where((patient) {
      final name = (patient.fullName ?? '').toLowerCase();
      final email = (patient.email ?? '').toLowerCase();
      final role = patient.membershipRole.toLowerCase();
      return name.contains(query) ||
          email.contains(query) ||
          role.contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final patientsState = ref.watch(caregiverPatientsProvider);
    final patients = _filteredPatients(patientsState.patients);
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
          onPressed: () => context.go('/caregiver/home'),
        ),
        title: Text(
          l10n?.caregiverPatientsTitle ?? 'My Patients',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Read-only access',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context)
                      .colorScheme
                      .secondary
                      .withOpacity(0.7),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n?.caregiverPatientsSearchHint ??
                    'Search patients by name, relationship, or condition...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clearSearch,
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.withOpacity(0.1),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Results Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  l10n?.caregiverPatientsCount(patients.length) ??
                      '${patients.length} ${patients.length == 1 ? 'Patient' : 'Patients'}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const Spacer(),
                if (patientsState.isRefreshing)
                  Text(
                    'Refreshing',
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),

          // Patient List
          Expanded(
            child: patientsState.isLoading && !patientsState.hasData
                ? const Center(child: CircularProgressIndicator())
                : patients.isEmpty
                    ? _buildEmptyState(patientsState.errorMessage)
                    : RefreshIndicator(
                        onRefresh: () => ref
                            .read(caregiverPatientsProvider.notifier)
                            .refresh(userInitiated: true),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: patients.length,
                          itemBuilder: (context, index) {
                            final patient = patients[index];
                            return _buildPatientCard(patient);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String? errorMessage) {
    final l10n = AppLocalizations.of(context);
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
            errorMessage != null
                ? (l10n?.commonRetry ?? 'Unable to load patients')
                : _searchQuery.isNotEmpty
                    ? l10n?.caregiverPatientsEmptyNoMatch ??
                        'No patients match your search'
                    : l10n?.caregiverPatientsEmptyNone ?? 'No patients found',
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          if (errorMessage == null)
            Text(
              _searchQuery.isNotEmpty
                  ? l10n?.caregiverPatientsEmptyAdjustSearch ??
                      'Try adjusting your search terms'
                  : l10n?.caregiverPatientsEmptyAddPatients ??
                      'Add patients to start managing their care',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          if (errorMessage != null) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => ref
                  .read(caregiverPatientsProvider.notifier)
                  .refresh(userInitiated: true),
              child: Text(l10n?.commonRetry ?? 'Retry'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPatientCard(CaregiverPatient patient) {
    final patientId = patient.patientId;
    final title = patient.fullName ?? patient.email ?? 'Patient';
    final subtitle = patient.email ?? '';
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _selectPatient(patientId),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(
                      Icons.person,
                      color: Theme.of(context).colorScheme.primary,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        Text(
                          patient.membershipRole,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.7),
                          ),
                        ),
                        Text(
                          patient.permission.toUpperCase(),
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
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.5),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
    });
  }

  Future<void> _selectPatient(String patientId) async {
    ref
        .read(activePatientIdProvider.notifier)
        .setActivePatientId(patientId);
    await PreferencesService().setActivePatientId(patientId);
    if (!mounted) return;
    context.go('/caregiver/patient-home');
  }
}
