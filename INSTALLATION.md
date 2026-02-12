# Installation Guide

Complete installation guide for the Egg Gender Prediction System.

## 📋 Quick Links

- [Prerequisites](#prerequisites)
- [Mobile App Installation](#mobile-app-installation)
- [Backend Server Installation](#backend-server-installation)
- [Raspberry Pi Deployment](#raspberry-pi-deployment)
- [Troubleshooting](#troubleshooting)

---

## Prerequisites

### For Mobile App Development
- Flutter SDK 3.0+ ([Download](https://flutter.dev/docs/get-started/install))
- Android Studio or VS Code with Flutter extensions
- Firebase account ([Create here](https://console.firebase.google.com/))
- Android device/emulator or iOS device/simulator

### For Backend Server
- Python 3.7+ ([Download](https://www.python.org/downloads/))
- pip (Python package installer)
- USB webcam or built-in camera
- (Optional) Raspberry Pi 4B with camera

### System Requirements

**Development PC:**
- OS: Windows 10/11, macOS 10.14+, or Ubuntu 20.04+
- RAM: 4GB minimum, 8GB recommended
- Storage: 10GB free space
- Webcam: Any USB or built-in camera

**Raspberry Pi (Production):**
- Raspberry Pi 4B (2GB RAM minimum, 4GB recommended)
- MicroSD card: 16GB minimum, 32GB recommended
- Camera: Raspberry Pi Camera Module V2 or USB webcam
- Power supply: Official 5V 3A adapter
- Network: WiFi or Ethernet connection

---

## Mobile App Installation

### Step 1: Install Flutter

**Windows:**
1. Download Flutter SDK from [flutter.dev](https://flutter.dev)
2. Extract to `C:\src\flutter`
3. Add `C:\src\flutter\bin` to PATH
4. Run `flutter doctor` in terminal

**macOS:**
```bash
cd ~/development
unzip ~/Downloads/flutter_macos_*.zip
export PATH="$PATH:`pwd`/flutter/bin"
flutter doctor
```

**Linux:**
```bash
cd ~/development
tar xf ~/Downloads/flutter_linux_*.tar.xz
export PATH="$PATH:`pwd`/flutter/bin"
flutter doctor
```

### Step 2: Clone Repository

```bash
git clone https://github.com/yourusername/egg-gender-prediction.git
cd egg-gender-prediction/APP/App/egg_detection_app
```

### Step 3: Install Dependencies

```bash
flutter pub get
```

### Step 4: Setup Firebase

1. Create project at [Firebase Console](https://console.firebase.google.com/)
2. Enable Authentication (Email/Password)
3. Create Firestore database (optional)

**For Android:**
```bash
# Add Android app in Firebase Console
# Download google-services.json
# Place in: android/app/google-services.json
```

**For iOS:**
```bash
# Add iOS app in Firebase Console
# Download GoogleService-Info.plist
# Place in: ios/Runner/GoogleService-Info.plist
```

**Generate Firebase config:**
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

### Step 5: Configure Server URL

Edit `lib/utils/constants.dart`:

```dart
static const String baseUrl = 'http://YOUR_SERVER_IP:5000';
```

### Step 6: Run App

```bash
# Check devices
flutter devices

# Run app
flutter run

# Or run on specific device
flutter run -d <device-id>
```

### Step 7: Build Release

**Android APK:**
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

**Android App Bundle (for Play Store):**
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

**iOS:**
```bash
flutter build ios --release
# Then archive in Xcode
```

---

## Backend Server Installation

### Option 1: Windows PC

1. **Install Python**
   - Download from [python.org](https://www.python.org)
   - Check "Add Python to PATH" during installation
   - Verify: `python --version`

2. **Navigate to server directory**
   ```cmd
   cd APP\egg_detection_server
   ```

3. **Create virtual environment**
   ```cmd
   python -m venv venv
   venv\Scripts\activate
   ```

4. **Install dependencies**
   ```cmd
   pip install -r requirements.txt
   ```

5. **Find camera index**
   ```cmd
   python find_camera.py
   ```

6. **Update camera index** (if needed)
   - Edit `detection.py`
   - Change `camera_index=YOUR_INDEX`

7. **Start server**
   ```cmd
   python server.py
   ```

8. **Test**
   - Open browser: `http://localhost:5000/api/status`

### Option 2: macOS/Linux

```bash
cd APP/egg_detection_server

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Find camera
python find_camera.py

# Start server
python server.py
```

---

## Raspberry Pi Deployment

### Quick Setup (Automated)

1. **Prepare Raspberry Pi**
   - Install Raspberry Pi OS (32-bit or 64-bit)
   - Enable SSH: `sudo raspi-config` → Interface Options → SSH
   - Connect to WiFi or Ethernet
   - Update system: `sudo apt update && sudo apt upgrade -y`

2. **Transfer files**
   ```bash
   # From your PC
   scp -r egg_detection_server pi@raspberrypi.local:~/
   ```

3. **SSH to Raspberry Pi**
   ```bash
   ssh pi@raspberrypi.local
   # Default password: raspberry
   ```

4. **Run installer**
   ```bash
   cd ~/egg_detection_server
   chmod +x install_rpi.sh
   ./install_rpi.sh
   ```

5. **Wait for installation** (5-10 minutes)

6. **Verify setup**
   ```bash
   chmod +x test_rpi_setup.sh
   ./test_rpi_setup.sh
   ```

7. **Get IP address**
   ```bash
   hostname -I
   ```

8. **Test from PC**
   ```
   http://YOUR_RPI_IP:5000/api/status
   ```

### Manual Raspberry Pi Setup

See [APP/egg_detection_server/RASPBERRY_PI_SETUP.md](APP/egg_detection_server/RASPBERRY_PI_SETUP.md) for detailed instructions.

---

## Post-Installation

### Configure Auto-Start (Windows)

Create batch file `start_server.bat`:
```batch
@echo off
cd C:\path\to\egg_detection_server
call venv\Scripts\activate
python server.py
pause
```

Add to Windows Startup folder:
- Press `Win+R`
- Type `shell:startup`
- Copy `start_server.bat` to this folder

### Configure Static IP (Raspberry Pi)

```bash
sudo nano /etc/dhcpcd.conf
```

Add:
```conf
interface wlan0  # or eth0 for Ethernet
static ip_address=192.168.1.100/24
static routers=192.168.1.1
static domain_name_servers=192.168.1.1 8.8.8.8
```

Reboot:
```bash
sudo reboot
```

---

## Troubleshooting

### Camera Issues

**Problem:** Camera not detected
**Solution:**
```bash
# List cameras (Linux/Mac)
v4l2-ctl --list-devices

# Test camera (Windows)
python
>>> import cv2
>>> cap = cv2.VideoCapture(0)  # Try 0, 1, 2...
>>> cap.isOpened()
>>> cap.release()

# Update camera index in detection.py
```

### Python Module Errors

**Problem:** Module not found
**Solution:**
```bash
# Ensure virtual environment is activated
# Windows
venv\Scripts\activate

# Mac/Linux
source venv/bin/activate

# Reinstall dependencies
pip install -r requirements.txt
```

### Flutter Build Errors

**Problem:** Build fails
**Solution:**
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

### Firebase Configuration

**Problem:** Firebase not working
**Solution:**
- Verify `google-services.json` location
- Check package name matches Firebase project
- Run `flutterfire configure` again
- Ensure internet connection

### Port Already in Use

**Problem:** Port 5000 in use
**Solution:**
```bash
# Windows
netstat -ano | findstr :5000
taskkill /PID <PID> /F

# Mac/Linux
lsof -i :5000
kill -9 <PID>

# Or change port in server.py
app.run(port=5001)
```

### Raspberry Pi Service Issues

**Problem:** Service won't start
**Solution:**
```bash
# Check status
sudo systemctl status egg-detection.service

# View logs
sudo journalctl -u egg-detection.service -n 50

# Restart
sudo systemctl restart egg-detection.service

# Check permissions
ls -la ~/egg_detection_server
```

---

## Uninstallation

### Remove Mobile App
- Android: Settings → Apps → Egg Detection → Uninstall
- iOS: Long press app icon → Remove App

### Remove Backend Server

**Windows:**
```cmd
cd APP\egg_detection_server
venv\Scripts\deactivate
cd ..
rmdir /s egg_detection_server
```

**Mac/Linux:**
```bash
cd APP
rm -rf egg_detection_server
```

**Raspberry Pi:**
```bash
# Stop service
sudo systemctl stop egg-detection.service
sudo systemctl disable egg-detection.service
sudo rm /etc/systemd/system/egg-detection.service

# Remove files
rm -rf ~/egg_detection_server
```

---

## Additional Resources

- [Flask Documentation](https://flask.palletsprojects.com/)
- [Flutter Documentation](https://docs.flutter.dev/)
- [OpenCV Documentation](https://docs.opencv.org/)
- [Raspberry Pi Documentation](https://www.raspberrypi.org/documentation/)
- [Firebase Documentation](https://firebase.google.com/docs)

---

## Next Steps

After installation:
1. ✅ Configure Firebase authentication
2. ✅ Update server URL in mobile app
3. ✅ Test camera detection
4. ✅ Train or update ML model (if needed)
5. ✅ Setup automatic backups
6. ✅ Configure monitoring/logging
7. ✅ Deploy to production

---

For more help:
- Check [README.md](README.md)
- See [CONTRIBUTING.md](CONTRIBUTING.md)
- Create an issue on GitHub
