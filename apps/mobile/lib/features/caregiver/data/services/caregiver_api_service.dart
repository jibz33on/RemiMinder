import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/config/environment.dart';
import '../../../../core/services/auth_service.dart';
import '../models/caregiver_patient.dart';

class CaregiverApiService {
  final AuthService _authService;

  CaregiverApiService({AuthService? authService})
      : _authService = authService ?? AuthService();

  Future<String> _getAccessToken() async {
    final accessToken = await _authService.getAccessToken();
    if (accessToken == null) {
      throw Exception('Authentication required. Please log in again.');
    }
    return accessToken;
  }

  Future<List<CaregiverPatient>> getMyPatients() async {
    final accessToken = await _getAccessToken();
    final uri = Uri.parse('${Environment.apiBaseUrl}/api/care-team/my-patients');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to load patients: ${response.statusCode} - ${response.body}');
    }

    final List<dynamic> data = json.decode(response.body) as List<dynamic>;
    return data
        .map((item) => CaregiverPatient.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> getPatientReminders(String patientId) async {
    final accessToken = await _getAccessToken();
    final uri =
        Uri.parse('${Environment.apiBaseUrl}/api/patients/$patientId/reminders');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to load reminders: ${response.statusCode} - ${response.body}');
    }

    return json.decode(response.body) as Map<String, dynamic>;
  }

  Future<List<dynamic>> getPatientTasks(String patientId) async {
    final accessToken = await _getAccessToken();
    final uri =
        Uri.parse('${Environment.apiBaseUrl}/api/patients/$patientId/tasks');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to load tasks: ${response.statusCode} - ${response.body}');
    }

    return json.decode(response.body) as List<dynamic>;
  }
}
