import '../../../../core/usecases/usecase.dart';
import '../entities/todo_item.dart';
import '../repositories/todo_repository.dart';

class AddTodoUseCase implements UseCase<void, TodoItemEntity> {
  final TodoRepository repository;

  AddTodoUseCase(this.repository);

  @override
  Future<void> call(TodoItemEntity todo) async {
    return await repository.addTodo(todo);
  }
}
