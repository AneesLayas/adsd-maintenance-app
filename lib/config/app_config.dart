class AppConfig {
  static const String serverBaseUrl = 'http://10.1.1.4:5000/api';
  static const String appName = 'ADSD Maintenance';
  static const String appVersion = '1.0.0';
  
  // Sync settings
  static const int syncIntervalMinutes = 30;
  static const int maxRetryAttempts = 3;
  
  // Database settings
  static const String localDatabaseName = 'maintenance_reports.db';
}
