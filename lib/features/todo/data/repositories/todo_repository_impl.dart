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
    final currentModels = await localDataSource.getTodos();
    final newModel = TodoItemModelX.fromEntity(todo);
    final updatedModels = [newModel, ...currentModels];
    await localDataSource.saveTodos(updatedModels);
  }

  @override
  Future<void> toggleTodoStatus(String id) async {
    final currentModels = await localDataSource.getTodos();
    final updatedModels = currentModels.map((model) {
      if (model.id == id) {
        final entity = model.toEntity();
        final updatedEntity = entity.copyWith(isCompleted: !entity.isCompleted);
        return TodoItemModelX.fromEntity(updatedEntity);
      }
      return model;
    }).toList();
    await localDataSource.saveTodos(updatedModels);
  }

  @override
  Future<void> deleteTodo(String id) async {
    final currentModels = await localDataSource.getTodos();
    final updatedModels = currentModels.where((model) => model.id != id).toList();
    await localDataSource.saveTodos(updatedModels);
  }
}
