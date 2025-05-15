import 'package:test_dev_mobile/data/models/field_model.dart';

class TaskModel {
  final int id;
  final String taskName;
  final String description;
  final List<FieldModel> fields;
  bool isCompleted;

  TaskModel({
    required this.id,
    required this.taskName,
    required this.description,
    required this.fields,
    this.isCompleted = false,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] ?? 0,
      taskName: json['task_name'] ?? '',
      description: json['description'] ?? '',
      fields: (json['fields'] as List<dynamic>?)
              ?.map((field) => FieldModel.fromJson(field))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task_name': taskName,
      'description': description,
      'fields': fields.map((field) => field.toJson()).toList(),
      'is_completed': isCompleted ? 1 : 0,
    };
  }
}