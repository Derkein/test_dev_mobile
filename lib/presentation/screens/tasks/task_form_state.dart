class TaskFormState {
  final bool isLoading;
  final bool isFormDirty;

  const TaskFormState({
    this.isLoading = true,   // começa carregando os dados
    this.isFormDirty = false,
  });

  TaskFormState copyWith({
    bool? isLoading,
    bool? isFormDirty,
  }) {
    return TaskFormState(
      isLoading:  isLoading  ?? this.isLoading,
      isFormDirty: isFormDirty ?? this.isFormDirty,
    );
  }
}