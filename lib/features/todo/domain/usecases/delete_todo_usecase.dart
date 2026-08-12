import '../../../../core/usecases/usecase.dart';
import '../repositories/todo_repository.dart';

class DeleteTodoUseCase implements UseCase<void, String> {
  final TodoRepository repository;

  DeleteTodoUseCase(this.repository);

  @override
  Future<void> call(String todoId) async {
    return await repository.deleteTodo(todoId);
  }
}
