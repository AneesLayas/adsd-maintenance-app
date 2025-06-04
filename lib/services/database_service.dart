import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/report_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static DatabaseService get instance => _instance;
  
  DatabaseService._internal();
  
  Database? _database;
  
  Future<Database> get database async {
    _database ??= await initDatabase();
    return _database!;
  }
  
  Future<Database> initDatabase() async {
    final String path = join(await getDatabasesPath(), 'maintenance_reports.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }
  
  Future<void> _createTables(Database db, int version) async {
    // Create reports table
    await db.execute('''
      CREATE TABLE reports (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        report_id TEXT UNIQUE NOT NULL,
        customer_name TEXT NOT NULL,
        customer_type TEXT NOT NULL,
        customer_telephone TEXT NOT NULL,
        city TEXT NOT NULL,
        call_visit TEXT NOT NULL,
        purpose TEXT NOT NULL,
        instrument_name TEXT NOT NULL,
        instrument_manufacturer TEXT NOT NULL,
        serial_number TEXT NOT NULL,
        sw_version TEXT NOT NULL,
        ud_date TEXT NOT NULL,
        time_in TEXT NOT NULL,
        time_out TEXT NOT NULL,
        duration_hours INTEGER NOT NULL,
        duration_minutes INTEGER NOT NULL,
        problem_description TEXT NOT NULL,
        problem_solved TEXT NOT NULL,
        remedy_description TEXT,
        technician_name TEXT NOT NULL,
        customer_signature TEXT,
        engineer_signature TEXT,
        created_at TEXT NOT NULL,
        synced_at TEXT,
        is_sync INTEGER DEFAULT 0
      )
    ''');
    
    // Create materials_used table
    await db.execute('''
      CREATE TABLE materials_used (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        report_id TEXT NOT NULL,
        material_number TEXT NOT NULL,
        material_name TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        remarks TEXT,
        FOREIGN KEY (report_id) REFERENCES reports (report_id) ON DELETE CASCADE
      )
    ''');
    
    // Create indexes for better performance
    await db.execute('CREATE INDEX idx_reports_report_id ON reports(report_id)');
    await db.execute('CREATE INDEX idx_reports_sync ON reports(is_sync)');
    await db.execute('CREATE INDEX idx_materials_report_id ON materials_used(report_id)');
  }
  
  // Generate unique report ID
  Future<String> generateReportId() async {
    final db = await database;
    final today = DateTime.now();
    final dateStr = '${today.year}${today.month.toString().padLeft(2, '0')}${today.day.toString().padLeft(2, '0')}';
    
    // Get the last report ID for today
    final List<Map<String, dynamic>> results = await db.query(
      'reports',
      columns: ['report_id'],
      where: 'report_id LIKE ?',
      whereArgs: ['TSR-$dateStr-%'],
      orderBy: 'report_id DESC',
      limit: 1,
    );
    
    int sequence = 1;
    if (results.isNotEmpty) {
      final lastId = results.first['report_id'] as String;
      final parts = lastId.split('-');
      if (parts.length == 3) {
        sequence = int.parse(parts[2]) + 1;
      }
    }
    
    return 'TSR-$dateStr-${sequence.toString().padLeft(4, '0')}';
  }
  
  // Save a new report
  Future<int> saveReport(MaintenanceReport report) async {
    final db = await database;
    
    try {
      await db.transaction((txn) async {
        // Insert the report
        await txn.insert('reports', report.toDbMap());
        
        // Insert materials
        for (final material in report.materials) {
          await txn.insert(
            'materials_used',
            material.copyWith(reportId: report.reportId).toDbMap(),
          );
        }
      });
      
      return 1; // Success
    } catch (e) {
      print('Error saving report: $e');
      return 0; // Failure
    }
  }
  
  // Get all reports
  Future<List<MaintenanceReport>> getAllReports() async {
    final db = await database;
    
    final List<Map<String, dynamic>> reportMaps = await db.query(
      'reports',
      orderBy: 'created_at DESC',
    );
    
    List<MaintenanceReport> reports = [];
    
    for (final reportMap in reportMaps) {
      final materials = await getMaterialsForReport(reportMap['report_id']);
      final report = MaintenanceReport.fromDbMap(reportMap).copyWith(
        materials: materials,
      );
      reports.add(report);
    }
    
    return reports;
  }
  
  // Get unsynced reports
  Future<List<MaintenanceReport>> getUnsyncedReports() async {
    final db = await database;
    
    final List<Map<String, dynamic>> reportMaps = await db.query(
      'reports',
      where: 'is_sync = ?',
      whereArgs: [0],
      orderBy: 'created_at ASC',
    );
    
    List<MaintenanceReport> reports = [];
    
    for (final reportMap in reportMaps) {
      final materials = await getMaterialsForReport(reportMap['report_id']);
      final report = MaintenanceReport.fromDbMap(reportMap).copyWith(
        materials: materials,
      );
      reports.add(report);
    }
    
    return reports;
  }
  
  // Get materials for a specific report
  Future<List<MaterialUsed>> getMaterialsForReport(String reportId) async {
    final db = await database;
    
    final List<Map<String, dynamic>> materialMaps = await db.query(
      'materials_used',
      where: 'report_id = ?',
      whereArgs: [reportId],
    );
    
    return materialMaps.map((map) => MaterialUsed.fromDbMap(map)).toList();
  }
  
  // Update report sync status
  Future<void> markReportAsSynced(String reportId) async {
    final db = await database;
    
    await db.update(
      'reports',
      {
        'is_sync': 1,
        'synced_at': DateTime.now().toIso8601String(),
      },
      where: 'report_id = ?',
      whereArgs: [reportId],
    );
  }
  
  // Get report by ID
  Future<MaintenanceReport?> getReportById(String reportId) async {
    final db = await database;
    
    final List<Map<String, dynamic>> reportMaps = await db.query(
      'reports',
      where: 'report_id = ?',
      whereArgs: [reportId],
      limit: 1,
    );
    
    if (reportMaps.isEmpty) return null;
    
    final materials = await getMaterialsForReport(reportId);
    return MaintenanceReport.fromDbMap(reportMaps.first).copyWith(
      materials: materials,
    );
  }
  
  // Delete a report
  Future<void> deleteReport(String reportId) async {
    final db = await database;
    
    await db.transaction((txn) async {
      // Delete materials first (foreign key constraint)
      await txn.delete(
        'materials_used',
        where: 'report_id = ?',
        whereArgs: [reportId],
      );
      
      // Delete the report
      await txn.delete(
        'reports',
        where: 'report_id = ?',
        whereArgs: [reportId],
      );
    });
  }
  
  // Get reports count
  Future<int> getReportsCount() async {
    final db = await database;
    
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM reports');
    return result.first['count'] as int;
  }
  
  // Get unsynced reports count
  Future<int> getUnsyncedReportsCount() async {
    final db = await database;
    
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM reports WHERE is_sync = 0'
    );
    return result.first['count'] as int;
  }
  
  // Search reports
  Future<List<MaintenanceReport>> searchReports(String query) async {
    final db = await database;
    
    final List<Map<String, dynamic>> reportMaps = await db.query(
      'reports',
      where: '''
        customer_name LIKE ? OR 
        instrument_name LIKE ? OR 
        technician_name LIKE ? OR 
        report_id LIKE ?
      ''',
      whereArgs: ['%$query%', '%$query%', '%$query%', '%$query%'],
      orderBy: 'created_at DESC',
    );
    
    List<MaintenanceReport> reports = [];
    
    for (final reportMap in reportMaps) {
      final materials = await getMaterialsForReport(reportMap['report_id']);
      final report = MaintenanceReport.fromDbMap(reportMap).copyWith(
        materials: materials,
      );
      reports.add(report);
    }
    
    return reports;
  }
  
  // Get reports by date range
  Future<List<MaintenanceReport>> getReportsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await database;
    
    final List<Map<String, dynamic>> reportMaps = await db.query(
      'reports',
      where: 'created_at BETWEEN ? AND ?',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
      orderBy: 'created_at DESC',
    );
    
    List<MaintenanceReport> reports = [];
    
    for (final reportMap in reportMaps) {
      final materials = await getMaterialsForReport(reportMap['report_id']);
      final report = MaintenanceReport.fromDbMap(reportMap).copyWith(
        materials: materials,
      );
      reports.add(report);
    }
    
    return reports;
  }
  
  // Clear all data (for testing or reset)
  Future<void> clearAllData() async {
    final db = await database;
    
    await db.transaction((txn) async {
      await txn.delete('materials_used');
      await txn.delete('reports');
    });
  }
} 