class EggDetectionResult {
  final String status;
  final double cameraWidth;
  final double cameraHeight;
  final double cameraEsi;
  final String cameraGender;
  final double mlWidth;
  final double mlHeight;
  final double mlEsi;
  final String mlGender;
  final double mlConfidence;
  final String timestamp;
  final String errorMessage;

  EggDetectionResult({
    required this.status,
    required this.cameraWidth,
    required this.cameraHeight,
    required this.cameraEsi,
    required this.cameraGender,
    required this.mlWidth,
    required this.mlHeight,
    required this.mlEsi,
    required this.mlGender,
    required this.mlConfidence,
    required this.timestamp,
    required this.errorMessage,
  });

  factory EggDetectionResult.fromJson(Map<String, dynamic> json) {
    return EggDetectionResult(
      status: json['status'] ?? 'idle',
      cameraWidth: (json['camera_width'] ?? 0).toDouble(),
      cameraHeight: (json['camera_height'] ?? 0).toDouble(),
      cameraEsi: (json['camera_esi'] ?? 0).toDouble(),
      cameraGender: json['camera_gender'] ?? '',
      mlWidth: (json['ml_width'] ?? 0).toDouble(),
      mlHeight: (json['ml_height'] ?? 0).toDouble(),
      mlEsi: (json['ml_esi'] ?? 0).toDouble(),
      mlGender: json['ml_gender'] ?? '',
      mlConfidence: (json['ml_confidence'] ?? 0).toDouble(),
      timestamp: json['timestamp'] ?? '',
      errorMessage: json['error_message'] ?? '',
    );
  }

  bool get isCompleted => status == 'completed';
  bool get isDetecting => status == 'detecting';
  bool get hasError => status == 'error';
}

class HistoryEntry {
  final int id;
  final String userEmail;
  final String timestamp;
  final double cameraWidth;
  final double cameraHeight;
  final double cameraEsi;
  final String cameraGender;
  final double mlWidth;
  final double mlHeight;
  final double mlEsi;
  final String mlGender;
  final double mlConfidence;
  final String detectionType;

  HistoryEntry({
    required this.id,
    required this.userEmail,
    required this.timestamp,
    required this.cameraWidth,
    required this.cameraHeight,
    required this.cameraEsi,
    required this.cameraGender,
    required this.mlWidth,
    required this.mlHeight,
    required this.mlEsi,
    required this.mlGender,
    required this.mlConfidence,
    required this.detectionType,
  });

  factory HistoryEntry.fromJson(Map<String, dynamic> json) {
    return HistoryEntry(
      id: json['id'] ?? 0,
      userEmail: json['user_email'] ?? '',
      timestamp: json['timestamp'] ?? '',
      cameraWidth: (json['camera_width'] ?? 0).toDouble(),
      cameraHeight: (json['camera_height'] ?? 0).toDouble(),
      cameraEsi: (json['camera_esi'] ?? 0).toDouble(),
      cameraGender: json['camera_gender'] ?? '',
      mlWidth: (json['ml_width'] ?? 0).toDouble(),
      mlHeight: (json['ml_height'] ?? 0).toDouble(),
      mlEsi: (json['ml_esi'] ?? 0).toDouble(),
      mlGender: json['ml_gender'] ?? '',
      mlConfidence: (json['ml_confidence'] ?? 0).toDouble(),
      detectionType: json['detection_type'] ?? 'camera',
    );
  }
}