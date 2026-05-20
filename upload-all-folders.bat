@echo off
cd /d "C:\Users\lap.lk\Desktop\New folder\Egg-Gender-Prediction"

echo ============================================
echo Uploading ALL ml-models Folders
echo ============================================
echo.

echo [1] Undo last commit to restore deleted files...
git reset --soft HEAD~1
echo Done!
echo.

echo [2] Unstaging everything...
git reset HEAD
echo Done!
echo.

echo [3] Re-adding ALL ml-models folders...
git add ml-models/
git add .gitignore
echo Done!
echo.

echo [4] Checking what will be uploaded...
git status
echo.

echo [5] Creating new commit...
git commit -m "feat: add all ml-models folders with datasets and training files

- production-models: Trained ML models (pkl files)
- datasets: Training and raw data
- documentation: ML model explanations and guides
- model train: Training scripts and notebooks
- model-iterations: Model development iterations
- training-notebooks: Jupyter notebooks for training
- README.md: Documentation

All files tracked with Git LFS for large files.

Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"
echo Done!
echo.

echo [6] Pushing to GitHub...
echo This may take 5-10 minutes...
git push origin main --force-with-lease
echo Done!
echo.

echo ============================================
echo ALL FOLDERS UPLOADED!
echo ============================================
pause
