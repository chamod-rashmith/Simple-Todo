import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../models/todo_item_model.dart';

abstract class TodoLocalDataSource {
  Future<List<TodoItemModel>> getTodos();
  Future<void> addTodo(TodoItemModel model);
  Future<void> updateTodo(TodoItemModel model);
  Future<void> toggleTodoStatus(String id);
  Future<void> deleteTodo(String id);
}

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  final AppDatabase database;

  TodoLocalDataSourceImpl(this.database);

  @override
  Future<List<TodoItemModel>> getTodos() async {
    final rows = await (database.select(database.todoItemEntries)
          ..orderBy([
            (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
          ]))
        .get();

    return rows.map((row) {
      return TodoItemModel(
        id: row.id,
        title: row.title,
        description: row.description,
        category: row.category,
        isCompleted: row.isCompleted,
        priority: row.priority,
        dueDate: row.dueDate,
        createdAt: row.createdAt,
      );
    }).toList();
  }

  @override
  Future<void> addTodo(TodoItemModel model) async {
    await database.into(database.todoItemEntries).insertOnConflictUpdate(
          TodoItemEntriesCompanion.insert(
            id: model.id,
            title: model.title,
            description: model.description,
            category: model.category,
            isCompleted: Value(model.isCompleted),
            priority: model.priority,
            dueDate: Value(model.dueDate),
            createdAt: model.createdAt,
          ),
        );
  }

  @override
  Future<void> updateTodo(TodoItemModel model) async {
    await (database.update(database.todoItemEntries)
          ..where((t) => t.id.equals(model.id)))
        .write(
      TodoItemEntriesCompanion(
        title: Value(model.title),
        description: Value(model.description),
        category: Value(model.category),
        priority: Value(model.priority),
        dueDate: Value(model.dueDate),
        isCompleted: Value(model.isCompleted),
      ),
    );
  }

  @override
  Future<void> toggleTodoStatus(String id) async {
    final current = await (database.select(database.todoItemEntries)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();

    if (current != null) {
      await (database.update(database.todoItemEntries)
            ..where((t) => t.id.equals(id)))
          .write(
        TodoItemEntriesCompanion(
          isCompleted: Value(!current.isCompleted),
        ),
      );
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    await (database.delete(database.todoItemEntries)
          ..where((t) => t.id.equals(id)))
        .go();
  }
}
