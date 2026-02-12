"""
ML Model Predictor
Loads and uses the trained Random Forest model for egg gender prediction
"""

import joblib
import numpy as np
import pandas as pd
import os


class MLPredictor:
    def __init__(self, model_dir='models'):
        self.model_dir = model_dir
        self.model = None
        self.scaler = None
        self.label_encoder = None
        self.is_model_loaded = False
        
        self.load_models()
    
    
    def load_models(self):
        try:
            model_path = os.path.join(self.model_dir, 'egg_gender_model.pkl')
            scaler_path = os.path.join(self.model_dir, 'scaler.pkl')
            encoder_path = os.path.join(self.model_dir, 'label_encoder.pkl')
            
            if not os.path.exists(model_path):
                print(f"❌ Model file not found: {model_path}")
                return False
            
            if not os.path.exists(scaler_path):
                print(f"❌ Scaler file not found: {scaler_path}")
                return False
            
            if not os.path.exists(encoder_path):
                print(f"❌ Encoder file not found: {encoder_path}")
                return False
            
            self.model = joblib.load(model_path)
            self.scaler = joblib.load(scaler_path)
            self.label_encoder = joblib.load(encoder_path)
            
            self.is_model_loaded = True
            
            print("✅ ML Models loaded successfully!")
            print(f"   Model type: {type(self.model).__name__}")
            print(f"   Classes: {list(self.label_encoder.classes_)}")
            
            return True
            
        except Exception as e:
            print(f"❌ Error loading models: {str(e)}")
            self.is_model_loaded = False
            return False
    
    
    def is_loaded(self):
        return self.is_model_loaded
    
    
    def calculate_features(self, width, height, esi):
        aspect_ratio = width / height
        perimeter_approx = 2 * (width + height)
        area_approx = width * height
        width_height_diff = width - height
        width_height_sum = width + height
        
        features = {
            'Width': width,
            'Heigth': height,
            'Shape Index(%)': esi,
            'Aspect_Ratio': aspect_ratio,
            'Perimeter_Approx': perimeter_approx,
            'Area_Approx': area_approx,
            'Width_Height_Diff': width_height_diff
        }
        
        df = pd.DataFrame([features])
        
        return df
    
    
    def predict(self, width, height, esi):
        if not self.is_model_loaded:
            return {
                "success": False,
                "error": "ML model not loaded",
                "gender": "Unknown",
                "confidence": 0
            }
        
        try:
            features_df = self.calculate_features(width, height, esi)
            features_scaled = self.scaler.transform(features_df)
            prediction = self.model.predict(features_scaled)
            
            if hasattr(self.model, 'predict_proba'):
                probabilities = self.model.predict_proba(features_scaled)
                confidence = float(np.max(probabilities) * 100)
            else:
                confidence = 100.0
            
            gender = self.label_encoder.inverse_transform(prediction)[0]
            
            return {
                "success": True,
                "gender": gender,
                "confidence": round(confidence, 2),
                "width": round(width, 2),
                "height": round(height, 2),
                "esi": round(esi, 2)
            }
            
        except Exception as e:
            print(f"Prediction error: {str(e)}")
            return {
                "success": False,
                "error": str(e),
                "gender": "Unknown",
                "confidence": 0
            }
