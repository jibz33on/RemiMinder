import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/patient_task.dart';
import '../../data/services/patient_home_cache_service.dart';
import '../../data/services/patient_tasks_api_service.dart';
import '../../data/services/reminders_api_service.dart';

class RemindersState {
  final Map<String, dynamic>? upNext;
  final List<Map<String, dynamic>> today;
  final DateTime? lastUpdated;
  final bool isLoading;
  final bool isRefreshing;
  final String? errorMessage;

  const RemindersState({
    this.upNext,
    this.today = const [],
    this.lastUpdated,
    this.isLoading = false,
    this.isRefreshing = false,
    this.errorMessage,
  });

  bool get hasData => upNext != null || today.isNotEmpty;

  RemindersState copyWith({
    Map<String, dynamic>? upNext,
    List<Map<String, dynamic>>? today,
    DateTime? lastUpdated,
    bool? isLoading,
    bool? isRefreshing,
    String? errorMessage,
  }) {
    return RemindersState(
      upNext: upNext ?? this.upNext,
      today: today ?? this.today,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: errorMessage,
    );
  }
}

class RemindersNotifier extends Notifier<RemindersState> {
  final _cacheService = PatientHomeCacheService();
  final _apiService = RemindersApiService();
  bool _isFetching = false;
  bool _initialized = false;

  @override
  RemindersState build() {
    if (!_initialized) {
      _initialized = true;
      Future.microtask(() async {
        await _loadCachedReminders();
        await refresh();
      });
    }
    return const RemindersState(isLoading: true);
  }

  Future<void> _loadCachedReminders() async {
    final cached = await _cacheService.loadReminders();
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
    if (_isFetching) return;
    _isFetching = true;
    state = state.copyWith(
      isRefreshing: true,
      isLoading: !state.hasData,
      errorMessage: null,
    );

    try {
      final payload = await _apiService.fetchReminders();
      final parsed = _parseReminders(payload);
      await _cacheService.saveReminders(payload);
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

class PatientTasksState {
  final List<PatientTask> tasks;
  final DateTime? lastUpdated;
  final bool isLoading;
  final bool isRefreshing;
  final String? errorMessage;

  const PatientTasksState({
    this.tasks = const [],
    this.lastUpdated,
    this.isLoading = false,
    this.isRefreshing = false,
    this.errorMessage,
  });

  bool get hasData => tasks.isNotEmpty;

  PatientTasksState copyWith({
    List<PatientTask>? tasks,
    DateTime? lastUpdated,
    bool? isLoading,
    bool? isRefreshing,
    String? errorMessage,
  }) {
    return PatientTasksState(
      tasks: tasks ?? this.tasks,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: errorMessage,
    );
  }
}

class PatientTasksNotifier extends Notifier<PatientTasksState> {
  final _cacheService = PatientHomeCacheService();
  final _apiService = PatientTasksApiService();
  bool _isFetching = false;
  bool _initialized = false;

  @override
  PatientTasksState build() {
    if (!_initialized) {
      _initialized = true;
      Future.microtask(() async {
        await _loadCachedTasks();
        await refresh();
      });
    }
    return const PatientTasksState(isLoading: true);
  }

  Future<void> _loadCachedTasks() async {
    final cached = await _cacheService.loadTasks();
    if (cached == null) return;
    state = state.copyWith(
      tasks: cached.tasks,
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
      final tasks = await _apiService.fetchTasks();
      await _cacheService.saveTasks(tasks);
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

final remindersNotifierProvider =
    NotifierProvider<RemindersNotifier, RemindersState>(() {
  return RemindersNotifier();
});

final patientTasksNotifierProvider =
    NotifierProvider<PatientTasksNotifier, PatientTasksState>(() {
  return PatientTasksNotifier();
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
