import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:record/record.dart';  // Temporarily disabled due to build issues
import 'package:path_provider/path_provider.dart';
import 'permissions_service.dart';

/// Service for handling audio recording operations (conversations, consultations)
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  // final AudioRecorder _audioRecorder = AudioRecorder();  // Temporarily disabled
  bool _isRecording = false;
  String? _currentRecordingPath;
  Timer? _recordingTimer;
  Duration _recordingDuration = Duration.zero;

  /// Check if currently recording
  bool get isRecording => _isRecording;

  /// Get current recording duration
  Duration get recordingDuration => _recordingDuration;

  /// Get current recording path
  String? get currentRecordingPath => _currentRecordingPath;

  /// Request microphone permission and initialize recorder
  Future<bool> initialize(BuildContext context) async {
    try {
      final permissionStatus =
          await PermissionsService().requestMicrophonePermission(context);
      if (permissionStatus != PermissionStatus.granted) {
        return false;
      }

      // Audio recording temporarily disabled due to build issues
      // TODO: Re-enable when record package issues are resolved
      debugPrint('Audio recording temporarily disabled');
      return false;
    } catch (e) {
      debugPrint('Error initializing audio recorder: $e');
      return false;
    }
  }

  /// Start recording audio
  Future<bool> startRecording(BuildContext context) async {
    // Temporarily disabled due to build issues with record package
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            'Audio recording temporarily unavailable. Feature coming soon!'),
        duration: Duration(seconds: 3),
      ),
    );
    return false;
  }

  /// Stop recording audio
  Future<String?> stopRecording() async {
    // Temporarily disabled
    _isRecording = false;
    _recordingTimer?.cancel();
    _recordingTimer = null;
    return null;
  }

  /// Pause recording
  Future<void> pauseRecording() async {
    // Temporarily disabled - record package commented out
    debugPrint('Audio recording is temporarily disabled');
    // try {
    //   await _audioRecorder.pause();
    //   _recordingTimer?.cancel();
    // } catch (e) {
    //   debugPrint('Error pausing recording: $e');
    // }
  }

  /// Resume recording
  Future<void> resumeRecording() async {
    // Temporarily disabled - record package commented out
    debugPrint('Audio recording is temporarily disabled');
    // try {
    //   await _audioRecorder.resume();
    //   _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
    //     _recordingDuration += const Duration(seconds: 1);
    //   });
    // } catch (e) {
    //   debugPrint('Error resuming recording: $e');
    // }
  }

  /// Cancel recording (delete the file)
  Future<void> cancelRecording() async {
    try {
      // await _audioRecorder.stop();  // Temporarily disabled
      _isRecording = false;
      _recordingTimer?.cancel();
      _recordingTimer = null;

      if (_currentRecordingPath != null) {
        final file = File(_currentRecordingPath!);
        if (await file.exists()) {
          await file.delete();
        }
        _currentRecordingPath = null;
      }
      _recordingDuration = Duration.zero;
    } catch (e) {
      debugPrint('Error canceling recording: $e');
    }
  }

  /// Get recording duration as formatted string
  String getFormattedDuration() {
    final minutes = _recordingDuration.inMinutes;
    final seconds = _recordingDuration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Check if recording is paused
  Future<bool> isRecordingPaused() async {
    // Temporarily disabled - record package commented out
    // try {
    //   return await _audioRecorder.isPaused();
    // } catch (e) {
    //   return false;
    // }
    return false;
  }

  /// Play recorded audio (placeholder for future implementation)
  Future<void> playRecording(String filePath) async {
    // TODO: Implement audio playback
    // This could use just_audio or audio_players package
    debugPrint('Playing recording: $filePath');
  }

  /// Delete recording file
  Future<bool> deleteRecording(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting recording: $e');
      return false;
    }
  }

  /// Get list of saved recordings
  Future<List<File>> getSavedRecordings() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final files = directory
          .listSync()
          .where((entity) {
            return entity is File && entity.path.endsWith('.m4a');
          })
          .cast<File>()
          .toList();

      // Sort by modification time (newest first)
      files
          .sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      return files;
    } catch (e) {
      debugPrint('Error getting saved recordings: $e');
      return [];
    }
  }

  /// Dispose resources
  void dispose() {
    _recordingTimer?.cancel();
    // _audioRecorder.dispose();  // Temporarily disabled
  }
}
