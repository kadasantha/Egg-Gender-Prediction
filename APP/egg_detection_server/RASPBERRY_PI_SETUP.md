# Raspberry Pi 4B Setup Guide for Egg Detection Server

This guide will help you run the egg detection server on Raspberry Pi 4B and configure it to auto-start on boot.

## Prerequisites
- Raspberry Pi 4B with Raspberry Pi OS installed
- Camera (Raspberry Pi Camera Module or USB Camera)
- Network connection (WiFi or Ethernet)
- Power supply for Raspberry Pi

---

## Step 1: Transfer Project to Raspberry Pi

### Option A: Using USB Drive
1. Copy the entire `egg_detection_server` folder to a USB drive
2. Insert USB drive into Raspberry Pi
3. Open terminal and copy files:
```bash
cp -r /media/pi/YOUR_USB_DRIVE/egg_detection_server ~/egg_detection_server
```

### Option B: Using Network Transfer (if both devices on same network)
On your laptop, install Python's HTTP server, then in project folder:
```bash
# On your laptop (in egg_detection_server directory)
python -m http.server 8000
```

On Raspberry Pi:
```bash
cd ~
wget -r -np -nH --cut-dirs=1 http://YOUR_LAPTOP_IP:8000/
```

### Option C: Using Git (Recommended if you use version control)
```bash
cd ~
git clone YOUR_REPOSITORY_URL egg_detection_server
```

---

## Step 2: Install System Dependencies

Connect to Raspberry Pi via SSH or use terminal:

```bash
# Update system packages
sudo apt update
sudo apt upgrade -y

# Install Python 3 and pip
sudo apt install python3 python3-pip -y

# Install OpenCV dependencies (important for Raspberry Pi)
sudo apt install python3-opencv -y
sudo apt install libatlas-base-dev libjasper-dev libqtgui4 libqt4-test -y
sudo apt install libhdf5-dev libhdf5-serial-dev -y
sudo apt install libharfbuzz0b libwebp6 libtiff5 libjasper1 -y
sudo apt install libilmbase-dev libopenexr-dev libgstreamer1.0-dev -y

# Install camera support
sudo apt install v4l-utils -y

# Enable camera (if using Raspberry Pi Camera Module)
sudo raspi-config
# Navigate to: Interface Options -> Camera -> Enable
```

---

## Step 3: Install Python Dependencies

Navigate to your project directory:
```bash
cd ~/egg_detection_server
```

Create a virtual environment (recommended):
```bash
python3 -m venv venv
source venv/bin/activate
```

Install requirements with Raspberry Pi compatible versions:
```bash
# Install from requirements.txt
pip3 install Flask flask-cors numpy pandas scikit-learn joblib

# For OpenCV, use system-installed version or install via pip
# System version (already installed) is recommended for RPi
# If you need pip version:
# pip3 install opencv-python-headless
```

---

## Step 4: Configure Camera Settings

Edit the detection.py to use the correct camera index:

For Raspberry Pi Camera Module, use index 0:
```python
camera_index=0
```

For USB Camera, typically index 0 or 1.

Test camera:
```bash
# List available cameras
v4l2-ctl --list-devices

# Test with Python
python3 test_camera.py
```

---

## Step 5: Test Manual Run

Before setting up auto-start, test if everything works:

```bash
cd ~/egg_detection_server
source venv/bin/activate  # if using virtual environment
python3 server.py
```

Access from another device on the same network:
```
http://RASPBERRY_PI_IP:5000/api/status
```

Find Raspberry Pi IP address:
```bash
hostname -I
```

Press Ctrl+C to stop the server.

---

## Step 6: Create Systemd Service for Auto-Start

Create a service file:
```bash
sudo nano /etc/systemd/system/egg-detection.service
```

Add the following content:

```ini
[Unit]
Description=Egg Detection Flask Server
After=network.target

[Service]
Type=simple
User=pi
WorkingDirectory=/home/pi/egg_detection_server
Environment="PATH=/home/pi/egg_detection_server/venv/bin"
ExecStart=/home/pi/egg_detection_server/venv/bin/python3 /home/pi/egg_detection_server/server.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

**Note:** If you're NOT using virtual environment, change:
- `Environment="PATH=/usr/bin"`
- `ExecStart=/usr/bin/python3 /home/pi/egg_detection_server/server.py`

Save and exit (Ctrl+X, then Y, then Enter).

Enable and start the service:
```bash
# Reload systemd daemon
sudo systemctl daemon-reload

# Enable service to start on boot
sudo systemctl enable egg-detection.service

# Start the service now
sudo systemctl start egg-detection.service

# Check service status
sudo systemctl status egg-detection.service
```

---

## Step 7: Manage the Service

### Common Commands:
```bash
# Check if service is running
sudo systemctl status egg-detection.service

# Stop the service
sudo systemctl stop egg-detection.service

# Start the service
sudo systemctl start egg-detection.service

# Restart the service
sudo systemctl restart egg-detection.service

# View logs
sudo journalctl -u egg-detection.service -f

# Disable auto-start (if needed)
sudo systemctl disable egg-detection.service
```

---

## Step 8: Access Raspberry Pi Remotely

### Option A: SSH Access
```bash
# From your laptop
ssh pi@RASPBERRY_PI_IP
```

### Option B: VNC (Screen Sharing)
1. Enable VNC on Raspberry Pi:
```bash
sudo raspi-config
# Navigate to: Interface Options -> VNC -> Enable
```

2. Install VNC Viewer on your laptop from: https://www.realvnc.com/download/viewer/

3. Connect using Raspberry Pi's IP address

### Option C: Access Web Server
Simply open browser on any device on same network:
```
http://RASPBERRY_PI_IP:5000/api/status
```

---

## Step 9: Network Configuration

### Find Raspberry Pi IP Address:
```bash
hostname -I
```

### Set Static IP (optional but recommended):
Edit dhcpcd.conf:
```bash
sudo nano /etc/dhcpcd.conf
```

Add at the end (adjust to your network):
```
interface wlan0  # or eth0 for ethernet
static ip_address=192.168.1.100/24
static routers=192.168.1.1
static domain_name_servers=192.168.1.1 8.8.8.8
```

Reboot to apply:
```bash
sudo reboot
```

---

## Step 10: Firewall Configuration (if needed)

If you have firewall enabled:
```bash
sudo ufw allow 5000/tcp
sudo ufw reload
```

---

## Troubleshooting

### Service won't start:
```bash
# Check detailed logs
sudo journalctl -u egg-detection.service -n 50 --no-pager

# Check if port is already in use
sudo netstat -tulpn | grep 5000
```

### Camera not detected:
```bash
# List cameras
v4l2-ctl --list-devices

# For Raspberry Pi Camera Module
vcgencmd get_camera

# Test camera
raspistill -o test.jpg
```

### Permission issues:
```bash
# Add user to video group
sudo usermod -a -G video pi

# Reboot
sudo reboot
```

### Python module not found:
```bash
# Ensure virtual environment is activated in service file
# Or install globally
pip3 install MODULE_NAME
```

---

## Performance Optimization for Raspberry Pi

### 1. Reduce Camera Resolution
Edit detection.py and add after camera initialization:
```python
self.cap.set(cv2.CAP_PROP_FRAME_WIDTH, 640)
self.cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 480)
```

### 2. Disable Debug Mode
In server.py, change:
```python
app.run(host='0.0.0.0', port=5000, debug=False, threaded=True)
```

### 3. Increase Swap Space (if needed)
```bash
sudo dphys-swapfile swapoff
sudo nano /etc/dphys-swapfile
# Change CONF_SWAPSIZE=100 to CONF_SWAPSIZE=1024
sudo dphys-swapfile setup
sudo dphys-swapfile swapon
```

---

## Testing Auto-Start

1. Reboot Raspberry Pi:
```bash
sudo reboot
```

2. Wait 30 seconds for boot

3. From another device, test the API:
```bash
curl http://RASPBERRY_PI_IP:5000/api/status
```

If you get a response, it's working!

---

## Quick Reference

### Essential Files:
- Service file: `/etc/systemd/system/egg-detection.service`
- Project directory: `/home/pi/egg_detection_server`
- Log file: `sudo journalctl -u egg-detection.service`

### Essential Commands:
```bash
# Service control
sudo systemctl status egg-detection.service
sudo systemctl restart egg-detection.service

# View logs
sudo journalctl -u egg-detection.service -f

# Find IP
hostname -I

# SSH into Pi
ssh pi@RASPBERRY_PI_IP
```

---

## Security Recommendations

1. **Change default password:**
```bash
passwd
```

2. **Update system regularly:**
```bash
sudo apt update && sudo apt upgrade -y
```

3. **Consider using HTTPS** if accessing over internet (not just local network)

4. **Use strong WiFi password**

5. **Disable SSH password authentication** and use SSH keys instead

---

## Next Steps

- Your Flutter app should connect to: `http://RASPBERRY_PI_IP:5000`
- Update the API endpoint in your Flutter app configuration
- Consider adding authentication if needed
- Set up automatic backups of detection_history.json

---

**Note:** Replace `pi` with your actual username if different, and adjust paths accordingly.
