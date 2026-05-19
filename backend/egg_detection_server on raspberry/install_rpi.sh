#!/bin/bash
# Raspberry Pi Installation Script for Egg Detection Server
# Run this script on your Raspberry Pi to set up everything automatically

echo "======================================"
echo "Egg Detection Server - RPi Setup"
echo "======================================"
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running on Raspberry Pi
if [ ! -f /proc/device-tree/model ]; then
    echo -e "${YELLOW}Warning: This doesn't appear to be a Raspberry Pi${NC}"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo -e "${GREEN}Step 1: Updating system packages...${NC}"
sudo apt update
sudo apt upgrade -y

echo ""
echo -e "${GREEN}Step 2: Installing system dependencies...${NC}"
sudo apt install -y python3 python3-pip python3-venv
sudo apt install -y python3-opencv
sudo apt install -y libatlas-base-dev libjasper-dev libqtgui4 libqt4-test
sudo apt install -y libhdf5-dev libhdf5-serial-dev
sudo apt install -y libharfbuzz0b libwebp6 libtiff5 libjasper1
sudo apt install -y libilmbase-dev libopenexr-dev libgstreamer1.0-dev
sudo apt install -y v4l-utils

echo ""
echo -e "${GREEN}Step 3: Creating virtual environment...${NC}"
python3 -m venv venv
source venv/bin/activate

echo ""
echo -e "${GREEN}Step 4: Installing Python dependencies...${NC}"
pip3 install --upgrade pip
pip3 install Flask flask-cors numpy pandas scikit-learn joblib

echo ""
echo -e "${GREEN}Step 5: Testing camera...${NC}"
if [ -e /dev/video0 ]; then
    echo -e "${GREEN}Camera detected at /dev/video0${NC}"
else
    echo -e "${YELLOW}Warning: No camera detected. Make sure camera is connected.${NC}"
fi

echo ""
echo -e "${GREEN}Step 6: Setting up systemd service...${NC}"

# Get the current directory
CURRENT_DIR=$(pwd)
USER=$(whoami)

# Create systemd service file
sudo bash -c "cat > /etc/systemd/system/egg-detection.service << EOF
[Unit]
Description=Egg Detection Flask Server
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$CURRENT_DIR
Environment=\"PATH=$CURRENT_DIR/venv/bin\"
ExecStart=$CURRENT_DIR/venv/bin/python3 $CURRENT_DIR/server.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF"

# Reload systemd, enable and start service
sudo systemctl daemon-reload
sudo systemctl enable egg-detection.service

echo ""
echo -e "${GREEN}Step 7: Starting service...${NC}"
sudo systemctl start egg-detection.service

sleep 3

echo ""
echo -e "${GREEN}Step 8: Checking service status...${NC}"
sudo systemctl status egg-detection.service --no-pager

echo ""
echo "======================================"
echo -e "${GREEN}Installation Complete!${NC}"
echo "======================================"
echo ""
echo "Service Status: $(systemctl is-active egg-detection.service)"
echo "Your Raspberry Pi IP: $(hostname -I | awk '{print $1}')"
echo ""
echo "API Endpoint: http://$(hostname -I | awk '{print $1}'):5000"
echo ""
echo "Useful Commands:"
echo "  sudo systemctl status egg-detection.service  # Check status"
echo "  sudo systemctl restart egg-detection.service # Restart server"
echo "  sudo systemctl stop egg-detection.service    # Stop server"
echo "  sudo journalctl -u egg-detection.service -f  # View logs"
echo ""
echo "Test the server:"
echo "  curl http://localhost:5000/api/status"
echo ""
