import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../models/egg_detection_model.dart';

class ApiService {
  // Check server status
  static Future<Map<String, dynamic>> checkServerStatus() async {
    try {
      final response = await http.get(
        Uri.parse(AppConstants.apiStatus),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Server returned ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Cannot connect to server: $e');
    }
  }

  // Start detection
  static Future<Map<String, dynamic>> startDetection() async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.apiStartDetection),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to start detection');
      }
    } catch (e) {
      throw Exception('Error starting detection: $e');
    }
  }

  // Get detection results
  static Future<EggDetectionResult> getResults() async {
    try {
      final response = await http.get(
        Uri.parse(AppConstants.apiGetResults),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return EggDetectionResult.fromJson(data);
      } else {
        throw Exception('Failed to get results');
      }
    } catch (e) {
      throw Exception('Error getting results: $e');
    }
  }

  // Manual prediction
  static Future<Map<String, dynamic>> manualPredict(
      double width, double height) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.apiManualPredict),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'width': width,
          'height': height,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to predict');
      }
    } catch (e) {
      throw Exception('Error predicting: $e');
    }
  }

  // Save to history
  static Future<bool> saveToHistory(
      String userEmail, Map<String, dynamic> detectionData) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.apiSaveHistory),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_email': userEmail,
          'detection_data': detectionData,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] ?? false;
      } else {
        print('Failed to save history: Status ${response.statusCode}');
        print('Response: ${response.body}');
        return false;
      }
    } catch (e) {
      // Log the error for debugging
      print('Error saving to history: $e');
      return false;
    }
  }

  // Get history
  static Future<List<HistoryEntry>> getHistory({
    required String userEmail,
    int limit = 50,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.apiGetHistory}?user_email=$userEmail&limit=$limit'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final List historyList = data['history'] ?? [];
          return historyList
              .map((item) => HistoryEntry.fromJson(item))
              .toList();
        }
      }
      print('Failed to get history: Status ${response.statusCode}');
      return [];
    } catch (e) {
      // Log error and return empty list
      print('Error getting history: $e');
      return [];
    }
  }
}