import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class ManualInputScreen extends StatefulWidget {
  const ManualInputScreen({super.key});

  @override
  State<ManualInputScreen> createState() => _ManualInputScreenState();
}

class _ManualInputScreenState extends State<ManualInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  bool _hasResult = false;
  String _errorMessage = '';

  // Result variables
  double? _esi;
  String? _predictedGender;
  double? _confidence;

  @override
  void dispose() {
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Future<void> _predict() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _hasResult = false;
      _errorMessage = '';
    });

    try {
      final width = double.parse(_widthController.text);
      final height = double.parse(_heightController.text);

      final result = await ApiService.manualPredict(width, height);

      if (result['success'] == true) {
        setState(() {
          _esi = result['esi']?.toDouble() ?? 0.0;
          _predictedGender = result['predicted_gender'] ?? 'Unknown';
          _confidence = result['confidence']?.toDouble() ?? 0.0;
          _hasResult = true;
          _isLoading = false;
        });

        // Save to history
        _saveToHistory(width, height);
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Prediction failed';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _saveToHistory(double width, double height) async {
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

    if (_esi != null && _predictedGender != null) {
      final success = await ApiService.saveToHistory(userEmail, {
        'camera_width': 0,
        'camera_height': 0,
        'camera_esi': 0,
        'camera_gender': '',
        'ml_width': width,
        'ml_height': height,
        'ml_esi': _esi,
        'ml_gender': _predictedGender,
        'ml_confidence': _confidence,
        'detection_type': 'manual',
        'timestamp': DateTime.now().toIso8601String(),
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
  }

  void _reset() {
    setState(() {
      _hasResult = false;
      _errorMessage = '';
      _esi = null;
      _predictedGender = null;
      _confidence = null;
      _widthController.clear();
      _heightController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manual Input'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Instructions Card
            if (!_hasResult)
              Card(
                color: Colors.purple[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: const [
                      Icon(Icons.edit, color: Colors.purple, size: 40),
                      SizedBox(height: 10),
                      Text(
                        'Manual Measurement',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Measure the egg dimensions manually and enter the values below. '
                        'The ML model will predict the gender based on these measurements.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 30),

            // Input Form
            if (!_hasResult && _errorMessage.isEmpty)
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Width Input
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.straighten, color: AppConstants.primaryColor),
                                SizedBox(width: 10),
                                Text(
                                  'Egg Width',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: _widthController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: InputDecoration(
                                labelText: 'Width (mm)',
                                hintText: 'e.g., 42.5',
                                prefixIcon: const Icon(Icons.arrow_right_alt),
                                suffixText: 'mm',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter width';
                                }
                                final width = double.tryParse(value);
                                if (width == null) {
                                  return 'Please enter a valid number';
                                }
                                if (width <= 0 || width > 100) {
                                  return 'Width must be between 0 and 100 mm';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Height Input
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.height, color: AppConstants.primaryColor),
                                SizedBox(width: 10),
                                Text(
                                  'Egg Height',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: _heightController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: InputDecoration(
                                labelText: 'Height (mm)',
                                hintText: 'e.g., 55.3',
                                prefixIcon: const Icon(Icons.arrow_upward),
                                suffixText: 'mm',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter height';
                                }
                                final height = double.tryParse(value);
                                if (height == null) {
                                  return 'Please enter a valid number';
                                }
                                if (height <= 0 || height > 100) {
                                  return 'Height must be between 0 and 100 mm';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Predict Button
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _predict,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: AppConstants.secondaryColor,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.psychology, size: 28),
                        label: Text(
                          _isLoading ? 'PREDICTING...' : 'PREDICT GENDER',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Info text
                    Text(
                      'Make sure to measure accurately for best results',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

            // Results Display
            if (_hasResult)
              Column(
                children: [
                  // Success Icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
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
                    'Prediction Complete!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.successColor,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Input Values Card
                  Card(
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
                                  color: Colors.blue.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.straighten, color: Colors.blue),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Measurements',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          _buildResultRow('Width', '${_widthController.text} mm'),
                          _buildResultRow('Height', '${_heightController.text} mm'),
                          _buildResultRow('ESI', _esi?.toStringAsFixed(2) ?? 'N/A'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Prediction Card
                  Card(
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
                                  color: AppConstants.femaleColor.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.psychology, color: AppConstants.femaleColor),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'ML Prediction',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppConstants.femaleColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          _buildResultRow(
                            'Confidence',
                            '${(_confidence! * 100).toStringAsFixed(1)}%',
                            color: _confidence! > 0.7 ? AppConstants.successColor : AppConstants.warningColor,
                          ),
                          const Divider(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                getGenderIcon(_predictedGender!),
                                size: 40,
                                color: getGenderColor(_predictedGender!),
                              ),
                              const SizedBox(width: 15),
                              Text(
                                _predictedGender!.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: getGenderColor(_predictedGender!),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _reset,
                          icon: const Icon(Icons.refresh),
                          label: const Text('New Prediction'),
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
            if (!_hasResult && _errorMessage.isNotEmpty)
              Column(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 80,
                    color: AppConstants.errorColor,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Prediction Failed',
                    style: TextStyle(
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
                    onPressed: _reset,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, {Color? color}) {
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
              fontWeight: FontWeight.w600,
              color: color ?? AppConstants.secondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
