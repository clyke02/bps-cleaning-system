class Petugas {
  final int id;
  final String nama;
  final String username;
  final String phone;
  final String role;
  final String status;
  final DateTime? lastActive;
  final int totalTask;
  final int completedTask;
  final DateTime createdAt;

  Petugas({
    required this.id,
    required this.nama,
    required this.username,
    required this.phone,
    required this.role,
    this.status = 'active',
    this.lastActive,
    this.totalTask = 0,
    this.completedTask = 0,
    required this.createdAt,
  });

  factory Petugas.fromJson(Map<String, dynamic> json) {
    return Petugas(
      id: json['id'],
      nama: json['name'] ?? json['nama'],
      username: json['username'],
      phone: json['phone'],
      role: json['role'],
      status: json['status'] ?? 'active',
      lastActive: json['last_active'] != null
          ? DateTime.parse(json['last_active'])
          : null,
      totalTask: json['total_task'] ?? 0,
      completedTask: json['completed_task'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': nama,
      'username': username,
      'phone': phone,
      'role': role,
      'status': status,
      'last_active': lastActive?.toIso8601String(),
      'total_task': totalTask,
      'completed_task': completedTask,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Petugas copyWith({
    int? id,
    String? nama,
    String? username,
    String? phone,
    String? role,
    String? status,
    DateTime? lastActive,
    int? totalTask,
    int? completedTask,
    DateTime? createdAt,
  }) {
    return Petugas(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      status: status ?? this.status,
      lastActive: lastActive ?? this.lastActive,
      totalTask: totalTask ?? this.totalTask,
      completedTask: completedTask ?? this.completedTask,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Helper getters
  String get displayRole =>
      role == 'admin' ? 'Administrator' : 'Petugas Kebersihan';

  String get statusDisplay {
    switch (status) {
      case 'active':
        return 'Aktif';
      case 'inactive':
        return 'Tidak Aktif';
      default:
        return 'Unknown';
    }
  }

  double get completionRate {
    if (totalTask == 0) return 0.0;
    return completedTask / totalTask;
  }

  String get lastActiveDisplay {
    if (lastActive == null) return 'Belum pernah aktif';

    final now = DateTime.now();
    final difference = now.difference(lastActive!);

    if (difference.inDays > 0) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit yang lalu';
    } else {
      return 'Baru saja';
    }
  }
}
