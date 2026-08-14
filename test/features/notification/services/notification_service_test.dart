import 'package:flutter_test/flutter_test.dart';
import 'package:simple_todo/core/services/notification_service.dart';
import 'package:simple_todo/features/notification/domain/entities/notification_item.dart';
import 'package:simple_todo/features/notification/domain/repositories/notification_repository.dart';
import 'package:simple_todo/features/notification/domain/usecases/cancel_notification_usecase.dart';
import 'package:simple_todo/features/notification/domain/usecases/request_permission_usecase.dart';
import 'package:simple_todo/features/notification/domain/usecases/schedule_notification_usecase.dart';
import 'package:simple_todo/features/notification/domain/usecases/show_instant_notification_usecase.dart';
import 'package:simple_todo/features/todo/domain/entities/todo_item.dart';

class MockNotificationRepository implements NotificationRepository {
  NotificationItemEntity? scheduledNotification;
  NotificationItemEntity? instantNotification;
  String? cancelledId;
  bool permissionGranted = true;

  @override
  Future<void> scheduleNotification(NotificationItemEntity notification) async {
    scheduledNotification = notification;
  }

  @override
  Future<void> showInstantNotification(NotificationItemEntity notification) async {
    instantNotification = notification;
  }

  @override
  Future<void> cancelNotification(String id) async {
    cancelledId = id;
  }

  @override
  Future<bool> requestPermission() async => permissionGranted;

  @override
  Future<void> cancelAllNotifications() async {}
  @override
  Future<void> initialize() async {}
}

void main() {
  late NotificationService service;
  late MockNotificationRepository repository;

  setUp(() {
    repository = MockNotificationRepository();
    service = NotificationService(
      scheduleNotificationUseCase: ScheduleNotificationUseCase(repository),
      cancelNotificationUseCase: CancelNotificationUseCase(repository),
      requestPermissionUseCase: RequestNotificationPermissionUseCase(repository),
      showInstantNotificationUseCase: ShowInstantNotificationUseCase(repository),
    );
  });

  group('NotificationService Facade Tests', () {
    test('requestPermission returns true when repository grants permission', () async {
      repository.permissionGranted = true;
      final result = await service.requestPermission();
      expect(result, isTrue);
    });

    test('scheduleTodoReminder should schedule notification when todo has future dueDate', () async {
      final futureDue = DateTime.now().add(const Duration(hours: 3));
      final todo = TodoItemEntity(
        id: 'todo_10',
        title: 'Submit Report',
        description: 'Quarterly review report',
        category: 'Work',
        dueDate: futureDue,
        createdAt: DateTime.now(),
      );

      await service.scheduleTodoReminder(todo);

      expect(repository.scheduledNotification, isNotNull);
      expect(repository.scheduledNotification!.id, equals('todo_10'));
      expect(repository.scheduledNotification!.title, contains('Submit Report'));
      expect(repository.scheduledNotification!.body, equals('Quarterly review report'));
      expect(repository.scheduledNotification!.scheduledDate, equals(futureDue));
    });

    test('scheduleTodoReminder should skip scheduling when todo has null dueDate', () async {
      final todo = TodoItemEntity(
        id: 'todo_11',
        title: 'No Date Task',
        createdAt: DateTime.now(),
      );

      await service.scheduleTodoReminder(todo);

      expect(repository.scheduledNotification, isNull);
    });

    test('scheduleTodoReminder should skip scheduling when dueDate is in past', () async {
      final pastDue = DateTime.now().subtract(const Duration(hours: 1));
      final todo = TodoItemEntity(
        id: 'todo_12',
        title: 'Past Task',
        dueDate: pastDue,
        createdAt: DateTime.now(),
      );

      await service.scheduleTodoReminder(todo);

      expect(repository.scheduledNotification, isNull);
    });

    test('cancelTodoReminder should delegate cancellation by ID', () async {
      await service.cancelTodoReminder('todo_55');
      expect(repository.cancelledId, equals('todo_55'));
    });

    test('showInstantAlert should dispatch instant notification', () async {
      await service.showInstantAlert(
        title: 'Alert Title',
        body: 'Alert Body',
        payload: 'alert_payload',
      );

      expect(repository.instantNotification, isNotNull);
      expect(repository.instantNotification!.title, equals('Alert Title'));
      expect(repository.instantNotification!.body, equals('Alert Body'));
      expect(repository.instantNotification!.payload, equals('alert_payload'));
    });
  });
}
