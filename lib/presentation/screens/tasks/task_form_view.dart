import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:test_dev_mobile/data/models/task_model.dart';
import '../../../core/utils/input_formatters.dart';
import '../../../data/repositories/task_repository.dart';
import '../../widgets/loading_overlay.dart';
import 'task_form_controller.dart';

class TaskFormView extends StatelessWidget {
  final TaskModel task;
  const TaskFormView({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TaskFormController>(
      create: (ctx) => TaskFormController(
        ctx.read<TaskRepository>(),
        task,
      ),
      child: Consumer<TaskFormController>(
        builder: (ctx, controller, _) {
          final state = controller.state;

          return LoadingOverlay(
            isLoading: state.isLoading,
            child: Scaffold(
              appBar: AppBar(
                title: Text(task.taskName),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    controller.saveFormState();
                    Navigator.of(context).pop();
                  },
                ),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.description,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 24),
                      ...task.fields.map((field) {
                        final ctrl = controller.controllers[field.id]!;

                        // define tipo de teclado e formatadores
                        TextInputType keyboardType = TextInputType.text;
                        List<TextInputFormatter>? inputFormatters;
                        String? hint;
                        if (field.fieldType == 'mask_price') {
                          keyboardType = const TextInputType.numberWithOptions(
                              decimal: true);
                          inputFormatters = [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9.,]')),
                            PriceInputFormatter(),
                          ];
                          hint = 'Ex: R\$ 10,50';
                        } else if (field.fieldType == 'mask_date') {
                          keyboardType = TextInputType.datetime;
                          inputFormatters = [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9/]')),
                            DateInputFormatter(),
                          ];
                          hint = 'Ex: 01/01/2023';
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: ctrl,
                            decoration: InputDecoration(
                              labelText: field.label,
                              hintText: hint,
                            ),
                            keyboardType: keyboardType,
                            inputFormatters: inputFormatters,
                            validator: (val) {
                              if (field.required &&
                                  (val == null || val.isEmpty)) {
                                return 'Este campo é obrigatório';
                              }
                              if (field.fieldType == 'mask_date' &&
                                  val != null &&
                                  val.isNotEmpty) {
                                if (!RegExp(r'^(\d{2}/\d{2}/\d{4})$')
                                    .hasMatch(val)) {
                                  return 'Formato de data inválido. Use DD/MM/AAAA';
                                }
                                if (!controller.isValidDate(val)) {
                                  return 'Data inválida. Insira uma data real.';
                                }
                              }

                              return null;
                            },
                            onChanged: (_) {
                              controller.updateState(isFormDirty: true);
                            },
                          ),
                        );
                      }),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => controller.submitForm(ctx),
                          child: const Text('SALVAR'),
                        ),
                      ),
                    ],
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
