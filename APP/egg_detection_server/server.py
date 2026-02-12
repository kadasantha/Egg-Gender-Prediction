"""
Egg Detection Flask Server
Handles communication between Flutter app and detection system
"""

from flask import Flask, request, jsonify
from flask_cors import CORS
import threading
import time
from detection import EggDetectionSystem
from ml_predict import MLPredictor
from history_manager import HistoryManager

app = Flask(__name__)
CORS(app)  # Allow cross-origin requests from Flutter app

# Initialize systems
detector = EggDetectionSystem()
ml_predictor = MLPredictor()
history_manager = HistoryManager()

# Global variables for detection results
detection_results = {
    "status": "idle",  # idle, detecting, completed, error
    "camera_width": 0,
    "camera_height": 0,
    "camera_esi": 0,
    "camera_gender": "",
    "ml_width": 0,
    "ml_height": 0,
    "ml_esi": 0,
    "ml_gender": "",
    "ml_confidence": 0,
    "timestamp": "",
    "error_message": ""
}

detection_lock = threading.Lock()


def run_detection_process():
    """
    Background thread to run detection for 5 seconds
    """
    global detection_results
    
    try:
        with detection_lock:
            detection_results["status"] = "detecting"
        
        # Run detection for 5 seconds
        camera_data = detector.detect_for_duration(duration_seconds=5)
        
        if camera_data["success"]:
            # Get ML prediction
            ml_prediction = ml_predictor.predict(
                camera_data["width"],
                camera_data["height"],
                camera_data["esi"]
            )
            
            with detection_lock:
                detection_results["status"] = "completed"
                detection_results["camera_width"] = camera_data["width"]
                detection_results["camera_height"] = camera_data["height"]
                detection_results["camera_esi"] = camera_data["esi"]
                detection_results["camera_gender"] = camera_data["gender"]
                detection_results["ml_width"] = camera_data["width"]
                detection_results["ml_height"] = camera_data["height"]
                detection_results["ml_esi"] = camera_data["esi"]
                detection_results["ml_gender"] = ml_prediction["gender"]
                detection_results["ml_confidence"] = ml_prediction["confidence"]
                detection_results["timestamp"] = time.strftime("%Y-%m-%d %H:%M:%S")
                detection_results["error_message"] = ""
        else:
            with detection_lock:
                detection_results["status"] = "error"
                detection_results["error_message"] = camera_data["error"]
                
    except Exception as e:
        with detection_lock:
            detection_results["status"] = "error"
            detection_results["error_message"] = str(e)


@app.route('/api/status', methods=['GET'])
def get_status():
    """
    Check if server is running
    """
    return jsonify({
        "status": "online",
        "message": "Egg Detection Server is running",
        "camera_available": detector.is_camera_available()
    })


@app.route('/api/start_detection', methods=['POST'])
def start_detection():
    """
    Start egg detection process
    """
    global detection_results
    
    with detection_lock:
        if detection_results["status"] == "detecting":
            return jsonify({
                "success": False,
                "message": "Detection already in progress"
            }), 400
        
        # Reset results
        detection_results = {
            "status": "detecting",
            "camera_width": 0,
            "camera_height": 0,
            "camera_esi": 0,
            "camera_gender": "",
            "ml_width": 0,
            "ml_height": 0,
            "ml_esi": 0,
            "ml_gender": "",
            "ml_confidence": 0,
            "timestamp": "",
            "error_message": ""
        }
    
    # Start detection in background thread
    detection_thread = threading.Thread(target=run_detection_process)
    detection_thread.daemon = True
    detection_thread.start()
    
    return jsonify({
        "success": True,
        "message": "Detection started",
        "duration": 5
    })


@app.route('/api/get_results', methods=['GET'])
def get_results():
    """
    Get current detection results
    """
    with detection_lock:
        return jsonify(detection_results)


@app.route('/api/manual_predict', methods=['POST'])
def manual_predict():
    """
    Manual prediction from user input
    Accepts width and height, calculates ESI, uses ML model
    """
    try:
        data = request.get_json()
        width = float(data.get('width', 0))
        height = float(data.get('height', 0))
        
        if width <= 0 or height <= 0:
            return jsonify({
                "success": False,
                "error": "Invalid width or height"
            }), 400
        
        # Calculate ESI
        esi = (width / height) * 100
        
        # Get camera-based classification
        if esi < 72:
            camera_gender = "Male"
        elif 72 <= esi <= 78:
            camera_gender = "Female"
        else:
            camera_gender = "Unhatched"
        
        # Get ML prediction
        ml_prediction = ml_predictor.predict(width, height, esi)
        
        return jsonify({
            "success": True,
            "camera_width": round(width, 2),
            "camera_height": round(height, 2),
            "camera_esi": round(esi, 2),
            "camera_gender": camera_gender,
            "ml_width": round(width, 2),
            "ml_height": round(height, 2),
            "ml_esi": round(esi, 2),
            "ml_gender": ml_prediction["gender"],
            "ml_confidence": ml_prediction["confidence"],
            "timestamp": time.strftime("%Y-%m-%d %H:%M:%S")
        })
        
    except Exception as e:
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500


@app.route('/api/stop_detection', methods=['POST'])
def stop_detection():
    """
    Stop ongoing detection
    """
    detector.stop_detection()
    
    with detection_lock:
        if detection_results["status"] == "detecting":
            detection_results["status"] = "idle"
    
    return jsonify({
        "success": True,
        "message": "Detection stopped"
    })


@app.route('/api/save_history', methods=['POST'])
def save_history():
    """
    Save detection result to history
    """
    try:
        data = request.get_json()
        user_email = data.get('user_email', 'anonymous')
        detection_data = data.get('detection_data', {})
        
        result = history_manager.add_detection(user_email, detection_data)
        return jsonify(result)
        
    except Exception as e:
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500


@app.route('/api/get_history', methods=['GET'])
def get_history():
    """
    Get all detection history
    """
    try:
        limit = request.args.get('limit', 50, type=int)
        history = history_manager.get_recent_history(limit)
        
        return jsonify({
            "success": True,
            "history": history,
            "total": len(history)
        })
        
    except Exception as e:
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500


@app.route('/api/get_statistics', methods=['GET'])
def get_statistics():
    """
    Get detection statistics
    """
    try:
        stats = history_manager.get_statistics()
        return jsonify({
            "success": True,
            "statistics": stats
        })
        
    except Exception as e:
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500


if __name__ == '__main__':
    print("=" * 60)
    print("🥚 Egg Detection Server Starting...")
    print("=" * 60)
    print(f"Server URL: http://localhost:5000")
    print(f"Camera Status: {'Available' if detector.is_camera_available() else 'Not Available'}")
    print(f"ML Model: {'Loaded' if ml_predictor.is_loaded() else 'Not Loaded'}")
    print("=" * 60)
    print("\nAPI Endpoints:")
    print("  GET  /api/status           - Check server status")
    print("  POST /api/start_detection  - Start detection")
    print("  GET  /api/get_results      - Get detection results")
    print("  POST /api/manual_predict   - Manual prediction")
    print("  POST /api/stop_detection   - Stop detection")
    print("=" * 60)
    print("\n🚀 Server is ready! Waiting for connections...")
    print("Press Ctrl+C to stop\n")
    
    # Run Flask server
    # Use 0.0.0.0 to allow connections from other devices on same network
    app.run(host='0.0.0.0', port=5000, debug=True, threaded=True)