@echo off
echo ========================================
echo Push to GitHub Script
echo ========================================

set /p repo_url="Enter your GitHub repository URL: "

echo.
echo Setting up remote repository...
git remote add origin %repo_url%

echo Setting main branch...
git branch -M main

echo Pushing to GitHub...
git push -u origin main

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo SUCCESS! 🎉
    echo ========================================
    echo Your code is now on GitHub!
    echo.
    echo Next steps:
    echo 1. Go to your GitHub repository
    echo 2. Click "Actions" tab
    echo 3. Watch the APK build process
    echo 4. Download APK from Artifacts when complete
    echo.
    echo Build time: ~10-15 minutes
    echo.
) else (
    echo.
    echo ========================================
    echo ERROR!
    echo ========================================
    echo Something went wrong. Check:
    echo 1. Repository URL is correct
    echo 2. You have internet connection
    echo 3. Repository exists on GitHub
    echo.
)

pause 