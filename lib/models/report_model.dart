class Report {
  final int id;
  final String title;
  final String petugas;
  final String tanggal;
  final ReportStatus status;
  final String? catatanPetugas;
  final String? catatanAdmin;
  final List<String> imagePaths;
  final int areaId;
  final List<CleaningTask> tasks;

  Report({
    required this.id,
    required this.title,
    required this.petugas,
    required this.tanggal,
    required this.status,
    this.catatanPetugas,
    this.catatanAdmin,
    this.imagePaths = const [],
    required this.areaId,
    this.tasks = const [],
  });

  Report copyWith({
    int? id,
    String? title,
    String? petugas,
    String? tanggal,
    ReportStatus? status,
    String? catatanPetugas,
    String? catatanAdmin,
    List<String>? imagePaths,
    int? areaId,
    List<CleaningTask>? tasks,
  }) {
    return Report(
      id: id ?? this.id,
      title: title ?? this.title,
      petugas: petugas ?? this.petugas,
      tanggal: tanggal ?? this.tanggal,
      status: status ?? this.status,
      catatanPetugas: catatanPetugas ?? this.catatanPetugas,
      catatanAdmin: catatanAdmin ?? this.catatanAdmin,
      imagePaths: imagePaths ?? this.imagePaths,
      areaId: areaId ?? this.areaId,
      tasks: tasks ?? this.tasks,
    );
  }

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      petugas: json['petugas'] ?? '',
      tanggal: json['tanggal'] ?? '',
      status: ReportStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => ReportStatus.menunggu,
      ),
      catatanPetugas: json['catatan_petugas'],
      catatanAdmin: json['catatan_admin'],
      imagePaths: List<String>.from(json['image_paths'] ?? []),
      areaId: json['area_id'] ?? 0,
      tasks: (json['tasks'] as List<dynamic>?)
              ?.map((task) => CleaningTask.fromJson(task))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'petugas': petugas,
      'tanggal': tanggal,
      'status': status.toString().split('.').last,
      'catatan_petugas': catatanPetugas,
      'catatan_admin': catatanAdmin,
      'image_paths': imagePaths,
      'area_id': areaId,
      'tasks': tasks.map((task) => task.toJson()).toList(),
    };
  }
}

enum ReportStatus {
  menunggu,
  selesai,
  ditolak,
}

extension ReportStatusExtension on ReportStatus {
  String get displayName {
    switch (this) {
      case ReportStatus.menunggu:
        return 'Menunggu';
      case ReportStatus.selesai:
        return 'Selesai';
      case ReportStatus.ditolak:
        return 'Ditolak';
    }
  }

  String get colorCode {
    switch (this) {
      case ReportStatus.menunggu:
        return 'orange';
      case ReportStatus.selesai:
        return 'green';
      case ReportStatus.ditolak:
        return 'red';
    }
  }
}

class CleaningTask {
  final int id;
  final String description;
  final bool isCompleted;

  CleaningTask({
    required this.id,
    required this.description,
    this.isCompleted = false,
  });

  CleaningTask copyWith({
    int? id,
    String? description,
    bool? isCompleted,
  }) {
    return CleaningTask(
      id: id ?? this.id,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  factory CleaningTask.fromJson(Map<String, dynamic> json) {
    return CleaningTask(
      id: json['id'] ?? 0,
      description: json['description'] ?? '',
      isCompleted: json['is_completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'is_completed': isCompleted,
    };
  }
}