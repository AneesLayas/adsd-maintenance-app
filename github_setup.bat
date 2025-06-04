@echo off
echo ========================================
echo GitHub Setup & Upload Script
echo ========================================

echo.
echo Step 1: Initializing Git repository...
git init

echo Step 2: Adding all files...
git add .

echo Step 3: Creating initial commit...
git commit -m "Initial Flutter app commit - ready for APK build"

echo.
echo ========================================
echo NEXT STEPS - MANUAL:
echo ========================================
echo.
echo 1. Go to: https://github.com/new
echo 2. Repository name: adsd-maintenance-app
echo 3. Make it PUBLIC (for free GitHub Actions)
echo 4. DON'T check "Add README" (we already have one)
echo 5. Click "Create repository"
echo.
echo 6. Copy the repository URL (looks like: https://github.com/yourusername/adsd-maintenance-app.git)
echo.
echo 7. Run this command with YOUR repository URL:
echo    git remote add origin YOUR_REPO_URL_HERE
echo    git branch -M main
echo    git push -u origin main
echo.
echo ========================================
echo AUTOMATIC APK BUILD:
echo ========================================
echo After pushing, GitHub will automatically:
echo • Build your Flutter APK (10-15 minutes)
echo • Make it available in Actions → Artifacts
echo • No local installation needed!
echo.

pause 