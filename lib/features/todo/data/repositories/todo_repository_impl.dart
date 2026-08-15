import '../../domain/entities/todo_item.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_local_datasource.dart';
import '../models/todo_item_model.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource localDataSource;

  TodoRepositoryImpl(this.localDataSource);

  @override
  Future<List<TodoItemEntity>> getTodos() async {
    final models = await localDataSource.getTodos();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> addTodo(TodoItemEntity todo) async {
    final model = TodoItemModelX.fromEntity(todo);
    await localDataSource.addTodo(model);
  }

  @override
  Future<void> updateTodo(TodoItemEntity todo) async {
    final model = TodoItemModelX.fromEntity(todo);
    await localDataSource.updateTodo(model);
  }

  @override
  Future<void> toggleTodoStatus(String id) async {
    await localDataSource.toggleTodoStatus(id);
  }

  @override
  Future<void> deleteTodo(String id) async {
    await localDataSource.deleteTodo(id);
  }
}
