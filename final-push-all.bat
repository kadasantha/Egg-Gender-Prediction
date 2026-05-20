@echo off
cd /d "C:\Users\lap.lk\Desktop\New folder\Egg-Gender-Prediction"

echo ============================================
echo FINAL UPLOAD - All ml-models Folders
echo ============================================
echo.

echo [1] Adding everything...
git add -A
echo Done!
echo.

echo [2] Status check...
git status
echo.

echo [3] Committing...
git commit -m "feat: add all ml-models folders with complete structure

Added all ml-models subdirectories:
- production-models/ (trained ML models)
- datasets/ (training and raw data)
- documentation/ (model guides and explanations)
- model train/ (training scripts)
- model-iterations/ (development history)
- training-notebooks/ (Jupyter notebooks)

Updated gitignore to allow ml-models content.

Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"
echo Done!
echo.

echo [4] Pushing to GitHub...
git push origin main
echo Done!
echo.

echo ============================================
echo ALL FOLDERS UPLOADED TO GITHUB!
echo ============================================
pause
