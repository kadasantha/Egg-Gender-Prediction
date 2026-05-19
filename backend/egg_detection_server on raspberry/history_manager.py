"""
History Manager
Stores detection history in JSON file (no Firebase needed)
"""

import json
import os
from datetime import datetime


class HistoryManager:
    def __init__(self, filename='detection_history.json'):
        """Initialize history manager with JSON file"""
        self.filename = filename
        self.ensure_file_exists()
    
    def ensure_file_exists(self):
        """Create history file if it doesn't exist"""
        if not os.path.exists(self.filename):
            with open(self.filename, 'w') as f:
                json.dump([], f)
    
    def add_detection(self, user_email, detection_data):
        """
        Add new detection to history
        
        Args:
            user_email: User's email
            detection_data: Dict with detection results
        """
        try:
            # Read existing history
            history = self.get_all_history()
            
            # Create new entry
            entry = {
                'id': len(history) + 1,
                'user_email': user_email,
                'timestamp': datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                'camera_width': detection_data.get('camera_width', 0),
                'camera_height': detection_data.get('camera_height', 0),
                'camera_esi': detection_data.get('camera_esi', 0),
                'camera_gender': detection_data.get('camera_gender', ''),
                'ml_width': detection_data.get('ml_width', 0),
                'ml_height': detection_data.get('ml_height', 0),
                'ml_esi': detection_data.get('ml_esi', 0),
                'ml_gender': detection_data.get('ml_gender', ''),
                'ml_confidence': detection_data.get('ml_confidence', 0),
                'detection_type': detection_data.get('detection_type', 'camera')  # camera or manual
            }
            
            # Add to history
            history.append(entry)
            
            # Save to file
            with open(self.filename, 'w') as f:
                json.dump(history, f, indent=2)
            
            return {
                'success': True,
                'message': 'Detection saved to history',
                'entry_id': entry['id']
            }
            
        except Exception as e:
            return {
                'success': False,
                'error': str(e)
            }
    
    def get_all_history(self):
        """Get all detection history"""
        try:
            with open(self.filename, 'r') as f:
                history = json.load(f)
            return history
        except:
            return []
    
    def get_user_history(self, user_email):
        """Get history for specific user"""
        all_history = self.get_all_history()
        return [h for h in all_history if h.get('user_email') == user_email]
    
    def get_recent_history(self, limit=50):
        """Get recent history (last N entries)"""
        history = self.get_all_history()
        return history[-limit:] if len(history) > limit else history
    
    def delete_entry(self, entry_id):
        """Delete a history entry"""
        try:
            history = self.get_all_history()
            history = [h for h in history if h.get('id') != entry_id]
            
            with open(self.filename, 'w') as f:
                json.dump(history, f, indent=2)
            
            return {'success': True}
        except Exception as e:
            return {'success': False, 'error': str(e)}
    
    def clear_history(self):
        """Clear all history"""
        try:
            with open(self.filename, 'w') as f:
                json.dump([], f)
            return {'success': True}
        except Exception as e:
            return {'success': False, 'error': str(e)}
    
    def get_statistics(self):
        """Get statistics from history"""
        history = self.get_all_history()
        
        if not history:
            return {
                'total_detections': 0,
                'male_count': 0,
                'female_count': 0,
                'unhatched_count': 0
            }
        
        stats = {
            'total_detections': len(history),
            'male_count': sum(1 for h in history if h.get('ml_gender') == 'Male'),
            'female_count': sum(1 for h in history if h.get('ml_gender') == 'Female'),
            'unhatched_count': sum(1 for h in history if h.get('ml_gender') == 'Unhatched'),
            'camera_detections': sum(1 for h in history if h.get('detection_type') == 'camera'),
            'manual_detections': sum(1 for h in history if h.get('detection_type') == 'manual')
        }
        
        return stats


# Test the history manager
if __name__ == "__main__":
    manager = HistoryManager()
    
    # Test adding detection
    test_data = {
        'camera_width': 38.5,
        'camera_height': 56.2,
        'camera_esi': 68.51,
        'camera_gender': 'Male',
        'ml_width': 38.5,
        'ml_height': 56.2,
        'ml_esi': 68.51,
        'ml_gender': 'Male',
        'ml_confidence': 100.0,
        'detection_type': 'camera'
    }
    
    result = manager.add_detection('test@example.com', test_data)
    print("Add result:", result)
    
    # Get statistics
    stats = manager.get_statistics()
    print("\nStatistics:", stats)
    
    # Get all history
    history = manager.get_all_history()
    print(f"\nTotal entries: {len(history)}")