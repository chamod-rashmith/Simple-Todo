import '../../../../core/usecases/usecase.dart';
import '../entities/notification_item.dart';
import '../repositories/notification_repository.dart';

/// ============================================================================
/// ScheduleNotificationUseCase
/// ============================================================================
///
/// **Clean Architecture Use Case:**
/// Encapsulates the single business logic rule for scheduling a future notification
/// (e.g. when a ToDo task deadline or reminder time is set).
///
/// **How to Use:**
/// ```dart
/// final scheduleUseCase = sl<ScheduleNotificationUseCase>();
/// await scheduleUseCase(
///   NotificationItemEntity(
///     id: 'todo_42',
///     title: 'Submit Assignment',
///     body: 'Due at 5:00 PM today',
///     scheduledDate: DateTime.now().add(const Duration(hours: 2)),
///   ),
/// );
/// ```
class ScheduleNotificationUseCase implements UseCase<void, NotificationItemEntity> {
  final NotificationRepository repository;

  ScheduleNotificationUseCase(this.repository);

  @override
  Future<void> call(NotificationItemEntity params) async {
    return await repository.scheduleNotification(params);
  }
}
