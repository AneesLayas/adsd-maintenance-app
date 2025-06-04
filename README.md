# ADSD Maintenance Android App

Flutter-based Android app for maintenance report management with offline capabilities.

## Features
- ✅ Offline-first design
- ✅ Automatic sync when online
- ✅ SQLite local storage
- ✅ Material Design UI
- ✅ Background synchronization

## Building APK

This repository is configured with GitHub Actions for automatic APK building.

### Automatic Build
- Push code to `main` branch
- GitHub Actions will automatically build the APK
- Download the APK from the "Actions" tab → "Artifacts"

### Manual Trigger
- Go to "Actions" tab
- Click "Build Flutter APK"
- Click "Run workflow"

## APK Download
After the build completes (10-15 minutes):
1. Go to Actions tab
2. Click on the latest workflow run
3. Download `app-release-apk` artifact
4. Extract the zip file to get your APK

## Installation
1. Enable "Unknown Sources" on your Android device
2. Transfer the APK to your device
3. Install the APK
4. Configure server URL in app settings

## Server Requirements
- API server running on port 5000
- Network connectivity for sync operations

Built with Flutter 3.32.1 🚀 