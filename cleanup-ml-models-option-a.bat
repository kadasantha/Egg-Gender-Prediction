@echo off
REM ========================================================================
REM ML-Models Cleanup - OPTION A (Clean Structure)
REM This script implements the recommended clean folder structure
REM ========================================================================

setlocal enabledelayedexpansion
cls

echo.
echo ========================================================================
echo   ML-Models Folder Cleanup - OPTION A (Clean Structure)
echo ========================================================================
echo.

cd /d "C:\Users\lap.lk\Desktop\New folder\Egg-Gender-Prediction-System"

echo [STEP 1/3] Moving FINAL notebooks to final-models (if they exist elsewhere)...
echo.

REM Check if experiments folder still exists with notebooks
if exist "experiments" (
    echo Moving notebooks from experiments folder...
    
    if exist "experiments\FINAL_WithLecturerFeedback.ipynb" (
        move "experiments\FINAL_WithLecturerFeedback.ipynb" "ml-models\model-iterations\final-models\" >nul 2>&1
        echo ✓ Moved FINAL_WithLecturerFeedback.ipynb
    )
    
    if exist "experiments\FINAL_Egg_Model_WithGridSearch.ipynb" (
        move "experiments\FINAL_Egg_Model_WithGridSearch.ipynb" "ml-models\model-iterations\final-models\" >nul 2>&1
        echo ✓ Moved FINAL_Egg_Model_WithGridSearch.ipynb
    )
    
    echo.
)

REM Check if they're in model-iterations but wrong subfolder
if exist "ml-models\model-iterations\experimental\FINAL_*.ipynb" (
    echo Moving FINAL notebooks from experimental to final-models...
    move "ml-models\model-iterations\experimental\FINAL_*.ipynb" "ml-models\model-iterations\final-models\" >nul 2>&1
    echo ✓ Moved FINAL notebooks
)

if exist "ml-models\model-iterations\comparisons\FINAL_*.ipynb" (
    move "ml-models\model-iterations\comparisons\FINAL_*.ipynb" "ml-models\model-iterations\final-models\" >nul 2>&1
    echo ✓ Moved FINAL notebooks from comparisons
)

echo.
echo [STEP 2/3] Deleting empty/unwanted folders...
echo.

REM Delete experimental folder
if exist "ml-models\model-iterations\experimental" (
    rmdir /s /q "ml-models\model-iterations\experimental" >nul 2>&1
    echo ✓ Deleted ml-models\model-iterations\experimental\
)

REM Delete comparisons folder
if exist "ml-models\model-iterations\comparisons" (
    rmdir /s /q "ml-models\model-iterations\comparisons" >nul 2>&1
    echo ✓ Deleted ml-models\model-iterations\comparisons\
)

REM Delete old experiments folder if exists
if exist "experiments" (
    rmdir /s /q "experiments" >nul 2>&1
    echo ✓ Deleted experiments\ folder
)

echo.
echo [STEP 3/3] Verifying final structure...
echo.

echo.
echo ========================================================================
echo   ✓ CLEANUP COMPLETE - OPTION A IMPLEMENTED!
echo ========================================================================
echo.
echo Final Clean Structure:
echo.
echo ml-models/
echo ├─ README.md
echo ├─ training-notebooks/              ✓ Your training work
echo ├─ datasets/                        ✓ Your data
echo │  ├─ train/                        (training data)
echo │  ├─ test/                         (placeholder for test data)
echo │  └─ raw/                          (raw/backup data)
echo ├─ model-iterations/
echo │  └─ final-models/                 ✓ Your FINAL notebooks
echo ├─ production-models/               ✓ Your .pkl models
echo └─ documentation/                   ✓ Your ML documentation
echo.
echo ========================================================================
echo   Benefits:
echo   ✅ Clean, professional structure
echo   ✅ No empty placeholder folders
echo   ✅ Ready for GitHub
echo   ✅ Easier to navigate
echo.
echo   Next Steps:
echo   1. Commit changes: git add . && git commit -m "refactor: clean ml-models structure"
echo   2. Push to GitHub: git push
echo   3. Your project is now ready for production!
echo ========================================================================
echo.

pause
