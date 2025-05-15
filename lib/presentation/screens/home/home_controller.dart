import 'package:flutter/material.dart';
import 'package:test_dev_mobile/presentation/screens/login/login_view.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/login_repository.dart';
import '../../../data/repositories/task_repository.dart';
import 'home_state.dart';

class HomeController extends ChangeNotifier {
  final LoginRepository _loginRepository;
  final TaskRepository _taskRepository;

  HomeState _state = const HomeState(isLoading: true);
  HomeState get state => _state;

  HomeController(this._loginRepository, this._taskRepository);

  /// Carrega usuário e tarefas concluídas
  Future<void> loadUserAndTasks() async {
    _updateState(isLoading: true, errorMessage: '');
    try {
      final user = await _loginRepository.getUser();
      final completed = await _taskRepository.getCompletedTaskIds();
      _updateState(
        isLoading: false,
        user: user,
        completedTaskIds: completed,
      );
    } catch (e) {
      _updateState(
        isLoading: false,
        errorMessage: 'Erro ao carregar dados: ${e.toString()}',
      );
    }
  }

  /// Desloga e navega para a tela de login
  Future<void> logout(BuildContext context) async {
  final navigator = Navigator.of(context);

  await _loginRepository.logout();

  navigator.pushReplacement(
    MaterialPageRoute(builder: (_) => const LoginView()),
  );
}

  void _updateState({
    bool? isLoading,
    UserModel? user,
    List<int>? completedTaskIds,
    String? errorMessage,
  }) {
    _state = _state.copyWith(
      isLoading: isLoading,
      user: user,
      completedTaskIds: completedTaskIds,
      errorMessage: errorMessage,
    );
    notifyListeners();
  }
}