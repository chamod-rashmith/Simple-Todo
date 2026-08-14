import 'package:flutter_test/flutter_test.dart';
import 'package:simple_todo/features/notification/domain/entities/notification_item.dart';
import 'package:simple_todo/features/notification/domain/repositories/notification_repository.dart';
import 'package:simple_todo/features/notification/domain/usecases/schedule_notification_usecase.dart';

class MockNotificationRepository implements NotificationRepository {
  NotificationItemEntity? lastScheduledNotification;

  @override
  Future<void> scheduleNotification(NotificationItemEntity notification) async {
    lastScheduledNotification = notification;
  }

  @override
  Future<void> cancelAllNotifications() async {}
  @override
  Future<void> cancelNotification(String id) async {}
  @override
  Future<void> initialize() async {}
  @override
  Future<bool> requestPermission() async => true;
  @override
  Future<void> showInstantNotification(NotificationItemEntity notification) async {}
}

void main() {
  late ScheduleNotificationUseCase useCase;
  late MockNotificationRepository repository;

  setUp(() {
    repository = MockNotificationRepository();
    useCase = ScheduleNotificationUseCase(repository);
  });

  test('should delegate scheduling to NotificationRepository with given entity', () async {
    final tNotification = NotificationItemEntity(
      id: 'task_1',
      title: 'Reminder: Task 1',
      body: 'Task is due now',
      scheduledDate: DateTime.now().add(const Duration(hours: 2)),
    );

    await useCase(tNotification);

    expect(repository.lastScheduledNotification, equals(tNotification));
  });
}
