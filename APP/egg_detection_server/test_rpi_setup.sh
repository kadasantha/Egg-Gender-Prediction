#!/bin/bash
# Test script to verify Raspberry Pi setup

echo "======================================"
echo "Egg Detection Server - System Test"
echo "======================================"
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Test 1: Check if service exists
echo -n "Test 1: Service file exists... "
if [ -f /etc/systemd/system/egg-detection.service ]; then
    echo -e "${GREEN}PASS${NC}"
else
    echo -e "${RED}FAIL${NC}"
fi

# Test 2: Check if service is active
echo -n "Test 2: Service is running... "
if systemctl is-active --quiet egg-detection.service; then
    echo -e "${GREEN}PASS${NC}"
else
    echo -e "${RED}FAIL${NC}"
    echo "  Try: sudo systemctl start egg-detection.service"
fi

# Test 3: Check if service is enabled
echo -n "Test 3: Service auto-start enabled... "
if systemctl is-enabled --quiet egg-detection.service; then
    echo -e "${GREEN}PASS${NC}"
else
    echo -e "${YELLOW}WARN${NC}"
    echo "  Try: sudo systemctl enable egg-detection.service"
fi

# Test 4: Check if port 5000 is listening
echo -n "Test 4: Server listening on port 5000... "
if sudo netstat -tulpn | grep -q ":5000"; then
    echo -e "${GREEN}PASS${NC}"
else
    echo -e "${RED}FAIL${NC}"
    echo "  Check logs: sudo journalctl -u egg-detection.service -n 20"
fi

# Test 5: Check camera
echo -n "Test 5: Camera device available... "
if [ -e /dev/video0 ]; then
    echo -e "${GREEN}PASS${NC}"
else
    echo -e "${YELLOW}WARN${NC} (Camera not detected)"
fi

# Test 6: Test API endpoint
echo -n "Test 6: API responding... "
if curl -s http://localhost:5000/api/status > /dev/null 2>&1; then
    echo -e "${GREEN}PASS${NC}"
else
    echo -e "${RED}FAIL${NC}"
fi

# Test 7: Check Python dependencies
echo -n "Test 7: Python dependencies... "
source venv/bin/activate 2>/dev/null
if python3 -c "import flask, flask_cors, numpy, pandas, sklearn, joblib" 2>/dev/null; then
    echo -e "${GREEN}PASS${NC}"
else
    echo -e "${RED}FAIL${NC}"
    echo "  Try: source venv/bin/activate && pip install -r requirements_rpi.txt"
fi

echo ""
echo "======================================"
echo "System Information"
echo "======================================"
echo "IP Address: $(hostname -I | awk '{print $1}')"
echo "Hostname: $(hostname)"
echo "Python Version: $(python3 --version)"
echo ""
echo "Service Status:"
sudo systemctl status egg-detection.service --no-pager | head -n 5
echo ""
echo "Recent Logs (last 10 lines):"
sudo journalctl -u egg-detection.service -n 10 --no-pager
echo ""
echo "Access your server at:"
echo "  http://$(hostname -I | awk '{print $1}'):5000/api/status"
echo ""
