import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/task_repository.dart';
import '../../widgets/task_item.dart';
import '../tasks/task_form_view.dart';
import 'home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeController>(
      create: (ctx) {
        final authRepo = ctx.read<AuthRepository>();
        final taskRepo = ctx.read<TaskRepository>();
        final ctrl = HomeController(authRepo, taskRepo);
        // dispara a carga inicial
        ctrl.loadUserAndTasks();
        return ctrl;
      },
      child: Consumer<HomeController>(
        builder: (ctx, controller, _) {
          final state = controller.state;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Minhas Tarefas'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () => controller.logout(ctx),
                ),
              ],
            ),
            body: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.errorMessage.isNotEmpty
                    ? Center(child: Text(state.errorMessage))
                    : RefreshIndicator(
                        onRefresh: controller.loadUserAndTasks,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (state.user != null) ...[
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Olá, ${state.user!.name}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Perfil: ${state.user!.profile}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(),
                            ],
                            Expanded(
                              child: (state.user?.tasks.isEmpty ?? true)
                                  ? const Center(
                                      child: Text('Nenhuma tarefa disponível'),
                                    )
                                  : ListView.builder(
                                      padding: const EdgeInsets.all(8.0),
                                      itemCount: state.user!.tasks.length,
                                      itemBuilder: (context, index) {
                                        final task =
                                            state.user!.tasks[index];
                                        final isCompleted =
                                            state.completedTaskIds
                                                .contains(task.id);

                                        return TaskItem(
                                          task: task,
                                          isCompleted: isCompleted,
                                          onTap: () async {
                                            final result =
                                                await Navigator.of(context)
                                                    .push(
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    TaskFormView(
                                                        task: task),
                                              ),
                                            );
                                            if (result == true) {
                                              controller.loadUserAndTasks();
                                            }
                                          },
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
          );
        },
      ),
    );
  }
}
