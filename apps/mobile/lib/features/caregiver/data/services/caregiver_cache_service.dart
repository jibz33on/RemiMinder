import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/caregiver_patient.dart';
import '../../../patient/data/models/patient_task.dart';

class CachedCaregiverPatients {
  final List<CaregiverPatient> patients;
  final DateTime timestamp;

  CachedCaregiverPatients({
    required this.patients,
    required this.timestamp,
  });
}

class CachedCaregiverReminders {
  final Map<String, dynamic> payload;
  final DateTime timestamp;

  CachedCaregiverReminders({
    required this.payload,
    required this.timestamp,
  });
}

class CachedCaregiverTasks {
  final List<PatientTask> tasks;
  final DateTime timestamp;

  CachedCaregiverTasks({
    required this.tasks,
    required this.timestamp,
  });
}

class CaregiverCacheService {
  static const _patientsPayloadKey = 'cached_caregiver_patients_payload';
  static const _patientsTimestampKey = 'cached_caregiver_patients_timestamp';

  String _remindersPayloadKey(String patientId) =>
      'cached_caregiver_reminders_payload_$patientId';
  String _remindersTimestampKey(String patientId) =>
      'cached_caregiver_reminders_timestamp_$patientId';

  String _tasksPayloadKey(String patientId) =>
      'cached_caregiver_tasks_payload_$patientId';
  String _tasksTimestampKey(String patientId) =>
      'cached_caregiver_tasks_timestamp_$patientId';

  Future<CachedCaregiverPatients?> loadPatients() async {
    final prefs = await SharedPreferences.getInstance();
    final payloadRaw = prefs.getString(_patientsPayloadKey);
    final timestampMillis = prefs.getInt(_patientsTimestampKey);
    if (payloadRaw == null || timestampMillis == null) return null;
    try {
      final payload = json.decode(payloadRaw) as List<dynamic>;
      final patients = payload
          .whereType<Map<String, dynamic>>()
          .map(CaregiverPatient.fromJson)
          .toList();
      return CachedCaregiverPatients(
        patients: patients,
        timestamp: DateTime.fromMillisecondsSinceEpoch(timestampMillis),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> savePatients(List<CaregiverPatient> patients) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = patients.map((patient) => patient.toJson()).toList();
    await prefs.setString(_patientsPayloadKey, json.encode(payload));
    await prefs.setInt(
        _patientsTimestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<CachedCaregiverReminders?> loadReminders(String patientId) async {
    final prefs = await SharedPreferences.getInstance();
    final payloadRaw = prefs.getString(_remindersPayloadKey(patientId));
    final timestampMillis = prefs.getInt(_remindersTimestampKey(patientId));
    if (payloadRaw == null || timestampMillis == null) return null;
    try {
      final payload = json.decode(payloadRaw) as Map<String, dynamic>;
      return CachedCaregiverReminders(
        payload: payload,
        timestamp: DateTime.fromMillisecondsSinceEpoch(timestampMillis),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> saveReminders(
      String patientId, Map<String, dynamic> payload) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _remindersPayloadKey(patientId), json.encode(payload));
    await prefs.setInt(
        _remindersTimestampKey(patientId), DateTime.now().millisecondsSinceEpoch);
  }

  Future<CachedCaregiverTasks?> loadTasks(String patientId) async {
    final prefs = await SharedPreferences.getInstance();
    final payloadRaw = prefs.getString(_tasksPayloadKey(patientId));
    final timestampMillis = prefs.getInt(_tasksTimestampKey(patientId));
    if (payloadRaw == null || timestampMillis == null) return null;
    try {
      final payload = json.decode(payloadRaw) as List<dynamic>;
      final tasks = payload
          .whereType<Map<String, dynamic>>()
          .map(PatientTask.fromJson)
          .toList();
      return CachedCaregiverTasks(
        tasks: tasks,
        timestamp: DateTime.fromMillisecondsSinceEpoch(timestampMillis),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> saveTasks(String patientId, List<PatientTask> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = tasks.map((task) => task.toJson()).toList();
    await prefs.setString(_tasksPayloadKey(patientId), json.encode(payload));
    await prefs.setInt(
        _tasksTimestampKey(patientId), DateTime.now().millisecondsSinceEpoch);
  }
}
