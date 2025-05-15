import 'package:test_dev_mobile/data/models/task_model.dart';

class UserModel {
  final String name;
  final String profile;
  final List<TaskModel> tasks;

  UserModel({
    required this.name,
    required this.profile,
    required this.tasks,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      profile: json['profile'] ?? '',
      tasks: (json['tasks'] as List<dynamic>?)
              ?.map((task) => TaskModel.fromJson(task))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'profile': profile,
      'tasks': tasks.map((task) => task.toJson()).toList(),
    };
  }
}