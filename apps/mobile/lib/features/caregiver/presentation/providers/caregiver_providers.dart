import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../patient/data/models/patient_task.dart';
import '../../data/models/caregiver_patient.dart';
import '../../data/services/caregiver_api_service.dart';
import '../../data/services/caregiver_cache_service.dart';

class CaregiverPatientsState {
  final List<CaregiverPatient> patients;
  final DateTime? lastUpdated;
  final bool isLoading;
  final bool isRefreshing;
  final String? errorMessage;

  const CaregiverPatientsState({
    this.patients = const [],
    this.lastUpdated,
    this.isLoading = false,
    this.isRefreshing = false,
    this.errorMessage,
  });

  bool get hasData => patients.isNotEmpty;

  CaregiverPatientsState copyWith({
    List<CaregiverPatient>? patients,
    DateTime? lastUpdated,
    bool? isLoading,
    bool? isRefreshing,
    String? errorMessage,
  }) {
    return CaregiverPatientsState(
      patients: patients ?? this.patients,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: errorMessage,
    );
  }
}

class CaregiverPatientsNotifier extends Notifier<CaregiverPatientsState> {
  final _cacheService = CaregiverCacheService();
  final _apiService = CaregiverApiService();
  bool _isFetching = false;
  bool _initialized = false;

  @override
  CaregiverPatientsState build() {
    if (!_initialized) {
      _initialized = true;
      Future.microtask(() async {
        await _loadCachedPatients();
        await refresh();
      });
    }
    return const CaregiverPatientsState(isLoading: true);
  }

  Future<void> _loadCachedPatients() async {
    final cached = await _cacheService.loadPatients();
    if (cached == null) return;
    state = state.copyWith(
      patients: cached.patients,
      lastUpdated: cached.timestamp,
      isLoading: false,
      errorMessage: null,
    );
  }

  Future<void> refresh({bool userInitiated = false}) async {
    if (_isFetching) return;
    _isFetching = true;
    state = state.copyWith(
      isRefreshing: true,
      isLoading: !state.hasData,
      errorMessage: null,
    );

    try {
      final patients = await _apiService.getMyPatients();
      await _cacheService.savePatients(patients);
      state = state.copyWith(
        patients: patients,
        lastUpdated: DateTime.now(),
        isLoading: false,
        isRefreshing: false,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        errorMessage: userInitiated ? e.toString() : null,
      );
    } finally {
      _isFetching = false;
    }
  }
}

class CaregiverRemindersState {
  final Map<String, dynamic>? upNext;
  final List<Map<String, dynamic>> today;
  final DateTime? lastUpdated;
  final bool isLoading;
  final bool isRefreshing;
  final String? errorMessage;

  const CaregiverRemindersState({
    this.upNext,
    this.today = const [],
    this.lastUpdated,
    this.isLoading = false,
    this.isRefreshing = false,
    this.errorMessage,
  });

  bool get hasData => upNext != null || today.isNotEmpty;

  CaregiverRemindersState copyWith({
    Map<String, dynamic>? upNext,
    List<Map<String, dynamic>>? today,
    DateTime? lastUpdated,
    bool? isLoading,
    bool? isRefreshing,
    String? errorMessage,
  }) {
    return CaregiverRemindersState(
      upNext: upNext ?? this.upNext,
      today: today ?? this.today,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: errorMessage,
    );
  }
}

class CaregiverPatientRemindersNotifier
    extends Notifier<CaregiverRemindersState> {
  final CaregiverCacheService _cacheService = CaregiverCacheService();
  final CaregiverApiService _apiService = CaregiverApiService();
  String? _patientId;
  bool _isFetching = false;

  @override
  CaregiverRemindersState build() {
    final activePatientId = ref.watch(activePatientIdProvider);
    if (activePatientId == null || activePatientId.isEmpty) {
      _patientId = null;
      return const CaregiverRemindersState(isLoading: false);
    }

    if (_patientId != activePatientId) {
      _patientId = activePatientId;
      Future.microtask(() async {
        await _loadCachedReminders(activePatientId);
        await refresh();
      });
    }

    return const CaregiverRemindersState(isLoading: true);
  }

  Future<void> _loadCachedReminders(String patientId) async {
    final cached = await _cacheService.loadReminders(patientId);
    if (cached == null) return;
    final parsed = _parseReminders(cached.payload);
    state = state.copyWith(
      upNext: parsed.upNext,
      today: parsed.today,
      lastUpdated: cached.timestamp,
      isLoading: false,
      errorMessage: null,
    );
  }

  Future<void> refresh({bool userInitiated = false}) async {
    final patientId = _patientId;
    if (patientId == null || patientId.isEmpty) return;
    if (_isFetching) return;
    _isFetching = true;
    state = state.copyWith(
      isRefreshing: true,
      isLoading: !state.hasData,
      errorMessage: null,
    );

    try {
      final payload = await _apiService.getPatientReminders(patientId);
      final parsed = _parseReminders(payload);
      await _cacheService.saveReminders(patientId, payload);
      state = state.copyWith(
        upNext: parsed.upNext,
        today: parsed.today,
        lastUpdated: DateTime.now(),
        isLoading: false,
        isRefreshing: false,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        errorMessage: userInitiated ? e.toString() : null,
      );
    } finally {
      _isFetching = false;
    }
  }

  _ParsedReminders _parseReminders(Map<String, dynamic> payload) {
    final upcoming = payload['upcoming'] as List<dynamic>? ?? [];
    final today = payload['today'] as List<dynamic>? ?? [];
    final upNext = upcoming.whereType<Map<String, dynamic>>().firstOrNull;
    final todayItems = today.whereType<Map<String, dynamic>>().toList();
    return _ParsedReminders(upNext: upNext, today: todayItems);
  }
}

class CaregiverTasksState {
  final List<PatientTask> tasks;
  final DateTime? lastUpdated;
  final bool isLoading;
  final bool isRefreshing;
  final String? errorMessage;

  const CaregiverTasksState({
    this.tasks = const [],
    this.lastUpdated,
    this.isLoading = false,
    this.isRefreshing = false,
    this.errorMessage,
  });

  bool get hasData => tasks.isNotEmpty;

  CaregiverTasksState copyWith({
    List<PatientTask>? tasks,
    DateTime? lastUpdated,
    bool? isLoading,
    bool? isRefreshing,
    String? errorMessage,
  }) {
    return CaregiverTasksState(
      tasks: tasks ?? this.tasks,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: errorMessage,
    );
  }
}

class CaregiverPatientTasksNotifier
    extends Notifier<CaregiverTasksState> {
  final CaregiverCacheService _cacheService = CaregiverCacheService();
  final CaregiverApiService _apiService = CaregiverApiService();
  String? _patientId;
  bool _isFetching = false;

  @override
  CaregiverTasksState build() {
    final activePatientId = ref.watch(activePatientIdProvider);
    if (activePatientId == null || activePatientId.isEmpty) {
      _patientId = null;
      return const CaregiverTasksState(isLoading: false);
    }

    if (_patientId != activePatientId) {
      _patientId = activePatientId;
      Future.microtask(() async {
        await _loadCachedTasks(activePatientId);
        await refresh();
      });
    }

    return const CaregiverTasksState(isLoading: true);
  }

  Future<void> _loadCachedTasks(String patientId) async {
    final cached = await _cacheService.loadTasks(patientId);
    if (cached == null) return;
    state = state.copyWith(
      tasks: cached.tasks,
      lastUpdated: cached.timestamp,
      isLoading: false,
      errorMessage: null,
    );
  }

  Future<void> refresh({bool userInitiated = false}) async {
    final patientId = _patientId;
    if (patientId == null || patientId.isEmpty) return;
    if (_isFetching) return;
    _isFetching = true;
    state = state.copyWith(
      isRefreshing: true,
      isLoading: !state.hasData,
      errorMessage: null,
    );

    try {
      final payload = await _apiService.getPatientTasks(patientId);
      final tasks = payload
          .whereType<Map<String, dynamic>>()
          .map(PatientTask.fromJson)
          .toList();
      await _cacheService.saveTasks(patientId, tasks);
      state = state.copyWith(
        tasks: tasks,
        lastUpdated: DateTime.now(),
        isLoading: false,
        isRefreshing: false,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        errorMessage: userInitiated ? e.toString() : null,
      );
    } finally {
      _isFetching = false;
    }
  }
}

final caregiverPatientsProvider =
    NotifierProvider<CaregiverPatientsNotifier, CaregiverPatientsState>(() {
  return CaregiverPatientsNotifier();
});

class ActivePatientIdNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setActivePatientId(String? patientId) {
    state = patientId;
  }
}

final activePatientIdProvider =
    NotifierProvider<ActivePatientIdNotifier, String?>(() {
  return ActivePatientIdNotifier();
});

final caregiverPatientRemindersProvider =
    NotifierProvider<CaregiverPatientRemindersNotifier, CaregiverRemindersState>(
        () {
  return CaregiverPatientRemindersNotifier();
});

final caregiverPatientTasksProvider =
    NotifierProvider<CaregiverPatientTasksNotifier, CaregiverTasksState>(() {
  return CaregiverPatientTasksNotifier();
});

class _ParsedReminders {
  final Map<String, dynamic>? upNext;
  final List<Map<String, dynamic>> today;

  _ParsedReminders({
    required this.upNext,
    required this.today,
  });
}

extension _FirstOrNullExtension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
