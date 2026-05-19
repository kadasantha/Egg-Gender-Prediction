# Raspberry Pi Deployment Checklist

Use this checklist to ensure smooth deployment of your egg detection server to Raspberry Pi.

---

## Pre-Deployment Checklist

### Hardware Preparation
- [ ] Raspberry Pi 4B (2GB+ RAM)
- [ ] MicroSD card (16GB+) with Raspberry Pi OS installed
- [ ] Official power supply (5V 3A)
- [ ] Camera (Raspberry Pi Camera Module or USB webcam)
- [ ] Ethernet cable or WiFi credentials
- [ ] (Optional) Heatsink or cooling fan
- [ ] (Optional) Case for protection

### Software Preparation
- [ ] Raspberry Pi OS installed and booted
- [ ] SSH enabled (for remote access)
- [ ] WiFi/Ethernet configured
- [ ] Default password changed
- [ ] System updated (`sudo apt update && sudo apt upgrade`)

### Files to Transfer
- [ ] Entire `egg_detection_server` folder
- [ ] All Python files (server.py, detection.py, etc.)
- [ ] requirements_rpi.txt
- [ ] install_rpi.sh
- [ ] test_rpi_setup.sh
- [ ] find_camera.py
- [ ] ML model files (if any)

---

## Deployment Steps

### Step 1: Access Raspberry Pi
- [ ] Connect via SSH: `ssh pi@raspberrypi.local`
- [ ] Or use monitor and keyboard directly
- [ ] Navigate to home directory: `cd ~`

### Step 2: Transfer Project Files
Choose one method:

**Method A: USB Drive**
- [ ] Insert USB drive with project files
- [ ] Copy files: `cp -r /media/pi/*/egg_detection_server ~/`

**Method B: SCP (from your laptop)**
- [ ] Run: `scp -r egg_detection_server pi@RPi_IP:~/`

**Method C: Git**
- [ ] Clone repository: `git clone YOUR_REPO_URL ~/egg_detection_server`

### Step 3: Run Installation Script
- [ ] Navigate to project: `cd ~/egg_detection_server`
- [ ] Make script executable: `chmod +x install_rpi.sh`
- [ ] Run installation: `./install_rpi.sh`
- [ ] Wait for completion (5-10 minutes)
- [ ] Check for any error messages

### Step 4: Verify Camera
- [ ] Make find_camera.py executable: `chmod +x find_camera.py`
- [ ] Run camera detection: `python3 find_camera.py`
- [ ] Note the working camera index
- [ ] If needed, update detection.py with correct camera index

### Step 5: Test Setup
- [ ] Make test script executable: `chmod +x test_rpi_setup.sh`
- [ ] Run tests: `./test_rpi_setup.sh`
- [ ] Verify all tests pass
- [ ] Check service status: `sudo systemctl status egg-detection.service`

### Step 6: Network Configuration
- [ ] Find Raspberry Pi IP: `hostname -I`
- [ ] Note down the IP address: ___________________
- [ ] Test API from RPi: `curl http://localhost:5000/api/status`
- [ ] Test API from laptop: `curl http://RPi_IP:5000/api/status`

### Step 7: Set Static IP (Recommended)
- [ ] Edit config: `sudo nano /etc/dhcpcd.conf`
- [ ] Add static IP configuration
- [ ] Reboot: `sudo reboot`
- [ ] Verify IP remained the same

### Step 8: Configure Auto-Start
- [ ] Service enabled: `sudo systemctl is-enabled egg-detection.service`
- [ ] Test reboot: `sudo reboot`
- [ ] Wait 1 minute after reboot
- [ ] Check if service started: `sudo systemctl status egg-detection.service`
- [ ] Test API: `curl http://localhost:5000/api/status`

---

## Post-Deployment Verification

### Server Health Check
- [ ] Server responds to `/api/status`
- [ ] Camera is detected (camera_available: true)
- [ ] ML model loaded successfully
- [ ] No errors in logs: `sudo journalctl -u egg-detection.service -n 50`

### Functionality Tests
- [ ] Start detection: Test `/api/start_detection`
- [ ] Get results: Test `/api/get_results`
- [ ] Manual predict: Test `/api/manual_predict`
- [ ] History save: Test `/api/save_history`
- [ ] History retrieve: Test `/api/get_history`

### Performance Tests
- [ ] Detection completes in ~5 seconds
- [ ] Server remains stable during detection
- [ ] Multiple consecutive detections work
- [ ] No memory leaks (check with `free -h`)

### Network Access Tests
- [ ] Access from laptop browser
- [ ] Access from mobile phone browser
- [ ] Access from Flutter app
- [ ] Consistent response times

---

## Flutter App Configuration

### Update API Endpoint
- [ ] Open Flutter app configuration
- [ ] Update base URL to: `http://YOUR_RPI_IP:5000`
- [ ] Test connection from Flutter app
- [ ] Test all API calls
- [ ] Test error handling

### Test Scenarios
- [ ] Start detection from app
- [ ] View real-time results
- [ ] Manual measurement input
- [ ] View detection history
- [ ] Check statistics

---

## Troubleshooting Checklist

If something doesn't work, check:

### Service Issues
- [ ] Service status: `sudo systemctl status egg-detection.service`
- [ ] View logs: `sudo journalctl -u egg-detection.service -f`
- [ ] Restart service: `sudo systemctl restart egg-detection.service`
- [ ] Try manual run: `python3 server.py`

### Camera Issues
- [ ] Camera connected and recognized: `ls -l /dev/video*`
- [ ] Camera enabled in config: `sudo raspi-config`
- [ ] Correct camera index in detection.py
- [ ] User in video group: `groups | grep video`

### Network Issues
- [ ] Raspberry Pi IP address: `hostname -I`
- [ ] Server listening on port 5000: `sudo netstat -tulpn | grep 5000`
- [ ] Firewall not blocking: `sudo ufw status`
- [ ] Devices on same network

### Python Issues
- [ ] Virtual environment activated
- [ ] All dependencies installed: `pip list`
- [ ] OpenCV installed: `python3 -c "import cv2; print(cv2.__version__)"`
- [ ] Flask installed: `python3 -c "import flask; print(flask.__version__)"`

---

## Maintenance Tasks

### Daily
- [ ] Check service status
- [ ] Monitor system resources: `htop`

### Weekly
- [ ] Review detection logs
- [ ] Backup detection_history.json
- [ ] Check disk space: `df -h`

### Monthly
- [ ] Update system: `sudo apt update && sudo apt upgrade`
- [ ] Review and clean old logs
- [ ] Test full detection workflow

---

## Security Checklist

- [ ] Default password changed
- [ ] SSH key-based authentication configured
- [ ] Unnecessary services disabled
- [ ] Firewall configured if needed
- [ ] Regular system updates scheduled
- [ ] API authentication considered (if needed)

---

## Documentation & Notes

### Important Information to Record:

**Raspberry Pi Details:**
- Hostname: _________________
- IP Address: _________________
- Username: _________________
- Camera Type: _________________
- Camera Index: _________________

**Network Details:**
- WiFi SSID: _________________
- Router IP: _________________
- Static IP: Yes / No
- Port: 5000

**Service Details:**
- Service Name: egg-detection.service
- Service Status: Active / Inactive
- Auto-start: Enabled / Disabled
- Log Location: /var/log/syslog or journalctl

**Project Details:**
- Project Path: /home/pi/egg_detection_server
- Python Version: _________________
- Virtual Environment: Yes / No
- Last Updated: _________________

---

## Emergency Procedures

### If Server Stops Working:
```bash
# Check service
sudo systemctl status egg-detection.service

# Restart service
sudo systemctl restart egg-detection.service

# View recent errors
sudo journalctl -u egg-detection.service -n 50
```

### If Camera Stops Working:
```bash
# Check camera
ls -l /dev/video*

# Re-run camera finder
python3 find_camera.py

# Restart Raspberry Pi
sudo reboot
```

### If Network Issues:
```bash
# Check IP
hostname -I

# Test server locally
curl http://localhost:5000/api/status

# Restart network
sudo systemctl restart networking
```

---

## Final Verification

Before considering deployment complete:

- [ ] Server auto-starts on boot
- [ ] Camera works reliably
- [ ] API accessible from network
- [ ] Flutter app connects successfully
- [ ] Detection workflow completes end-to-end
- [ ] History saves correctly
- [ ] System stable for 24 hours
- [ ] All tests passing
- [ ] Documentation complete
- [ ] Backup plan in place

---

## Sign-Off

**Deployment Date:** _________________

**Deployed By:** _________________

**Tested By:** _________________

**Status:** ✓ Complete / ⚠ Pending / ✗ Failed

**Notes:**
_________________________________________________________________
_________________________________________________________________
_________________________________________________________________

---

## Quick Reference Commands

```bash
# Service Management
sudo systemctl status egg-detection.service
sudo systemctl restart egg-detection.service
sudo systemctl stop egg-detection.service
sudo systemctl start egg-detection.service

# Logs
sudo journalctl -u egg-detection.service -f
sudo journalctl -u egg-detection.service -n 50

# Network
hostname -I
curl http://localhost:5000/api/status

# Camera
python3 find_camera.py
ls -l /dev/video*

# System
htop              # System resources
df -h             # Disk space
free -h           # Memory usage
sudo reboot       # Restart
sudo shutdown -h now  # Power off
```

---

**Good luck with your deployment!** 🥚🚀
