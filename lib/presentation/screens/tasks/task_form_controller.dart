import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_dev_mobile/data/models/field_model.dart';
import 'package:test_dev_mobile/data/models/task_model.dart';
import '../../../data/models/task_reponse_model.dart';
import '../../../data/repositories/task_repository.dart';
import 'task_form_state.dart';

class TaskFormController extends ChangeNotifier with WidgetsBindingObserver {
  final TaskRepository _taskRepository;
  final TaskModel task;

  TaskFormState _state = const TaskFormState();
  TaskFormState get state => _state;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Map<int, TextEditingController> controllers = {};

  TaskFormController(this._taskRepository, this.task) {
    WidgetsBinding.instance.addObserver(this);
    _initialize();
  }

  Future<void> _initialize() async {
    _initControllers();
    await loadForm();
  }

  void _initControllers() {
    for (var field in task.fields) {
      controllers[field.id] = TextEditingController();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      saveFormState();
    }
  }

  Future<void> loadForm() async {
    updateState(isLoading: true);

    // 1) Carrega estado temporário
    final formState = await _taskRepository.getFormState(task.id);
    if (formState.isNotEmpty) {
      formState.forEach((fieldId, value) {
        controllers[fieldId]?.text = value;
      });
      updateState(isFormDirty: true);
    } else {
      // 2) Se NÃO existe estado temporário, carrega respostas já salvas
      final responses = await _taskRepository.getTaskResponses(task.id);
      for (var resp in responses) {
        FieldModel? match;
        try {
          match = task.fields.firstWhere((f) => f.label == resp.fieldLabel);
        } catch (_) {
          match = null;
        }
        if (match != null) {
          controllers[match.id]!.text = resp.fieldValue;
        }
      }
      if (responses.isNotEmpty) {
        updateState(isFormDirty: true);
      }
    }

    updateState(isLoading: false);
  }

  Future<void> saveFormState() async {
    if (!_state.isFormDirty) return;
    for (var field in task.fields) {
      final text = controllers[field.id]?.text ?? '';
      await _taskRepository.saveFormState(
        task.id,
        field.id,
        text,
      );
    }
  }

  Future<void> submitForm(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    updateState(isLoading: true);

    try {
      // salva cada resposta
      for (var field in task.fields) {
        final resp = TaskResponseModel(
          id: 0,
          taskId: task.id,
          fieldLabel: field.label,
          fieldValue: controllers[field.id]!.text,
          createdAt: DateTime.now(),
        );
        await _taskRepository.saveTaskResponse(resp);
      }
      // marca concluída
      await _taskRepository.markTaskAsCompleted(task.id);
      // limpa estado temporário
      await _taskRepository.clearFormState(task.id);

      navigator.pop(true);
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar tarefa: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      updateState(isLoading: false);
    }
  }

  void updateState({
    bool? isLoading,
    bool? isFormDirty,
  }) {
    _state = _state.copyWith(
      isLoading: isLoading,
      isFormDirty: isFormDirty,
    );
    notifyListeners();
  }

  bool isValidDate(String input) {
    try {
      DateFormat('dd/MM/yyyy').parseStrict(input);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    for (var c in controllers.values) {
      c.dispose();
    }
    super.dispose();
  }
}
