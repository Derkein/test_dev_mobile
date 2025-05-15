class TaskResponseModel {
  final int id;
  final int taskId;
  final String fieldLabel;
  final String fieldValue;
  final DateTime createdAt;

  TaskResponseModel({
    required this.id,
    required this.taskId,
    required this.fieldLabel,
    required this.fieldValue,
    required this.createdAt,
  });

  factory TaskResponseModel.fromJson(Map<String, dynamic> json) {
    return TaskResponseModel(
      id: json['id'] ?? 0,
      taskId: json['task_id'] ?? 0,
      fieldLabel: json['field_label'] ?? '',
      fieldValue: json['field_value'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task_id': taskId,
      'field_label': fieldLabel,
      'field_value': fieldValue,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'task_id': taskId,
      'field_label': fieldLabel,
      'field_value': fieldValue,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory TaskResponseModel.fromMap(Map<String, dynamic> map) {
    return TaskResponseModel(
      id: map['id'] ?? 0,
      taskId: map['task_id'] ?? 0,
      fieldLabel: map['field_label'] ?? '',
      fieldValue: map['field_value'] ?? '',
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
    );
  }
}