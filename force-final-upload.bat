@echo off
cd /d "C:\Users\lap.lk\Desktop\New folder\Egg-Gender-Prediction"

echo ============================================
echo FORCE Upload - ALL ml-models
echo ============================================
echo.

echo [1] Force-add all ml-models (ignore gitignore)...
git add -f ml-models/
echo Done!
echo.

echo [2] Checking status...
git status
echo.

echo [3] Committing all files...
git commit -m "feat: add all ml-models with complete folder structure

Folders included:
- production-models/ (ML model files)
- datasets/ (training and raw data)
- documentation/ (model explanations)
- model train/ (training scripts)
- model-iterations/ (development iterations)
- training-notebooks/ (Jupyter notebooks)

Using git add -f to override gitignore for ml-models folder.

Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"
echo Done!
echo.

echo [4] Pushing to GitHub...
git push origin main
echo Done!
echo.

echo ============================================
echo SUCCESS! All folders should be on GitHub now
echo ============================================
pause
