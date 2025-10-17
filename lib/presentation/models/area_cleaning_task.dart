class AreaCleaningTask {
  final int id;
  final int areaId;
  final String taskName;
  final String description;
  final bool isCompleted;

  AreaCleaningTask({
    required this.id,
    required this.areaId,
    required this.taskName,
    required this.description,
    this.isCompleted = false,
  });

  factory AreaCleaningTask.fromJson(Map<String, dynamic> json) {
    return AreaCleaningTask(
      id: json['id'] ?? 0,
      areaId: json['area_id'] ?? 0,
      taskName: json['task_name'] ?? '',
      description: json['description'] ?? '',
      isCompleted: json['is_completed'] == 1 || json['is_completed'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'area_id': areaId,
      'task_name': taskName,
      'description': description,
      'is_completed': isCompleted ? 1 : 0,
    };
  }

  AreaCleaningTask copyWith({
    int? id,
    int? areaId,
    String? taskName,
    String? description,
    bool? isCompleted,
  }) {
    return AreaCleaningTask(
      id: id ?? this.id,
      areaId: areaId ?? this.areaId,
      taskName: taskName ?? this.taskName,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
