import '../../../../core/usecases/usecase.dart';
import '../entities/todo_item.dart';
import '../repositories/todo_repository.dart';

class UpdateTodoUseCase implements UseCase<void, TodoItemEntity> {
  final TodoRepository repository;

  UpdateTodoUseCase(this.repository);

  @override
  Future<void> call(TodoItemEntity todo) async {
    return await repository.updateTodo(todo);
  }
}
