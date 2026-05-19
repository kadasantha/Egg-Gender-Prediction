@echo off
REM Folder Reorganization Script for Egg Gender Prediction System
REM This script reorganizes folders to professional GitHub-ready structure

echo.
echo =========================================================
echo   Egg Gender Prediction System - Folder Reorganization
echo =========================================================
echo.

setlocal enabledelayedexpansion

cd /d "c:\Users\lap.lk\Desktop\New folder\Egg-Gender-Prediction-System"

echo [1/10] Creating new folder structure...
mkdir frontend 2>nul
mkdir backend 2>nul
mkdir ml-models 2>nul
mkdir experiments 2>nul
mkdir assets 2>nul
mkdir docs\reference 2>nul
echo ✓ New folders created

echo.
echo [2/10] Moving frontend files...
if exist "APP\App\egg_detection_app" (
    move "APP\App\egg_detection_app" "frontend\mobile-app" >nul 2>&1
    echo ✓ Moved egg_detection_app to frontend/mobile-app
) else (
    echo ⚠ Warning: APP\App\egg_detection_app not found
)

echo.
echo [3/10] Moving backend files...
if exist "APP\egg_detection_server on raspberry" (
    move "APP\egg_detection_server on raspberry" "backend" >nul 2>&1
    echo ✓ Moved egg_detection_server to backend
) else (
    echo ⚠ Warning: egg_detection_server not found
)

echo.
echo [4/10] Moving ML models and training files...
if exist "Model train" (
    move "Model train" "ml-models" >nul 2>&1
    echo ✓ Moved Model train to ml-models
) else (
    echo ⚠ Warning: Model train not found
)

echo.
echo [5/10] Moving experiment notebooks...
if exist "try to edit rapa project" (
    move "try to edit rapa project" "experiments" >nul 2>&1
    echo ✓ Moved 'try to edit rapa project' to experiments
) else (
    echo ⚠ Warning: Experiments folder not found
)

echo.
echo [6/10] Moving media assets...
if exist "Images and videos" (
    move "Images and videos" "assets" >nul 2>&1
    echo ✓ Moved Images and videos to assets
) else (
    echo ⚠ Warning: Images and videos not found
)

echo.
echo [7/10] Moving personal reference files...
if exist "Wifi details.txt" (
    move "Wifi details.txt" "docs\reference\" >nul 2>&1
    echo ✓ Moved Wifi details.txt
) else (
    echo ⚠ Wifi details.txt not found
)

if exist "details abt folder.txt" (
    move "details abt folder.txt" "docs\reference\" >nul 2>&1
    echo ✓ Moved details abt folder.txt
) else (
    echo ⚠ details abt folder.txt not found
)

echo.
echo [8/10] Cleaning up old APP folder...
if exist "APP\App" (
    rmdir "APP\App" >nul 2>&1
)
if exist "APP\Download" (
    rmdir /s /q "APP\Download" >nul 2>&1
    echo ✓ Removed redundant Download folder
) else (
    echo ⚠ APP\Download not found
)
if exist "Download file" (
    rmdir /s /q "Download file" >nul 2>&1
    echo ✓ Removed Download file folder
) else (
    echo ⚠ Download file not found
)

echo.
echo [9/10] Creating README files for organization...

REM Create frontend README
echo # Frontend - Mobile Application >> frontend\README.md
echo. >> frontend\README.md
echo Flutter-based mobile application for Egg Gender Prediction System. >> frontend\README.md
echo. >> frontend\README.md
echo See `mobile-app/` for the Flutter project. >> frontend\README.md

REM Create backend README
echo # Backend - Server Application >> backend\README.md
echo. >> backend\README.md
echo Python Flask server with OpenCV and ML model integration. >> backend\README.md
echo. >> backend\README.md
echo For detailed documentation, see the main README.md in project root. >> backend\README.md

REM Create ml-models README
echo # ML Models and Training >> ml-models\README.md
echo. >> ml-models\README.md
echo Training notebooks, datasets, and model development files. >> ml-models\README.md
echo. >> ml-models\README.md
echo Subdirectories: >> ml-models\README.md
echo - training-notebooks/: Jupyter notebooks used for model development >> ml-models\README.md
echo - datasets/: Training and test datasets >> ml-models\README.md
echo - research/: Research papers and documentation >> ml-models\README.md

REM Create experiments README
echo # Experiments and Model Iterations >> experiments\README.md
echo. >> experiments\README.md
echo Alternative model implementations and experimental approaches. >> experiments\README.md
echo. >> experiments\README.md
echo Use this folder for testing new ideas and model variations. >> experiments\README.md

REM Create assets README
echo # Assets - Images, Videos, and Media >> assets\README.md
echo. >> assets\README.md
echo Project media files including screenshots, diagrams, and demonstration videos. >> assets\README.md
echo. >> assets\README.md
echo Subdirectories: >> assets\README.md
echo - screenshots/: Application UI screenshots >> assets\README.md
echo - diagrams/: Architecture and system diagrams >> assets\README.md
echo - videos/: Demonstration and tutorial videos >> assets\README.md

echo ✓ Created README files for new folders

echo.
echo [10/10] Displaying new structure...
echo.
tree /f /a 2>nul || (
    echo Directory structure:
    cd
)

echo.
echo =========================================================
echo   ✓ REORGANIZATION COMPLETE!
echo =========================================================
echo.
echo New Structure:
echo   frontend/          - Flutter mobile app
echo   backend/           - Python Flask server
echo   ml-models/         - Training notebooks and datasets
echo   experiments/       - Experimental implementations
echo   assets/            - Media files (screenshots, videos)
echo   docs/              - Documentation files
echo.
echo Next Steps:
echo   1. Review the new structure
echo   2. Update any internal file references in code
echo   3. Test the application
echo   4. Commit changes: git add . && git commit -m "refactor: reorganize folder structure"
echo   5. Push to GitHub
echo.
echo =========================================================

pause
