import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/loading_overlay.dart';
import 'login_controller.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginController(
        Provider.of(context, listen: false), // injeta LoginRepository
      ),
      child: Consumer<LoginController>(
        builder: (context, controller, _) {
          final state = controller.state;

          return LoadingOverlay(
            isLoading: state.isLoading,
            child: Scaffold(
              body: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 24),
                          const Icon(Icons.account_circle,
                              size: 100, color: Colors.blue),
                          const SizedBox(height: 24),
                          const Text(
                            'Login',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 48),
                          TextFormField(
                            controller: controller.usernameController,
                            decoration: const InputDecoration(
                              labelText: 'Usuário',
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: controller.passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Senha',
                              prefixIcon: Icon(Icons.lock),
                            ),
                            obscureText: true,
                          ),
                          const SizedBox(height: 24),
                          if (state.errorMessage.isNotEmpty)
                            Text(
                              state.errorMessage,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => controller.login(context),
                            child: const Text('ENTRAR'),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton(
                            onPressed: () => controller.resetDatabase(context),
                            child: const Text('RESETAR BANCO LOCAL'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
