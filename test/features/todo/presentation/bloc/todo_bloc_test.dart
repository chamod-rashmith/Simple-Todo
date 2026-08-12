import 'package:flutter_test/flutter_test.dart';
import 'package:simple_todo/features/todo/domain/entities/todo_item.dart';
import 'package:simple_todo/features/todo/domain/repositories/todo_repository.dart';
import 'package:simple_todo/features/todo/domain/usecases/add_todo_usecase.dart';
import 'package:simple_todo/features/todo/domain/usecases/delete_todo_usecase.dart';
import 'package:simple_todo/features/todo/domain/usecases/get_todos_usecase.dart';
import 'package:simple_todo/features/todo/domain/usecases/toggle_todo_usecase.dart';
import 'package:simple_todo/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:simple_todo/features/todo/presentation/bloc/todo_event.dart';
import 'package:simple_todo/features/todo/presentation/bloc/todo_state.dart';

class FakeTodoRepository implements TodoRepository {
  final List<TodoItemEntity> _todos = [];

  @override
  Future<List<TodoItemEntity>> getTodos() async => List.unmodifiable(_todos);

  @override
  Future<void> addTodo(TodoItemEntity todo) async {
    _todos.insert(0, todo);
  }

  @override
  Future<void> toggleTodoStatus(String id) async {
    final idx = _todos.indexWhere((t) => t.id == id);
    if (idx != -1) {
      _todos[idx] = _todos[idx].copyWith(isCompleted: !_todos[idx].isCompleted);
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    _todos.removeWhere((t) => t.id == id);
  }
}

void main() {
  late TodoBloc bloc;
  late FakeTodoRepository repository;

  setUp(() {
    repository = FakeTodoRepository();
    bloc = TodoBloc(
      getTodosUseCase: GetTodosUseCase(repository),
      addTodoUseCase: AddTodoUseCase(repository),
      toggleTodoUseCase: ToggleTodoUseCase(repository),
      deleteTodoUseCase: DeleteTodoUseCase(repository),
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state should be TodoState.initial', () {
    expect(bloc.state.status, equals(TodoStatus.initial));
  });

  test('LoadTodosEvent emits loaded status with todos', () async {
    final now = DateTime.now();
    await repository.addTodo(TodoItemEntity(
      id: '1',
      title: 'Test Task',
      createdAt: now,
    ));

    bloc.add(LoadTodosEvent());

    await expectLater(
      bloc.stream,
      emitsInOrder([
        predicate<TodoState>((s) => s.status == TodoStatus.loading),
        predicate<TodoState>(
          (s) => s.status == TodoStatus.loaded && s.todos.length == 1,
        ),
      ]),
    );
  });
}
