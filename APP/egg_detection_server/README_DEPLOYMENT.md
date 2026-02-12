# Egg Detection Server - Deployment Guide

## Overview
This project is a Flask-based egg detection server that uses OpenCV for camera-based egg measurement and machine learning for gender prediction. It can run on both regular computers and Raspberry Pi.

---

## Architecture

```
┌─────────────────┐         HTTP/REST API         ┌──────────────────┐
│  Flutter App    │◄────────────────────────────►│  Flask Server    │
│  (Mobile/Web)   │                               │  (RPi/Computer)  │
└─────────────────┘                               └────────┬─────────┘
                                                           │
                                                           ├─► Camera (USB/RPi Cam)
                                                           ├─► ML Model
                                                           └─► History Storage
```

---

## Features
- Real-time egg detection using camera
- Automatic measurement (width, height, ESI)
- ML-based gender prediction
- Manual measurement input
- Detection history storage
- REST API for mobile/web integration
- Auto-start capability on Raspberry Pi

---

## Hardware Requirements

### For Development (Current Setup - Laptop):
- Any Windows/Mac/Linux computer
- USB camera or built-in webcam
- Python 3.7+

### For Production (Raspberry Pi):
- Raspberry Pi 4 Model B (2GB RAM minimum, 4GB recommended)
- Raspberry Pi Camera Module V2 or USB webcam
- MicroSD card (16GB minimum, 32GB recommended)
- Power supply (official 5V 3A recommended)
- Network connection (WiFi or Ethernet)

---

## Project Files

### Core Files:
- `server.py` - Main Flask server
- `detection.py` - OpenCV-based egg detection system
- `ml_predict.py` - Machine learning prediction
- `history_manager.py` - Detection history management
- `requirements.txt` - Python dependencies (for development)
- `requirements_rpi.txt` - Python dependencies (for Raspberry Pi)

### Setup Files:
- `RASPBERRY_PI_SETUP.md` - Complete Raspberry Pi setup guide
- `QUICK_START_RPI.md` - Quick start guide for Raspberry Pi
- `install_rpi.sh` - Automated installation script for RPi
- `test_rpi_setup.sh` - Test script to verify setup
- `find_camera.py` - Utility to find correct camera index

### Data Files:
- `detection_history.json` - Stored detection history
- ML model files (if any)

---

## Deployment Options

### Option 1: Run on Laptop (Current)
**Pros:**
- Easy development and testing
- Full display for debugging
- More processing power

**Cons:**
- Not portable
- Must keep laptop running
- Not suitable for production

**How to run:**
```bash
python server.py
```

### Option 2: Run on Raspberry Pi (Recommended for Production)
**Pros:**
- Low power consumption (~5W)
- Small and portable
- Auto-start on boot
- No display needed
- Can run 24/7

**Cons:**
- Less processing power than laptop
- Initial setup required
- May need optimization for performance

**How to deploy:**
See [QUICK_START_RPI.md](QUICK_START_RPI.md)

---

## Quick Deployment to Raspberry Pi

### 1. Transfer Files
Copy the entire `egg_detection_server` folder to Raspberry Pi

### 2. Run Installation Script
```bash
cd ~/egg_detection_server
chmod +x install_rpi.sh
./install_rpi.sh
```

### 3. Verify Setup
```bash
./test_rpi_setup.sh
```

### 4. Access Server
```
http://YOUR_RPI_IP:5000/api/status
```

That's it! Server will auto-start on boot.

---

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/status` | Check server status |
| POST | `/api/start_detection` | Start 5-second detection |
| GET | `/api/get_results` | Get detection results |
| POST | `/api/manual_predict` | Manual measurement prediction |
| POST | `/api/stop_detection` | Stop ongoing detection |
| POST | `/api/save_history` | Save detection to history |
| GET | `/api/get_history` | Get detection history |
| GET | `/api/get_statistics` | Get detection statistics |

---

## Connecting Flutter App

Update your Flutter app's API base URL:

**For Laptop (Development):**
```dart
final String apiBaseUrl = 'http://localhost:5000';
```

**For Raspberry Pi (Production):**
```dart
final String apiBaseUrl = 'http://192.168.1.100:5000';  // Use your RPi IP
```

Make sure devices are on the same WiFi network.

---

## Performance Considerations

### Raspberry Pi Optimizations:
1. **Reduce camera resolution** (640x480 is sufficient)
2. **Disable debug mode** in Flask
3. **Use system OpenCV** (apt install) instead of pip
4. **Close unused applications**
5. **Ensure adequate cooling** (heatsink/fan)

---

## Network Setup

### Development (Same Device):
```
http://localhost:5000
```

### Local Network (Different Devices):
```
http://DEVICE_IP:5000
```

Find device IP:
- **Windows:** `ipconfig`
- **Linux/Mac/RPi:** `hostname -I`

### Static IP (Recommended for RPi):
Edit `/etc/dhcpcd.conf`:
```
interface wlan0
static ip_address=192.168.1.100/24
static routers=192.168.1.1
static domain_name_servers=192.168.1.1
```

---

## Troubleshooting

### Camera Issues:
```bash
# Find cameras
python3 find_camera.py

# Enable RPi Camera
sudo raspi-config  # Interface Options -> Camera
```

### Service Issues:
```bash
# Check status
sudo systemctl status egg-detection.service

# View logs
sudo journalctl -u egg-detection.service -f

# Restart
sudo systemctl restart egg-detection.service
```

### Network Issues:
```bash
# Check if server is running
curl http://localhost:5000/api/status

# Check if port is open
sudo netstat -tulpn | grep 5000

# Allow firewall
sudo ufw allow 5000/tcp
```

---

## Auto-Start Configuration

The server runs as a systemd service on Raspberry Pi:

**Service file location:**
```
/etc/systemd/system/egg-detection.service
```

**Control commands:**
```bash
sudo systemctl start egg-detection.service    # Start
sudo systemctl stop egg-detection.service     # Stop
sudo systemctl restart egg-detection.service  # Restart
sudo systemctl status egg-detection.service   # Status
sudo systemctl enable egg-detection.service   # Enable auto-start
sudo systemctl disable egg-detection.service  # Disable auto-start
```

---

## Security Recommendations

1. **Change default password** on Raspberry Pi
2. **Use strong WiFi password**
3. **Don't expose to internet** without proper security
4. **Keep system updated:** `sudo apt update && sudo apt upgrade`
5. **Consider adding authentication** to API endpoints
6. **Use HTTPS** if exposing beyond local network

---

## Backup Important Data

Regular backup of:
```bash
# Detection history
~/egg_detection_server/detection_history.json

# Service configuration
/etc/systemd/system/egg-detection.service
```

---

## Development vs Production

| Feature | Development (Laptop) | Production (RPi) |
|---------|---------------------|------------------|
| Environment | Windows/Mac/Linux | Raspberry Pi OS |
| Camera | USB/Built-in | RPi Camera/USB |
| Auto-start | Manual | systemd service |
| Display | Required | Not required |
| Access | localhost | Network IP |
| Debug mode | Enabled | Disabled |

---

## Next Steps

1. **Test on laptop first** to ensure everything works
2. **Deploy to Raspberry Pi** using installation script
3. **Configure static IP** for consistent access
4. **Update Flutter app** with RPi IP address
5. **Test thoroughly** with real eggs
6. **Monitor performance** and optimize if needed

---

## Support Files

- Detailed setup: [RASPBERRY_PI_SETUP.md](RASPBERRY_PI_SETUP.md)
- Quick start: [QUICK_START_RPI.md](QUICK_START_RPI.md)
- Installation script: `install_rpi.sh`
- Test script: `test_rpi_setup.sh`
- Camera finder: `find_camera.py`

---

## License & Notes

This is a portable egg detection system designed for embedded deployment. The server runs independently and can be accessed from any device on the same network.

**Remember:** Always test thoroughly before deploying to production!
