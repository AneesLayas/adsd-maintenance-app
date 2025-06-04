@echo off
echo Building APK with optimized settings for limited resources...

REM Set environment variables for low memory usage
set GRADLE_OPTS=-Xmx1024m -XX:MaxPermSize=256m
set FLUTTER_BUILD_MODE=release

echo Cleaning previous builds...
flutter clean

echo Getting dependencies...
flutter pub get

echo Building APK with memory optimizations...
flutter build apk --release ^
  --no-tree-shake-icons ^
  --dart-define=flutter.inspector.structuredErrors=false ^
  --target-platform android-arm64

echo Build complete! APK location:
echo build\app\outputs\flutter-apk\app-release.apk

pause 