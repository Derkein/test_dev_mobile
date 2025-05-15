import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:test_dev_mobile/presentation/screens/home/home_view.dart';
import '../../../data/repositories/login_repository.dart';
import 'login_state.dart';

class LoginController extends ChangeNotifier {
  final LoginRepository _loginRepository;

  // Estado interno
  LoginState _state = const LoginState();
  LoginState get state => _state;

  // Text controllers (você pode pré-preencher aqui)
  final usernameController = TextEditingController(text: 'teste.mobile');
  final passwordController = TextEditingController(text: '1234');

  LoginController(this._loginRepository);

  // Método de login
  Future<void> login(BuildContext context) async {
    if (_state.isLoading) return;

    // validações básicas
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      _updateState(errorMessage: 'Usuário e senha são obrigatórios.');
      return;
    }

    // captura navigator ANTES do await
    final navigator = Navigator.of(context);

    _updateState(isLoading: true, errorMessage: '');

    try {
      final success = await _loginRepository.login(
        usernameController.text,
        passwordController.text,
      );

      if (success) {
        navigator.pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeView()),
        );
      } else {
        _updateState(errorMessage: 'Credenciais inválidas.');
      }
    } catch (e) {
      _updateState(errorMessage: 'Erro de conexão. Tente mais tarde.');
      log('Error login with correct credentials: $e');
    } finally {
      _updateState(isLoading: false);
    }
  }

// Método de reset do banco local
  Future<void> resetDatabase(BuildContext context) async {
    if (_state.isLoading) return;

    _updateState(isLoading: true);

    // captura o messenger ANTES do await
    final messenger = ScaffoldMessenger.of(context);

    try {
      final databasesPath = await getDatabasesPath();
      final dbPath = p.join(databasesPath, 'mundo_wap_tasks.db');
      await deleteDatabase(dbPath);

      messenger.showSnackBar(
        const SnackBar(content: Text('Banco local resetado com sucesso.')),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Falha ao resetar banco: $e')),
      );
    } finally {
      _updateState(isLoading: false);
    }
  }

  // Atualiza o state e notifica view
  void _updateState({bool? isLoading, String? errorMessage}) {
    _state = _state.copyWith(
      isLoading: isLoading,
      errorMessage: errorMessage,
    );
    notifyListeners();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
