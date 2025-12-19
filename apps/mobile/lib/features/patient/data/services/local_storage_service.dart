import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/models.dart';

class LocalStorageService {
  static const String _medicationsKey = 'medications';
  static const String _remindersKey = 'reminders';
  static const String _appointmentsKey = 'appointments';
  static const String _visitsKey = 'visits';
  static const String _caregiversKey = 'caregivers';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  // Medications
  Future<void> saveMedications(List<Medication> medications) async {
    final prefs = await _prefs;
    final medicationsJson = medications.map((m) => m.toJson()).toList();
    await prefs.setString(_medicationsKey, json.encode(medicationsJson));
  }

  Future<List<Medication>> getMedications() async {
    final prefs = await _prefs;
    final medicationsString = prefs.getString(_medicationsKey);
    if (medicationsString == null) return [];

    final List<dynamic> medicationsJson = json.decode(medicationsString);
    return medicationsJson.map((json) => Medication.fromJson(json)).toList();
  }

  // Reminders
  Future<void> saveReminders(List<Reminder> reminders) async {
    final prefs = await _prefs;
    final remindersJson = reminders.map((r) => r.toJson()).toList();
    await prefs.setString(_remindersKey, json.encode(remindersJson));
  }

  Future<List<Reminder>> getReminders() async {
    final prefs = await _prefs;
    final remindersString = prefs.getString(_remindersKey);
    if (remindersString == null) return [];

    final List<dynamic> remindersJson = json.decode(remindersString);
    return remindersJson.map((json) => Reminder.fromJson(json)).toList();
  }

  // Appointments
  Future<void> saveAppointments(List<Appointment> appointments) async {
    final prefs = await _prefs;
    final appointmentsJson = appointments.map((a) => a.toJson()).toList();
    await prefs.setString(_appointmentsKey, json.encode(appointmentsJson));
  }

  Future<List<Appointment>> getAppointments() async {
    final prefs = await _prefs;
    final appointmentsString = prefs.getString(_appointmentsKey);
    if (appointmentsString == null) return [];

    final List<dynamic> appointmentsJson = json.decode(appointmentsString);
    return appointmentsJson.map((json) => Appointment.fromJson(json)).toList();
  }

  // Visits
  Future<void> saveVisits(List<Visit> visits) async {
    final prefs = await _prefs;
    final visitsJson = visits.map((v) => v.toJson()).toList();
    await prefs.setString(_visitsKey, json.encode(visitsJson));
  }

  Future<List<Visit>> getVisits() async {
    final prefs = await _prefs;
    final visitsString = prefs.getString(_visitsKey);
    if (visitsString == null) return [];

    final List<dynamic> visitsJson = json.decode(visitsString);
    return visitsJson.map((json) => Visit.fromJson(json)).toList();
  }

  // Caregivers
  Future<void> saveCaregivers(List<Caregiver> caregivers) async {
    final prefs = await _prefs;
    final caregiversJson = caregivers.map((c) => c.toJson()).toList();
    await prefs.setString(_caregiversKey, json.encode(caregiversJson));
  }

  Future<List<Caregiver>> getCaregivers() async {
    final prefs = await _prefs;
    final caregiversString = prefs.getString(_caregiversKey);
    if (caregiversString == null) return [];

    final List<dynamic> caregiversJson = json.decode(caregiversString);
    return caregiversJson.map((json) => Caregiver.fromJson(json)).toList();
  }

  // Clear all data
  Future<void> clearAllData() async {
    final prefs = await _prefs;
    await prefs.remove(_medicationsKey);
    await prefs.remove(_remindersKey);
    await prefs.remove(_appointmentsKey);
    await prefs.remove(_visitsKey);
    await prefs.remove(_caregiversKey);
  }

  // Get last sync timestamp
  Future<DateTime?> getLastSyncTimestamp() async {
    final prefs = await _prefs;
    final timestampString = prefs.getString('last_sync_timestamp');
    return timestampString != null ? DateTime.parse(timestampString) : null;
  }

  Future<void> setLastSyncTimestamp(DateTime timestamp) async {
    final prefs = await _prefs;
    await prefs.setString('last_sync_timestamp', timestamp.toIso8601String());
  }
}
