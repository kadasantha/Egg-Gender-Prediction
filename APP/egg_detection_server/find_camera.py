#!/usr/bin/env python3
"""
Camera Detection Utility
Helps find the correct camera index for Raspberry Pi
"""

import cv2
import sys

def test_camera(index):
    """Test if camera at given index works"""
    try:
        cap = cv2.VideoCapture(index)
        if cap.isOpened():
            ret, frame = cap.read()
            cap.release()
            if ret:
                return True, "Working"
            else:
                return False, "Opened but cannot read"
        return False, "Cannot open"
    except Exception as e:
        return False, str(e)

def main():
    print("=" * 60)
    print("Camera Detection Utility for Raspberry Pi")
    print("=" * 60)
    print()

    # Check for video devices
    import subprocess
    try:
        result = subprocess.run(['v4l2-ctl', '--list-devices'],
                              capture_output=True, text=True)
        print("Available Video Devices:")
        print(result.stdout)
        print("-" * 60)
    except FileNotFoundError:
        print("Note: v4l2-ctl not found. Install with: sudo apt install v4l-utils")
        print("-" * 60)

    print("\nTesting camera indices...\n")

    found_cameras = []

    # Test indices 0-4
    for i in range(5):
        print(f"Testing index {i}...", end=" ")
        sys.stdout.flush()

        success, message = test_camera(i)

        if success:
            print(f"✓ {message}")
            found_cameras.append(i)
        else:
            print(f"✗ {message}")

    print()
    print("=" * 60)

    if found_cameras:
        print(f"Found {len(found_cameras)} working camera(s): {found_cameras}")
        print()
        print("Recommendation:")
        print(f"  Update detection.py camera_index to: {found_cameras[0]}")
        print()
        print("To update, edit detection.py line 13:")
        print(f"  camera_index={found_cameras[0]}")
    else:
        print("No working cameras found!")
        print()
        print("Troubleshooting:")
        print("1. Check if camera is connected")
        print("2. For RPi Camera Module:")
        print("   - Run: sudo raspi-config")
        print("   - Enable: Interface Options -> Camera")
        print("   - Reboot: sudo reboot")
        print("3. For USB Camera:")
        print("   - Check connection")
        print("   - Try different USB port")
        print("4. Check permissions:")
        print("   - Run: ls -l /dev/video*")
        print("   - Add user to video group: sudo usermod -a -G video $USER")

    print("=" * 60)

if __name__ == "__main__":
    main()
