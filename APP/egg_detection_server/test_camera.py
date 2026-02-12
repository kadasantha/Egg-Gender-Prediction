"""
Simple Camera Test Script
Tests different camera indices to find your webcam
"""

import cv2

print("=" * 60)
print("CAMERA TEST - Finding Available Cameras")
print("=" * 60)

# Test camera indices 0, 1, 2
for i in range(3):
    print(f"\nTesting Camera Index {i}...")
    cap = cv2.VideoCapture(i)
    
    if cap.isOpened():
        # Try to read a frame
        ret, frame = cap.read()
        if ret:
            print(f"✅ Camera {i} is AVAILABLE and WORKING!")
            print(f"   Resolution: {frame.shape[1]} x {frame.shape[0]}")
        else:
            print(f"⚠️ Camera {i} opened but can't read frames")
        cap.release()
    else:
        print(f"❌ Camera {i} not available")

print("\n" + "=" * 60)
print("Test Complete!")
print("=" * 60)
print("\nIf you found a working camera:")
print("1. Note the camera index number (0, 1, or 2)")
print("2. Open detection.py in Notepad")
print("3. Find line: camera_index=1")
print("4. Change the number to your working camera index")
print("5. Save the file")
print("=" * 60)
