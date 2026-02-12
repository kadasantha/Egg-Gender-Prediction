"""
Egg Detection System using OpenCV
Modified from your original main.py
"""

import cv2
import numpy as np
from collections import deque
import time


class EggDetectionSystem:
    def __init__(self, camera_index=1, pixels_to_cm_ratio=0.016):
        self.camera_index = camera_index
        self.PIXELS_TO_CM_RATIO = pixels_to_cm_ratio
        self.MIN_CONTOUR_AREA = 500
        self.FPS = 30
        self.MOVING_AVG_WINDOW = self.FPS * 5
        
        self.cap = None
        self.is_running = False
        
        self.width_measurements = deque(maxlen=self.MOVING_AVG_WINDOW)
        self.height_measurements = deque(maxlen=self.MOVING_AVG_WINDOW)
        self.esi_values = deque(maxlen=self.MOVING_AVG_WINDOW)
    
    
    def is_camera_available(self):
        try:
            cap = cv2.VideoCapture(self.camera_index)
            if cap.isOpened():
                cap.release()
                return True
            return False
        except:
            return False
    
    
    def initialize_camera(self):
        self.cap = cv2.VideoCapture(self.camera_index)
        if not self.cap.isOpened():
            raise Exception("Unable to open camera")
        return True
    
    
    def release_camera(self):
        if self.cap is not None:
            self.cap.release()
            self.cap = None
    
    
    def get_egg_classification(self, esi):
        if esi < 72:
            return 1, "Male"
        elif 72 <= esi <= 78:
            return 2, "Female"
        else:
            return 3, "Unhatched"
    
    
    def detect_background_color(self, frame):
        height, width, _ = frame.shape
        corners = [
            frame[0, 0],
            frame[0, width - 1],
            frame[height - 1, 0],
            frame[height - 1, width - 1]
        ]
        background_color = np.mean(corners, axis=0)
        return background_color
    
    
    def process_frame(self, frame):
        background_color = self.detect_background_color(frame)
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        blurred = cv2.GaussianBlur(gray, (7, 7), 0)
        
        if np.mean(background_color) > 127:
            _, thresh = cv2.threshold(blurred, 0, 255, cv2.THRESH_BINARY_INV + cv2.THRESH_OTSU)
        else:
            _, thresh = cv2.threshold(blurred, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)
        
        kernel = np.ones((5, 5), np.uint8)
        thresh = cv2.morphologyEx(thresh, cv2.MORPH_CLOSE, kernel, iterations=2)
        thresh = cv2.morphologyEx(thresh, cv2.MORPH_OPEN, kernel, iterations=1)
        
        contours, _ = cv2.findContours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
        
        if contours:
            contours = [cnt for cnt in contours if cv2.contourArea(cnt) > self.MIN_CONTOUR_AREA]
            
            if contours:
                largest_contour = max(contours, key=cv2.contourArea)
                rect = cv2.minAreaRect(largest_contour)
                (cx, cy), (w, h), angle = rect
                
                width_cm = round(w * self.PIXELS_TO_CM_RATIO, 2)
                height_cm = round(h * self.PIXELS_TO_CM_RATIO, 2)
                
                if height_cm > 0:
                    esi = round((width_cm / height_cm) * 100, 2)
                else:
                    esi = 0
                
                return {
                    "width": width_cm,
                    "height": height_cm,
                    "esi": esi,
                    "detected": True
                }
        
        return None
    
    
    def detect_for_duration(self, duration_seconds=5):
        try:
            self.initialize_camera()
            self.is_running = True
            
            self.width_measurements.clear()
            self.height_measurements.clear()
            self.esi_values.clear()
            
            start_time = time.time()
            frames_processed = 0
            
            print(f"Starting detection for {duration_seconds} seconds...")
            
            while time.time() - start_time < duration_seconds and self.is_running:
                ret, frame = self.cap.read()
                
                if not ret:
                    continue
                
                result = self.process_frame(frame)
                
                if result and result["detected"]:
                    self.width_measurements.append(result["width"])
                    self.height_measurements.append(result["height"])
                    self.esi_values.append(result["esi"])
                    frames_processed += 1
                
                time.sleep(0.033)
            
            self.release_camera()
            
            if len(self.esi_values) > 0:
                avg_width = round(np.mean(self.width_measurements), 2)
                avg_height = round(np.mean(self.height_measurements), 2)
                avg_esi = round(np.mean(self.esi_values), 2)
                
                mark, label = self.get_egg_classification(avg_esi)
                
                print(f"Detection complete! Processed {frames_processed} frames")
                print(f"Results: Width={avg_width}cm, Height={avg_height}cm, ESI={avg_esi}, Gender={label}")
                
                return {
                    "success": True,
                    "width": avg_width,
                    "height": avg_height,
                    "esi": avg_esi,
                    "gender": label,
                    "mark": mark,
                    "frames_processed": frames_processed
                }
            else:
                return {
                    "success": False,
                    "error": "No egg detected in the specified duration"
                }
                
        except Exception as e:
            self.release_camera()
            print(f"Detection error: {str(e)}")
            return {
                "success": False,
                "error": str(e)
            }
    
    
    def stop_detection(self):
        self.is_running = False
        self.release_camera()
    
    
    def __del__(self):
        self.release_camera()
