"""
Model Diagnostic Script
Checks if model files exist and can be loaded
"""

import os
import sys

print("=" * 60)
print("MODEL DIAGNOSTIC - Checking ML Model Files")
print("=" * 60)

# Check current directory
print(f"\nCurrent directory: {os.getcwd()}")

# Check if models folder exists
models_dir = 'models'
print(f"\nChecking for '{models_dir}' folder...")

if os.path.exists(models_dir):
    print(f"✅ '{models_dir}' folder exists")
    
    # List all files in models folder
    print(f"\nFiles in '{models_dir}' folder:")
    try:
        files = os.listdir(models_dir)
        if len(files) == 0:
            print("   ⚠️ Folder is EMPTY!")
        else:
            for file in files:
                file_path = os.path.join(models_dir, file)
                file_size = os.path.getsize(file_path)
                print(f"   - {file} ({file_size:,} bytes)")
    except Exception as e:
        print(f"   ❌ Error reading folder: {e}")
else:
    print(f"❌ '{models_dir}' folder NOT FOUND!")
    print(f"\nPlease create a folder named '{models_dir}' in:")
    print(f"   {os.getcwd()}")
    sys.exit(1)

# Check for required model files
required_files = [
    'egg_gender_model.pkl',
    'scaler.pkl',
    'label_encoder.pkl'
]

print("\n" + "-" * 60)
print("Checking required model files:")
print("-" * 60)

all_found = True
for filename in required_files:
    filepath = os.path.join(models_dir, filename)
    if os.path.exists(filepath):
        size = os.path.getsize(filepath)
        print(f"✅ {filename} - {size:,} bytes")
    else:
        print(f"❌ {filename} - NOT FOUND")
        all_found = False

if not all_found:
    print("\n" + "=" * 60)
    print("⚠️ MISSING MODEL FILES!")
    print("=" * 60)
    print("\nPlease download these files from Google Drive:")
    print("  Location: Egg Gender Prediction Model/")
    print("\nRequired files:")
    for filename in required_files:
        print(f"  - {filename}")
    print(f"\nPut them in: {os.path.join(os.getcwd(), models_dir)}")
    sys.exit(1)

# Try to load the models
print("\n" + "=" * 60)
print("Attempting to load models...")
print("=" * 60)

try:
    import joblib
    print("\n1. Loading egg_gender_model.pkl...")
    model = joblib.load(os.path.join(models_dir, 'egg_gender_model.pkl'))
    print(f"   ✅ Model loaded: {type(model).__name__}")
    
    print("\n2. Loading scaler.pkl...")
    scaler = joblib.load(os.path.join(models_dir, 'scaler.pkl'))
    print(f"   ✅ Scaler loaded: {type(scaler).__name__}")
    
    print("\n3. Loading label_encoder.pkl...")
    label_encoder = joblib.load(os.path.join(models_dir, 'label_encoder.pkl'))
    print(f"   ✅ Label encoder loaded: {type(label_encoder).__name__}")
    print(f"   Classes: {list(label_encoder.classes_)}")
    
    print("\n" + "=" * 60)
    print("✅ ALL MODELS LOADED SUCCESSFULLY!")
    print("=" * 60)
    
    # Test a prediction
    print("\n🧪 Testing prediction...")
    import pandas as pd
    import numpy as np
    
    # Test data
    test_width = 38.5
    test_height = 56.2
    test_esi = (test_width / test_height) * 100
    
    # Create features
    features = {
        'Width': test_width,
        'Heigth': test_height,
        'Shape Index(%)': test_esi,
        'Aspect_Ratio': test_width / test_height,
        'Perimeter_Approx': 2 * (test_width + test_height),
        'Area_Approx': test_width * test_height,
        'Width_Height_Diff': test_width - test_height
    }
    
    features_df = pd.DataFrame([features])
    features_scaled = scaler.transform(features_df)
    prediction = model.predict(features_scaled)
    gender = label_encoder.inverse_transform(prediction)[0]
    
    if hasattr(model, 'predict_proba'):
        probabilities = model.predict_proba(features_scaled)
        confidence = float(np.max(probabilities) * 100)
    else:
        confidence = 100.0
    
    print(f"\nTest Input:")
    print(f"  Width: {test_width} cm")
    print(f"  Height: {test_height} cm")
    print(f"  ESI: {test_esi:.2f}")
    print(f"\nPrediction:")
    print(f"  Gender: {gender}")
    print(f"  Confidence: {confidence:.2f}%")
    
    print("\n" + "=" * 60)
    print("✅ EVERYTHING WORKING PERFECTLY!")
    print("=" * 60)
    print("\nYour models are ready to use!")
    print("You can now run: python server.py")
    
except ImportError as e:
    print(f"\n❌ Import Error: {e}")
    print("\nMissing Python package. Install it with:")
    print("   pip install joblib pandas numpy scikit-learn")
    
except Exception as e:
    print(f"\n❌ Error loading models: {e}")
    print(f"\nError type: {type(e).__name__}")
    import traceback
    print("\nFull error details:")
    traceback.print_exc()
    print("\n" + "=" * 60)
    print("TROUBLESHOOTING:")
    print("=" * 60)
    print("1. Make sure .pkl files are not corrupted")
    print("2. Download fresh copies from Google Drive")
    print("3. Check file permissions")
    print("4. Try running: pip install --upgrade scikit-learn joblib")
