import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  CaptureState _captureState = CaptureState.ready;
  String _captureType = 'General Document';
  Timer? _processingTimer;
  int _processingProgress = 0;

  @override
  void dispose() {
    _processingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: _handleClose,
        ),
        title: const Text(
          'Capture Document',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.flash_off,
              color: Colors.white,
            ),
            onPressed: () {
              // TODO: Toggle flash
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Camera Preview Area (Mock)
            Expanded(
              child: Container(
                color: Colors.grey[900],
                child: Stack(
                  children: [
                    // Mock camera preview
                    Center(
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.grey[800]!,
                              Colors.grey[900]!,
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white.withOpacity(0.3),
                          size: 80,
                        ),
                      ),
                    ),

                    // Processing overlay
                    if (_captureState == CaptureState.processing)
                      Container(
                        color: Colors.black.withOpacity(0.7),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Processing... $_processingProgress%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Extracting information from document',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Capture guide overlay
                    if (_captureState == CaptureState.ready)
                      Positioned(
                        top: 20,
                        left: 20,
                        right: 20,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.lightbulb_outline,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Position the document clearly in frame and ensure good lighting',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Success overlay
                    if (_captureState == CaptureState.completed)
                      Container(
                        color: Colors.black.withOpacity(0.7),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'Document captured successfully!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Information extracted from $_captureType',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Bottom Controls
            Container(
              padding: const EdgeInsets.all(24),
              color: Colors.black,
              child: Column(
                children: [
                  // Document Type Selector
                  if (_captureState == CaptureState.ready)
                    Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildDocumentTypeChip('Lab Report', Icons.science),
                            const SizedBox(width: 12),
                            _buildDocumentTypeChip(
                                'Prescription', Icons.receipt),
                            const SizedBox(width: 12),
                            _buildDocumentTypeChip(
                                'Pill Bottle', Icons.medication),
                            const SizedBox(width: 12),
                            _buildDocumentTypeChip(
                                'Medical Record', Icons.description),
                            const SizedBox(width: 12),
                            _buildDocumentTypeChip(
                                'Insurance Card', Icons.credit_card),
                          ],
                        ),
                      ),
                    ),

                  // Capture Button
                  if (_captureState != CaptureState.completed)
                    GestureDetector(
                      onTap: _captureDocument,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 4,
                          ),
                          color: _captureState == CaptureState.processing
                              ? Colors.grey
                              : Colors.white,
                        ),
                        child: Icon(
                          _captureState == CaptureState.processing
                              ? Icons.hourglass_empty
                              : Icons.camera,
                          color: Colors.black,
                          size: 32,
                        ),
                      ),
                    ),

                  // Status Text
                  const SizedBox(height: 16),
                  Text(
                    _getStatusText(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  // Action Buttons
                  if (_captureState == CaptureState.completed)
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _retakePhoto,
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text(
                                'Retake',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _saveDocument,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text('Save Document'),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentTypeChip(String label, IconData icon) {
    final isSelected = _captureType == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _captureType = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : Colors.white,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _captureDocument() {
    if (_captureState == CaptureState.processing) return;

    setState(() {
      _captureState = CaptureState.processing;
      _processingProgress = 0;
    });

    // TODO: Trigger actual camera capture
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Capturing $_captureType...')),
    );

    // Simulate processing
    _processingTimer =
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _processingProgress += 2;
        if (_processingProgress >= 100) {
          _processingTimer?.cancel();
          setState(() {
            _captureState = CaptureState.completed;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Document processed successfully!')),
          );
        }
      });
    });
  }

  void _retakePhoto() {
    setState(() {
      _captureState = CaptureState.ready;
      _processingProgress = 0;
    });
    _processingTimer?.cancel();
  }

  void _saveDocument() {
    // TODO: Save the captured document and extracted information
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$_captureType saved to your records')),
    );

    // Navigate back to home after a delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        context.go('/patient/home');
      }
    });
  }

  void _handleClose() {
    if (_captureState == CaptureState.processing) {
      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Cancel Capture?'),
          content: const Text(
              'Are you sure you want to cancel? Any unsaved progress will be lost.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Continue'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _processingTimer?.cancel();
                context.go('/patient/home');
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      );
    } else {
      context.go('/patient/home');
    }
  }

  String _getStatusText() {
    switch (_captureState) {
      case CaptureState.ready:
        return 'Tap to capture $_captureType';
      case CaptureState.processing:
        return 'Processing document...';
      case CaptureState.completed:
        return 'Document captured and processed';
    }
  }
}

enum CaptureState {
  ready,
  processing,
  completed,
}
