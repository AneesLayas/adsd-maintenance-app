import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/database_service.dart';
import '../services/api_service.dart';
import '../models/report_model.dart';

class SyncService {
  final Ref _ref;
  late ApiService _apiService;
  late DatabaseService _databaseService;

  SyncService(this._ref) {
    _apiService = ApiService();
    _databaseService = DatabaseService.instance;
  }

  Future<bool> isOnline() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<SyncResult> syncWithServer() async {
    if (!await isOnline()) {
      throw Exception('No internet connection');
    }

    try {
      // Get unsynced local reports
      final unsyncedReports = await _databaseService.getUnsyncedReports();
      
      // Get last sync timestamp
      final prefs = await SharedPreferences.getInstance();
      final lastSync = prefs.getString('last_sync');
      
      // Sync with server
      final response = await _apiService.syncReports(unsyncedReports, lastSync);
      
      if (response['success'] == true) {
        final uploadedCount = response['uploaded_reports'] as int;
        final serverReports = response['server_reports'] as List;
        final syncTimestamp = response['sync_timestamp'] as String;
        
        // Mark uploaded reports as synced
        for (final report in unsyncedReports) {
          await _databaseService.markReportAsSynced(report.reportId);
        }
        
        // Save new server reports locally
        int downloadedCount = 0;
        for (final serverReportData in serverReports) {
          try {
            final serverReport = MaintenanceReport.fromJson(serverReportData);
            final existingReport = await _databaseService.getReportById(serverReport.reportId);
            
            if (existingReport == null) {
              await _databaseService.saveReport(serverReport.copyWith(isSync: true));
              downloadedCount++;
            }
          } catch (e) {
            print('Error processing server report: $e');
          }
        }
        
        // Update last sync timestamp
        await prefs.setString('last_sync', syncTimestamp);
        
        return SyncResult(
          success: true,
          uploadedCount: uploadedCount,
          downloadedCount: downloadedCount,
          message: 'Sync completed successfully',
        );
      } else {
        throw Exception(response['error'] ?? 'Sync failed');
      }
    } catch (e) {
      return SyncResult(
        success: false,
        uploadedCount: 0,
        downloadedCount: 0,
        message: 'Sync failed: $e',
      );
    }
  }

  Future<bool> canSync() async {
    return await isOnline();
  }

  Future<DateTime?> getLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSyncString = prefs.getString('last_sync');
    
    if (lastSyncString != null) {
      return DateTime.parse(lastSyncString);
    }
    return null;
  }
}

class SyncResult {
  final bool success;
  final int uploadedCount;
  final int downloadedCount;
  final String message;

  SyncResult({
    required this.success,
    required this.uploadedCount,
    required this.downloadedCount,
    required this.message,
  });
} 