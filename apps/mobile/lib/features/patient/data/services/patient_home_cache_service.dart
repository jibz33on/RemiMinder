import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/patient_task.dart';

class CachedReminders {
  final Map<String, dynamic> payload;
  final DateTime timestamp;

  CachedReminders({
    required this.payload,
    required this.timestamp,
  });
}

class CachedTasks {
  final List<PatientTask> tasks;
  final DateTime timestamp;

  CachedTasks({
    required this.tasks,
    required this.timestamp,
  });
}

class PatientHomeCacheService {
  static const _remindersPayloadKey = 'cached_reminders_payload';
  static const _remindersTimestampKey = 'cached_reminders_timestamp';
  static const _tasksPayloadKey = 'cached_patient_tasks_payload';
  static const _tasksTimestampKey = 'cached_patient_tasks_timestamp';

  Future<CachedReminders?> loadReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final payloadRaw = prefs.getString(_remindersPayloadKey);
    final timestampMillis = prefs.getInt(_remindersTimestampKey);
    if (payloadRaw == null || timestampMillis == null) return null;
    try {
      final payload = json.decode(payloadRaw) as Map<String, dynamic>;
      return CachedReminders(
        payload: payload,
        timestamp: DateTime.fromMillisecondsSinceEpoch(timestampMillis),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> saveReminders(Map<String, dynamic> payload) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_remindersPayloadKey, json.encode(payload));
    await prefs.setInt(
        _remindersTimestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<CachedTasks?> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final payloadRaw = prefs.getString(_tasksPayloadKey);
    final timestampMillis = prefs.getInt(_tasksTimestampKey);
    if (payloadRaw == null || timestampMillis == null) return null;
    try {
      final payload = json.decode(payloadRaw) as List<dynamic>;
      final tasks = payload
          .whereType<Map<String, dynamic>>()
          .map(PatientTask.fromJson)
          .toList();
      return CachedTasks(
        tasks: tasks,
        timestamp: DateTime.fromMillisecondsSinceEpoch(timestampMillis),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> saveTasks(List<PatientTask> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = tasks.map((task) => task.toJson()).toList();
    await prefs.setString(_tasksPayloadKey, json.encode(payload));
    await prefs.setInt(
        _tasksTimestampKey, DateTime.now().millisecondsSinceEpoch);
  }
}
