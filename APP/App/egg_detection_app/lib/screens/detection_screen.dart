import 'package:flutter/material.dart';
import 'dart:async';
import '../utils/constants.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../models/egg_detection_model.dart';

class DetectionScreen extends StatefulWidget {
  const DetectionScreen({super.key});

  @override
  State<DetectionScreen> createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  final _authService = AuthService();
  bool _isDetecting = false;
  bool _hasResult = false;
  EggDetectionResult? _result;
  String _errorMessage = '';
  int _countdown = AppConstants.detectionDuration;
  Timer? _countdownTimer;
  Timer? _pollTimer;

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _startDetection() async {
    setState(() {
      _isDetecting = true;
      _hasResult = false;
      _errorMessage = '';
      _countdown = AppConstants.detectionDuration;
    });

    try {
      // Start detection on backend
      await ApiService.startDetection();

      // Start countdown
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _countdown--;
          if (_countdown <= 0) {
            timer.cancel();
          }
        });
      });

      // Poll for results
      _pollTimer = Timer.periodic(
        Duration(milliseconds: AppConstants.pollInterval),
        (timer) async {
          try {
            final result = await ApiService.getResults();

            if (result.isCompleted) {
              timer.cancel();
              _countdownTimer?.cancel();

              setState(() {
                _result = result;
                _hasResult = true;
                _isDetecting = false;
              });

              // Save to history
              _saveToHistory(result);
            } else if (result.hasError) {
              timer.cancel();
              _countdownTimer?.cancel();

              setState(() {
                _errorMessage = result.errorMessage;
                _isDetecting = false;
              });
            }
          } catch (e) {
            // Continue polling on error
          }
        },
      );

      // Timeout after detection duration + 2 seconds
      await Future.delayed(Duration(seconds: AppConstants.detectionDuration + 2));

      if (_isDetecting) {
        _countdownTimer?.cancel();
        _pollTimer?.cancel();

        setState(() {
          _errorMessage = 'Detection timeout. Please try again.';
          _isDetecting = false;
        });
      }
    } catch (e) {
      _countdownTimer?.cancel();
      _pollTimer?.cancel();

      setState(() {
        _errorMessage = 'Failed to start detection: ${e.toString()}';
        _isDetecting = false;
      });
    }
  }

  Future<void> _saveToHistory(EggDetectionResult result) async {
    final userEmail = _authService.getUserEmail();
    if (userEmail == null) {
      // Show warning that history won't be saved
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Warning: Not logged in. History will not be saved.'),
            backgroundColor: AppConstants.warningColor,
            duration: Duration(seconds: 3),
          ),
        );
      }
      return;
    }

    final success = await ApiService.saveToHistory(userEmail, {
      'camera_width': result.cameraWidth,
      'camera_height': result.cameraHeight,
      'camera_esi': result.cameraEsi,
      'camera_gender': result.cameraGender,
      'ml_width': result.mlWidth,
      'ml_height': result.mlHeight,
      'ml_esi': result.mlEsi,
      'ml_gender': result.mlGender,
      'ml_confidence': result.mlConfidence,
      'detection_type': 'camera',
      'timestamp': result.timestamp,
    });

    if (!success && mounted) {
      // Show error if save failed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save to history. Check server connection.'),
          backgroundColor: AppConstants.errorColor,
          duration: Duration(seconds: 3),
        ),
      );
    } else if (success && mounted) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Detection saved to history!'),
          backgroundColor: AppConstants.successColor,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Detection'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Instructions Card
            if (!_isDetecting && !_hasResult)
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: const [
                      Icon(Icons.info_outline, color: Colors.blue, size: 40),
                      SizedBox(height: 10),
                      Text(
                        'Instructions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '1. Make sure the Python server is running\n'
                        '2. Place the egg in front of the webcam\n'
                        '3. Click Start Detection\n'
                        '4. Wait for ${AppConstants.detectionDuration} seconds\n'
                        '5. Get your result!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 30),

            // Detection Status
            if (_isDetecting)
              Column(
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppConstants.primaryColor.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$_countdown',
                            style: const TextStyle(
                              fontSize: 72,
                              fontWeight: FontWeight.bold,
                              color: AppConstants.primaryColor,
                            ),
                          ),
                          const Text(
                            'seconds',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppConstants.secondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const CircularProgressIndicator(
                    color: AppConstants.primaryColor,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Detecting egg gender...',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Keep the egg steady in front of camera',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),

            // Results Display
            if (_hasResult && _result != null)
              Column(
                children: [
                  // Success Icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppConstants.successColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Detection Complete!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.successColor,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Camera Measurements
                  _buildResultCard(
                    title: 'Camera Measurements',
                    icon: Icons.camera_alt,
                    color: AppConstants.maleColor,
                    children: [
                      _buildResultRow('Width', '${_result!.cameraWidth.toStringAsFixed(2)} mm'),
                      _buildResultRow('Height', '${_result!.cameraHeight.toStringAsFixed(2)} mm'),
                      _buildResultRow('ESI', _result!.cameraEsi.toStringAsFixed(2)),
                      _buildResultRow('Gender', _result!.cameraGender,
                        color: getGenderColor(_result!.cameraGender)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ML Prediction
                  _buildResultCard(
                    title: 'ML Prediction',
                    icon: Icons.psychology,
                    color: AppConstants.femaleColor,
                    children: [
                      _buildResultRow('Width', '${_result!.mlWidth.toStringAsFixed(2)} mm'),
                      _buildResultRow('Height', '${_result!.mlHeight.toStringAsFixed(2)} mm'),
                      _buildResultRow('ESI', _result!.mlEsi.toStringAsFixed(2)),
                      _buildResultRow('Confidence', '${(_result!.mlConfidence * 100).toStringAsFixed(1)}%',
                        color: _result!.mlConfidence > 0.7 ? AppConstants.successColor : AppConstants.warningColor),
                      const Divider(),
                      _buildResultRow('Predicted Gender', _result!.mlGender,
                        color: getGenderColor(_result!.mlGender), isBold: true),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _hasResult = false;
                              _result = null;
                            });
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Detect Again'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.home),
                          label: const Text('Home'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppConstants.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

            // Error Display
            if (!_isDetecting && !_hasResult && _errorMessage.isNotEmpty)
              Column(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 80,
                    color: AppConstants.errorColor,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Detection Failed',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.errorColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _errorMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _errorMessage = '';
                      });
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                  ),
                ],
              ),

            // Start Button
            if (!_isDetecting && !_hasResult && _errorMessage.isEmpty)
              Column(
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: AppConstants.primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 80,
                      color: AppConstants.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed: _startDetection,
                      icon: const Icon(Icons.play_arrow, size: 30),
                      label: const Text(
                        'START DETECTION',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, {Color? color, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color ?? AppConstants.secondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
