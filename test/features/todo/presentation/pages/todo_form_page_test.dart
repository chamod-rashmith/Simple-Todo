import 'package:drift/native.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:simple_todo/core/database/app_database.dart';
import 'package:simple_todo/core/di/injection_container.dart';
import 'package:simple_todo/core/di/modules/todo_module.dart';
import 'package:simple_todo/core/services/notification_service.dart';
import 'package:simple_todo/core/theme/app_theme.dart';
import 'package:simple_todo/features/notification/domain/entities/notification_item.dart';
import 'package:simple_todo/features/notification/domain/repositories/notification_repository.dart';
import 'package:simple_todo/features/notification/domain/usecases/cancel_notification_usecase.dart';
import 'package:simple_todo/features/notification/domain/usecases/request_permission_usecase.dart';
import 'package:simple_todo/features/notification/domain/usecases/schedule_notification_usecase.dart';
import 'package:simple_todo/features/notification/domain/usecases/show_instant_notification_usecase.dart';
import 'package:simple_todo/features/todo/domain/entities/todo_item.dart';
import 'package:simple_todo/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:simple_todo/features/todo/presentation/pages/todo_form_page.dart';

class _FakeNotificationRepository implements NotificationRepository {
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
  setUp(() async {
    await sl.reset();
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    sl.registerLazySingleton<AppDatabase>(() => db);

    final notifRepo = _FakeNotificationRepository();
    sl.registerLazySingleton<NotificationService>(
      () => NotificationService(
        scheduleNotificationUseCase: ScheduleNotificationUseCase(notifRepo),
        cancelNotificationUseCase: CancelNotificationUseCase(notifRepo),
        requestPermissionUseCase: RequestNotificationPermissionUseCase(notifRepo),
        showInstantNotificationUseCase: ShowInstantNotificationUseCase(notifRepo),
      ),
    );

    initTodoModule(sl);
  });

  tearDown(() async {
    await sl<AppDatabase>().close();
    await sl.reset();
  });

  testWidgets('TodoFormPage renders in Create mode with empty fields and creates task', (tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final bloc = sl<TodoBloc>();

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: BlocProvider<TodoBloc>.value(
          value: bloc,
          child: const TodoFormPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('New Task'), findsOneWidget);
    expect(find.text('Create Task'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'Brand New Task');
    await tester.tap(find.text('Create Task'));
    await tester.pumpAndSettle();
  });

  testWidgets('TodoFormPage renders in Edit mode with prefilled values', (tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final bloc = sl<TodoBloc>();
    final existingTodo = TodoItemEntity(
      id: 'task_edit_1',
      title: 'Existing Task Title',
      description: 'Existing Description',
      category: 'Work',
      priority: TodoPriority.high,
      createdAt: DateTime.now(),
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: BlocProvider<TodoBloc>.value(
          value: bloc,
          child: TodoFormPage(initialTodo: existingTodo),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Edit Task'), findsOneWidget);
    expect(find.text('Save Changes'), findsOneWidget);
    expect(find.text('Existing Task Title'), findsOneWidget);
  });
}
