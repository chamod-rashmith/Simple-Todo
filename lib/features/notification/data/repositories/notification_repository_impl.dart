import '../../domain/entities/notification_item.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_local_datasource.dart';
import '../models/notification_item_model.dart';

/// ============================================================================
/// NotificationRepositoryImpl
/// ============================================================================
///
/// **Clean Architecture Repository Implementation (Data Layer):**
/// Acts as the mediator between the **Domain Layer** (Entities & UseCases) and
/// the **Data Layer** (DataSources & Models).
///
/// **Strict Clean Architecture Rules Enforced:**
/// 1. Takes Domain Entities (`NotificationItemEntity`) from Use Cases.
/// 2. Uses Extension Mapper (`NotificationItemModelX.fromEntity(entity)`) to convert them to `NotificationItemModel`.
/// 3. Passes `NotificationItemModel` down to `NotificationLocalDataSource`.
/// 4. Ensures zero leak of raw models to the Domain layer.
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationLocalDataSource localDataSource;

  NotificationRepositoryImpl(this.localDataSource);

  @override
  Future<void> initialize() async {
    await localDataSource.initialize();
  }

  @override
  Future<bool> requestPermission() async {
    return await localDataSource.requestPermission();
  }

  @override
  Future<void> scheduleNotification(NotificationItemEntity notification) async {
    // 1. Convert Domain Entity -> Data Model using Extension Mapper
    final model = NotificationItemModelX.fromEntity(notification);

    // 2. Delegate execution to DataSource
    await localDataSource.scheduleNotification(model);
  }

  @override
  Future<void> showInstantNotification(NotificationItemEntity notification) async {
    // 1. Convert Domain Entity -> Data Model using Extension Mapper
    final model = NotificationItemModelX.fromEntity(notification);

    // 2. Delegate execution to DataSource
    await localDataSource.showInstantNotification(model);
  }

  @override
  Future<void> cancelNotification(String id) async {
    await localDataSource.cancelNotification(id);
  }

  @override
  Future<void> cancelAllNotifications() async {
    await localDataSource.cancelAllNotifications();
  }
}
