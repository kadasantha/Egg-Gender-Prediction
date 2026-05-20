@echo off
echo ============================================
echo Force Upload ML Models to GitHub
echo ============================================
echo.

cd /d "C:\Users\lap.lk\Desktop\New folder\Egg-Gender-Prediction"

echo [STEP 1] Checking Git LFS status...
git lfs version
echo.

echo [STEP 2] Force add all pkl files (ignoring gitignore)...
git add -f ml-models/
echo.

echo [STEP 3] Checking what will be committed...
git status
echo.

echo [STEP 4] Creating commit...
git commit -m "feat: force add ML models with Git LFS

- Added all ml-models including production-models
- Using Git LFS for large .pkl files

Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"
echo.

echo [STEP 5] Pushing to GitHub...
echo Note: This will take 2-5 minutes for large files...
echo.
git push origin main
echo.

echo ============================================
echo COMPLETE!
echo ============================================
pause
