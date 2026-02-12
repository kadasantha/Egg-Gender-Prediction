# Quick Start Guide

Get up and running with the Egg Gender Prediction System in 15 minutes!

## ⚡ Prerequisites Checklist

Before you begin, ensure you have:
- [ ] Python 3.7+ installed
- [ ] Flutter SDK installed (for mobile app)
- [ ] USB camera or built-in webcam
- [ ] WiFi network
- [ ] (Optional) Raspberry Pi 4B

---

## 🚀 Quick Start (Development Mode)

### For Backend Server (5 minutes)

1. **Open terminal and navigate to server directory**
   ```bash
   cd APP/egg_detection_server
   ```

2. **Create and activate virtual environment**
   ```bash
   # Windows
   python -m venv venv
   venv\Scripts\activate

   # Mac/Linux
   python3 -m venv venv
   source venv/bin/activate
   ```

3. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

4. **Start server**
   ```bash
   python server.py
   ```

5. **Test in browser**
   - Open: `http://localhost:5000/api/status`
   - You should see: `{"status": "online"}`

✅ **Server is ready!**

---

### For Mobile App (10 minutes)

1. **Navigate to app directory**
   ```bash
   cd APP/App/egg_detection_app
   ```

2. **Get dependencies**
   ```bash
   flutter pub get
   ```

3. **Update server URL**
   - Open: `lib/utils/constants.dart`
   - Change: `baseUrl = 'http://YOUR_IP:5000'`
   - Use `localhost` or your computer's IP address

4. **Run app**
   ```bash
   flutter run
   ```

5. **Test the app**
   - Login/Register
   - Check server connection on Dashboard
   - Try manual input first

✅ **App is ready!**

---

## 📱 Quick Test Workflow

### Test Manual Prediction (No camera needed)

1. Open app → Login
2. Navigate to "Manual Input"
3. Enter:
   - Width: 5.5
   - Height: 7.0
4. Tap "Predict"
5. View results!

### Test Camera Detection

1. Open app → Login
2. Navigate to "Detection"
3. Place an egg (or similar object) under camera
4. Tap "Start Detection"
5. Wait 5 seconds
6. View results!

---

## 🥧 Production Deployment (Raspberry Pi)

### Quick Raspberry Pi Setup (15 minutes)

1. **Prepare Raspberry Pi**
   - Install Raspberry Pi OS
   - Connect to WiFi
   - Enable SSH

2. **Transfer files from your PC**
   ```bash
   scp -r egg_detection_server pi@raspberrypi.local:~/
   ```

3. **SSH to Raspberry Pi**
   ```bash
   ssh pi@raspberrypi.local
   ```

4. **Run auto-installer**
   ```bash
   cd ~/egg_detection_server
   chmod +x install_rpi.sh
   ./install_rpi.sh
   ```

5. **Wait 5-10 minutes for installation**

6. **Get Raspberry Pi IP**
   ```bash
   hostname -I
   ```

7. **Update mobile app**
   - Edit `lib/utils/constants.dart`
   - Change: `baseUrl = 'http://YOUR_RPI_IP:5000'`
   - Rebuild app

✅ **Production deployment complete!**

---

## 🔧 Common Issues & Quick Fixes

### Issue: Cannot connect to server
**Fix:**
```bash
# Check if server is running
# Visit in browser: http://localhost:5000/api/status

# Check firewall (Windows)
# Allow Python through firewall

# Get your IP address
# Windows: ipconfig
# Mac/Linux: ifconfig
```

### Issue: Camera not detected
**Fix:**
```bash
# Find camera index
python find_camera.py

# Update detection.py
# Change: camera_index=YOUR_INDEX
```

### Issue: Flutter build errors
**Fix:**
```bash
flutter clean
flutter pub get
flutter run
```

### Issue: Module not found (Python)
**Fix:**
```bash
# Ensure virtual environment is activated
# Look for (venv) in terminal prompt

# Reinstall dependencies
pip install -r requirements.txt
```

---

## 📖 Next Steps

After successful setup:

1. **Read the full documentation**
   - [README.md](README.md) - Complete overview
   - [INSTALLATION.md](INSTALLATION.md) - Detailed installation
   - [ARCHITECTURE.md](ARCHITECTURE.md) - System design

2. **Configure Firebase** (for authentication)
   - See Flutter app README
   - Setup takes ~10 minutes

3. **Train custom ML model** (optional)
   - See `Model train/` directory
   - Use Jupyter notebooks

4. **Customize the app**
   - Change colors in `constants.dart`
   - Add your logo
   - Modify features

5. **Deploy to production**
   - Follow Raspberry Pi guides
   - Setup auto-start
   - Configure network

---

## 🆘 Need Help?

- **Documentation:** Check the README files
- **Issues:** Search or create in GitHub Issues
- **Community:** Join discussions
- **Contact:** See README for contact info

---

## 🎯 Development Roadmap

**Week 1: Setup**
- [ ] Install all prerequisites
- [ ] Get backend running locally
- [ ] Get mobile app running
- [ ] Test manual predictions

**Week 2: Testing**
- [ ] Test camera detection
- [ ] Test with real eggs
- [ ] Calibrate camera settings
- [ ] Fine-tune ML model

**Week 3: Deployment**
- [ ] Setup Raspberry Pi
- [ ] Configure auto-start
- [ ] Network configuration
- [ ] Build production app

**Week 4: Production**
- [ ] User testing
- [ ] Bug fixes
- [ ] Performance optimization
- [ ] Documentation updates

---

## 📊 System Requirements Summary

### Minimum
- **PC:** Any computer with Python 3.7+, 4GB RAM
- **Mobile:** Android 6.0+ or iOS 11+
- **Camera:** Any USB webcam
- **Network:** WiFi router

### Recommended
- **RPi:** Raspberry Pi 4B (4GB RAM)
- **Mobile:** Android 10+ or iOS 14+
- **Camera:** 720p or better
- **Network:** Dedicated WiFi network

---

<div align="center">

**🎉 Congratulations! You're all set!**

Start detecting egg genders now! 🥚

[Main README](README.md) | [Installation Guide](INSTALLATION.md) | [Contributing](CONTRIBUTING.md)

</div>
