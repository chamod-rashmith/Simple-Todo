import '../entities/todo_item.dart';

abstract class TodoRepository {
  Future<List<TodoItemEntity>> getTodos();
  Future<void> addTodo(TodoItemEntity todo);
  Future<void> updateTodo(TodoItemEntity todo);
  Future<void> toggleTodoStatus(String id);
  Future<void> deleteTodo(String id);
}
