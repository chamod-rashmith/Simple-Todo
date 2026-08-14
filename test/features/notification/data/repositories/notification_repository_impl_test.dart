import 'package:flutter_test/flutter_test.dart';
import 'package:simple_todo/features/notification/data/datasources/notification_local_datasource.dart';
import 'package:simple_todo/features/notification/data/models/notification_item_model.dart';
import 'package:simple_todo/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:simple_todo/features/notification/domain/entities/notification_item.dart';

class MockNotificationLocalDataSource implements NotificationLocalDataSource {
  NotificationItemModel? scheduledModel;
  NotificationItemModel? instantModel;
  String? cancelledId;
  bool isInitialized = false;
  bool permissionResult = true;
  bool allCancelled = false;

  @override
  Future<void> initialize() async {
    isInitialized = true;
  }

  @override
  Future<bool> requestPermission() async => permissionResult;

  @override
  Future<void> scheduleNotification(NotificationItemModel model) async {
    scheduledModel = model;
  }

  @override
  Future<void> showInstantNotification(NotificationItemModel model) async {
    instantModel = model;
  }

  @override
  Future<void> cancelNotification(String id) async {
    cancelledId = id;
  }

  @override
  Future<void> cancelAllNotifications() async {
    allCancelled = true;
  }
}

void main() {
  late NotificationRepositoryImpl repository;
  late MockNotificationLocalDataSource dataSource;

  setUp(() {
    dataSource = MockNotificationLocalDataSource();
    repository = NotificationRepositoryImpl(dataSource);
  });

  final tEntity = NotificationItemEntity(
    id: 'notif_1',
    title: 'Hello',
    body: 'World',
    scheduledDate: DateTime(2026, 8, 14, 12, 0),
    payload: 'custom_payload',
  );

  group('NotificationRepositoryImpl Tests', () {
    test('initialize should call dataSource.initialize()', () async {
      await repository.initialize();
      expect(dataSource.isInitialized, isTrue);
    });

    test('requestPermission should delegate to dataSource.requestPermission()', () async {
      dataSource.permissionResult = true;
      final result = await repository.requestPermission();
      expect(result, isTrue);
    });

    test('scheduleNotification should convert Entity -> Model and pass to dataSource', () async {
      await repository.scheduleNotification(tEntity);

      expect(dataSource.scheduledModel, isNotNull);
      expect(dataSource.scheduledModel!.id, equals(tEntity.id));
      expect(dataSource.scheduledModel!.title, equals(tEntity.title));
      expect(dataSource.scheduledModel!.body, equals(tEntity.body));
      expect(dataSource.scheduledModel!.scheduledDate, equals(tEntity.scheduledDate));
      expect(dataSource.scheduledModel!.payload, equals(tEntity.payload));
    });

    test('showInstantNotification should convert Entity -> Model and pass to dataSource', () async {
      await repository.showInstantNotification(tEntity);

      expect(dataSource.instantModel, isNotNull);
      expect(dataSource.instantModel!.id, equals(tEntity.id));
      expect(dataSource.instantModel!.title, equals(tEntity.title));
    });

    test('cancelNotification should forward ID to dataSource', () async {
      await repository.cancelNotification('notif_123');
      expect(dataSource.cancelledId, equals('notif_123'));
    });

    test('cancelAllNotifications should delegate to dataSource.cancelAllNotifications()', () async {
      await repository.cancelAllNotifications();
      expect(dataSource.allCancelled, isTrue);
    });
  });
}
