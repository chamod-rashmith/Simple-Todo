import '../../../../core/usecases/usecase.dart';
import '../repositories/notification_repository.dart';

/// ============================================================================
/// CancelNotificationUseCase
/// ============================================================================
///
/// **Clean Architecture Use Case:**
/// Encapsulates the business rule for canceling an existing scheduled notification
/// when a ToDo task is marked completed or deleted by the user.
///
/// **Parameters:**
/// Takes a `String` representing the unique ID of the notification / ToDo.
///
/// **How to Use:**
/// ```dart
/// final cancelUseCase = sl<CancelNotificationUseCase>();
/// await cancelUseCase('todo_42');
/// ```
class CancelNotificationUseCase implements UseCase<void, String> {
  final NotificationRepository repository;

  CancelNotificationUseCase(this.repository);

  @override
  Future<void> call(String notificationId) async {
    return await repository.cancelNotification(notificationId);
  }
}
