import 'package:flutter_test/flutter_test.dart';
import 'package:simple_todo/features/notification/domain/entities/notification_item.dart';
import 'package:simple_todo/features/notification/domain/repositories/notification_repository.dart';
import 'package:simple_todo/features/notification/domain/usecases/show_instant_notification_usecase.dart';

class MockNotificationRepository implements NotificationRepository {
  NotificationItemEntity? instantNotification;

  @override
  Future<void> showInstantNotification(NotificationItemEntity notification) async {
    instantNotification = notification;
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
  Future<void> scheduleNotification(NotificationItemEntity notification) async {}
}

void main() {
  late ShowInstantNotificationUseCase useCase;
  late MockNotificationRepository repository;

  setUp(() {
    repository = MockNotificationRepository();
    useCase = ShowInstantNotificationUseCase(repository);
  });

  test('should delegate instant alert dispatching to NotificationRepository', () async {
    final tNotification = NotificationItemEntity(
      id: 'instant_123',
      title: 'Immediate Alert',
      body: 'Testing instant notification',
    );

    await useCase(tNotification);

    expect(repository.instantNotification, equals(tNotification));
  });
}
