import '../../../../core/usecases/usecase.dart';
import '../entities/notification_item.dart';
import '../repositories/notification_repository.dart';

/// ============================================================================
/// ShowInstantNotificationUseCase
/// ============================================================================
///
/// **Clean Architecture Use Case:**
/// Encapsulates displaying an immediate system push notification (e.g. "Task created
/// successfully", or an urgent task ping).
///
/// **How to Use:**
/// ```dart
/// final showInstantUseCase = sl<ShowInstantNotificationUseCase>();
/// await showInstantUseCase(
///   NotificationItemEntity(
///     id: 'instant_1',
///     title: 'Task Created',
///     body: 'You created a new task!',
///   ),
/// );
/// ```
class ShowInstantNotificationUseCase implements UseCase<void, NotificationItemEntity> {
  final NotificationRepository repository;

  ShowInstantNotificationUseCase(this.repository);

  @override
  Future<void> call(NotificationItemEntity params) async {
    return await repository.showInstantNotification(params);
  }
}
