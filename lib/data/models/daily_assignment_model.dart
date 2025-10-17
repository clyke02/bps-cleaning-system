class DailyAssignment {
  final int id;
  final int userId;
  final int areaId;
  final String assignmentDate;
  final String status; // pending, completed, missed
  final int? reportId;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Related objects
  final Map<String, dynamic>? user;
  final Map<String, dynamic>? area;
  final Map<String, dynamic>? report;

  DailyAssignment({
    required this.id,
    required this.userId,
    required this.areaId,
    required this.assignmentDate,
    required this.status,
    this.reportId,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.area,
    this.report,
  });

  factory DailyAssignment.fromJson(Map<String, dynamic> json) {
    return DailyAssignment(
      id: json['id'],
      userId: json['user_id'],
      areaId: json['area_id'],
      assignmentDate: json['assignment_date'],
      status: json['status'],
      reportId: json['report_id'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: json['user'],
      area: json['area'],
      report: json['report'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'area_id': areaId,
      'assignment_date': assignmentDate,
      'status': status,
      'report_id': reportId,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user': user,
      'area': area,
      'report': report,
    };
  }

  // Helper methods
  bool get isPending => status == 'pending';
  bool get isCompleted => status == 'completed';
  bool get isMissed => status == 'missed';
  bool get isRejected => status == 'rejected';

  String get statusText {
    switch (status) {
      case 'pending':
        // Check if has report - if yes, it's "In Review", otherwise "Belum Lapor"
        return reportId != null ? 'In Review' : 'Belum Lapor';
      case 'completed':
        return 'Disetujui';
      case 'rejected':
        return 'Ditolak';
      case 'missed':
        return 'Ditolak';
      default:
        return status;
    }
  }

  String get areaName => area?['name'] ?? 'Area $areaId';
  String get areaDescription => area?['description'] ?? '';
}
