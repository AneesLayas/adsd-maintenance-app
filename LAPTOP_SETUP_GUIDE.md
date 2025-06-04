# Flutter APK Build Setup Guide for Windows Laptop

## Step 1: Install Flutter SDK

### Download and Install Flutter
1. Download Flutter SDK from: https://docs.flutter.dev/get-started/install/windows
2. Or use this direct link: https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.16.0-stable.zip

### Extract and Setup Path
1. Extract the zip file to `C:\flutter` (avoid Program Files)
2. Add Flutter to your PATH:
   - Search "Environment Variables" in Windows
   - Click "Environment Variables" button
   - Under "User variables", find "Path" and click "Edit"
   - Click "New" and add: `C:\flutter\bin`
   - Click "OK" to save

### Verify Installation
Open a new PowerShell window and run:
```powershell
flutter --version
flutter doctor
```

## Step 2: Install Android Studio

### Download Android Studio
1. Go to: https://developer.android.com/studio
2. Download and install Android Studio

### Setup Android SDK
1. Open Android Studio
2. Go to File → Settings → Appearance & Behavior → System Settings → Android SDK
3. Install:
   - Android SDK Platform-Tools
   - Android SDK Build-Tools
   - At least one Android platform (API 33 or latest)

### Accept Licenses
```powershell
flutter doctor --android-licenses
```
Type 'y' to accept all licenses.

## Step 3: Install Git (if not already installed)
Download from: https://git-scm.com/download/win

## Step 4: Build Your APK

### Quick Build Commands
```powershell
# Navigate to your project
cd "C:\Users\anees\OneDrive\Desktop\alfa_project\Android_App\android_app"

# Get dependencies
flutter pub get

# Generate code (if needed)
flutter packages pub run build_runner build --delete-conflicting-outputs

# Build the APK
flutter build apk --release
```

### Your APK will be located at:
`build\app\outputs\flutter-apk\app-release.apk`

## Step 5: Troubleshooting

### If you get Java errors:
Flutter includes its own Java, but if needed:
```powershell
# Check Java version
java -version
```

### If you get Gradle errors:
```powershell
cd android
.\gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk --release
```

### Common Issues:
1. **Path issues**: Make sure Flutter is in your PATH
2. **Android licenses**: Run `flutter doctor --android-licenses`
3. **SDK issues**: Run `flutter doctor` and follow suggestions

## Expected Build Time
On a typical laptop: 10-20 minutes for first build, 5-10 minutes for subsequent builds.

## System Requirements
- Windows 10/11
- 4GB+ RAM (8GB recommended)
- 10GB+ free disk space
- Internet connection for initial setup 