# ADSD Maintenance App - Android Offline Solution

## 📱 Overview

This solution provides an **Android app that works completely offline** and syncs with your existing web application when internet connectivity is available. Technicians can fill maintenance reports in the field without internet access, and the data will automatically sync when they return to a connected area.

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Android App   │◄──►│   API Server    │◄──►│   Web App DB    │
│  (Offline-First)│    │  (Flask REST)   │    │   (SQLite)      │
│                 │    │                 │    │                 │
│ • Local SQLite  │    │ • Sync endpoint │    │ • Same schema   │
│ • Same forms    │    │ • Auth system   │    │ • Existing data │
│ • Auto sync     │    │ • Data exchange │    │ • PDF reports   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🚀 Quick Start

### 1. **Backup & Setup**
```bash
# The backup has already been created: pre_android_backup_20250604_080321.tar.gz

# Run the setup script
./setup_android_solution.sh
```

### 2. **Start the API Server**
```bash
./start_api_server.sh
```

### 3. **Build the Android App**
```bash
cd android_app
flutter pub get
flutter build apk --release
```

The APK will be available at: `android_app/build/app/outputs/flutter-apk/app-release.apk`

## 📋 Features

### ✅ **Offline Capabilities**
- Fill maintenance reports without internet
- Local SQLite database storage
- Automatic report ID generation
- Materials tracking
- Digital signatures support

### ✅ **Sync Functionality**
- Automatic background sync every 30 minutes
- Manual sync with pull-to-refresh
- Conflict resolution (latest wins)
- Sync status indicators
- Retry mechanism for failed syncs

### ✅ **Same Interface**
- Identical form fields as web app
- Same dropdown options
- Same validation rules
- Same customer types, cities, manufacturers
- Same report format and structure

### ✅ **User Management**
- Uses existing user accounts
- Role-based access (technician/manager)
- Secure authentication with tokens
- Auto-login functionality

## 🛠️ Implementation Details

### **API Server** (`api_server.py`)
- Flask REST API with CORS support
- Authentication endpoint
- Report submission and retrieval
- Bi-directional sync capabilities
- Configuration data for mobile app

### **Android App** (Flutter-based)
- Offline-first architecture using SQLite
- State management with Riverpod
- Reactive forms for data entry
- Background sync service
- Material Design UI

### **Database Schema**
The Android app uses the same database structure as your web app:
- `reports` table: Main maintenance reports
- `materials_used` table: Materials used in each report
- Automatic foreign key relationships
- Optimized indexes for performance

## 📁 File Structure

```
/home/anis/alfa_app_code_3/
├── api_server.py                 # Flask API server
├── requirements_api.txt          # Python dependencies
├── setup_android_solution.sh     # Setup script
├── start_api_server.sh           # Server start script (auto-generated)
└── android_app/
    ├── pubspec.yaml              # Flutter dependencies
    ├── BUILD_INSTRUCTIONS.md     # Detailed build guide
    ├── lib/
    │   ├── main.dart             # App entry point
    │   ├── models/
    │   │   └── report_model.dart # Data models
    │   ├── services/
    │   │   ├── database_service.dart # Local database
    │   │   ├── api_service.dart     # Server communication
    │   │   └── sync_service.dart    # Data synchronization
    │   ├── screens/              # UI screens
    │   └── providers/            # State management
    └── android/                  # Android configuration
```

## 🔧 Configuration

### **Server URL Configuration**
The setup script automatically detects your server IP and configures the app. If you need to change it:

1. Edit `android_app/lib/config/app_config.dart`
2. Update the `serverBaseUrl` value
3. Rebuild the app

### **Firewall Configuration**
```bash
sudo ufw allow 5000
```

### **Network Access**
The API server runs on port 5000 and needs to be accessible from mobile devices on your network.

## 🔄 Sync Process

### **How Sync Works**
1. **Offline Mode**: Reports saved locally with `is_sync = false`
2. **Online Detection**: App checks connectivity periodically
3. **Upload**: Unsynced local reports sent to server
4. **Download**: New server reports retrieved
5. **Conflict Resolution**: Server version takes precedence
6. **Status Update**: Local reports marked as synced

### **Sync Triggers**
- App startup (if online)
- Manual pull-to-refresh
- Automatic every 30 minutes
- When connectivity is restored

## 👥 User Experience

### **For Technicians**
1. **Login Once**: Authenticate when internet is available
2. **Work Offline**: Fill reports in the field without connectivity
3. **Auto Sync**: Data syncs automatically when back online
4. **Visual Feedback**: See sync status and pending uploads

### **For Managers**
- All reports appear in the web app after sync
- No change to existing web interface
- Real-time data when technicians sync
- Same PDF generation and reporting

## 🛡️ Security

### **Authentication**
- Token-based authentication
- Secure password hashing with bcrypt
- Auto-logout on token expiry
- Local token storage with Android keystore

### **Data Protection**
- Local SQLite database encrypted by Android
- HTTPS support ready (configure SSL certificates)
- No sensitive data in plain text
- Secure API communication

## 📊 Testing

### **Test the Setup**
```bash
# Test API server
curl http://localhost:5000/api/health

# Test authentication
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"tech","password":"tech123"}'

# Test report submission
curl -X POST http://localhost:5000/api/reports/submit \
  -H "Content-Type: application/json" \
  -d @test_report.json
```

## 🚀 Deployment

### **Internal Distribution**
1. Build the release APK
2. Share APK file with technicians
3. Install on devices (enable unknown sources)
4. Configure server access

### **Production Considerations**
- Use HTTPS for production
- Configure proper SSL certificates
- Set up proper firewall rules
- Consider VPN access for remote technicians
- Implement proper backup strategies

## 🔍 Troubleshooting

### **Common Issues**

**App Won't Connect**
- Check server IP configuration
- Verify firewall allows port 5000
- Ensure API server is running

**Sync Not Working**
- Check internet connectivity
- Verify server logs for errors
- Clear app data and re-login

**Build Issues**
- Run `flutter doctor` to check setup
- Clear build cache: `flutter clean`
- Update Flutter: `flutter upgrade`

### **Logs and Debugging**
```bash
# API server logs
python3 api_server.py

# Flutter app logs
flutter logs

# Android system logs
adb logcat
```

## 📞 Support

### **Documentation**
- `android_app/BUILD_INSTRUCTIONS.md` - Detailed build guide
- Flutter docs: https://flutter.dev/docs
- Flask docs: https://flask.palletsprojects.com/

### **Architecture Decisions**
- **Flutter**: Cross-platform with excellent offline capabilities
- **SQLite**: Same database engine as web app for consistency
- **Flask**: Lightweight API server, easy to integrate
- **Offline-First**: Ensures usability in poor connectivity areas

## 📈 Benefits

### **For Users**
- ✅ Work without internet connectivity
- ✅ Familiar interface matching web app
- ✅ Automatic data synchronization
- ✅ No data loss in poor connectivity areas
- ✅ Fast, responsive mobile experience

### **For IT Administration**
- ✅ No complex server infrastructure needed
- ✅ Uses existing database and user accounts
- ✅ Easy deployment and maintenance
- ✅ Full data consistency with web app
- ✅ Standard Android app distribution

### **For Business**
- ✅ Increased productivity in field work
- ✅ Real-time data collection
- ✅ Reduced paperwork and manual entry
- ✅ Better data accuracy and completeness
- ✅ Seamless integration with existing workflow

---

**Ready to get started?** Run `./setup_android_solution.sh` and follow the instructions! 