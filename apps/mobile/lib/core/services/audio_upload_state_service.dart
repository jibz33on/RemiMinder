import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

enum AudioUploadStatus {
  recorded,
  uploading,
  uploaded,
  failed,
}

class AudioUploadState {
  final AudioUploadStatus status;
  final String? audioId;
  final String? errorMessage;
  final DateTime updatedAt;

  AudioUploadState({
    required this.status,
    this.audioId,
    this.errorMessage,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'status': status.name,
      'audio_id': audioId,
      'error_message': errorMessage,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory AudioUploadState.fromJson(Map<String, dynamic> json) {
    final statusValue = json['status'] as String? ?? 'recorded';
    return AudioUploadState(
      status: AudioUploadStatus.values.firstWhere(
        (value) => value.name == statusValue,
        orElse: () => AudioUploadStatus.recorded,
      ),
      audioId: json['audio_id'] as String?,
      errorMessage: json['error_message'] as String?,
      updatedAt: DateTime.tryParse(json['updated_at'] as String? ?? ''),
    );
  }
}

class AudioUploadStateService {
  static const _prefix = 'audio_upload_state_';

  Future<AudioUploadState?> getState(String visitId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_prefix$visitId');
    if (raw == null) return null;
    return AudioUploadState.fromJson(json.decode(raw) as Map<String, dynamic>);
  }

  Future<void> setState(String visitId, AudioUploadState state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      '$_prefix$visitId',
      json.encode(state.toJson()),
    );
  }

  Future<void> clearState(String visitId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_prefix$visitId');
  }
}
