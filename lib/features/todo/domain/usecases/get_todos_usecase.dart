import '../../../../core/usecases/usecase.dart';
import '../entities/todo_item.dart';
import '../repositories/todo_repository.dart';

class GetTodosUseCase implements UseCase<List<TodoItemEntity>, NoParams> {
  final TodoRepository repository;

  GetTodosUseCase(this.repository);

  @override
  Future<List<TodoItemEntity>> call(NoParams params) async {
    return await repository.getTodos();
  }
}
