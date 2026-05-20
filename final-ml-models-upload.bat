@echo off
cd /d "C:\Users\lap.lk\Desktop\New folder\Egg-Gender-Prediction"

echo ============================================
echo Final Upload - ALL ml-models Folders
echo ============================================
echo.

echo [1] Clearing git cache...
git rm -r --cached ml-models/
echo Done!
echo.

echo [2] Adding all ml-models with new gitignore rules...
git add ml-models/
git add .gitignore
echo Done!
echo.

echo [3] Checking status...
git status
echo.

echo [4] Committing...
git commit -m "feat: add all ml-models folders and subfolders

- production-models: Trained ML models
- datasets: Training and raw datasets
- documentation: ML documentation files
- model train: Training scripts
- model-iterations: Iteration history
- training-notebooks: Jupyter notebooks
- README.md: Documentation

Updated gitignore to include ml-models content.

Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"
echo Done!
echo.

echo [5] Pushing to GitHub...
git push origin main
echo Done!
echo.

echo ============================================
echo COMPLETE! Check GitHub now!
echo ============================================
pause
