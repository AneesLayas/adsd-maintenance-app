import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../models/report_model.dart';

class ApiService {
  static const String baseUrl = AppConfig.serverBaseUrl;
  
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
  };

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: _headers,
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> submitReport(MaintenanceReport report) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reports/submit'),
        headers: _headers,
        body: jsonEncode(report.toJson()),
      );

      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> syncReports(
    List<MaintenanceReport> reports,
    String? lastSync,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reports/sync'),
        headers: _headers,
        body: jsonEncode({
          'reports': reports.map((r) => r.toJson()).toList(),
          'last_sync': lastSync,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> getReports({
    String? startDate,
    String? endDate,
    String? technician,
    int limit = 50,
  }) async {
    try {
      var uri = Uri.parse('$baseUrl/reports');
      final queryParams = <String, String>{};
      
      if (startDate != null) queryParams['start_date'] = startDate;
      if (endDate != null) queryParams['end_date'] = endDate;
      if (technician != null) queryParams['technician'] = technician;
      queryParams['limit'] = limit.toString();
      
      uri = uri.replace(queryParameters: queryParams);
      
      final response = await http.get(uri, headers: _headers);
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> getConfig() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/config'),
        headers: _headers,
      );

      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<bool> checkHealth() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
        headers: _headers,
      );

      final data = jsonDecode(response.body);
      return data['status'] == 'ok';
    } catch (e) {
      return false;
    }
  }
} 