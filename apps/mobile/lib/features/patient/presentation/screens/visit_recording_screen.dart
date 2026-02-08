import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import '../../../../core/services/audio_service.dart';
import '../../../../core/services/audio_upload_state_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/preferences_service.dart';
import '../../../../core/services/consent_service.dart';
import '../../../../core/services/visit_context.dart';
import '../../../../core/config/environment.dart';
import '../../../../l10n/app_localizations.dart';

class VisitRecordingScreen extends StatefulWidget {
  final String visitId;

  const VisitRecordingScreen({
    super.key,
    required this.visitId,
  });

  @override
  State<VisitRecordingScreen> createState() => _VisitRecordingScreenState();
}

class _VisitRecordingScreenState extends State<VisitRecordingScreen>
    with WidgetsBindingObserver {
  final AudioService _audioService = AudioService();
  final AudioUploadStateService _uploadStateService =
      AudioUploadStateService();
  final AuthService _authService = AuthService();
  final ConsentService _consentService = ConsentService();
  RecordingState _recordingState = RecordingState.idle;
  Timer? _timer;
  int _secondsElapsed = 0;
  String _formattedTime = '00:00';
  String? _audioFilePath;
  StreamSubscription<String>? _audioEventSub;
  bool _wasBackgroundedWhileRecording = false;
  AudioUploadState? _uploadState;
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  bool _isGeneratingSummary = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Establish this visit as the current visit context
    VisitContext().setCurrentVisit(widget.visitId);
    _updateFormattedTime(); // Initialize timer display
    _audioEventSub = _audioService.platformEvents.listen(_handleAudioEvent);
    _loadUploadState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioEventSub?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _audioService.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      if (_recordingState == RecordingState.recording) {
        _wasBackgroundedWhileRecording = true;
      }
    } else if (state == AppLifecycleState.resumed &&
        _wasBackgroundedWhileRecording) {
      _wasBackgroundedWhileRecording = false;
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recording is still active.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _loadUploadState() async {
    final state = await _uploadStateService.getState(widget.visitId);
    if (!mounted || state == null) return;

    if (state.status == AudioUploadStatus.uploading) {
      final interrupted = AudioUploadState(
        status: AudioUploadStatus.failed,
        errorMessage: 'Upload interrupted. Please retry.',
      );
      await _uploadStateService.setState(widget.visitId, interrupted);
      setState(() {
        _uploadState = interrupted;
      });
      return;
    }

    setState(() {
      _uploadState = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: _handleClose,
        ),
        title: Text(
          l10n?.visitRecordingTitle ?? 'Record Visit',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (_recordingState == RecordingState.completed)
            TextButton(
              onPressed: _saveRecording,
              child: Text(
                l10n?.visitRecordingSave ?? 'Save',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: animation,
                          child: child,
                        ),
                      );
                    },
                    child: _buildStateContent(_recordingState),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStateContent(RecordingState state) {
    // Use MediaQuery to determine screen size and adjust layout
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen =
        screenHeight < 700; // iPhone SE and similar small screens

    return Column(
      key: ValueKey(state), // Required for AnimatedSwitcher
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Timer Display - Always visible, hero element
        Container(
          width:
              isSmallScreen ? 200 : 250, // Fixed width for consistent alignment
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 24 : 32,
            vertical: isSmallScreen ? 12 : 16,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(isSmallScreen ? 20 : 24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Text(
            _formattedTime,
            style: TextStyle(
              fontSize: isSmallScreen ? 36 : 48,
              fontWeight: FontWeight.bold,
              color: _getTimerColor(),
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
            textAlign: TextAlign.center,
          ),
        ),

        SizedBox(height: isSmallScreen ? 16 : 20),

        // Recording Status
        Container(
          constraints: BoxConstraints(
            minWidth: isSmallScreen ? 140 : 160, // Fixed minimum width
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: _getStatusColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _getStatusText(),
            style: TextStyle(
              color: _getStatusColor(),
              fontWeight: FontWeight.w600,
              fontSize: isSmallScreen ? 14 : 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        SizedBox(height: isSmallScreen ? 12 : 16),

        // State-specific content - All buttons use identical width constraints
        SizedBox(
          width: isSmallScreen ? 200 : 240, // Fixed width for all button areas
          child: state == RecordingState.idle
              ? _buildMicButtonContent(isSmallScreen)
              : state == RecordingState.recording
                  ? _buildStopButtonContent(isSmallScreen)
                  : state == RecordingState.paused
                      ? _buildPausedButtonsContent(isSmallScreen)
                      : _buildCompletedButtonsContent(isSmallScreen),
        ),

        SizedBox(height: isSmallScreen ? 12 : 16),

        // Recording Instructions - state-specific
        SizedBox(
          width: isSmallScreen
              ? 280
              : 320, // Fixed width for consistent text alignment
          child: Text(
            _getRecordingInstructions(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: isSmallScreen ? 13 : 15,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
          ),
        ),
      ],
    );
  }

  Widget _buildMicButtonContent(bool isSmallScreen) {
    return GestureDetector(
      onTap: _toggleRecording,
      child: Container(
        width: double.infinity,
        height: isSmallScreen ? 100 : 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Icon(
          Icons.mic,
          color: Colors.white,
          size: isSmallScreen ? 40 : 52,
        ),
      ),
    );
  }

  Widget _buildPausedButtonsContent(bool isSmallScreen) {
    return Column(
      children: [
        GestureDetector(
          onTap: _toggleRecording,
          child: Container(
            width: double.infinity,
            height: isSmallScreen ? 100 : 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: isSmallScreen ? 40 : 52,
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: _stopRecording,
          child: const Text(
            'Stop recording',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }

  Widget _buildStopButtonContent(bool isSmallScreen) {
    return _PulsingButton(
      child: GestureDetector(
        onTap: _toggleRecording,
        child: Container(
          width: double.infinity,
          height: isSmallScreen ? 100 : 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Colors.red, Colors.redAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.3),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            Icons.stop,
            color: Colors.white,
            size: isSmallScreen ? 40 : 52,
          ),
        ),
      ),
    );
  }

  Widget _buildCompletedButtonsContent(bool isSmallScreen) {
    final status = _uploadState?.status;
    if (status == AudioUploadStatus.uploading) {
      return Column(
        children: [
          const SizedBox(height: 8),
          const Text(
            'Uploading...',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(value: _uploadProgress),
          const SizedBox(height: 12),
          Text('${(_uploadProgress * 100).toStringAsFixed(0)}%'),
        ],
      );
    }

    if (status == AudioUploadStatus.failed) {
      return Column(
        children: [
          const SizedBox(height: 8),
          Text(
            _uploadState?.errorMessage ?? 'Upload failed. Please retry.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _startUpload,
            icon: const Icon(Icons.refresh, size: 20),
            label: const Text('Retry Upload'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              minimumSize: const Size(double.infinity, 0),
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _discardRecording,
            icon: const Icon(Icons.delete_outline, size: 20),
            label: const Text('Discard Recording'),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
              foregroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              minimumSize: const Size(double.infinity, 0),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        // Success Checkmark
        Container(
          width: isSmallScreen ? 50 : 60,
          height: isSmallScreen ? 50 : 60,
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check,
            color: Colors.white,
            size: isSmallScreen ? 28 : 32,
          ),
        ),

        SizedBox(height: isSmallScreen ? 12 : 16),

        // Generate Summary Button
        ElevatedButton.icon(
          onPressed: (_uploadState?.status == AudioUploadStatus.uploaded && !_isGeneratingSummary)
              ? _generateSummary
              : null,
          icon: _isGeneratingSummary
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Icon(Icons.auto_awesome, size: 20),
          label: Text(
              _isGeneratingSummary
                  ? 'Generating...'
                  : (AppLocalizations.of(context)?.visitRecordingGenerateSummary ??
                      'Generate Summary')),
          style: ElevatedButton.styleFrom(
            backgroundColor: (_uploadState?.status == AudioUploadStatus.uploaded && !_isGeneratingSummary)
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            foregroundColor: (_uploadState?.status == AudioUploadStatus.uploaded && !_isGeneratingSummary)
                ? Colors.white
                : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            minimumSize:
                Size(double.infinity, 0), // Full width within container
          ),
        ),

        if (_uploadState?.status != AudioUploadStatus.uploaded)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Save your recording first to generate a summary',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.secondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),

        SizedBox(height: isSmallScreen ? 8 : 12),

        // Discard Button
        OutlinedButton.icon(
          onPressed: _discardRecording,
          icon: const Icon(Icons.delete_outline, size: 20),
          label: Text(
              AppLocalizations.of(context)?.visitRecordingDiscardRecording ??
                  'Discard Recording'),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.red),
            foregroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            minimumSize:
                Size(double.infinity, 0), // Full width within container
          ),
        ),
      ],
    );
  }

  Color _getTimerColor() {
    switch (_recordingState) {
      case RecordingState.idle:
        return Theme.of(context).colorScheme.primary;
      case RecordingState.recording:
        return Colors.red;
      case RecordingState.paused:
        return Colors.orange;
      case RecordingState.completed:
        return Colors.green;
    }
  }

  void _toggleRecording() {
    switch (_recordingState) {
      case RecordingState.idle:
        _startRecording();
        break;
      case RecordingState.recording:
        _stopRecording();
        break;
      case RecordingState.paused:
        _resumeRecording();
        break;
      case RecordingState.completed:
        _resetRecording();
        break;
    }
  }

  void _startRecording() async {
    // Check if user has accepted audio consent
    final hasConsent = await _consentService.hasAcceptedAudioConsent();
    if (!mounted) return;

    if (!hasConsent) {
      final accepted = await _showAudioConsentDialog();
      if (!mounted) return;

      if (!accepted) {
        return; // User declined consent
      }
    }

    print('🎬 Starting recording...');
    final success = await _audioService.startRecording(context);
    if (!mounted) return;

    print('🎬 Recording start success: $success');
    if (success) {
      setState(() {
        _recordingState = RecordingState.recording;
        _secondsElapsed = 0;
        _updateFormattedTime();
      });

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            _secondsElapsed++;
            _updateFormattedTime();
          });
        }
      });
    } else {
      // Permission denied or initialization failed
      print('🎬 Recording failed - permission denied or initialization error');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)
                    ?.visitRecordingMicPermission ??
                'Microphone permission is required. Please enable it in Settings > RemiMinder > Microphone.'),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _stopRecording() async {
    final recordingPath = await _audioService.stopRecording();
    if (!mounted) return;

    setState(() {
      _recordingState = RecordingState.completed;
      _audioFilePath = recordingPath;
    });

    _timer?.cancel();

    if (recordingPath != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)
                    ?.visitRecordingCompleted ??
                'Recording completed!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)
                    ?.visitRecordingSaveFailed ??
                'Failed to save recording')),
      );
    }
  }

  void _resetRecording() async {
    await _audioService.cancelRecording();
    if (!mounted) return;

    setState(() {
      _recordingState = RecordingState.idle;
      _secondsElapsed = 0;
      _formattedTime = '00:00';
    });

    _timer?.cancel();
  }

  Future<void> _pauseForInterruption(String message) async {
    if (_recordingState != RecordingState.recording) return;
    await _audioService.pauseRecording();
    if (!mounted) return;
    setState(() {
      _recordingState = RecordingState.paused;
    });
    _timer?.cancel();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _resumeRecording() async {
    await _audioService.resumeRecording();
    if (!mounted) return;
    setState(() {
      _recordingState = RecordingState.recording;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _secondsElapsed++;
          _updateFormattedTime();
        });
      }
    });
  }

  void _handleAudioEvent(String event) {
    switch (event) {
      case 'interruptionBegan':
      case 'audioFocusLoss':
      case 'audioFocusLossTransient':
        _pauseForInterruption(
            'Recording paused due to an interruption. Tap to resume.');
        break;
      case 'interruptionEnded':
      case 'audioFocusGain':
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Interruption ended. Tap to resume recording.'),
            duration: Duration(seconds: 3),
          ),
        );
        break;
    }
  }

  void _discardRecording() async {
    // Delete the recorded file if it exists
    if (_audioFilePath != null) {
      await _audioService.deleteRecording(_audioFilePath!);
    }

    // Reset to idle state
    setState(() {
      _recordingState = RecordingState.idle;
      _secondsElapsed = 0;
      _formattedTime = '00:00';
      _audioFilePath = null;
    });

    _timer?.cancel();

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(AppLocalizations.of(context)
                  ?.visitRecordingDiscarded ??
              'Recording discarded')),
    );
  }

  void _saveRecording() async {
    await _startUpload();
  }

  Future<void> _startUpload() async {
    if (_isUploading ||
        _uploadState?.status == AudioUploadStatus.uploaded) {
      return;
    }

    if (_audioFilePath == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)
                    ?.visitRecordingNoRecording ??
                'No recording available')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
      _uploadState = AudioUploadState(status: AudioUploadStatus.uploading);
    });
    await _uploadStateService.setState(widget.visitId, _uploadState!);

    try {
      final result = await _uploadAudioToBackend(
        _audioFilePath!,
        onProgress: (progress) {
          if (!mounted) return;
          setState(() {
            _uploadProgress = progress;
          });
        },
      );

      final uploadedState = AudioUploadState(
        status: AudioUploadStatus.uploaded,
        audioId: result.audioId,
      );
      await _uploadStateService.setState(widget.visitId, uploadedState);
      if (!mounted) return;
      setState(() {
        _uploadState = uploadedState;
      });

      // Processing will be triggered explicitly by user action
      if (!mounted) return;

      // Clean up local file
      await _audioService.deleteRecording(_audioFilePath!);
      if (!mounted) return;

      // Show success message and stay on screen to allow Generate Summary
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)?.visitRecordingSaved ??
              '✅ Recording saved successfully! You can now generate a summary.'),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      final failedState = AudioUploadState(
        status: AudioUploadStatus.failed,
        errorMessage: 'Upload failed. Please retry.',
      );
      await _uploadStateService.setState(widget.visitId, failedState);
      if (!mounted) return;

      setState(() {
        _uploadState = failedState;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)
                    ?.visitRecordingUploadFailed(e.toString()) ??
                'Failed to upload audio: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  Future<_UploadResult> _uploadAudioToBackend(
    String audioFilePath, {
    required void Function(double progress) onProgress,
  }) async {
    // Get access token from AuthService
    final accessToken = await _authService.getAccessToken();
    if (accessToken == null) {
      throw Exception('Authentication required. Please log in again.');
    }

    // Use the visit ID from widget arguments
    final visitId = widget.visitId;

    // Use API_BASE_URL from environment configuration
    final uri =
        Uri.parse('${Environment.apiBaseUrl}/api/visits/$visitId/audio/upload');
    final request = http.MultipartRequest('POST', uri);

    // Add authentication header
    request.headers['Authorization'] = 'Bearer $accessToken';

    final appLanguage = await PreferencesService().getAppLanguage();
    final visitLanguage = await PreferencesService().getDefaultVisitLanguage();
    final deviceLocale =
        mounted ? Localizations.localeOf(context).toString() : null;
    final languageHints = <String, String>{};
    if (appLanguage != null && appLanguage.isNotEmpty) {
      languageHints['app_language'] = appLanguage;
    }
    if (visitLanguage != null && visitLanguage.isNotEmpty) {
      languageHints['visit_language'] = visitLanguage;
    }
    if (deviceLocale != null && deviceLocale.isNotEmpty) {
      languageHints['device_locale'] = deviceLocale;
    }
    if (languageHints.isNotEmpty) {
      request.fields['language_hints'] = json.encode(languageHints);
    }

    // Use MultipartFile.fromPath for efficient streaming (no memory loading)
    final file = File(audioFilePath);
    final fileLength = await file.length();
    var bytesSent = 0;
    final stream = file.openRead().transform(
      StreamTransformer<List<int>, List<int>>.fromHandlers(
        handleData: (data, sink) {
          bytesSent += data.length;
          onProgress(bytesSent / fileLength);
          sink.add(data);
        },
      ),
    );
    final multipartFile = http.MultipartFile(
      'file',
      stream,
      fileLength,
      filename: 'recording.wav',
    );
    request.files.add(multipartFile);

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode != 200) {
      throw Exception(
          'Audio upload failed: ${response.statusCode} - $responseBody');
    }

    final payload = json.decode(responseBody) as Map<String, dynamic>;
    if (payload['status'] != 'uploaded') {
      throw Exception('Audio upload failed: invalid response');
    }
    return _UploadResult(
      audioId: payload['audio_id'] as String?,
    );
  }

  Future<void> _generateSummary() async {
    print("📋 Stage 2: Generating summary for visit ${widget.visitId}");

    if (!mounted) return;
    setState(() {
      _isGeneratingSummary = true;
    });

    try {
      // Double-check that audio has been uploaded
      if (_uploadState?.status != AudioUploadStatus.uploaded) {
        throw Exception('Please save your recording first before generating summary.');
      }

    final accessToken = await _authService.getAccessToken();
    if (accessToken == null) {
      throw Exception('Authentication required. Please log in again.');
    }

    final visitId = widget.visitId;
    final uri = Uri.parse(
        '${Environment.apiBaseUrl}/api/visits/$visitId/generate-summary');

    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      print("📋 generate-summary status: ${response.statusCode}");

      if (response.statusCode == 404) {
        // Audio not found - user needs to upload first
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)
                    ?.visitRecordingNoRecording ??
                'Please save your recording first before generating summary.'),
            duration: const Duration(seconds: 5),
          ),
        );
        return;
      }

      if (response.statusCode != 200) {
        final responseBody = response.body;
        throw Exception(
            'Failed to generate summary: ${response.statusCode} - $responseBody');
      }

      // Parse response to get job info
      final responseBody = response.body;
      // Response contains job information but we don't need it for UI

      if (!mounted) return;

      // Show success dialog and navigate
      await showDialog<void>(
        context: context,
        builder: (context) {
          final l10n = AppLocalizations.of(context);
          return AlertDialog(
            title: Text(l10n?.visitRecordingProcessingTitle ??
                '✅ Summary generation started'),
            content: Text(
              l10n?.visitRecordingProcessingBody ??
                  'Your visit summary is being generated.\nYou can continue using the app. We\'ll notify you when it\'s ready.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go('/patient/home');
                },
                child: Text(
                    l10n?.visitRecordingGoToHome ?? 'Go to Home'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isGeneratingSummary = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)
                    ?.visitRecordingUploadFailed(e.toString()) ??
                'Failed to start summary generation: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isGeneratingSummary = false;
        });
      }
    }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isGeneratingSummary = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)
                    ?.visitRecordingUploadFailed(e.toString()) ??
                'Failed to start summary generation: ${e.toString()}')),
      );
    }
  }

  void _handleClose() {
    if (_recordingState == RecordingState.recording ||
        _recordingState == RecordingState.paused) {
      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (context) {
          final l10n = AppLocalizations.of(context);
          return AlertDialog(
            title: Text(l10n?.visitRecordingStopTitle ??
                'Stop Recording?'),
            content: Text(l10n?.visitRecordingStopConfirm ??
                'Are you sure you want to stop recording? This action cannot be undone.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n?.visitRecordingContinue ??
                    'Continue Recording'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _stopRecording();
                  if (!mounted) return;
                  context.go('/patient/home');
                },
                child: Text(l10n?.visitRecordingStopAndDiscard ??
                    'Stop & Discard'),
              ),
            ],
          );
        },
      );
    } else {
      context.go('/patient/home');
    }
  }

  void _updateFormattedTime() {
    final minutes = (_secondsElapsed ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsElapsed % 60).toString().padLeft(2, '0');
    _formattedTime = '$minutes:$seconds';
  }

  Color _getStatusColor() {
    switch (_recordingState) {
      case RecordingState.idle:
        return Theme.of(context).colorScheme.primary;
      case RecordingState.recording:
        return Colors.red;
      case RecordingState.paused:
        return Colors.orange;
      case RecordingState.completed:
        return Colors.green;
    }
  }

  String _getStatusText() {
    final l10n = AppLocalizations.of(context);
    switch (_recordingState) {
      case RecordingState.idle:
        return l10n?.visitRecordingStatusReady ?? 'Ready to Record';
      case RecordingState.recording:
        return l10n?.visitRecordingStatusRecording ?? 'Recording...';
      case RecordingState.paused:
        return 'Paused';
      case RecordingState.completed:
        return l10n?.visitRecordingStatusComplete ?? 'Recording complete';
    }
  }

  String _getRecordingInstructions() {
    final l10n = AppLocalizations.of(context);
    switch (_recordingState) {
      case RecordingState.idle:
        return l10n?.visitRecordingInstructionIdle ??
            'Tap to start recording your visit\nYour recording stays private and secure';
      case RecordingState.recording:
        return l10n?.visitRecordingInstructionRecording ??
            'Recording in progress...';
      case RecordingState.paused:
        return 'Recording paused.\nTap to resume when ready.';
      case RecordingState.completed:
        return l10n?.visitRecordingInstructionComplete ??
            'Recording complete!\nTap Generate to process your visit summary';
    }
  }

  Future<bool> _showAudioConsentDialog() async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            final l10n = AppLocalizations.of(context);
            return AlertDialog(
              title: Text(l10n?.visitRecordingAudioPermissionTitle ??
                  'Audio Recording'),
              content: Text(l10n?.visitRecordingAudioConsentBody ??
                  'Recording helps create visit notes, summaries, and reminders.\n\n'
                      '• Audio is recorded only when you tap Record\n'
                      '• Recordings are processed securely and deleted from your phone\n'
                      '• You can stop recording at any time\n\n'
                      'Would you like to proceed?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child:
                      Text(l10n?.visitRecordingNotNow ?? 'Not Now'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _consentService.acceptAudioConsent();
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                      l10n?.visitRecordingYesRecord ?? 'Yes, Record'),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}

class _PulsingButton extends StatefulWidget {
  final Widget child;

  const _PulsingButton({required this.child});

  @override
  _PulsingButtonState createState() => _PulsingButtonState();
}

class _UploadResult {
  final String? audioId;

  const _UploadResult({this.audioId});
}

class _PulsingButtonState extends State<_PulsingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}

enum RecordingState {
  idle, // before recording
  recording, // while recording
  paused, // paused due to interruption/background
  completed, // after recording stops
}
