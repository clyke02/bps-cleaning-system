import 'dart:io';

class CleaningReport {
  final int? id;
  final int areaId;
  final int userId;
  final String areaName;
  final String lantai;
  final String nomorRuangan;
  final List<int> completedTaskIds;
  final List<File> photoBukti;
  final String catatanPembersihan;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CleaningReport({
    this.id,
    required this.areaId,
    required this.userId,
    required this.areaName,
    required this.lantai,
    required this.nomorRuangan,
    required this.completedTaskIds,
    required this.photoBukti,
    required this.catatanPembersihan,
    this.status = 'pending',
    this.createdAt,
    this.updatedAt,
  });

  factory CleaningReport.fromJson(Map<String, dynamic> json) {
    return CleaningReport(
      id: json['id'],
      areaId: json['area_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      areaName: json['area_name'] ?? '',
      lantai: json['lantai'] ?? '',
      nomorRuangan: json['nomor_ruangan'] ?? '',
      completedTaskIds: List<int>.from(json['completed_task_ids'] ?? []),
      photoBukti: [], // Files will be handled separately
      catatanPembersihan: json['catatan_pembersihan'] ?? '',
      status: json['status'] ?? 'pending',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'area_id': areaId,
      'user_id': userId,
      'area_name': areaName,
      'lantai': lantai,
      'nomor_ruangan': nomorRuangan,
      'completed_task_ids': completedTaskIds,
      'catatan_pembersihan': catatanPembersihan,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
