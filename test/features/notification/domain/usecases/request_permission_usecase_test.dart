import 'package:flutter_test/flutter_test.dart';
import 'package:simple_todo/core/usecases/usecase.dart';
import 'package:simple_todo/features/notification/domain/entities/notification_item.dart';
import 'package:simple_todo/features/notification/domain/repositories/notification_repository.dart';
import 'package:simple_todo/features/notification/domain/usecases/request_permission_usecase.dart';

class MockNotificationRepository implements NotificationRepository {
  bool permissionResult = true;

  @override
  Future<bool> requestPermission() async => permissionResult;

  @override
  Future<void> cancelAllNotifications() async {}
  @override
  Future<void> cancelNotification(String id) async {}
  @override
  Future<void> initialize() async {}
  @override
  Future<void> scheduleNotification(NotificationItemEntity notification) async {}
  @override
  Future<void> showInstantNotification(NotificationItemEntity notification) async {}
}

void main() {
  late RequestNotificationPermissionUseCase useCase;
  late MockNotificationRepository repository;

  setUp(() {
    repository = MockNotificationRepository();
    useCase = RequestNotificationPermissionUseCase(repository);
  });

  test('should return true when permission is granted by repository', () async {
    repository.permissionResult = true;
    final result = await useCase(NoParams());
    expect(result, isTrue);
  });

  test('should return false when permission is denied by repository', () async {
    repository.permissionResult = false;
    final result = await useCase(NoParams());
    expect(result, isFalse);
  });
}
