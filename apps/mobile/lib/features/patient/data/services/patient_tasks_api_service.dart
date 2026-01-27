import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/config/environment.dart';
import '../../../../core/services/auth_service.dart';
import '../models/patient_task.dart';

class PatientTasksApiService {
  final AuthService _authService;

  PatientTasksApiService({AuthService? authService})
      : _authService = authService ?? AuthService();

  Future<String> _getAccessToken() async {
    final accessToken = await _authService.getAccessToken();
    if (accessToken == null) {
      throw Exception('Authentication required. Please log in again.');
    }
    return accessToken;
  }

  Future<List<PatientTask>> fetchTasks() async {
    final accessToken = await _getAccessToken();
    final uri = Uri.parse('${Environment.apiBaseUrl}/api/patient/tasks');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map((item) => PatientTask.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    throw Exception(
        'Failed to load tasks: ${response.statusCode} - ${response.body}');
  }
}
