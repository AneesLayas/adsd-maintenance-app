# ADSD Maintenance Android App - Build Instructions

## Overview
This Flutter-based Android app allows technicians to fill maintenance reports offline and sync with the web application when internet connectivity is available.

## Features
- **Offline-First Design**: All forms can be filled without internet connection
- **Automatic Sync**: Data syncs automatically when internet is available
- **Same Interface**: Mirrors the web app's form structure
- **Local Storage**: SQLite database for offline report storage
- **Background Sync**: Periodic synchronization in the background

## Prerequisites

### 1. Install Flutter
```bash
# Download Flutter SDK
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.0-stable.tar.xz

# Extract and add to PATH
tar xf flutter_linux_3.16.0-stable.tar.xz
export PATH="$PATH:`pwd`/flutter/bin"

# Verify installation
flutter doctor
```

### 2. Install Android Studio and SDK
```bash
# Install Android Studio
sudo snap install android-studio --classic

# Or using apt (Ubuntu/Debian)
sudo apt update
sudo apt install android-studio

# Accept licenses
flutter doctor --android-licenses
```

### 3. Setup Android Device/Emulator
- Enable Developer Options and USB Debugging on Android device
- Or create an Android Virtual Device (AVD) in Android Studio

## Setup Instructions

### 1. Navigate to Android App Directory
```bash
cd android_app
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Generate Model Classes
```bash
flutter packages pub run build_runner build
```

### 4. Configure Server URL
Edit `lib/services/api_service.dart` and update the base URL:
```dart
static const String baseUrl = 'http://YOUR_SERVER_IP:5000/api';
```

### 5. Build and Run

#### For Development (Debug Mode)
```bash
# Check connected devices
flutter devices

# Run on connected device/emulator
flutter run
```

#### For Production (Release APK)
```bash
# Build release APK
flutter build apk --release

# The APK will be located at:
# build/app/outputs/flutter-apk/app-release.apk
```

#### For App Bundle (Google Play Store)
```bash
flutter build appbundle --release
```

## Server Setup for Sync

### 1. Install API Server Dependencies
```bash
cd /home/anis/alfa_app_code_3
pip3 install -r requirements_api.txt
```

### 2. Run the API Server
```bash
python3 api_server.py
```

The server will run on `http://0.0.0.0:5000` and provide the following endpoints:
- `POST /api/auth/login` - User authentication
- `POST /api/reports/submit` - Submit new reports
- `POST /api/reports/sync` - Sync reports between app and server
- `GET /api/reports` - Get reports with filtering
- `GET /api/config` - Get app configuration data

### 3. Configure Firewall (if needed)
```bash
sudo ufw allow 5000
```

## App Configuration

### Updating Server URL in App
The app needs to know your server's IP address. Update it in multiple files:

1. **Main API Service**: `lib/services/api_service.dart`
2. **Sync Service**: `lib/services/sync_service.dart`

Replace `YOUR_SERVER_IP` with your actual server IP address.

### Default Credentials
The app uses the same credentials as your web application:
- Admin: admin/admin123
- Technician: tech/tech123

## Usage Guide

### 1. Login
- Open the app and enter your credentials
- The app will authenticate with the server (requires internet)
- Once logged in, you can work offline

### 2. Creating Reports
- Tap "New Report" to create a maintenance report
- Fill all required fields (marked with *)
- Add materials used as needed
- Save the report locally

### 3. Syncing Data
- The app automatically syncs when internet is available
- Manual sync: Pull down on the reports list to refresh
- Check sync status in the app's status bar

### 4. Viewing Reports
- View all reports in the "Reports" tab
- Search and filter reports
- View report details and materials used

## Troubleshooting

### Flutter Issues
```bash
# Clean build cache
flutter clean
flutter pub get

# Check for issues
flutter doctor

# Update Flutter
flutter upgrade
```

### Database Issues
- The app automatically creates and manages the local SQLite database
- To reset: Clear app data or reinstall the app

### Sync Issues
- Check internet connectivity
- Verify server is running and accessible
- Check server logs for errors
- Ensure firewall allows connections on port 5000

### Building Issues
```bash
# If build fails, try:
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk
```

## File Structure
```
android_app/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/
│   │   └── report_model.dart     # Data models
│   ├── services/
│   │   ├── database_service.dart # Local SQLite operations
│   │   ├── api_service.dart      # Server communication
│   │   └── sync_service.dart     # Data synchronization
│   ├── screens/
│   │   ├── login_screen.dart     # Login interface
│   │   ├── home_screen.dart      # Main dashboard
│   │   └── report_form.dart      # Report creation form
│   └── providers/
│       └── auth_provider.dart    # Authentication state
├── pubspec.yaml                  # Dependencies
└── android/                     # Android-specific configuration
```

## Deployment

### For Internal Distribution
1. Build the release APK
2. Transfer the APK file to target devices
3. Enable "Install from Unknown Sources" on devices
4. Install the APK

### Security Note
- The app stores authentication tokens securely
- All communication with the server uses standard HTTP (add HTTPS in production)
- Local database is encrypted by Android's security system

## Support
- Check Flutter documentation: https://flutter.dev/docs
- Android development: https://developer.android.com/
- For app-specific issues, check the logs in Android Studio or using `flutter logs` 