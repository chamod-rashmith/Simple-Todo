import 'package:flutter_test/flutter_test.dart';
import 'package:simple_todo/features/todo/domain/entities/todo_item.dart';
import 'package:simple_todo/features/todo/domain/repositories/todo_repository.dart';
import 'package:simple_todo/features/todo/domain/usecases/update_todo_usecase.dart';

class MockTodoRepository implements TodoRepository {
  TodoItemEntity? lastUpdatedTodo;

  @override
  Future<void> addTodo(TodoItemEntity todo) async {}

  @override
  Future<void> deleteTodo(String id) async {}

  @override
  Future<List<TodoItemEntity>> getTodos() async => [];

  @override
  Future<void> toggleTodoStatus(String id) async {}

  @override
  Future<void> updateTodo(TodoItemEntity todo) async {
    lastUpdatedTodo = todo;
  }
}

void main() {
  test('UpdateTodoUseCase should delegate call to repository.updateTodo', () async {
    final mockRepo = MockTodoRepository();
    final useCase = UpdateTodoUseCase(mockRepo);

    final todo = TodoItemEntity(
      id: 'task_1',
      title: 'Updated Task Title',
      createdAt: DateTime.now(),
    );

    await useCase(todo);

    expect(mockRepo.lastUpdatedTodo, equals(todo));
  });
}
