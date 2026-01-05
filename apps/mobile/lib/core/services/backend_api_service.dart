import 'dart:io';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import '../config/environment.dart';

/// Service for making authenticated API calls to the backend
class BackendApiService {
  final AuthService _authService;

  BackendApiService({AuthService? authService})
      : _authService = authService ?? AuthService();

  /// Upload audio file to backend
  Future<void> uploadAudio({
    required String visitId,
    required File audioFile,
  }) async {
    final accessToken = await _authService.getAccessToken();
    if (accessToken == null) {
      throw Exception('Authentication required. Please log in again.');
    }

    final uri =
        Uri.parse('${Environment.apiBaseUrl}/api/visits/$visitId/audio/upload');
    final request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer $accessToken';

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        audioFile.path,
        filename: 'recording.m4a',
      ),
    );

    final response = await request.send();

    if (response.statusCode != 200) {
      final responseBody = await response.stream.bytesToString();
      throw Exception(
          'Audio upload failed: ${response.statusCode} - $responseBody');
    }
  }

  /// Upload image file to backend
  Future<void> uploadImage({
    required String visitId,
    required File imageFile,
  }) async {
    final accessToken = await _authService.getAccessToken();
    if (accessToken == null) {
      throw Exception('Authentication required. Please log in again.');
    }

    final uri =
        Uri.parse('${Environment.apiBaseUrl}/api/visits/$visitId/image/upload');
    final request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer $accessToken';

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        filename: 'image.jpg',
      ),
    );

    final response = await request.send();

    if (response.statusCode != 200) {
      final responseBody = await response.stream.bytesToString();
      throw Exception(
          'Image upload failed: ${response.statusCode} - $responseBody');
    }
  }

  /// Bootstrap user in backend after Firebase authentication
  Future<void> bootstrapUser() async {
    final accessToken = await _authService.getAccessToken();
    if (accessToken == null) {
      throw Exception('Authentication required. Please log in again.');
    }

    final uri = Uri.parse('${Environment.apiBaseUrl}/api/users/bootstrap');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
          'User bootstrap failed: ${response.statusCode} - ${response.body}');
    }
  }
}
