import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VisitRecordingScreen extends StatefulWidget {
  const VisitRecordingScreen({super.key});

  @override
  State<VisitRecordingScreen> createState() => _VisitRecordingScreenState();
}

class _VisitRecordingScreenState extends State<VisitRecordingScreen> {
  RecordingState _recordingState = RecordingState.ready;
  Timer? _timer;
  int _secondsElapsed = 0;
  String _formattedTime = '00:00';

  // Mock doctor info (would come from navigation params)
  final String _doctorName = 'Dr. Sarah Johnson';
  final String _specialty = 'Cardiology';

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text(
          'Record Visit',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (_recordingState == RecordingState.completed)
            TextButton(
              onPressed: _saveRecording,
              child: Text(
                'Save',
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Doctor Info Card
              _buildDoctorInfo(),

              const SizedBox(height: 40),

              // Recording Interface
              Expanded(
                child: _buildRecordingInterface(),
              ),

              const SizedBox(height: 40),

              // Control Buttons
              _buildControlButtons(),

              const SizedBox(height: 24),

              // Status Text
              _buildStatusText(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.medical_services,
              color: Theme.of(context).colorScheme.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _doctorName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  _specialty,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Text(
                  DateTime.now().toString().split(' ')[0], // Today's date
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordingInterface() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Timer Display
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
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
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: _recordingState == RecordingState.recording
                  ? Colors.red
                  : Theme.of(context).colorScheme.primary,
              fontFeatures: [const FontFeature.tabularFigures()],
            ),
          ),
        ),

        const SizedBox(height: 40),

        // Recording Status
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _getStatusColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _getStatusText(),
            style: TextStyle(
              color: _getStatusColor(),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),

        const SizedBox(height: 60),

        // Recording Button
        GestureDetector(
          onTap: _toggleRecording,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: _recordingState == RecordingState.recording
                  ? const LinearGradient(
                      colors: [Colors.red, Colors.redAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              boxShadow: [
                BoxShadow(
                  color: (_recordingState == RecordingState.recording
                          ? Colors.red
                          : Theme.of(context).colorScheme.primary)
                      .withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              _getRecordingIcon(),
              color: Colors.white,
              size: 48,
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Recording Instructions
        Text(
          _getRecordingInstructions(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_recordingState == RecordingState.recording)
          _buildControlButton(
            icon: Icons.pause,
            label: 'Pause',
            onPressed: _pauseRecording,
          ),
        if (_recordingState == RecordingState.paused)
          _buildControlButton(
            icon: Icons.play_arrow,
            label: 'Resume',
            onPressed: _resumeRecording,
          ),
        if (_recordingState == RecordingState.completed)
          _buildControlButton(
            icon: Icons.replay,
            label: 'Record Again',
            onPressed: _resetRecording,
          ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon, size: 32),
          style: IconButton.styleFrom(
            backgroundColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.1),
            padding: const EdgeInsets.all(16),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusText() {
    if (_recordingState == RecordingState.completed) {
      return Column(
        children: [
          Text(
            'Recording completed successfully!',
            style: TextStyle(
              color: Colors.green,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'The recording will be processed and summarized automatically.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  void _toggleRecording() {
    switch (_recordingState) {
      case RecordingState.ready:
        _startRecording();
        break;
      case RecordingState.recording:
        _stopRecording();
        break;
      case RecordingState.paused:
        _resumeRecording();
        break;
      case RecordingState.completed:
        // Do nothing - use control buttons
        break;
    }
  }

  void _startRecording() {
    setState(() {
      _recordingState = RecordingState.recording;
      _secondsElapsed = 0;
      _updateFormattedTime();
    });

    // TODO: Start actual audio recording
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Recording started...')),
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
        _updateFormattedTime();
      });
    });
  }

  void _pauseRecording() {
    setState(() {
      _recordingState = RecordingState.paused;
    });

    _timer?.cancel();
    // TODO: Pause audio recording
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Recording paused')),
    );
  }

  void _resumeRecording() {
    setState(() {
      _recordingState = RecordingState.recording;
    });

    // TODO: Resume audio recording
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Recording resumed')),
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
        _updateFormattedTime();
      });
    });
  }

  void _stopRecording() {
    setState(() {
      _recordingState = RecordingState.completed;
    });

    _timer?.cancel();
    // TODO: Stop audio recording and save
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Recording stopped')),
    );
  }

  void _resetRecording() {
    setState(() {
      _recordingState = RecordingState.ready;
      _secondsElapsed = 0;
      _formattedTime = '00:00';
    });

    _timer?.cancel();
    // TODO: Reset recording
  }

  void _saveRecording() {
    // TODO: Save recording and navigate to visit details
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Recording saved! Processing transcript...')),
    );

    // Navigate back to home after a delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.go('/patient/home');
      }
    });
  }

  void _handleClose() {
    if (_recordingState == RecordingState.recording) {
      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Stop Recording?'),
          content: const Text(
              'Are you sure you want to stop recording? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Continue Recording'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _stopRecording();
                context.go('/patient/home');
              },
              child: const Text('Stop & Discard'),
            ),
          ],
        ),
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
      case RecordingState.ready:
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
    switch (_recordingState) {
      case RecordingState.ready:
        return 'Ready to Record';
      case RecordingState.recording:
        return 'Recording...';
      case RecordingState.paused:
        return 'Paused';
      case RecordingState.completed:
        return 'Recording Complete';
    }
  }

  IconData _getRecordingIcon() {
    switch (_recordingState) {
      case RecordingState.ready:
        return Icons.mic;
      case RecordingState.recording:
        return Icons.stop;
      case RecordingState.paused:
        return Icons.mic;
      case RecordingState.completed:
        return Icons.check;
    }
  }

  String _getRecordingInstructions() {
    switch (_recordingState) {
      case RecordingState.ready:
        return 'Tap to start recording your visit';
      case RecordingState.recording:
        return 'Recording... Speak clearly for best results';
      case RecordingState.paused:
        return 'Recording paused. Tap to resume';
      case RecordingState.completed:
        return 'Recording complete! Ready to save';
    }
  }
}

enum RecordingState {
  ready,
  recording,
  paused,
  completed,
}
