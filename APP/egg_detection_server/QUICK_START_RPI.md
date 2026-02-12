# Quick Start Guide - Raspberry Pi Setup

## The Fastest Way to Get Running

### Step 1: Transfer Files to Raspberry Pi

**Using USB Drive (Easiest):**
1. Copy entire `egg_detection_server` folder to USB drive
2. Insert USB into Raspberry Pi
3. Open Raspberry Pi terminal and run:
```bash
cd ~
cp -r /media/pi/*/egg_detection_server ~/
cd ~/egg_detection_server
```

**Or Using Network Share:**
- Use WinSCP, FileZilla, or `scp` command to transfer files

---

### Step 2: Run Auto-Install Script

On Raspberry Pi terminal:
```bash
cd ~/egg_detection_server
chmod +x install_rpi.sh
./install_rpi.sh
```

This will automatically:
- Install all dependencies
- Set up virtual environment
- Create auto-start service
- Start the server

Wait 5-10 minutes for installation to complete.

---

### Step 3: Test the Setup

```bash
chmod +x test_rpi_setup.sh
./test_rpi_setup.sh
```

This shows you if everything is working correctly.

---

### Step 4: Find Your Raspberry Pi IP Address

```bash
hostname -I
```

Note down the IP address (e.g., 192.168.1.100)

---

### Step 5: Test from Another Device

Open browser on your laptop or phone (on same WiFi) and visit:
```
http://YOUR_RPI_IP:5000/api/status
```

Example:
```
http://192.168.1.100:5000/api/status
```

You should see:
```json
{
  "status": "online",
  "message": "Egg Detection Server is running",
  "camera_available": true
}
```

---

### Step 6: Update Your Flutter App

In your Flutter app, update the API base URL to:
```dart
final String apiBaseUrl = 'http://YOUR_RPI_IP:5000';
```

---

## That's It!

Your server will now:
- Start automatically when Raspberry Pi powers on
- Run in the background (no display needed)
- Be accessible from any device on the same network

---

## Common Commands

### Check if server is running:
```bash
sudo systemctl status egg-detection.service
```

### View live logs:
```bash
sudo journalctl -u egg-detection.service -f
```

### Restart server:
```bash
sudo systemctl restart egg-detection.service
```

### Stop server:
```bash
sudo systemctl stop egg-detection.service
```

---

## Troubleshooting

### Server not starting?
```bash
# Check logs for errors
sudo journalctl -u egg-detection.service -n 50

# Try manual run to see error
cd ~/egg_detection_server
source venv/bin/activate
python3 server.py
```

### Camera not working?
```bash
# List available cameras
v4l2-ctl --list-devices

# Enable camera in config
sudo raspi-config
# Go to: Interface Options -> Camera -> Enable
# Reboot: sudo reboot
```

### Can't access from other device?
```bash
# Check if server is listening
sudo netstat -tulpn | grep 5000

# Check firewall (if enabled)
sudo ufw allow 5000/tcp
```

---

## Access Raspberry Pi Without Display

### Method 1: SSH (Terminal Access)
From your laptop:
```bash
ssh pi@YOUR_RPI_IP
```
Default password: `raspberry` (change it!)

### Method 2: VNC (Screen Sharing)
1. Enable VNC on Pi: `sudo raspi-config` -> Interface Options -> VNC
2. Download VNC Viewer on your laptop: https://www.realvnc.com/download/viewer/
3. Connect to: `YOUR_RPI_IP`

---

## Make Life Easier - Set Static IP

To always use the same IP address:

```bash
sudo nano /etc/dhcpcd.conf
```

Add at the end:
```
interface wlan0
static ip_address=192.168.1.100/24
static routers=192.168.1.1
static domain_name_servers=192.168.1.1 8.8.8.8
```

Save (Ctrl+X, Y, Enter) and reboot:
```bash
sudo reboot
```

Now your Pi will always be at 192.168.1.100

---

## Need Help?

Check the detailed guide: [RASPBERRY_PI_SETUP.md](RASPBERRY_PI_SETUP.md)
