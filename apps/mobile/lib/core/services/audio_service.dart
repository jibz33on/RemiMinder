import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Service for handling audio recording operations (conversations, consultations)
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  Record? _audioRecorder;
  stt.SpeechToText? _speechToText;
  bool _isRecording = false;
  bool _isListening = false;
  String? _currentRecordingPath;
  Timer? _recordingTimer;
  Duration _recordingDuration = Duration.zero;
  String _transcription = '';
  String _lastFinalTranscript = '';
  String _currentSegment = '';
  Function(String)? _onResultCallback;

  /// Check if currently recording
  bool get isRecording => _isRecording;

  /// Get current recording duration
  Duration get recordingDuration => _recordingDuration;

  /// Get current recording path
  String? get currentRecordingPath => _currentRecordingPath;

  /// Get current transcription
  String get transcription => _transcription;

  /// Check if currently listening for speech
  bool get isListening => _isListening;

  /// Request microphone permission and initialize recorder
  /// Uses record package's hasPermission() as source of truth on iOS
  /// NOTE: Speech-to-text is initialized separately on-demand to avoid iOS audio session conflicts
  Future<bool> initialize(BuildContext context) async {
    try {
      print('🎙️ Initializing audio service...');

      // Initialize record package first
      _audioRecorder ??= Record();

      // 🔥 iOS-safe: Use record package's hasPermission() as authoritative source
      final hasPermission = await _audioRecorder!.hasPermission();
      print(
          '🎙️ Recorder hasPermission (authoritative on iOS): $hasPermission');

      if (!hasPermission) {
        print('🎙️ Microphone permission not granted by hardware API');

        // Show dialog to open settings
        if (context.mounted) {
          await _showPermissionDialog(
            context,
            'Microphone access is needed to record conversations. Please enable it in Settings > RemiMinder > Microphone.',
          );
        }
        return false;
      }

      print('✅ Microphone permission granted! Audio recorder ready.');

      // NOTE: Speech-to-text will be initialized on-demand when startListening() is called
      // This prevents iOS audio session conflicts

      return true;
    } catch (e) {
      debugPrint('❌ Error initializing audio recorder: $e');
      return false;
    }
  }

  Future<void> _showPermissionDialog(
      BuildContext context, String message) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Microphone Permission Required'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  /// Start recording audio
  /// iOS-safe: Includes delay to prevent AVAudioSession race conditions
  Future<bool> startRecording(BuildContext context) async {
    try {
      if (_isRecording) {
        debugPrint('⚠️ Already recording');
        return false;
      }

      if (_audioRecorder == null) {
        final initialized = await initialize(context);
        if (!initialized) return false;
      }

      // Get the directory to save recordings
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      _currentRecordingPath = '${directory.path}/recording_$timestamp.m4a';

      // 🔥 iOS-CRITICAL: Small delay prevents AVAudioSession crash
      // This gives iOS time to properly configure the audio session
      await Future.delayed(const Duration(milliseconds: 300));

      debugPrint('🎙️ Starting recorder with path: $_currentRecordingPath');

      // Start recording with record package
      await _audioRecorder!.start(
        path: _currentRecordingPath!,
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        samplingRate: 44100,
      );

      _isRecording = true;
      _recordingDuration = Duration.zero;
      _transcription = '';
      _lastFinalTranscript = '';
      _currentSegment = '';
      _startRecordingTimer();

      debugPrint('✅ Recording started successfully');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Recording started...'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return true;
    } catch (e) {
      debugPrint('❌ Error starting recording: $e');
      _isRecording = false;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to start recording: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
      return false;
    }
  }

  /// Stop recording audio
  Future<String?> stopRecording() async {
    try {
      if (!_isRecording || _audioRecorder == null) return null;

      final path = await _audioRecorder!.stop();
      _isRecording = false;
      _recordingTimer?.cancel();
      _recordingTimer = null;

      // Verify the file was created and has content
      if (path != null) {
        final file = File(path);
        final exists = await file.exists();
        final size = exists ? await file.length() : 0;

        if (exists && size > 0) {
          debugPrint('Recording saved successfully: $path (${size} bytes)');
          return path;
        } else {
          debugPrint('Recording file is empty or missing');
          return null;
        }
      }

      return _currentRecordingPath;
    } catch (e) {
      debugPrint('Error stopping recording: $e');
      _isRecording = false;
      _recordingTimer?.cancel();
      _recordingTimer = null;
      return null;
    }
  }

  /// Pause recording
  Future<void> pauseRecording() async {
    try {
      if (_audioRecorder != null && _isRecording) {
        await _audioRecorder!.pause();
        _recordingTimer?.cancel();
        debugPrint('Recording paused');
      }
    } catch (e) {
      debugPrint('Error pausing recording: $e');
    }
  }

  /// Resume recording
  Future<void> resumeRecording() async {
    try {
      if (_audioRecorder != null && _isRecording) {
        await _audioRecorder!.resume();
        _startRecordingTimer();
        debugPrint('Recording resumed');
      }
    } catch (e) {
      debugPrint('Error resuming recording: $e');
    }
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
    try {
      return !(await _audioRecorder?.isRecording() ?? false);
    } catch (e) {
      debugPrint('Error checking recording pause state: $e');
      return false;
    }
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

  /// Start the recording timer
  void _startRecordingTimer() {
    _recordingTimer?.cancel();
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _recordingDuration += const Duration(seconds: 1);
    });
  }

  /// Start real-time speech-to-text listening
  /// Designed for continuous medical consultations (5-30+ minutes)
  /// - No time limits: Auto-restarts when segments complete
  /// - Only stops when user hits stop button
  /// - Accumulates all segments for LLM processing
  /// iOS-safe: Initializes on-demand and waits for recorder to stabilize
  Future<bool> startListening(Function(String) onResult) async {
    try {
      // Store callback for auto-restart
      _onResultCallback = onResult;

      // Initialize speech-to-text on-demand if not already initialized
      if (_speechToText == null) {
        debugPrint('🎤 Initializing speech-to-text on-demand...');
        _speechToText = stt.SpeechToText();

        final available = await _speechToText!.initialize(
          onStatus: (status) {
            debugPrint(
                '🔊 Speech status: $status | listening=$_isListening | recording=$_isRecording | transcript=${_transcription.length} chars');
            // Auto-restart when done, if still recording
            // This ensures continuous transcription throughout the entire consultation
            if (status == 'done') {
              if (_isListening && _isRecording) {
                debugPrint(
                    '✅ STATUS=DONE - Conditions met for restart. Auto-restarting in 1 second (allows proper finalization)...');
                Future.delayed(const Duration(seconds: 1), () {
                  if (_isListening && _isRecording) {
                    debugPrint('🔄 Executing auto-restart now...');
                    _restartListening();
                  } else {
                    debugPrint(
                        '❌ Restart cancelled: listening=$_isListening, recording=$_isRecording');
                  }
                });
              } else {
                debugPrint(
                    '⚠️ STATUS=DONE but NOT restarting: listening=$_isListening, recording=$_isRecording');
              }
            } else if (status == 'notListening') {
              if (_isListening && _isRecording) {
                debugPrint(
                    '⚠️ STATUS=NOT_LISTENING - Unexpected stop, restarting in 1 second...');
                Future.delayed(const Duration(seconds: 1), () {
                  if (_isListening && _isRecording) {
                    _restartListening();
                  }
                });
              }
            }
          },
          onError: (error) => debugPrint('Speech recognition error: $error'),
        );

        if (!available) {
          debugPrint('❌ Speech recognition not available');
          return false;
        }

        debugPrint('✅ Speech-to-text initialized successfully');
      }

      if (!_speechToText!.isAvailable) {
        debugPrint('❌ Speech recognition not available');
        return false;
      }

      // 🔥 iOS-CRITICAL: If recorder is running, wait for it to stabilize
      // This prevents audio session conflicts
      if (_isRecording) {
        debugPrint(
            '⏳ Waiting for recorder to stabilize before starting speech-to-text...');
        await Future.delayed(const Duration(seconds: 1));
      }

      _isListening = true;
      if (_lastFinalTranscript.isEmpty) {
        _lastFinalTranscript = '';
        _currentSegment = '';
      }

      debugPrint('🎤 Starting speech-to-text listening...');

      await _speechToText!.listen(
        onResult: (result) {
          if (result.finalResult) {
            // Final result - append to accumulated transcript
            final segment = result.recognizedWords;
            if (segment.isNotEmpty) {
              _lastFinalTranscript += segment + ' ';
              _currentSegment = '';
              _transcription = _lastFinalTranscript;
              debugPrint(
                  '📝 Final segment added (${segment.length} chars): ${segment.length > 50 ? segment.substring(0, 50) + "..." : segment}');
              debugPrint(
                  '📊 Total transcription: ${_transcription.length} chars');
            }
          } else {
            // Partial result - show temporarily without saving
            _currentSegment = result.recognizedWords;
            _transcription = _lastFinalTranscript + _currentSegment;
          }
          if (_onResultCallback != null) {
            _onResultCallback!(_transcription);
          }
        },
        listenFor: const Duration(
            hours: 2), // No practical limit for medical consultations
        pauseFor: const Duration(
            seconds: 3), // Quick finalization, auto-restart handles continuity
        partialResults: true,
        cancelOnError: false, // Continue even on minor errors
        localeId:
            'en_US', // Explicit locale improves accuracy. Use 'en_IN' for Indian accents
      );

      debugPrint('✅ Speech-to-text listening started');
      return true;
    } catch (e) {
      debugPrint('❌ Error starting speech listening: $e');
      _isListening = false;
      return false;
    }
  }

  /// Internal method to restart listening after it auto-stops
  /// This enables truly continuous transcription for long medical consultations
  Future<void> _restartListening() async {
    if (!_isListening || !_isRecording || _speechToText == null) {
      debugPrint(
          '⏹️ Not restarting: listening=$_isListening, recording=$_isRecording, speechToText=${_speechToText != null}');
      return;
    }

    try {
      debugPrint(
          '🔄 Auto-restarting speech recognition (accumulated: ${_transcription.length} chars)...');

      await _speechToText!.listen(
        onResult: (result) {
          if (result.finalResult) {
            // Final result - append to accumulated transcript
            final segment = result.recognizedWords;
            if (segment.isNotEmpty) {
              _lastFinalTranscript += segment + ' ';
              _currentSegment = '';
              _transcription = _lastFinalTranscript;
              debugPrint(
                  '📝 Final segment added (${segment.length} chars): ${segment.length > 50 ? segment.substring(0, 50) + "..." : segment}');
              debugPrint(
                  '📊 Total transcription: ${_transcription.length} chars');
            }
          } else {
            // Partial result - show temporarily without saving
            _currentSegment = result.recognizedWords;
            _transcription = _lastFinalTranscript + _currentSegment;
          }
          if (_onResultCallback != null) {
            _onResultCallback!(_transcription);
          }
        },
        listenFor: const Duration(
            hours: 2), // No practical limit for medical consultations
        pauseFor: const Duration(
            seconds: 3), // Quick finalization, auto-restart handles continuity
        partialResults: true,
        cancelOnError: false, // Continue even on minor errors
        localeId:
            'en_US', // Explicit locale improves accuracy. Use 'en_IN' for Indian accents
      );

      debugPrint('✅ Speech-to-text listening restarted');
    } catch (e) {
      debugPrint('❌ Error restarting speech listening: $e');
    }
  }

  /// Stop speech-to-text listening
  Future<void> stopListening() async {
    if (_speechToText != null && _isListening) {
      _isListening = false; // Set this first to prevent auto-restart
      await _speechToText!.stop();
      _onResultCallback = null;
      // Keep the final transcription, just mark as not listening
      debugPrint(
          '🎤 Speech-to-text stopped. Final transcription length: ${_transcription.length} characters');
    }
  }

  /// Transcribe recorded audio file (for post-processing if real-time fails)
  Future<String?> transcribeAudioFile(String filePath) async {
    // Note: This would require a speech-to-text service like Google Cloud Speech-to-Text
    // For now, we'll rely on real-time transcription
    // TODO: Implement file-based transcription using Google Cloud Speech API
    debugPrint(
        'File transcription not yet implemented. Use real-time transcription.');
    return null;
  }

  /// Get cleaned transcription with formatting hints for LLM processing
  /// This prepares the transcript for post-processing to improve accuracy
  String getFormattedTranscriptForCleanup() {
    if (_transcription.isEmpty) return '';

    debugPrint(
        '📝 Preparing transcript for LLM cleanup (${_transcription.length} chars)');

    // Return transcript with metadata for LLM processing
    return '''
Medical Conversation Transcript (Raw)
Duration: ${_recordingDuration.inMinutes} minutes ${_recordingDuration.inSeconds % 60} seconds
Length: ${_transcription.length} characters

Transcript:
$_transcription

Instructions for cleanup:
- Fix grammar and punctuation
- Normalize verb tenses (e.g., "continue" → "continues")
- Add articles where missing (e.g., "after week" → "after a week")
- Do NOT add or remove medical information
- Do NOT change meaning or intent
- Preserve all medical terms and symptoms mentioned
- Return only the cleaned transcript, no additional commentary
''';
  }

  /// Get transcript with basic speaker inference (heuristic-based)
  /// This attempts to identify doctor vs patient speech patterns
  String getTranscriptWithSpeakerLabels() {
    if (_transcription.isEmpty) return '';

    // Split by sentences and apply simple heuristics
    final sentences = _transcription.split(RegExp(r'[.!?]\s+'));
    final StringBuffer formatted = StringBuffer();

    for (var sentence in sentences) {
      if (sentence.trim().isEmpty) continue;

      final lowerSentence = sentence.toLowerCase();
      String speaker = 'Unknown';

      // Simple heuristic rules (can be improved with ML)
      if (lowerSentence
          .contains(RegExp(r'\b(doctor|hi doctor|hello doctor)\b'))) {
        speaker = 'Patient';
      } else if (lowerSentence.contains(
          RegExp(r'\b(bring you|what.*you|any.*you|prescribe|like you)\b'))) {
        speaker = 'Doctor';
      } else if (lowerSentence
          .contains(RegExp(r'\b(i have|my|i feel|having)\b'))) {
        speaker = 'Patient';
      } else if (lowerSentence
          .contains(RegExp(r'\b(prescribe|examine|test|scan|come back)\b'))) {
        speaker = 'Doctor';
      }

      formatted.writeln('$speaker: ${sentence.trim()}');
    }

    return formatted.toString();
  }

  /// Dispose resources
  void dispose() {
    _recordingTimer?.cancel();
    _audioRecorder?.dispose();
    _audioRecorder = null;
    _speechToText = null;
  }
}
