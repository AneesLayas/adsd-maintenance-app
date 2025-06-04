import 'package:json_annotation/json_annotation.dart';

part 'report_model.g.dart';

@JsonSerializable()
class MaintenanceReport {
  final int? id;
  final String reportId;
  final String customerName;
  final String customerType;
  final String customerTelephone;
  final String city;
  final String callVisit;
  final List<String> purpose;
  final String instrumentName;
  final String instrumentManufacturer;
  final String serialNumber;
  final String swVersion;
  final String udDate;
  final String timeIn;
  final String timeOut;
  final int durationHours;
  final int durationMinutes;
  final String problemDescription;
  final String problemSolved;
  final String remedyDescription;
  final String technicianName;
  final String? customerSignature;
  final String? engineerSignature;
  final List<MaterialUsed> materials;
  final DateTime createdAt;
  final DateTime? syncedAt;
  final bool isSync;

  MaintenanceReport({
    this.id,
    required this.reportId,
    required this.customerName,
    required this.customerType,
    required this.customerTelephone,
    required this.city,
    required this.callVisit,
    required this.purpose,
    required this.instrumentName,
    required this.instrumentManufacturer,
    required this.serialNumber,
    required this.swVersion,
    required this.udDate,
    required this.timeIn,
    required this.timeOut,
    required this.durationHours,
    required this.durationMinutes,
    required this.problemDescription,
    required this.problemSolved,
    required this.remedyDescription,
    required this.technicianName,
    this.customerSignature,
    this.engineerSignature,
    required this.materials,
    required this.createdAt,
    this.syncedAt,
    this.isSync = false,
  });

  factory MaintenanceReport.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceReportFromJson(json);

  Map<String, dynamic> toJson() => _$MaintenanceReportToJson(this);

  MaintenanceReport copyWith({
    int? id,
    String? reportId,
    String? customerName,
    String? customerType,
    String? customerTelephone,
    String? city,
    String? callVisit,
    List<String>? purpose,
    String? instrumentName,
    String? instrumentManufacturer,
    String? serialNumber,
    String? swVersion,
    String? udDate,
    String? timeIn,
    String? timeOut,
    int? durationHours,
    int? durationMinutes,
    String? problemDescription,
    String? problemSolved,
    String? remedyDescription,
    String? technicianName,
    String? customerSignature,
    String? engineerSignature,
    List<MaterialUsed>? materials,
    DateTime? createdAt,
    DateTime? syncedAt,
    bool? isSync,
  }) {
    return MaintenanceReport(
      id: id ?? this.id,
      reportId: reportId ?? this.reportId,
      customerName: customerName ?? this.customerName,
      customerType: customerType ?? this.customerType,
      customerTelephone: customerTelephone ?? this.customerTelephone,
      city: city ?? this.city,
      callVisit: callVisit ?? this.callVisit,
      purpose: purpose ?? this.purpose,
      instrumentName: instrumentName ?? this.instrumentName,
      instrumentManufacturer: instrumentManufacturer ?? this.instrumentManufacturer,
      serialNumber: serialNumber ?? this.serialNumber,
      swVersion: swVersion ?? this.swVersion,
      udDate: udDate ?? this.udDate,
      timeIn: timeIn ?? this.timeIn,
      timeOut: timeOut ?? this.timeOut,
      durationHours: durationHours ?? this.durationHours,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      problemDescription: problemDescription ?? this.problemDescription,
      problemSolved: problemSolved ?? this.problemSolved,
      remedyDescription: remedyDescription ?? this.remedyDescription,
      technicianName: technicianName ?? this.technicianName,
      customerSignature: customerSignature ?? this.customerSignature,
      engineerSignature: engineerSignature ?? this.engineerSignature,
      materials: materials ?? this.materials,
      createdAt: createdAt ?? this.createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
      isSync: isSync ?? this.isSync,
    );
  }

  // Convert to database map
  Map<String, dynamic> toDbMap() {
    return {
      'id': id,
      'report_id': reportId,
      'customer_name': customerName,
      'customer_type': customerType,
      'customer_telephone': customerTelephone,
      'city': city,
      'call_visit': callVisit,
      'purpose': purpose.join(','),
      'instrument_name': instrumentName,
      'instrument_manufacturer': instrumentManufacturer,
      'serial_number': serialNumber,
      'sw_version': swVersion,
      'ud_date': udDate,
      'time_in': timeIn,
      'time_out': timeOut,
      'duration_hours': durationHours,
      'duration_minutes': durationMinutes,
      'problem_description': problemDescription,
      'problem_solved': problemSolved,
      'remedy_description': remedyDescription,
      'technician_name': technicianName,
      'customer_signature': customerSignature,
      'engineer_signature': engineerSignature,
      'created_at': createdAt.toIso8601String(),
      'synced_at': syncedAt?.toIso8601String(),
      'is_sync': isSync ? 1 : 0,
    };
  }

  // Create from database map
  factory MaintenanceReport.fromDbMap(Map<String, dynamic> map) {
    return MaintenanceReport(
      id: map['id'],
      reportId: map['report_id'],
      customerName: map['customer_name'],
      customerType: map['customer_type'],
      customerTelephone: map['customer_telephone'],
      city: map['city'],
      callVisit: map['call_visit'],
      purpose: (map['purpose'] as String).split(','),
      instrumentName: map['instrument_name'],
      instrumentManufacturer: map['instrument_manufacturer'],
      serialNumber: map['serial_number'],
      swVersion: map['sw_version'],
      udDate: map['ud_date'],
      timeIn: map['time_in'],
      timeOut: map['time_out'],
      durationHours: map['duration_hours'],
      durationMinutes: map['duration_minutes'],
      problemDescription: map['problem_description'],
      problemSolved: map['problem_solved'],
      remedyDescription: map['remedy_description'],
      technicianName: map['technician_name'],
      customerSignature: map['customer_signature'],
      engineerSignature: map['engineer_signature'],
      materials: [], // Will be loaded separately
      createdAt: DateTime.parse(map['created_at']),
      syncedAt: map['synced_at'] != null ? DateTime.parse(map['synced_at']) : null,
      isSync: map['is_sync'] == 1,
    );
  }
}

@JsonSerializable()
class MaterialUsed {
  final int? id;
  final String? reportId;
  final String materialNumber;
  final String materialName;
  final int quantity;
  final String remarks;

  MaterialUsed({
    this.id,
    this.reportId,
    required this.materialNumber,
    required this.materialName,
    required this.quantity,
    required this.remarks,
  });

  factory MaterialUsed.fromJson(Map<String, dynamic> json) =>
      _$MaterialUsedFromJson(json);

  Map<String, dynamic> toJson() => _$MaterialUsedToJson(this);

  MaterialUsed copyWith({
    int? id,
    String? reportId,
    String? materialNumber,
    String? materialName,
    int? quantity,
    String? remarks,
  }) {
    return MaterialUsed(
      id: id ?? this.id,
      reportId: reportId ?? this.reportId,
      materialNumber: materialNumber ?? this.materialNumber,
      materialName: materialName ?? this.materialName,
      quantity: quantity ?? this.quantity,
      remarks: remarks ?? this.remarks,
    );
  }

  // Convert to database map
  Map<String, dynamic> toDbMap() {
    return {
      'id': id,
      'report_id': reportId,
      'material_number': materialNumber,
      'material_name': materialName,
      'quantity': quantity,
      'remarks': remarks,
    };
  }

  // Create from database map
  factory MaterialUsed.fromDbMap(Map<String, dynamic> map) {
    return MaterialUsed(
      id: map['id'],
      reportId: map['report_id'],
      materialNumber: map['material_number'],
      materialName: map['material_name'],
      quantity: map['quantity'],
      remarks: map['remarks'],
    );
  }
}

@JsonSerializable()
class User {
  final String username;
  final String role;
  final String firstName;
  final String lastName;
  final String email;
  final String? token;

  User({
    required this.username,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  String get fullName => '$firstName $lastName'.trim();
}

@JsonSerializable()
class AppConfig {
  final List<String> customerTypes;
  final List<String> cities;
  final List<String> manufacturers;
  final List<String> purposes;
  final List<String> technicians;

  AppConfig({
    required this.customerTypes,
    required this.cities,
    required this.manufacturers,
    required this.purposes,
    required this.technicians,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) =>
      _$AppConfigFromJson(json);

  Map<String, dynamic> toJson() => _$AppConfigToJson(this);
} 