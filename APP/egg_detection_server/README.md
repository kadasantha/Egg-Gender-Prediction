# 🐍 Egg Detection Backend Server

<div align="center">

![Python](https://img.shields.io/badge/Python-3.7+-blue?logo=python)
![Flask](https://img.shields.io/badge/Flask-2.3+-green?logo=flask)
![OpenCV](https://img.shields.io/badge/OpenCV-4.8+-red?logo=opencv)
![ML](https://img.shields.io/badge/ML-Scikit--learn-orange)

**Flask-based backend server with computer vision and machine learning**

</div>

---

## 📋 Overview

This is the Python Flask backend server for the Egg Gender Prediction System. It handles:
- Real-time computer vision-based egg detection using OpenCV
- Machine Learning predictions using Random Forest classifier
- RESTful API endpoints for Flutter app communication
- Detection history management with JSON storage
- Camera management and measurement calculations

---

## ✨ Features

### Computer Vision
- 📷 **Camera Integration** - USB and Raspberry Pi Camera Module support
- 🔍 **Image Processing** - Gaussian blur, adaptive thresholding, morphological operations
- 📏 **Automatic Measurement** - Width, height calculation using contour detection
- 📊 **ESI Calculation** - Egg Shape Index: `(Width / Height) × 100`
- 🎯 **Background Detection** - Adaptive processing for different backgrounds
- 📈 **Moving Average** - 5-second window for stable measurements (150 frames @ 30 FPS)

### Machine Learning
- 🤖 **Random Forest Classifier** - Trained model with GridSearchCV optimization
- 🧮 **Feature Engineering** - 7 calculated features from base measurements
- 🎯 **Confidence Scores** - Prediction probability distribution
- 📦 **Model Persistence** - Joblib serialization for fast loading
- 🔄 **StandardScaler** - Feature normalization for better predictions

### API & Storage
- 🌐 **RESTful API** - Flask-based with CORS support
- ⚡ **Async Processing** - Threading for non-blocking detection
- 💾 **JSON Storage** - Simple file-based history management
- 🔒 **Error Handling** - Comprehensive exception management

### Deployment
- 🥧 **Raspberry Pi Ready** - Optimized for RPi 4B
- 🚀 **Auto-start Service** - Systemd integration for production
- 🔧 **Easy Installation** - Automated setup scripts
- 📝 **Comprehensive Docs** - Deployment guides and checklists

---

## 🏗 System Architecture

```
┌─────────────────────────────────────────┐
│         Flask Application               │
│  ┌─────────────────────────────────┐   │
│  │      REST API Endpoints         │   │
│  │  - /api/status                  │   │
│  │  - /api/start_detection         │   │
│  │  - /api/get_results             │   │
│  │  - /api/manual_predict          │   │
│  │  - /api/save_history            │   │
│  │  - /api/get_history             │   │
│  └────────┬────────────────────────┘   │
│           │                             │
│  ┌────────▼────────────┐                │
│  │  Detection Module   │◄───┐           │
│  │  - Camera capture   │    │           │
│  │  - Image processing │    │           │
│  │  - Contour analysis │    │           │
│  │  - Measurement calc │    │           │
│  └─────────────────────┘    │           │
│                              │           │
│  ┌─────────────────────┐    │           │
│  │   ML Predictor      │    │           │
│  │  - Model loading    │    │           │
│  │  - Feature engineer │◄───┤           │
│  │  - Prediction       │    │           │
│  └─────────────────────┘    │           │
│                              │           │
│  ┌─────────────────────┐    │           │
│  │  History Manager    │◄───┘           │
│  │  - JSON storage     │                │
│  │  - Statistics       │                │
│  └─────────────────────┘                │
└─────────────────────────────────────────┘
         │
         ├──► 📷 Camera Hardware
         ├──► 💾 detection_history.json
         └──► 📦 models/*.pkl
```

---

## 📁 Project Structure

```
egg_detection_server/
├── server.py                   # Main Flask application
├── detection.py                # OpenCV detection system
├── ml_predict.py               # ML model interface
├── history_manager.py          # History storage manager
│
├── models/                     # Trained ML models
│   ├── egg_gender_model.pkl    # Random Forest classifier
│   ├── scaler.pkl              # Feature scaler
│   └── label_encoder.pkl       # Label encoder
│
├── requirements.txt            # Python deps (PC/Laptop)
├── requirements_rpi.txt        # Python deps (Raspberry Pi)
│
├── find_camera.py              # Camera detection utility
├── test_camera.py              # Camera test script
├── check_models.py             # Model validation script
│
├── install_rpi.sh              # Auto-install for RPi
├── test_rpi_setup.sh           # RPi setup verification
│
├── RASPBERRY_PI_SETUP.md       # Complete RPi guide
├── QUICK_START_RPI.md          # Quick RPi guide
├── DEPLOYMENT_CHECKLIST.md     # Deployment checklist
└── README_DEPLOYMENT.md        # Deployment options guide
```

---

## 🚀 Installation

### Option 1: PC/Laptop Setup

#### Prerequisites
- Python 3.7 or higher
- Webcam or USB camera
- Windows/Mac/Linux

#### Steps

1. **Navigate to server directory**
   ```bash
   cd APP/egg_detection_server
   ```

2. **Create virtual environment**
   ```bash
   python -m venv venv
   
   # Windows
   venv\Scripts\activate
   
   # Mac/Linux
   source venv/bin/activate
   ```

3. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

4. **Find camera index**
   ```bash
   python find_camera.py
   ```

5. **Update camera index** (if not 0 or 1)
   
   Edit `detection.py`:
   ```python
   def __init__(self, camera_index=YOUR_INDEX, ...):
   ```

6. **Verify models exist**
   ```bash
   python check_models.py
   ```

7. **Start server**
   ```bash
   python server.py
   ```

8. **Test in browser**
   ```
   http://localhost:5000/api/status
   ```

---

### Option 2: Raspberry Pi Deployment

#### Quick Setup (Automated)

1. **Transfer files to RPi**
   ```bash
   # From your PC
   scp -r egg_detection_server pi@raspberrypi.local:~/
   ```

2. **SSH into Raspberry Pi**
   ```bash
   ssh pi@raspberrypi.local
   ```

3. **Run auto-installer**
   ```bash
   cd ~/egg_detection_server
   chmod +x install_rpi.sh
   ./install_rpi.sh
   ```

4. **Wait 5-10 minutes** for installation

5. **Verify setup**
   ```bash
   chmod +x test_rpi_setup.sh
   ./test_rpi_setup.sh
   ```

6. **Find RPi IP address**
   ```bash
   hostname -I
   ```

7. **Test from another device**
   ```
   http://YOUR_RPI_IP:5000/api/status
   ```

The server will now:
- ✅ Start automatically on boot
- ✅ Run in background (no display needed)
- ✅ Restart automatically if it crashes
- ✅ Be accessible from any device on same network

#### Manual Setup

See [RASPBERRY_PI_SETUP.md](RASPBERRY_PI_SETUP.md) for detailed instructions.

---

## 📡 API Documentation

### Base URL
```
http://localhost:5000        # PC/Laptop
http://raspberrypi.local:5000  # Raspberry Pi (mDNS)
http://192.168.1.X:5000      # Raspberry Pi (IP address)
```

---

### `GET /api/status`

Check if server is running and camera is available.

**Response:**
```json
{
  "status": "online",
  "message": "Egg Detection Server is running",
  "camera_available": true
}
```

---

### `POST /api/start_detection`

Start automated 5-second detection process.

**Request:** Empty POST

**Response:**
```json
{
  "success": true,
  "message": "Detection started",
  "duration": 5
}
```

**Process:**
1. Activates camera for 5 seconds
2. Processes frames in background thread
3. Calculates average measurements
4. Stores results for retrieval

---

### `GET /api/get_results`

Poll for current detection results. Call every 500ms during detection.

**Response (Detecting):**
```json
{
  "status": "detecting",
  "camera_width": 0,
  ...
}
```

**Response (Completed):**
```json
{
  "status": "completed",
  "camera_width": 5.42,
  "camera_height": 6.85,
  "camera_esi": 79.12,
  "camera_gender": "Unhatched",
  "ml_width": 5.42,
  "ml_height": 6.85,
  "ml_esi": 79.12,
  "ml_gender": "Female",
  "ml_confidence": 0.89,
  "timestamp": "2026-02-12 14:30:45",
  "error_message": ""
}
```

**Response (Error):**
```json
{
  "status": "error",
  "error_message": "Camera not available"
}
```

---

### `POST /api/manual_predict`

Predict gender from manual measurements.

**Request:**
```json
{
  "width": 5.5,
  "height": 7.0
}
```

**Response:**
```json
{
  "success": true,
  "camera_width": 5.5,
  "camera_height": 7.0,
  "camera_esi": 78.57,
  "camera_gender": "Female",
  "ml_width": 5.5,
  "ml_height": 7.0,
  "ml_esi": 78.57,
  "ml_gender": "Female",
  "ml_confidence": 0.92,
  "timestamp": "2026-02-12 14:35:20"
}
```

---

### `POST /api/save_history`

Save detection result to history file.

**Request:**
```json
{
  "user_email": "user@example.com",
  "detection_data": {
    "camera_width": 5.42,
    "camera_height": 6.85,
    "camera_esi": 79.12,
    "camera_gender": "Unhatched",
    "ml_gender": "Female",
    "ml_confidence": 0.89,
    "detection_type": "camera"
  }
}
```

**Response:**
```json
{
  "success": true,
  "message": "Detection saved to history",
  "id": 123
}
```

---

### `GET /api/get_history`

Retrieve detection history.

**Query Parameters:**
- `limit` (optional): Number of recent entries to return (default: 50)

**Response:**
```json
{
  "success": true,
  "history": [
    {
      "id": 123,
      "user_email": "user@example.com",
      "timestamp": "2026-02-12 14:30:45",
      "camera_width": 5.42,
      "camera_height": 6.85,
      "camera_esi": 79.12,
      "camera_gender": "Unhatched",
      "ml_gender": "Female",
      "ml_confidence": 0.89,
      "detection_type": "camera"
    }
  ],
  "total": 1
}
```

---

### `POST /api/stop_detection`

Stop ongoing detection process.

**Response:**
```json
{
  "success": true,
  "message": "Detection stopped"
}
```

---

## 🤖 Machine Learning Details

### Model: Random Forest Classifier

**Training Features (7):**
1. Width (cm)
2. Height (cm)
3. Shape Index (ESI) %
4. Aspect Ratio
5. Perimeter Approximation
6. Area Approximation
7. Width-Height Difference

**Output Classes:**
- Male
- Female
- Unhatched

**Preprocessing:**
- StandardScaler normalization
- LabelEncoder for class labels

**Model Files:**
- `egg_gender_model.pkl` - Trained Random Forest
- `scaler.pkl` - Feature scaler
- `label_encoder.pkl` - Label encoder

---

## 🔧 Configuration

### Camera Settings

Edit `detection.py`:

```python
class EggDetectionSystem:
    def __init__(self, 
                 camera_index=0,              # Camera index (0, 1, 2...)
                 pixels_to_cm_ratio=0.016):   # Calibration ratio
```

**Calibration:**
1. Place object of known width under camera
2. Measure pixel width in detection
3. Calculate: `ratio = actual_width_cm / pixel_width`
4. Update `pixels_to_cm_ratio`

### Flask Settings

Edit `server.py`:

```python
app.run(
    host='0.0.0.0',  # Accept connections from any device
    port=5000,       # Port number
    debug=True,      # Debug mode (disable in production)
    threaded=True    # Handle multiple requests
)
```

---

## 🐛 Troubleshooting

### Camera Not Detected
```bash
# List available cameras
python find_camera.py

# Test camera
python test_camera.py

# Check camera index in detection.py
# Try different indices: 0, 1, 2...
```

### Model Not Loading
```bash
# Verify model files exist
python check_models.py

# Check models/ folder
ls -la models/

# Ensure these files exist:
# - egg_gender_model.pkl
# - scaler.pkl
# - label_encoder.pkl
```

### Server Won't Start
```bash
# Check port is not in use
# Windows
netstat -ano | findstr :5000

# Mac/Linux
lsof -i :5000

# Kill process using port 5000
# Windows: taskkill /PID <PID> /F
# Mac/Linux: kill -9 <PID>
```

### Raspberry Pi Service Issues
```bash
# Check service status
sudo systemctl status egg-detection.service

# View logs
sudo journalctl -u egg-detection.service -f

# Restart service
sudo systemctl restart egg-detection.service

# Disable auto-start
sudo systemctl disable egg-detection.service

# Enable auto-start
sudo systemctl enable egg-detection.service
```

---

## 📈 Performance

### Laptop/PC
- Detection: ~5 seconds
- CPU Usage: 30-50%
- Memory: ~150-200 MB

### Raspberry Pi 4B
- Detection: ~5-7 seconds
- CPU Usage: 60-80%
- Memory: ~250-300 MB
- Power: ~5W

---

## 🔒 Security Considerations

1. **CORS** - Currently allows all origins. Restrict in production:
   ```python
   CORS(app, resources={r"/api/*": {"origins": ["http://yourapp.com"]}})
   ```

2. **HTTPS** - Use SSL certificates in production

3. **Authentication** - Add API key validation if needed

4. **Firewall** - Configure firewall rules on RPi

---

## 🤝 Contributing

Contributions welcome! Areas for improvement:
- [ ] Add authentication to API endpoints
- [ ] Implement database instead of JSON
- [ ] Add concurrent detection support
- [ ] Improve error handling
- [ ] Add unit tests
- [ ] Implement logging system

---

## 📄 License

See [LICENSE](../../LICENSE) in root directory.

---

## 🆘 Support

For backend server issues:
1. Check logs: `detection_history.json` and console output
2. Run diagnostic scripts: `find_camera.py`, `check_models.py`
3. Review documentation files in this directory
4. Create issue with error logs and system info

---

<div align="center">

**Powered by Flask + OpenCV + Scikit-learn 🐍**

[Back to Main README](../../README.md)

</div>
