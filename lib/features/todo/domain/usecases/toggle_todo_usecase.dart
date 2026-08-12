import '../../../../core/usecases/usecase.dart';
import '../repositories/todo_repository.dart';

class ToggleTodoUseCase implements UseCase<void, String> {
  final TodoRepository repository;

  ToggleTodoUseCase(this.repository);

  @override
  Future<void> call(String todoId) async {
    return await repository.toggleTodoStatus(todoId);
  }
}
