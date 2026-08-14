import 'package:flutter_test/flutter_test.dart';
import 'package:simple_todo/features/notification/domain/entities/notification_item.dart';
import 'package:simple_todo/features/notification/domain/repositories/notification_repository.dart';
import 'package:simple_todo/features/notification/domain/usecases/cancel_notification_usecase.dart';

class MockNotificationRepository implements NotificationRepository {
  String? cancelledId;

  @override
  Future<void> cancelNotification(String id) async {
    cancelledId = id;
  }

  @override
  Future<void> cancelAllNotifications() async {}
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
  late CancelNotificationUseCase useCase;
  late MockNotificationRepository repository;

  setUp(() {
    repository = MockNotificationRepository();
    useCase = CancelNotificationUseCase(repository);
  });

  test('should delegate cancellation to NotificationRepository with given ID', () async {
    const tId = 'todo_999';

    await useCase(tId);

    expect(repository.cancelledId, equals(tId));
  });
}
