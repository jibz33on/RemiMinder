import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/models.dart';

class PatientApiService {
  final String baseUrl;
  final String authToken;

  PatientApiService({
    required this.baseUrl,
    required this.authToken,
  });

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      };

  // Medications
  Future<List<Medication>> getMedications() async {
    final response = await http.get(
      Uri.parse('$baseUrl/patient/medications'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Medication.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load medications');
    }
  }

  Future<Medication> createMedication(Medication medication) async {
    final response = await http.post(
      Uri.parse('$baseUrl/patient/medications'),
      headers: _headers,
      body: json.encode(medication.toJson()),
    );

    if (response.statusCode == 201) {
      return Medication.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create medication');
    }
  }

  // Reminders
  Future<List<Reminder>> getReminders() async {
    final response = await http.get(
      Uri.parse('$baseUrl/patient/reminders'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Reminder.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load reminders');
    }
  }

  Future<Reminder> createReminder(Reminder reminder) async {
    final response = await http.post(
      Uri.parse('$baseUrl/patient/reminders'),
      headers: _headers,
      body: json.encode(reminder.toJson()),
    );

    if (response.statusCode == 201) {
      return Reminder.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create reminder');
    }
  }

  Future<void> markReminderCompleted(String reminderId) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/patient/reminders/$reminderId/complete'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark reminder as completed');
    }
  }

  // Appointments
  Future<List<Appointment>> getAppointments() async {
    final response = await http.get(
      Uri.parse('$baseUrl/patient/appointments'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Appointment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load appointments');
    }
  }

  Future<Appointment> createAppointment(Appointment appointment) async {
    final response = await http.post(
      Uri.parse('$baseUrl/patient/appointments'),
      headers: _headers,
      body: json.encode(appointment.toJson()),
    );

    if (response.statusCode == 201) {
      return Appointment.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create appointment');
    }
  }

  // Visits
  Future<List<Visit>> getVisits() async {
    final response = await http.get(
      Uri.parse('$baseUrl/patient/visits'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Visit.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load visits');
    }
  }

  Future<Visit> createVisit(Visit visit) async {
    final response = await http.post(
      Uri.parse('$baseUrl/patient/visits'),
      headers: _headers,
      body: json.encode(visit.toJson()),
    );

    if (response.statusCode == 201) {
      return Visit.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create visit');
    }
  }

  // Caregivers
  Future<List<Caregiver>> getCaregivers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/patient/caregivers'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Caregiver.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load caregivers');
    }
  }

  Future<Caregiver> inviteCaregiver(Caregiver caregiver) async {
    final response = await http.post(
      Uri.parse('$baseUrl/patient/caregivers/invite'),
      headers: _headers,
      body: json.encode(caregiver.toJson()),
    );

    if (response.statusCode == 201) {
      return Caregiver.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to invite caregiver');
    }
  }

  Future<void> updateCaregiverPermissions(
      String caregiverId, List<Permission> permissions) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/patient/caregivers/$caregiverId/permissions'),
      headers: _headers,
      body: json.encode({
        'permissions': permissions.map((p) => p.index).toList(),
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update caregiver permissions');
    }
  }
}
