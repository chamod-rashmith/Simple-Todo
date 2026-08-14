import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_todo/core/database/app_database.dart';
import 'package:simple_todo/core/di/injection_container.dart';
import 'package:simple_todo/core/di/modules/todo_module.dart';
import 'package:simple_todo/core/services/notification_service.dart';
import 'package:simple_todo/features/notification/domain/entities/notification_item.dart';
import 'package:simple_todo/features/notification/domain/repositories/notification_repository.dart';
import 'package:simple_todo/features/notification/domain/usecases/cancel_notification_usecase.dart';
import 'package:simple_todo/features/notification/domain/usecases/request_permission_usecase.dart';
import 'package:simple_todo/features/notification/domain/usecases/schedule_notification_usecase.dart';
import 'package:simple_todo/features/notification/domain/usecases/show_instant_notification_usecase.dart';
import 'package:simple_todo/main.dart';

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

  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SimpleTodoApp());
    expect(find.byType(SimpleTodoApp), findsOneWidget);
  });
}
