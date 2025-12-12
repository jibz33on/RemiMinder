import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with TickerProviderStateMixin {
  late AnimationController _scanAnimationController;
  late Animation<double> _scanAnimation;
  late AnimationController _processingController;

  ScanMode _selectedMode = ScanMode.prescription;
  ScanState _scanState = ScanState.ready;
  Map<String, dynamic>? _scanResults;
  Timer? _scanTimer;

  @override
  void initState() {
    super.initState();
    _scanAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _scanAnimationController, curve: Curves.easeInOut),
    );

    _processingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _scanAnimationController.dispose();
    _processingController.dispose();
    _scanTimer?.cancel();
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
          onPressed: () => context.go('/patient/home'),
        ),
        title: const Text(
          'Scan Document',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (_scanState == ScanState.completed)
            TextButton(
              onPressed: _saveScan,
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: _scanState == ScanState.completed
          ? _buildResultsView()
          : _buildScanView(),
    );
  }

  Widget _buildScanView() {
    return Column(
      children: [
        // Scan Mode Selector
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildModeButton(
                  ScanMode.prescription, 'Prescription', Icons.receipt),
              _buildModeButton(ScanMode.labReport, 'Lab Report', Icons.science),
              _buildModeButton(
                  ScanMode.medication, 'Medication', Icons.medication),
            ],
          ),
        ),

        // Camera Preview Area
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Simulated Camera Feed
              Container(
                color: Colors.grey[900],
                child: const Center(
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white54,
                    size: 80,
                  ),
                ),
              ),

              // Scan Frame
              Container(
                margin: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _scanState == ScanState.scanning
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AspectRatio(
                    aspectRatio: 3 / 4,
                    child: Container(
                      color: Colors.transparent,
                      child: _scanState == ScanState.scanning
                          ? AnimatedBuilder(
                              animation: _scanAnimation,
                              builder: (context, child) {
                                return CustomPaint(
                                  painter: ScanLinePainter(
                                    progress: _scanAnimation.value,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                );
                              },
                            )
                          : Container(),
                    ),
                  ),
                ),
              ),

              // Scan Instructions
              if (_scanState == ScanState.ready)
                Positioned(
                  bottom: 100,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      _getScanInstructions(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

              // Processing Indicator
              if (_scanState == ScanState.processing)
                Container(
                  color: Colors.black.withOpacity(0.8),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Processing...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Bottom Controls
        Container(
          padding: const EdgeInsets.all(24),
          color: Colors.black,
          child: Column(
            children: [
              // Capture Button
              GestureDetector(
                onTap: _scanState == ScanState.ready ? _startScan : null,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _scanState == ScanState.scanning
                          ? Theme.of(context).colorScheme.primary
                          : Colors.white,
                      width: 4,
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _scanState == ScanState.scanning
                          ? Theme.of(context).colorScheme.primary
                          : Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Status Text
              Text(
                _getStatusText(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 8),

              // Tips
              Text(
                _getScanTips(),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildModeButton(ScanMode mode, String label, IconData icon) {
    final isSelected = _selectedMode == mode;

    return GestureDetector(
      onTap: _scanState == ScanState.ready
          ? () => setState(() => _selectedMode = mode)
          : null,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.white.withOpacity(0.7),
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsView() {
    if (_scanResults == null) return const SizedBox.shrink();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.green.withOpacity(0.1),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Scan Successful!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Text(
                          _getResultTitle(),
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Results
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _buildScanResults(),
              ),
            ),

            // Action Buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _shareScan,
                      icon: const Icon(Icons.share),
                      label: const Text('Share'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _saveScan,
                      icon: const Icon(Icons.save),
                      label: const Text('Save'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
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

  Widget _buildScanResults() {
    switch (_selectedMode) {
      case ScanMode.prescription:
        return _buildPrescriptionResults();
      case ScanMode.labReport:
        return _buildLabReportResults();
      case ScanMode.medication:
        return _buildMedicationResults();
    }
  }

  Widget _buildPrescriptionResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildResultSection('Prescription Details', [
          _buildResultItem('Medication', 'Lisinopril'),
          _buildResultItem('Dosage', '10mg'),
          _buildResultItem('Frequency', 'Once daily'),
          _buildResultItem('Quantity', '90 tablets'),
          _buildResultItem('Refills', '3 remaining'),
        ]),
        const SizedBox(height: 24),
        _buildResultSection('Prescriber Information', [
          _buildResultItem('Doctor', 'Dr. Sarah Johnson'),
          _buildResultItem('License', 'MD123456'),
          _buildResultItem('Date', 'Dec 12, 2024'),
        ]),
        const SizedBox(height: 24),
        _buildResultSection('Pharmacy Information', [
          _buildResultItem('Pharmacy', 'City Medical Pharmacy'),
          _buildResultItem('Phone', '(555) 123-4567'),
          _buildResultItem('Address', '123 Main St, City, ST 12345'),
        ]),
      ],
    );
  }

  Widget _buildLabReportResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildResultSection('Patient Information', [
          _buildResultItem('Name', 'John Doe'),
          _buildResultItem('DOB', '01/15/1985'),
          _buildResultItem('ID', 'P123456789'),
        ]),
        const SizedBox(height: 24),
        _buildResultSection('Test Results', [
          _buildResultItem('Cholesterol (Total)', '185 mg/dL', 'Normal: <200'),
          _buildResultItem('HDL Cholesterol', '45 mg/dL', 'Normal: >40'),
          _buildResultItem('LDL Cholesterol', '120 mg/dL', 'Normal: <130'),
          _buildResultItem('Triglycerides', '150 mg/dL', 'Normal: <150'),
        ]),
        const SizedBox(height: 24),
        _buildResultSection('Lab Information', [
          _buildResultItem('Lab', 'City Medical Labs'),
          _buildResultItem('Report Date', 'Dec 10, 2024'),
          _buildResultItem('Collected', 'Dec 9, 2024'),
        ]),
      ],
    );
  }

  Widget _buildMedicationResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildResultSection('Medication Information', [
          _buildResultItem('Name', 'Lisinopril'),
          _buildResultItem('Strength', '10mg'),
          _buildResultItem('Form', 'Tablet'),
          _buildResultItem('Quantity', '90 tablets'),
        ]),
        const SizedBox(height: 24),
        _buildResultSection('Usage Instructions', [
          _buildResultItem('Directions', 'Take one tablet by mouth once daily'),
          _buildResultItem('Purpose', 'Blood pressure management'),
          _buildResultItem('Storage', 'Store at room temperature'),
        ]),
        const SizedBox(height: 24),
        _buildResultSection('Additional Information', [
          _buildResultItem('Manufacturer', 'Generic Pharmaceuticals'),
          _buildResultItem('Lot Number', 'LP2024001'),
          _buildResultItem('Expiration', '06/2026'),
        ]),
      ],
    );
  }

  Widget _buildResultSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        ...items,
      ],
    );
  }

  Widget _buildResultItem(String label, String value, [String? reference]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (reference != null)
                  Text(
                    reference,
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

  void _startScan() {
    setState(() {
      _scanState = ScanState.scanning;
    });

    // Simulate scan time
    _scanTimer = Timer(const Duration(seconds: 3), _completeScan);
  }

  void _completeScan() {
    setState(() {
      _scanState = ScanState.processing;
    });

    // Simulate processing time
    Timer(const Duration(seconds: 2), () {
      setState(() {
        _scanState = ScanState.completed;
        _scanResults = _generateMockResults();
      });
    });
  }

  Map<String, dynamic> _generateMockResults() {
    // Generate mock results based on scan mode
    return {
      'scanMode': _selectedMode,
      'timestamp': DateTime.now(),
      'confidence': 0.95,
    };
  }

  void _saveScan() {
    // TODO: Save scan results
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Scan saved successfully!')),
    );
    context.go('/patient/home');
  }

  void _shareScan() {
    // TODO: Share scan results
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality - Coming Soon!')),
    );
  }

  String _getScanInstructions() {
    switch (_selectedMode) {
      case ScanMode.prescription:
        return 'Position prescription within the frame\nEnsure all text is visible';
      case ScanMode.labReport:
        return 'Center the lab report in the frame\nHold steady for clear scan';
      case ScanMode.medication:
        return 'Position pill bottle label clearly\nInclude dosage and instructions';
    }
  }

  String _getStatusText() {
    switch (_scanState) {
      case ScanState.ready:
        return 'Tap to scan';
      case ScanState.scanning:
        return 'Scanning...';
      case ScanState.processing:
        return 'Processing document...';
      case ScanState.completed:
        return 'Scan complete';
    }
  }

  String _getScanTips() {
    switch (_selectedMode) {
      case ScanMode.prescription:
        return 'Make sure prescription number and doctor signature are visible';
      case ScanMode.labReport:
        return 'Ensure all test results and reference ranges are captured';
      case ScanMode.medication:
        return 'Include drug name, strength, and usage instructions';
    }
  }

  String _getResultTitle() {
    switch (_selectedMode) {
      case ScanMode.prescription:
        return 'Prescription scanned successfully';
      case ScanMode.labReport:
        return 'Lab report processed successfully';
      case ScanMode.medication:
        return 'Medication information extracted';
    }
  }
}

enum ScanMode {
  prescription,
  labReport,
  medication,
}

enum ScanState {
  ready,
  scanning,
  processing,
  completed,
}

class ScanLinePainter extends CustomPainter {
  final double progress;
  final Color color;

  ScanLinePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final y = size.height * progress;
    canvas.drawLine(
      Offset(0, y),
      Offset(size.width, y),
      paint,
    );
  }

  @override
  bool shouldRepaint(ScanLinePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
