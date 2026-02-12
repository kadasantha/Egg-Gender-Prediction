# 🥚 Egg Gender Prediction System

<div align="center">

![Project Status](https://img.shields.io/badge/Status-Active-success)
![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue?logo=flutter)
![Python](https://img.shields.io/badge/Python-3.7+-blue?logo=python)
![License](https://img.shields.io/badge/License-MIT-green)

**An IoT + Machine Learning solution for automated egg gender detection using computer vision and predictive analytics.**

[Features](#-features) • [Architecture](#-architecture) • [Installation](#-installation) • [Documentation](#-documentation) • [Contributing](#-contributing)

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [System Architecture](#-architecture)
- [Technologies Used](#-technologies-used)
- [Project Structure](#-project-structure)
- [Installation](#-installation)
  - [Mobile App Setup](#mobile-app-setup)
  - [Backend Server Setup](#backend-server-setup)
  - [Raspberry Pi Deployment](#raspberry-pi-deployment)
- [Usage](#-usage)
- [API Documentation](#-api-documentation)
- [ML Model Details](#-ml-model-details)
- [Screenshots](#-screenshots)
- [Hardware Requirements](#-hardware-requirements)
- [Contributing](#-contributing)
- [License](#-license)
- [Contact](#-contact)

---

## 🎯 Overview

The **Egg Gender Prediction System** is a comprehensive IoT solution that combines computer vision, machine learning, and mobile technology to automatically detect and predict the gender of eggs. The system uses physical measurements (width, height) to calculate the Egg Shape Index (ESI) and classify eggs as Male, Female, or Unhatched.

### Key Highlights

- 🎥 **Real-time Camera Detection** - 5-second automated measurement using OpenCV
- 🤖 **Dual Prediction System** - Rule-based ESI classification + ML-based Random Forest prediction
- 📱 **Cross-platform Mobile App** - Built with Flutter for Android & iOS
- 🔄 **RESTful API** - Flask-based backend with comprehensive endpoints
- 🏗️ **IoT Ready** - Deployable on Raspberry Pi 4B with auto-start capability
- 📊 **History Tracking** - JSON-based storage with user-specific filtering
- 🔐 **Secure Authentication** - Firebase integration for user management

---

## ✨ Features

### Mobile Application
- ✅ Real-time egg detection with live countdown
- ✅ Manual measurement input option
- ✅ Detection history with advanced filtering
- ✅ User authentication (Firebase)
- ✅ Server connectivity status monitoring
- ✅ Material Design UI with custom theming
- ✅ Cross-platform support (Android/iOS)

### Backend Server
- ✅ OpenCV-based computer vision detection
- ✅ Machine learning prediction with confidence scores
- ✅ RESTful API with CORS support
- ✅ Background threading for non-blocking operations
- ✅ JSON-based history management
- ✅ Raspberry Pi deployment scripts
- ✅ Auto-start systemd service configuration

### Machine Learning
- ✅ Random Forest classifier
- ✅ 7-feature engineering pipeline
- ✅ GridSearchCV hyperparameter optimization
- ✅ 80/20 train-test split
- ✅ StandardScaler normalization
- ✅ Confidence score predictions

---

## 🏗 Architecture

```
┌─────────────────────────────┐
│   Flutter Mobile App        │  (Android / iOS / Web)
│   ├─ User Interface         │
│   ├─ Firebase Auth          │
│   └─ API Client             │
└──────────┬──────────────────┘
           │
           │ HTTP REST API
           │ (WiFi Network)
           │
           ▼
┌─────────────────────────────┐
│   Flask Server              │  (Raspberry Pi 4B / PC)
│   ├─ Detection Controller   │
│   ├─ API Endpoints          │
│   └─ History Manager        │
└──────────┬──────────────────┘
           │
           ├──► 📷 Camera (USB / Pi Camera)
           │    └─► OpenCV Processing
           │
           ├──► 🤖 ML Model (Random Forest)
           │    └─► Gender Prediction
           │
           └──► 💾 JSON Storage
                └─► Detection History
```

---

## 🛠 Technologies Used

### Frontend
- **Flutter** - Cross-platform mobile framework
- **Dart** - Programming language
- **Firebase** - Authentication & cloud services
- **Provider** - State management
- **HTTP** - API communication
- **Google Fonts** - Typography

### Backend
- **Python 3.7+** - Server language
- **Flask** - Web framework
- **OpenCV** - Computer vision
- **NumPy** - Numerical computing
- **Pandas** - Data manipulation
- **Scikit-learn** - Machine learning
- **Joblib** - Model serialization

### Hardware
- **Raspberry Pi 4B** (2GB+ RAM) - Production deployment
- **Camera Module** - USB or Raspberry Pi Camera Module V2
- **MicroSD Card** - 16GB+ for OS and storage

---

## 📁 Project Structure

```
Rapa/
├── APP/
│   ├── App/
│   │   └── egg_detection_app/          # Flutter mobile application
│   │       ├── lib/
│   │       │   ├── main.dart
│   │       │   ├── screens/            # UI screens
│   │       │   ├── services/           # API & Auth services
│   │       │   ├── models/             # Data models
│   │       │   └── utils/              # Constants & helpers
│   │       ├── assets/                 # Images & icons
│   │       ├── android/                # Android configuration
│   │       ├── ios/                    # iOS configuration
│   │       └── pubspec.yaml            # Dependencies
│   │
│   └── egg_detection_server/           # Python Flask backend
│       ├── server.py                   # Main Flask server
│       ├── detection.py                # OpenCV detection system
│       ├── ml_predict.py               # ML model interface
│       ├── history_manager.py          # History storage
│       ├── models/                     # Trained ML models
│       │   ├── egg_gender_model.pkl
│       │   ├── scaler.pkl
│       │   └── label_encoder.pkl
│       ├── requirements.txt            # Python dependencies (PC)
│       ├── requirements_rpi.txt        # Python dependencies (RPi)
│       ├── install_rpi.sh              # Auto-install script
│       └── *.md                        # Documentation files
│
├── Model train/
│   ├── Colab Notebooks/                # Original training notebooks
│   └── Egg Gender Prediction Model/    # Dataset & training files
│
├── try to edit rapa project/           # Model development notebooks
│   ├── FINAL_WithLecturerFeedback.ipynb
│   ├── FINAL_Egg_Model_WithGridSearch.ipynb
│   └── ...
│
└── README.md                           # This file
```

---

## 🚀 Installation

### Prerequisites
- Flutter SDK (3.0+)
- Python 3.7+
- Git
- (Optional) Raspberry Pi 4B with Raspberry Pi OS

### Mobile App Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/egg-gender-prediction.git
   cd egg-gender-prediction/APP/App/egg_detection_app
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Add your `google-services.json` (Android) to `android/app/`
   - Add your `GoogleService-Info.plist` (iOS) to `ios/Runner/`

4. **Update server URL**
   - Edit `lib/utils/constants.dart`
   - Change `baseUrl` to your server's IP address

5. **Run the app**
   ```bash
   flutter run
   ```

### Backend Server Setup

#### Option 1: Run on PC/Laptop

1. **Navigate to server directory**
   ```bash
   cd APP/egg_detection_server
   ```

2. **Create virtual environment**
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

4. **Find camera index**
   ```bash
   python find_camera.py
   ```

5. **Update camera index in detection.py** (if needed)

6. **Start server**
   ```bash
   python server.py
   ```

7. **Server will run on:** `http://localhost:5000`

#### Option 2: Raspberry Pi Deployment

> **Detailed guides available:**
> - [RASPBERRY_PI_SETUP.md](APP/egg_detection_server/RASPBERRY_PI_SETUP.md)
> - [QUICK_START_RPI.md](APP/egg_detection_server/QUICK_START_RPI.md)
> - [DEPLOYMENT_CHECKLIST.md](APP/egg_detection_server/DEPLOYMENT_CHECKLIST.md)

**Quick Setup:**

1. **Transfer files to Raspberry Pi**
   ```bash
   scp -r egg_detection_server pi@raspberrypi.local:~/
   ```

2. **SSH into Raspberry Pi**
   ```bash
   ssh pi@raspberrypi.local
   ```

3. **Run auto-install script**
   ```bash
   cd ~/egg_detection_server
   chmod +x install_rpi.sh
   ./install_rpi.sh
   ```

4. **Verify installation**
   ```bash
   chmod +x test_rpi_setup.sh
   ./test_rpi_setup.sh
   ```

5. **Server auto-starts on boot** via systemd service

---

## 💡 Usage

### Automated Detection

1. Open the mobile app
2. Login with your Firebase account
3. Tap **"Start Detection"** on the Detection screen
4. Place egg under camera
5. Wait 5 seconds for measurement
6. View results (Camera-based + ML prediction)
7. Results automatically saved to history

### Manual Input

1. Navigate to **"Manual Input"** screen
2. Enter egg Width (cm)
3. Enter egg Height (cm)
4. Tap **"Predict"**
5. View ESI and gender prediction
6. Results saved to history

### View History

1. Navigate to **"History"** screen
2. Filter by: All / Camera / Manual
3. View detailed measurements
4. Compare camera vs ML predictions

---

## 📡 API Documentation

### Base URL
```
http://raspberrypi.local:5000
```

### Endpoints

#### `GET /api/status`
Check server status and camera availability.

**Response:**
```json
{
  "status": "online",
  "message": "Egg Detection Server is running",
  "camera_available": true
}
```

#### `POST /api/start_detection`
Start 5-second automated detection process.

**Response:**
```json
{
  "success": true,
  "message": "Detection started",
  "duration": 5
}
```

#### `GET /api/get_results`
Poll for detection results (call every 500ms).

**Response:**
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
  "timestamp": "2026-02-12 14:30:45"
}
```

#### `POST /api/manual_predict`
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
  "camera_esi": 78.57,
  "camera_gender": "Female",
  "ml_gender": "Female",
  "ml_confidence": 0.92
}
```

#### `POST /api/save_history`
Save detection result to history.

#### `GET /api/get_history`
Retrieve detection history.

---

## 🤖 ML Model Details

### Algorithm
**Random Forest Classifier** with GridSearchCV optimization

### Features (7 total)
1. Width (cm)
2. Height (cm)
3. Shape Index (ESI) %
4. Aspect Ratio (Width/Height)
5. Perimeter Approximation
6. Area Approximation
7. Width-Height Difference

### Classification Rules (ESI-based)
```
ESI < 72        → Male
72 ≤ ESI ≤ 78   → Female
ESI > 78        → Unhatched
```

### Training Details
- Dataset: Extended egg dataset
- Split: 80% train, 20% test
- Normalization: StandardScaler
- Encoding: LabelEncoder
- Validation: Cross-validation
- Optimization: GridSearchCV

### Model Files
- `egg_gender_model.pkl` - Trained classifier
- `scaler.pkl` - Feature scaler
- `label_encoder.pkl` - Label encoder

---

## 📸 Screenshots

> Add screenshots of your mobile app here

---

## 🖥 Hardware Requirements

### For Development (PC/Laptop)
- Any computer with Python 3.7+
- USB webcam or built-in camera
- 4GB+ RAM recommended

### For Production (Raspberry Pi)
- **Raspberry Pi 4B** (2GB RAM minimum, 4GB recommended)
- **Camera**: Raspberry Pi Camera Module V2 or USB webcam
- **Storage**: MicroSD card (16GB minimum, 32GB recommended)
- **Power**: Official 5V 3A power supply
- **Network**: WiFi or Ethernet connection
- **Optional**: Heatsink, cooling fan, protective case

### Camera Setup Requirements
- Well-lit environment
- Contrasting background (white or dark)
- Stable camera mount
- Clear view of egg

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and development process.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👥 Authors

**Your Name**
- GitHub: [@yourusername](https://github.com/yourusername)
- Email: your.email@example.com

**Project Link:** [https://github.com/yourusername/egg-gender-prediction](https://github.com/yourusername/egg-gender-prediction)

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- OpenCV community for computer vision libraries
- Scikit-learn for machine learning tools
- Raspberry Pi Foundation for affordable computing hardware
- All contributors and testers

---

## 📞 Support

If you encounter any issues or have questions:

1. Check the [Documentation](APP/egg_detection_server/)
2. Search [Issues](https://github.com/yourusername/egg-gender-prediction/issues)
3. Create a new issue with detailed information
4. Contact via email

---

<div align="center">

**⭐ Star this repository if you find it helpful!**

Made with ❤️ for poultry farming automation

</div>
