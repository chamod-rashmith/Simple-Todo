import 'package:flutter_test/flutter_test.dart';
import 'package:simple_todo/core/services/notification_service.dart';
import 'package:simple_todo/features/notification/domain/entities/notification_item.dart';
import 'package:simple_todo/features/notification/domain/repositories/notification_repository.dart';
import 'package:simple_todo/features/notification/domain/usecases/cancel_notification_usecase.dart';
import 'package:simple_todo/features/notification/domain/usecases/request_permission_usecase.dart';
import 'package:simple_todo/features/notification/domain/usecases/schedule_notification_usecase.dart';
import 'package:simple_todo/features/notification/domain/usecases/show_instant_notification_usecase.dart';
import 'package:simple_todo/features/todo/domain/entities/todo_item.dart';
import 'package:simple_todo/features/todo/domain/repositories/todo_repository.dart';
import 'package:simple_todo/features/todo/domain/usecases/add_todo_usecase.dart';
import 'package:simple_todo/features/todo/domain/usecases/delete_todo_usecase.dart';
import 'package:simple_todo/features/todo/domain/usecases/get_todos_usecase.dart';
import 'package:simple_todo/features/todo/domain/usecases/toggle_todo_usecase.dart';
import 'package:simple_todo/features/todo/domain/usecases/update_todo_usecase.dart';
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
  Future<void> updateTodo(TodoItemEntity todo) async {
    final idx = _todos.indexWhere((t) => t.id == todo.id);
    if (idx != -1) {
      _todos[idx] = todo;
    }
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

class FakeNotificationRepository implements NotificationRepository {
  @override
  Future<void> cancelAllNotifications() async {}

  @override
  Future<void> cancelNotification(String id) async {}

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<void> scheduleNotification(NotificationItemEntity notification) async {}

  @override
  Future<void> showInstantNotification(NotificationItemEntity notification) async {}
}

void main() {
  late TodoBloc bloc;
  late FakeTodoRepository repository;
  late FakeNotificationRepository notificationRepository;
  late NotificationService notificationService;

  setUp(() {
    repository = FakeTodoRepository();
    notificationRepository = FakeNotificationRepository();
    notificationService = NotificationService(
      scheduleNotificationUseCase: ScheduleNotificationUseCase(notificationRepository),
      cancelNotificationUseCase: CancelNotificationUseCase(notificationRepository),
      requestPermissionUseCase: RequestNotificationPermissionUseCase(notificationRepository),
      showInstantNotificationUseCase: ShowInstantNotificationUseCase(notificationRepository),
    );

    bloc = TodoBloc(
      getTodosUseCase: GetTodosUseCase(repository),
      addTodoUseCase: AddTodoUseCase(repository),
      updateTodoUseCase: UpdateTodoUseCase(repository),
      toggleTodoUseCase: ToggleTodoUseCase(repository),
      deleteTodoUseCase: DeleteTodoUseCase(repository),
      notificationService: notificationService,
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
      title: 'Buy Groceries',
      category: 'Personal',
      createdAt: now,
    ));

    expectLater(
      bloc.stream,
      emitsInOrder([
        predicate<TodoState>((s) => s.status == TodoStatus.loading),
        predicate<TodoState>((s) =>
            s.status == TodoStatus.loaded &&
            s.todos.length == 1 &&
            s.todos.first.title == 'Buy Groceries'),
      ]),
    );

    bloc.add(LoadTodosEvent());
  });

  test('UpdateTodoEvent modifies existing todo in repository and reloads', () async {
    final now = DateTime.now();
    final original = TodoItemEntity(
      id: '1',
      title: 'Initial Title',
      category: 'Work',
      createdAt: now,
    );
    await repository.addTodo(original);

    final updated = original.copyWith(title: 'Updated Title', category: 'Design');

    bloc.add(UpdateTodoEvent(updated));
    await pumpEventQueue();

    final todos = await repository.getTodos();
    expect(todos.first.title, equals('Updated Title'));
    expect(todos.first.category, equals('Design'));
  });

  test('Daily progress calculates stats correctly for today tasks', () async {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));

    // Task 1: Assigned for today, completed
    await repository.addTodo(TodoItemEntity(
      id: '1',
      title: 'Today Task Done',
      assignedDate: now,
      isCompleted: true,
      createdAt: now,
    ));

    // Task 2: Assigned for today, incomplete
    await repository.addTodo(TodoItemEntity(
      id: '2',
      title: 'Today Task Pending',
      assignedDate: now,
      isCompleted: false,
      createdAt: now,
    ));

    // Task 3: Assigned for tomorrow (should NOT count towards today's daily progress)
    await repository.addTodo(TodoItemEntity(
      id: '3',
      title: 'Tomorrow Task',
      assignedDate: tomorrow,
      isCompleted: false,
      createdAt: now,
    ));

    bloc.add(LoadTodosEvent());
    await pumpEventQueue();

    expect(bloc.state.todos.length, equals(3));
    expect(bloc.state.todayTotalCount, equals(2));
    expect(bloc.state.todayCompletedCount, equals(1));
    expect(bloc.state.todayCompletionRatio, equals(0.5));
  });

  test('FilterDateEvent filters todos by today and upcoming', () async {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));

    await repository.addTodo(TodoItemEntity(
      id: '1',
      title: 'Today Task',
      assignedDate: now,
      createdAt: now,
    ));

    await repository.addTodo(TodoItemEntity(
      id: '2',
      title: 'Tomorrow Task',
      assignedDate: tomorrow,
      createdAt: now,
    ));

    bloc.add(LoadTodosEvent());
    await pumpEventQueue();

    // Filter by Today
    bloc.add(const FilterDateEvent('today'));
    await pumpEventQueue();
    expect(bloc.state.filteredTodos.length, equals(1));
    expect(bloc.state.filteredTodos.first.title, equals('Today Task'));

    // Filter by Upcoming
    bloc.add(const FilterDateEvent('upcoming'));
    await pumpEventQueue();
    expect(bloc.state.filteredTodos.length, equals(1));
    expect(bloc.state.filteredTodos.first.title, equals('Tomorrow Task'));

    // Filter by All
    bloc.add(const FilterDateEvent('all'));
    await pumpEventQueue();
    expect(bloc.state.filteredTodos.length, equals(2));
  });
}

