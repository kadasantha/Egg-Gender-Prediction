@echo off
REM ========================================================================
REM ML-Models Data Migration Script - FIXES
REM This script properly moves data from old folders to new structure
REM ========================================================================

setlocal enabledelayedexpansion
cls

echo.
echo ========================================================================
echo   ML-Models Data Migration - FIXING ORGANIZATION
echo ========================================================================
echo.

cd /d "C:\Users\lap.lk\Desktop\New folder\Egg-Gender-Prediction-System"

echo [STEP 1/3] Moving data from old "Model train" folder...
echo.

REM Move from ml-models\Model train\Colab Notebooks to training-notebooks\Colab
if exist "ml-models\Model train\Colab Notebooks" (
    echo Moving Colab Notebooks...
    for /d /r "ml-models\Model train\Colab Notebooks" %%D in (*) do (
        move "%%D" "ml-models\training-notebooks\Colab\" >nul 2>&1
    )
    for %%F in ("ml-models\Model train\Colab Notebooks\*.*") do (
        move "%%F" "ml-models\training-notebooks\Colab\" >nul 2>&1
    )
    echo ✓ Moved Colab files
)

REM Move Egg Gender Prediction Model files
if exist "ml-models\Model train\Egg Gender Prediction Model\Dataset" (
    echo Moving Dataset to train folder...
    for /d /r "ml-models\Model train\Egg Gender Prediction Model\Dataset" %%D in (*) do (
        move "%%D" "ml-models\datasets\train\" >nul 2>&1
    )
    for %%F in ("ml-models\Model train\Egg Gender Prediction Model\Dataset\*.*") do (
        move "%%F" "ml-models\datasets\train\" >nul 2>&1
    )
    echo ✓ Moved Dataset to datasets/train
)

if exist "ml-models\Model train\Egg Gender Prediction Model\Explanation_" (
    echo Moving Explanation files...
    for /d /r "ml-models\Model train\Egg Gender Prediction Model\Explanation_" %%D in (*) do (
        move "%%D" "ml-models\documentation\" >nul 2>&1
    )
    for %%F in ("ml-models\Model train\Egg Gender Prediction Model\Explanation_\*.*") do (
        move "%%F" "ml-models\documentation\" >nul 2>&1
    )
    echo ✓ Moved Explanation files
)

if exist "ml-models\Model train\Egg Gender Prediction Model\*.pkl" (
    echo Moving .pkl model files...
    for %%F in ("ml-models\Model train\Egg Gender Prediction Model\*.pkl") do (
        move "%%F" "ml-models\production-models\" >nul 2>&1
        echo ✓ Moved %%~nxF
    )
)

REM Move Support/Suppot folder data
if exist "ml-models\Model train\Suppot\Dataset" (
    echo Moving Support Dataset to raw folder...
    for /d /r "ml-models\Model train\Suppot\Dataset" %%D in (*) do (
        move "%%D" "ml-models\datasets\raw\" >nul 2>&1
    )
    for %%F in ("ml-models\Model train\Suppot\Dataset\*.*") do (
        move "%%F" "ml-models\datasets\raw\" >nul 2>&1
    )
    echo ✓ Moved Support Dataset to datasets/raw
)

if exist "ml-models\Model train\Suppot\Model" (
    echo Moving Support Model files...
    for /d /r "ml-models\Model train\Suppot\Model" %%D in (*) do (
        move "%%D" "ml-models\production-models\" >nul 2>&1
    )
    for %%F in ("ml-models\Model train\Suppot\Model\*.*") do (
        move "%%F" "ml-models\production-models\" >nul 2>&1
    )
    echo ✓ Moved Support Model files
)

REM Move any .ipynb files from Model train root
for %%F in ("ml-models\Model train\*.ipynb") do (
    move "%%F" "ml-models\training-notebooks\" >nul 2>&1
    echo ✓ Moved %%~nxF
)

echo.
echo [STEP 2/3] Moving model iteration files...
echo.

REM Check if experiments folder still has old name
if exist "experiments" (
    echo Moving experiment notebooks...
    if exist "experiments\*.ipynb" (
        for %%F in ("experiments\*.ipynb") do (
            if /i "%%~nxF"=="FINAL_WithLecturerFeedback.ipynb" (
                move "%%F" "ml-models\model-iterations\final-models\" >nul 2>&1
                echo ✓ Moved FINAL_WithLecturerFeedback.ipynb
            ) else if /i "%%~nxF"=="FINAL_Egg_Model_WithGridSearch.ipynb" (
                move "%%F" "ml-models\model-iterations\final-models\" >nul 2>&1
                echo ✓ Moved FINAL_Egg_Model_WithGridSearch.ipynb
            ) else if /i "%%~nxF"=="COMPLETE_4Models_Comparison.ipynb" (
                move "%%F" "ml-models\model-iterations\comparisons\" >nul 2>&1
                echo ✓ Moved COMPLETE_4Models_Comparison.ipynb
            ) else if /i "%%~nxF"=="CORRECTED_Egg_Gender_Model.ipynb" (
                move "%%F" "ml-models\model-iterations\experimental\" >nul 2>&1
                echo ✓ Moved CORRECTED_Egg_Gender_Model.ipynb
            ) else (
                move "%%F" "ml-models\model-iterations\experimental\" >nul 2>&1
                echo ✓ Moved %%~nxF
            )
        )
    )
)

echo.
echo [STEP 3/3] Cleaning up old folders...
echo.

REM Remove old Model train folder
if exist "ml-models\Model train" (
    rmdir /s /q "ml-models\Model train" >nul 2>&1
    echo ✓ Removed old Model train folder
)

REM Remove experiments folder if empty
if exist "experiments" (
    REM Move any remaining files
    for %%F in ("experiments\*.*") do (
        move "%%F" "ml-models\model-iterations\experimental\" >nul 2>&1
    )
    for /d %%D in ("experiments\*") do (
        rmdir /s /q "%%D" >nul 2>&1
    )
    rmdir "experiments" >nul 2>&1
    echo ✓ Cleaned up experiments folder
)

echo.
echo ========================================================================
echo   ✓ DATA MIGRATION COMPLETE!
echo ========================================================================
echo.
echo Organized structure:
echo   ml-models/
echo   ├─ training-notebooks/         [Training notebooks]
echo   ├─ datasets/
echo   │  ├─ train/                  [Training data]
echo   │  ├─ test/                   [Test data]
echo   │  └─ raw/                    [Raw data]
echo   ├─ model-iterations/
echo   │  ├─ final-models/           [Final models]
echo   │  ├─ experimental/           [Experimental code]
echo   │  └─ comparisons/            [Comparison analysis]
echo   ├─ production-models/         [Trained .pkl models]
echo   └─ documentation/             [ML documentation]
echo.
echo Next Steps:
echo   1. Verify data is in correct folders
echo   2. Test the application
echo   3. Commit changes: git add . && git commit -m "refactor: migrate ml-models data"
echo   4. Push: git push
echo.
echo ========================================================================

pause
