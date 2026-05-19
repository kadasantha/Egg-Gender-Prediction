@echo off
REM ========================================================================
REM ML-Models Folder Organization Script
REM This script properly organizes all ML-related files into a clean structure
REM ========================================================================

setlocal enabledelayedexpansion
cls

echo.
echo ========================================================================
echo   ML-Models Folder Organization Script
echo ========================================================================
echo.

REM Navigate to project root
cd /d "C:\Users\lap.lk\Desktop\New folder\Egg-Gender-Prediction-System"

echo [STEP 1/5] Creating folder structure...
echo.

REM Create main ml-models directory
mkdir ml-models 2>nul

REM Create subdirectories
mkdir ml-models\training-notebooks 2>nul
mkdir ml-models\training-notebooks\Colab 2>nul
mkdir ml-models\datasets 2>nul
mkdir ml-models\datasets\train 2>nul
mkdir ml-models\datasets\test 2>nul
mkdir ml-models\datasets\raw 2>nul
mkdir ml-models\model-iterations 2>nul
mkdir ml-models\model-iterations\final-models 2>nul
mkdir ml-models\model-iterations\final-models\explanation 2>nul
mkdir ml-models\model-iterations\experimental 2>nul
mkdir ml-models\model-iterations\comparisons 2>nul
mkdir ml-models\production-models 2>nul
mkdir ml-models\documentation 2>nul

echo ✓ Created ml-models directory structure
echo.

echo [STEP 2/5] Moving training files...
echo.

REM Move Model train folder contents
if exist "Model train\Colab Notebooks" (
    move "Model train\Colab Notebooks" "ml-models\training-notebooks\Colab" >nul 2>&1
    echo ✓ Moved Colab Notebooks
)

if exist "Model train\Egg Gender Prediction Model" (
    REM Move datasets
    if exist "Model train\Egg Gender Prediction Model\Dataset" (
        move "Model train\Egg Gender Prediction Model\Dataset" "ml-models\datasets\train" >nul 2>&1
        echo ✓ Moved Dataset to datasets/train
    )
    REM Move explanations
    if exist "Model train\Egg Gender Prediction Model\Explanation_" (
        move "Model train\Egg Gender Prediction Model\Explanation_" "ml-models\documentation" >nul 2>&1
        echo ✓ Moved Explanation files to documentation
    )
)

if exist "Model train\Suppot\Dataset" (
    move "Model train\Suppot\Dataset" "ml-models\datasets\raw" >nul 2>&1
    echo ✓ Moved Support Dataset to datasets/raw
)

if exist "Model train\Suppot\Model" (
    move "Model train\Suppot\Model" "ml-models\production-models" >nul 2>&1
    echo ✓ Moved Model files to production-models
)

echo.
echo [STEP 3/5] Moving model iteration files...
echo.

REM Move model iteration notebooks
if exist "try to edit rapa project" (
    REM Move final models
    if exist "try to edit rapa project\FINAL_WithLecturerFeedback.ipynb" (
        move "try to edit rapa project\FINAL_WithLecturerFeedback.ipynb" "ml-models\model-iterations\final-models" >nul 2>&1
        echo ✓ Moved FINAL_WithLecturerFeedback.ipynb
    )
    
    if exist "try to edit rapa project\FINAL_Egg_Model_WithGridSearch.ipynb" (
        move "try to edit rapa project\FINAL_Egg_Model_WithGridSearch.ipynb" "ml-models\model-iterations\final-models" >nul 2>&1
        echo ✓ Moved FINAL_Egg_Model_WithGridSearch.ipynb
    )
    
    REM Move experimental files
    if exist "try to edit rapa project\CORRECTED_Egg_Gender_Model.ipynb" (
        move "try to edit rapa project\CORRECTED_Egg_Gender_Model.ipynb" "ml-models\model-iterations\experimental" >nul 2>&1
        echo ✓ Moved CORRECTED_Egg_Gender_Model.ipynb
    )
    
    if exist "try to edit rapa project\CORRECTED_Egg_Gender_Model.py" (
        move "try to edit rapa project\CORRECTED_Egg_Gender_Model.py" "ml-models\model-iterations\experimental" >nul 2>&1
        echo ✓ Moved CORRECTED_Egg_Gender_Model.py
    )
    
    REM Move comparison files
    if exist "try to edit rapa project\COMPLETE_4Models_Comparison.ipynb" (
        move "try to edit rapa project\COMPLETE_4Models_Comparison.ipynb" "ml-models\model-iterations\comparisons" >nul 2>&1
        echo ✓ Moved COMPLETE_4Models_Comparison.ipynb
    )
)

echo.
echo [STEP 4/5] Creating README files...
echo.

REM Create main README
(
    echo # Machine Learning Models
    echo.
    echo Complete ML pipeline for Egg Gender Prediction System.
    echo.
    echo ## Directory Structure
    echo.
    echo - **training-notebooks/** - Original training and development notebooks
    echo - **datasets/** - Training, test, and raw datasets
    echo - **model-iterations/** - Model versions and comparative analysis
    echo - **production-models/** - Trained serialized models (.pkl files^)
    echo - **documentation/** - ML documentation and explanations
    echo.
    echo ## Quick Access
    echo.
    echo ### Training Files
    echo See [training-notebooks/](training-notebooks/) for:
    echo - Original training notebooks
    echo - Data exploration notebooks
    echo - Feature engineering code
    echo.
    echo ### Datasets
    echo See [datasets/](datasets/) for:
    echo - Training dataset
    echo - Test dataset
    echo - Raw original data
    echo.
    echo ### Model Iterations
    echo See [model-iterations/](model-iterations/) for:
    echo - Final production models
    echo - Experimental implementations
    echo - Model comparison analysis
    echo.
    echo ### Production Models
    echo See [production-models/](production-models/) for:
    echo - egg_gender_model.pkl - Trained Random Forest Classifier
    echo - scaler.pkl - Feature normalization scaler
    echo - label_encoder.pkl - Label encoder
    echo.
    echo ## Model Specifications
    echo.
    echo - **Algorithm:** Random Forest Classifier
    echo - **Features:** 7 engineered features
    echo - **Train/Test Split:** 80/20
    echo - **Optimization:** GridSearchCV
    echo - **Normalization:** StandardScaler
    echo.
    echo For detailed documentation, see [documentation/](documentation/)
) > ml-models\README.md
echo ✓ Created ml-models/README.md

REM Create training-notebooks README
(
    echo # Training Notebooks
    echo.
    echo Original development and training notebooks for the Egg Gender Prediction model.
    echo.
    echo ## Contents
    echo.
    echo - Main training notebooks used during development
    echo - Data exploration and analysis
    echo - Feature engineering experiments
    echo - Colab/ - Google Colab versions
    echo.
    echo ## Usage
    echo.
    echo 1. Open notebooks in Jupyter Notebook or Google Colab
    echo 2. Review the training process step-by-step
    echo 3. Run cells to reproduce results
    echo 4. Modify and experiment with parameters
    echo.
    echo ## Requirements
    echo.
    echo - Jupyter Notebook or Google Colab
    echo - Python 3.7+
    echo - scikit-learn, pandas, numpy, opencv-python
) > ml-models\training-notebooks\README.md
echo ✓ Created training-notebooks/README.md

REM Create datasets README
(
    echo # Datasets
    echo.
    echo Training and test data for the Egg Gender Prediction model.
    echo.
    echo ## Directory Structure
    echo.
    echo ```
    echo datasets/
    echo ├── train/          - Training dataset
    echo ├── test/           - Test dataset
    echo └── raw/            - Original raw data
    echo ```
    echo.
    echo ## Data Information
    echo.
    echo - **Format:** CSV or pickle files
    echo - **Features:** Width, Height, ESI, and derived features
    echo - **Target:** Egg gender (Male/Female/Unhatched^)
    echo - **Size:** [Add your dataset size]
    echo.
    echo ## Data Dictionary
    echo.
    echo [Document your specific features and values here]
) > ml-models\datasets\README.md
echo ✓ Created datasets/README.md

REM Create model-iterations README
(
    echo # Model Iterations and Comparisons
    echo.
    echo Evolution and comparison of different model approaches for egg gender prediction.
    echo.
    echo ## Directory Structure
    echo.
    echo ```
    echo model-iterations/
    echo ├── final-models/        - Production-ready models
    echo │   ├── FINAL_WithLecturerFeedback.ipynb
    echo │   ├── FINAL_Egg_Model_WithGridSearch.ipynb
    echo │   └── explanation/     - Model documentation
    echo ├── experimental/        - Alternative implementations
    echo │   ├── CORRECTED_Egg_Gender_Model.ipynb
    echo │   ├── CORRECTED_Egg_Gender_Model.py
    echo │   └── [other experiments]
    echo └── comparisons/         - Model comparison analysis
    echo    └── COMPLETE_4Models_Comparison.ipynb
    echo ```
    echo.
    echo ## Final Models
    echo.
    echo These are the production-ready models with best performance:
    echo - FINAL_WithLecturerFeedback.ipynb - Final model with improvements
    echo - FINAL_Egg_Model_WithGridSearch.ipynb - Optimized with GridSearch
    echo.
    echo ## Experimental Models
    echo.
    echo Alternative approaches and experimental implementations preserved for reference.
    echo.
    echo ## Model Comparisons
    echo.
    echo Comparative analysis of different model approaches and their performance metrics.
) > ml-models\model-iterations\README.md
echo ✓ Created model-iterations/README.md

REM Create production-models README
(
    echo # Production Models
    echo.
    echo Serialized trained models ready for deployment in the backend server.
    echo.
    echo ## Model Files
    echo.
    echo - **egg_gender_model.pkl** - Trained Random Forest Classifier
    echo - **scaler.pkl** - StandardScaler for feature normalization
    echo - **label_encoder.pkl** - Label encoder for target variable
    echo - **model_metadata.json** - Model metadata and performance metrics
    echo.
    echo ## Model Specifications
    echo.
    echo - **Algorithm:** Random Forest Classifier
    echo - **Accuracy:** [Add your accuracy]
    echo - **Precision:** [Add your precision]
    echo - **Recall:** [Add your recall]
    echo - **F1-Score:** [Add your F1-score]
    echo.
    echo ## Usage in Backend
    echo.
    echo These models are loaded by `backend/ml_predict.py`:
    echo.
    echo ```python
    echo model = joblib.load('egg_gender_model.pkl'^)
    echo scaler = joblib.load('scaler.pkl'^)
    echo encoder = joblib.load('label_encoder.pkl'^)
    echo ```
    echo.
    echo See backend/README.md for deployment instructions.
) > ml-models\production-models\README.md
echo ✓ Created production-models/README.md

REM Create documentation README
(
    echo # ML Documentation
    echo.
    echo Complete documentation of the ML pipeline, features, and training process.
    echo.
    echo ## Contents
    echo.
    echo - Model explanations and architecture
    echo - Feature engineering methodology
    echo - Training process and hyperparameter tuning
    echo - Performance metrics and results
    echo - Data preprocessing steps
    echo.
    echo ## Documentation Files
    echo.
    echo - Model_Explanation.md - How the model works
    echo - Features_Engineering.md - Feature creation methodology
    echo - Training_Process.md - Training pipeline steps
    echo - Hyperparameter_Tuning.md - GridSearch and optimization
) > ml-models\documentation\README.md
echo ✓ Created documentation/README.md

echo.
echo [STEP 5/5] Cleaning up old folders...
echo.

REM Remove old folders
if exist "Model train" (
    rmdir /s /q "Model train" >nul 2>&1
    echo ✓ Removed old "Model train" folder
)

if exist "try to edit rapa project" (
    rmdir /s /q "try to edit rapa project" >nul 2>&1
    echo ✓ Removed old "try to edit rapa project" folder
)

echo.
echo ========================================================================
echo   ✓ ML-MODELS FOLDER ORGANIZATION COMPLETE!
echo ========================================================================
echo.
echo New Structure:
echo   ml-models/
echo   ├─ training-notebooks/          (Original training work)
echo   ├─ datasets/                    (Training, test, raw data)
echo   ├─ model-iterations/            (Final, experimental, comparisons)
echo   ├─ production-models/           (Trained .pkl models)
echo   └─ documentation/               (ML documentation)
echo.
echo Each subfolder has a README.md with detailed information.
echo.
echo Next Steps:
echo   1. Review the new structure: start with ml-models/README.md
echo   2. Verify all files are in correct locations
echo   3. Update any code references if needed
echo   4. Test the application
echo   5. Commit: git add . && git commit -m "refactor: organize ml-models folder"
echo   6. Push: git push
echo.
echo ========================================================================

pause
