import 'package:flutter/material.dart';

class AppConstants {
  // API Configuration
  // Using hostname instead of IP address - works across different WiFi networks
  static const String baseUrl = 'http://raspberrypi.local:5000';
  
  // API Endpoints
  static const String apiStatus = '$baseUrl/api/status';
  static const String apiStartDetection = '$baseUrl/api/start_detection';
  static const String apiGetResults = '$baseUrl/api/get_results';
  static const String apiManualPredict = '$baseUrl/api/manual_predict';
  static const String apiSaveHistory = '$baseUrl/api/save_history';
  static const String apiGetHistory = '$baseUrl/api/get_history';
  
  // App Colors (Based on your logo)
  static const Color primaryColor = Color(0xFFFFD700); // Golden Yellow
  static const Color secondaryColor = Color(0xFF2C2C2C); // Dark Gray/Black
  static const Color accentColor = Colors.white;
  
  // Gender Colors
  static const Color maleColor = Color(0xFF2196F3); // Blue
  static const Color femaleColor = Color(0xFFE91E63); // Pink/Magenta
  static const Color unhatchedColor = Color(0xFFFF9800); // Orange
  
  // Status Colors
  static const Color successColor = Color(0xFF4CAF50); // Green
  static const Color errorColor = Color(0xFFF44336); // Red
  static const Color warningColor = Color(0xFFFFC107); // Amber
  
  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: secondaryColor,
  );
  
  static const TextStyle subHeadingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: secondaryColor,
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color: secondaryColor,
  );
  
  // Detection Settings
  static const int detectionDuration = 5; // seconds
  static const int pollInterval = 500; // milliseconds
  
  // App Info
  static const String appName = 'EGG GENDER PREDICTOR';
  static const String appVersion = '1.0.0';
}

// Helper function to get gender color
Color getGenderColor(String gender) {
  switch (gender.toLowerCase()) {
    case 'male':
      return AppConstants.maleColor;
    case 'female':
      return AppConstants.femaleColor;
    case 'unhatched':
      return AppConstants.unhatchedColor;
    default:
      return AppConstants.secondaryColor;
  }
}

// Helper function to get gender icon
IconData getGenderIcon(String gender) {
  switch (gender.toLowerCase()) {
    case 'male':
      return Icons.male;
    case 'female':
      return Icons.female;
    case 'unhatched':
      return Icons.help_outline;
    default:
      return Icons.circle;
  }
}