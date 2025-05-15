import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:test_dev_mobile/data/models/task_reponse_model.dart';

class TaskRepository {
  final Database _database;

  TaskRepository(this._database);

  // Save task response
  Future<int> saveTaskResponse(TaskResponseModel response) async {
    try {
      return await _database.insert(
        'task_responses',
        response.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      log('Error saving task response: $e');
      return -1;
    }
  }

  // Mark task as completed
  Future<bool> markTaskAsCompleted(int taskId) async {
    try {
      await _database.insert(
        'completed_tasks',
        {
          'task_id': taskId,
          'completed_at': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } catch (e) {
      log('Error marking task as completed: $e');
      return false;
    }
  }

  // Check if task is completed
  Future<bool> isTaskCompleted(int taskId) async {
    try {
      final result = await _database.query(
        'completed_tasks',
        where: 'task_id = ?',
        whereArgs: [taskId],
      );
      return result.isNotEmpty;
    } catch (e) {
      log('Error checking task completion: $e');
      return false;
    }
  }

  // Get all completed task IDs
  Future<List<int>> getCompletedTaskIds() async {
    try {
      final result = await _database.query('completed_tasks');
      return result.map((map) => map['task_id'] as int).toList();
    } catch (e) {
      log('Error getting completed tasks: $e');
      return [];
    }
  }

  // Save form state for when app goes to background
  Future<void> saveFormState(int taskId, int fieldId, String value) async {
    try {
      await _database.insert(
        'form_state',
        {
          'task_id': taskId,
          'field_id': fieldId,
          'field_value': value,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
     log('Error saving form state: $e');
    }
  }

  // Get saved form state
  Future<Map<int, String>> getFormState(int taskId) async {
    try {
      final result = await _database.query(
        'form_state',
        where: 'task_id = ?',
        whereArgs: [taskId],
      );
      
      Map<int, String> formState = {};
      for (var item in result) {
        formState[item['field_id'] as int] = item['field_value'] as String;
      }
      
      return formState;
    } catch (e) {
      log('Error getting form state: $e');
      return {};
    }
  }

  // Clear form state
  Future<void> clearFormState(int taskId) async {
    try {
      await _database.delete(
        'form_state',
        where: 'task_id = ?',
        whereArgs: [taskId],
      );
    } catch (e) {
      log('Error clearing form state: $e');
    }
  }

  // Get all responses for a task
  Future<List<TaskResponseModel>> getTaskResponses(int taskId) async {
    try {
      final result = await _database.query(
        'task_responses',
        where: 'task_id = ?',
        whereArgs: [taskId],
      );
      
      return result.map((map) => TaskResponseModel.fromMap(map)).toList();
    } catch (e) {
      log('Error getting task responses: $e');
      return [];
    }
  }
}