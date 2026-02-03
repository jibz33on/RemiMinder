import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/config/environment.dart';
import '../../../../core/services/auth_service.dart';

class RemindersApiService {
  final AuthService _authService;

  RemindersApiService({AuthService? authService})
      : _authService = authService ?? AuthService();

  Future<Map<String, dynamic>> fetchReminders() async {
    final accessToken = await _authService.getAccessToken();
    if (accessToken == null) {
      throw Exception('Authentication required. Please log in again.');
    }

    final uri = Uri.parse('${Environment.apiBaseUrl}/api/reminders');
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
}
