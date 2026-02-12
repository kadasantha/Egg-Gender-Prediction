import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/constants.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../models/egg_detection_model.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _authService = AuthService();
  List<HistoryEntry> _history = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String _filterType = 'all'; // all, camera, manual

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final userEmail = _authService.getUserEmail();
      if (userEmail == null) {
        setState(() {
          _errorMessage = 'User not logged in. Please log in to view history.';
          _isLoading = false;
        });
        return;
      }

      final history = await ApiService.getHistory(
        userEmail: userEmail,
        limit: 100,
      );
      setState(() {
        _history = history;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load history: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  List<HistoryEntry> get _filteredHistory {
    if (_filterType == 'all') return _history;
    return _history.where((entry) => entry.detectionType == _filterType).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detection History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadHistory,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.grey[100],
            child: Row(
              children: [
                const Text(
                  'Filter:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('All', 'all'),
                        const SizedBox(width: 8),
                        _buildFilterChip('Camera', 'camera'),
                        const SizedBox(width: 8),
                        _buildFilterChip('Manual', 'manual'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppConstants.primaryColor,
                    ),
                  )
                : _errorMessage.isNotEmpty
                    ? _buildErrorView()
                    : _filteredHistory.isEmpty
                        ? _buildEmptyView()
                        : _buildHistoryList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _filterType == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filterType = value;
        });
      },
      selectedColor: AppConstants.primaryColor,
      checkmarkColor: AppConstants.secondaryColor,
      labelStyle: TextStyle(
        color: isSelected ? AppConstants.secondaryColor : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildHistoryList() {
    return RefreshIndicator(
      onRefresh: _loadHistory,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _filteredHistory.length,
        itemBuilder: (context, index) {
          final entry = _filteredHistory[index];
          return _buildHistoryCard(entry);
        },
      ),
    );
  }

  Widget _buildHistoryCard(HistoryEntry entry) {
    final isManual = entry.detectionType == 'manual';
    final date = DateTime.tryParse(entry.timestamp);
    final dateStr = date != null
        ? DateFormat('MMM dd, yyyy - hh:mm a').format(date)
        : entry.timestamp;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: InkWell(
        onTap: () => _showDetailDialog(entry),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isManual
                          ? AppConstants.femaleColor.withValues(alpha: 0.2)
                          : AppConstants.maleColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isManual ? Icons.edit : Icons.camera_alt,
                      color: isManual
                          ? AppConstants.femaleColor
                          : AppConstants.maleColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isManual ? 'Manual Input' : 'Camera Detection',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dateStr,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Gender Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: getGenderColor(entry.mlGender),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          getGenderIcon(entry.mlGender),
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          entry.mlGender.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Quick Info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildQuickInfo(
                      'Width',
                      '${entry.mlWidth.toStringAsFixed(1)} mm',
                      Icons.straighten,
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.grey[300],
                    ),
                    _buildQuickInfo(
                      'Height',
                      '${entry.mlHeight.toStringAsFixed(1)} mm',
                      Icons.height,
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.grey[300],
                    ),
                    _buildQuickInfo(
                      'Confidence',
                      '${(entry.mlConfidence * 100).toStringAsFixed(0)}%',
                      Icons.psychology,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Tap to view more
              Center(
                child: Text(
                  'Tap to view details',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickInfo(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 16, color: Colors.grey[700]),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppConstants.secondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            _filterType == 'all'
                ? 'No detection history yet'
                : 'No ${_filterType} detections found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _filterType == 'all'
                ? 'Start detecting to see your history here'
                : 'Try a different filter',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 80,
            color: AppConstants.errorColor,
          ),
          const SizedBox(height: 20),
          const Text(
            'Failed to Load History',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppConstants.errorColor,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: _loadHistory,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showDetailDialog(HistoryEntry entry) {
    final isManual = entry.detectionType == 'manual';
    final date = DateTime.tryParse(entry.timestamp);
    final dateStr = date != null
        ? DateFormat('EEEE, MMM dd, yyyy\nhh:mm:ss a').format(date)
        : entry.timestamp;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              isManual ? Icons.edit : Icons.camera_alt,
              color: isManual
                  ? AppConstants.femaleColor
                  : AppConstants.maleColor,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                isManual ? 'Manual Detection' : 'Camera Detection',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timestamp
              _buildDetailRow('Date & Time', dateStr, Icons.access_time),
              const Divider(height: 24),

              // Camera measurements (if not manual)
              if (!isManual) ...[
                const Text(
                  'Camera Measurements',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.maleColor,
                  ),
                ),
                const SizedBox(height: 10),
                _buildDetailRow(
                    'Width', '${entry.cameraWidth.toStringAsFixed(2)} mm', Icons.straighten),
                _buildDetailRow(
                    'Height', '${entry.cameraHeight.toStringAsFixed(2)} mm', Icons.height),
                _buildDetailRow(
                    'ESI', entry.cameraEsi.toStringAsFixed(2), Icons.calculate),
                _buildDetailRow(
                    'Gender', entry.cameraGender, Icons.circle,
                    valueColor: getGenderColor(entry.cameraGender)),
                const Divider(height: 24),
              ],

              // ML Predictions
              const Text(
                'ML Prediction',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.femaleColor,
                ),
              ),
              const SizedBox(height: 10),
              _buildDetailRow(
                  'Width', '${entry.mlWidth.toStringAsFixed(2)} mm', Icons.straighten),
              _buildDetailRow(
                  'Height', '${entry.mlHeight.toStringAsFixed(2)} mm', Icons.height),
              _buildDetailRow(
                  'ESI', entry.mlEsi.toStringAsFixed(2), Icons.calculate),
              _buildDetailRow(
                'Confidence',
                '${(entry.mlConfidence * 100).toStringAsFixed(1)}%',
                Icons.bar_chart,
                valueColor: entry.mlConfidence > 0.7
                    ? AppConstants.successColor
                    : AppConstants.warningColor,
              ),
              const Divider(height: 24),
              _buildDetailRow(
                'Predicted Gender',
                entry.mlGender.toUpperCase(),
                getGenderIcon(entry.mlGender),
                valueColor: getGenderColor(entry.mlGender),
                isBold: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    IconData icon, {
    Color? valueColor,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                color: valueColor ?? AppConstants.secondaryColor,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
