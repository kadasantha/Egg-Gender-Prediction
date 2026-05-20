@echo off
cd /d "C:\Users\lap.lk\Desktop\New folder\Egg-Gender-Prediction"

echo [1] Removing old commits if any...
git reset HEAD ml-models/

echo [2] Clearing git cache...
git rm -r --cached ml-models/

echo [3] Adding ml-models again...
git add ml-models/
git add .gitignore

echo [4] Checking status...
git status

echo [5] Committing...
git commit -m "feat: upload ML models with Git LFS

- egg_gender_model.pkl
- scaler.pkl  
- label_encoder.pkl
- training datasets and notebooks

Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"

echo [6] Pushing to GitHub...
git push origin main

echo DONE!
pause
