import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/config/environment.dart';
import '../../../../core/services/auth_service.dart';
import '../models/care_team_invitation.dart';
import '../models/care_team_member.dart';

class CareTeamApiService {
  final AuthService _authService;

  CareTeamApiService({AuthService? authService})
      : _authService = authService ?? AuthService();

  Future<String> _getAccessToken() async {
    final accessToken = await _authService.getAccessToken();
    if (accessToken == null) {
      throw Exception('Authentication required. Please log in again.');
    }
    return accessToken;
  }

  Future<List<CareTeamMember>> getCareTeam() async {
    final accessToken = await _getAccessToken();
    final uri = Uri.parse('${Environment.apiBaseUrl}/api/care-team');
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
          .map((item) => CareTeamMember.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    throw Exception(
        'Failed to load care team: ${response.statusCode} - ${response.body}');
  }

  Future<void> inviteCaregiver({
    required String email,
    required String role,
    required String permission,
  }) async {
    final accessToken = await _getAccessToken();
    final uri = Uri.parse('${Environment.apiBaseUrl}/api/care-team/invite');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
        'role': role,
        'permission': permission,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
          'Failed to invite caregiver: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> acceptInvitation({required String token}) async {
    final accessToken = await _getAccessToken();
    final uri = Uri.parse('${Environment.apiBaseUrl}/api/care-team/accept');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: json.encode({'token': token}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
          'Failed to accept invitation: ${response.statusCode} - ${response.body}');
    }
  }

  Future<List<CareTeamInvitation>> getMyInvitations() async {
    final accessToken = await _getAccessToken();
    final uri =
        Uri.parse('${Environment.apiBaseUrl}/api/care-team/my-invitations');
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
          .map(
              (item) => CareTeamInvitation.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    throw Exception(
        'Failed to load invitations: ${response.statusCode} - ${response.body}');
  }

  Future<List<CareTeamInvitation>> getPendingInvitations() async {
    final accessToken = await _getAccessToken();
    final uri = Uri.parse('${Environment.apiBaseUrl}/api/care-team/pending');
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
          .map(
              (item) => CareTeamInvitation.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    throw Exception(
        'Failed to load pending invitations: ${response.statusCode} - ${response.body}');
  }

  Future<void> cancelPendingInvitation({required String invitationId}) async {
    final accessToken = await _getAccessToken();
    final uri = Uri.parse(
        '${Environment.apiBaseUrl}/api/care-team/pending/$invitationId');
    final response = await http.delete(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
          'Failed to cancel invitation: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> resendPendingInvitation(String invitationId) async {
    final accessToken = await _getAccessToken();
    final uri = Uri.parse(
        '${Environment.apiBaseUrl}/api/care-team/pending/$invitationId/resend');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
          'Failed to resend invitation: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> updatePermission({
    required String memberId,
    required String permission,
  }) async {
    final accessToken = await _getAccessToken();
    final uri = Uri.parse('${Environment.apiBaseUrl}/api/care-team/$memberId');
    final response = await http.patch(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: json.encode({'permission': permission}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
          'Failed to update permission: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> removeMember({required String memberId}) async {
    final accessToken = await _getAccessToken();
    final uri = Uri.parse('${Environment.apiBaseUrl}/api/care-team/$memberId');
    final response = await http.delete(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
          'Failed to remove member: ${response.statusCode} - ${response.body}');
    }
  }
}
