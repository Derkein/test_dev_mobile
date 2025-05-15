import '../../../data/models/user_model.dart';

class HomeState {
  final bool isLoading;
  final UserModel? user;
  final List<int> completedTaskIds;
  final String errorMessage;

  const HomeState({
    this.isLoading = false,
    this.user,
    this.completedTaskIds = const [],
    this.errorMessage = '',
  });

  HomeState copyWith({
    bool? isLoading,
    UserModel? user,
    List<int>? completedTaskIds,
    String? errorMessage,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      completedTaskIds: completedTaskIds ?? this.completedTaskIds,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}