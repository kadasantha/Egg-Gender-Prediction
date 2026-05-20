@echo off
echo ============================================
echo Git LFS Setup and ML Models Upload
echo ============================================
echo.

REM Step 1: Initialize Git LFS
echo [STEP 1] Installing Git LFS...
git lfs install
echo Done!
echo.

REM Step 2: Track .pkl files
echo [STEP 2] Tracking .pkl model files with Git LFS...
git lfs track "*.pkl"
echo Done!
echo.

REM Step 3: Add gitattributes
echo [STEP 3] Adding .gitattributes...
git add .gitattributes
echo Done!
echo.

REM Step 4: Add all model files
echo [STEP 4] Adding all ml-models folder...
git add ml-models/
echo Done!
echo.

REM Step 5: Commit
echo [STEP 5] Creating commit...
git commit -m "feat: add ML models with Git LFS storage

- Added egg_gender_model.pkl (Random Forest classifier)
- Added scaler.pkl (StandardScaler for feature normalization)
- Added label_encoder.pkl (Label encoder for gender classes)
- Configured Git LFS for large file storage

Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"
echo Done!
echo.

REM Step 6: Push to GitHub
echo [STEP 6] Pushing to GitHub (this may take a few minutes)...
git push
echo.
echo ============================================
echo SUCCESS! Models uploaded to GitHub!
echo ============================================
pause
