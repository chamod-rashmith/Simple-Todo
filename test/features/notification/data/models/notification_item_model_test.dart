import 'package:flutter_test/flutter_test.dart';
import 'package:simple_todo/features/notification/data/models/notification_item_model.dart';
import 'package:simple_todo/features/notification/domain/entities/notification_item.dart';

void main() {
  final tDate = DateTime(2026, 8, 14, 10, 30);
  final tModel = NotificationItemModel(
    id: 'test_123',
    title: 'Test Notification',
    body: 'This is a test notification body',
    scheduledDate: tDate,
    payload: 'test_payload',
  );

  final tEntity = NotificationItemEntity(
    id: 'test_123',
    title: 'Test Notification',
    body: 'This is a test notification body',
    scheduledDate: tDate,
    payload: 'test_payload',
  );

  group('NotificationItemModel Serialization & Mapping Tests', () {
    test('toJson should convert model to valid JSON map', () {
      final json = tModel.toJson();

      expect(json, {
        'id': 'test_123',
        'title': 'Test Notification',
        'body': 'This is a test notification body',
        'scheduledDate': tDate.toIso8601String(),
        'payload': 'test_payload',
      });
    });

    test('fromJson should parse valid JSON map into NotificationItemModel', () {
      final json = {
        'id': 'test_123',
        'title': 'Test Notification',
        'body': 'This is a test notification body',
        'scheduledDate': tDate.toIso8601String(),
        'payload': 'test_payload',
      };

      final result = NotificationItemModel.fromJson(json);

      expect(result.id, equals('test_123'));
      expect(result.title, equals('Test Notification'));
      expect(result.body, equals('This is a test notification body'));
      expect(result.scheduledDate, equals(tDate));
      expect(result.payload, equals('test_payload'));
    });

    test('Extension mapper fromEntity should convert Entity -> Model', () {
      final model = NotificationItemModelX.fromEntity(tEntity);

      expect(model.id, equals(tEntity.id));
      expect(model.title, equals(tEntity.title));
      expect(model.body, equals(tEntity.body));
      expect(model.scheduledDate, equals(tEntity.scheduledDate));
      expect(model.payload, equals(tEntity.payload));
    });

    test('Extension mapper toEntity should convert Model -> Entity', () {
      final entity = tModel.toEntity();

      expect(entity.id, equals(tModel.id));
      expect(entity.title, equals(tModel.title));
      expect(entity.body, equals(tModel.body));
      expect(entity.scheduledDate, equals(tModel.scheduledDate));
      expect(entity.payload, equals(tModel.payload));
    });
  });
}
