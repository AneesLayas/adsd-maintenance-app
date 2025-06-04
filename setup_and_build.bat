@echo off
echo ========================================
echo Flutter APK Build Setup for Laptop
echo ========================================

echo.
echo Checking if Flutter is installed...
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Flutter is not installed or not in PATH.
    echo Please install Flutter first following LAPTOP_SETUP_GUIDE.md
    echo.
    echo Quick steps:
    echo 1. Download Flutter from: https://docs.flutter.dev/get-started/install/windows
    echo 2. Extract to C:\flutter
    echo 3. Add C:\flutter\bin to your PATH
    echo 4. Restart PowerShell and run this script again
    pause
    exit /b 1
)

echo Flutter found! Checking Flutter doctor...
flutter doctor

echo.
echo Starting APK build process...
echo.

echo Step 1: Cleaning previous builds...
flutter clean

echo Step 2: Getting dependencies...
flutter pub get

echo Step 3: Generating code...
flutter packages pub run build_runner build --delete-conflicting-outputs

echo Step 4: Building APK (this may take 10-20 minutes)...
flutter build apk --release

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo BUILD SUCCESSFUL!
    echo ========================================
    echo Your APK is ready at:
    echo build\app\outputs\flutter-apk\app-release.apk
    echo.
    echo You can now install this APK on Android devices.
    echo.
) else (
    echo.
    echo ========================================
    echo BUILD FAILED!
    echo ========================================
    echo Please check the errors above.
    echo Common solutions:
    echo 1. Run: flutter doctor --android-licenses
    echo 2. Ensure Android Studio is installed
    echo 3. Check LAPTOP_SETUP_GUIDE.md for troubleshooting
    echo.
)

pause 