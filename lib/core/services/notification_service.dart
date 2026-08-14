import 'package:flutter/foundation.dart';
import '../../features/notification/domain/entities/notification_item.dart';
import '../../features/notification/domain/usecases/cancel_notification_usecase.dart';
import '../../features/notification/domain/usecases/request_permission_usecase.dart';
import '../../features/notification/domain/usecases/schedule_notification_usecase.dart';
import '../../features/notification/domain/usecases/show_instant_notification_usecase.dart';
import '../../features/todo/domain/entities/todo_item.dart';
import '../usecases/usecase.dart';

/// ============================================================================
/// NotificationService (Developer API Facade)
/// ============================================================================
///
/// **Overview:**
/// `NotificationService` provides a clean, unified, and developer-friendly API
/// facade for managing local notifications and task reminders across the entire app.
///
/// Under the hood, this service delegates operations directly to **Clean Architecture Use Cases**,
/// preserving single-responsibility and dependency inversion principles while eliminating
/// boilerplate in UI widgets and BLoC components.
///
/// **How to Use:**
/// 
/// 1. **Accessing via Dependency Injection (GetIt):**
///    ```dart
///    final notificationService = sl<NotificationService>();
///    ```
///
/// 2. **Requesting Permissions (e.g. on App Launch or Settings):**
///    ```dart
///    final isGranted = await notificationService.requestPermission();
///    ```
///
/// 3. **Scheduling a Task Reminder:**
///    ```dart
///    await notificationService.scheduleTodoReminder(todoItemEntity);
///    ```
///
/// 4. **Canceling a Task Reminder:**
///    ```dart
///    await notificationService.cancelTodoReminder(todoItemEntity.id);
///    ```
///
/// 5. **Displaying an Immediate Alert:**
///    ```dart
///    await notificationService.showInstantAlert(
///      title: 'Success',
///      body: 'Your task has been saved!',
///    );
///    ```
class NotificationService {
  final ScheduleNotificationUseCase scheduleNotificationUseCase;
  final CancelNotificationUseCase cancelNotificationUseCase;
  final RequestNotificationPermissionUseCase requestPermissionUseCase;
  final ShowInstantNotificationUseCase showInstantNotificationUseCase;

  NotificationService({
    required this.scheduleNotificationUseCase,
    required this.cancelNotificationUseCase,
    required this.requestPermissionUseCase,
    required this.showInstantNotificationUseCase,
  });

  /// ==========================================================================
  /// 1. REQUEST PERMISSIONS
  /// ==========================================================================
  /// Requests runtime notification permissions on Android 13+ (POST_NOTIFICATIONS)
  /// and iOS/macOS Darwin dialogs.
  ///
  /// Returns `true` if permission is granted or already authorized, `false` otherwise.
  Future<bool> requestPermission() async {
    try {
      final bool granted = await requestPermissionUseCase(NoParams());
      debugPrint('🔔 [NotificationService] Permission status: $granted');
      return granted;
    } catch (e) {
      debugPrint('❌ [NotificationService] Failed to request permission: $e');
      return false;
    }
  }

  /// ==========================================================================
  /// 2. SCHEDULE TODO REMINDER
  /// ==========================================================================
  /// Automatically checks if the given [todo] has a valid `dueDate` in the future.
  /// If it does, creates a scheduled system alarm that alerts the user with the
  /// task's title and description at the specified deadline.
  ///
  /// If `dueDate` is `null` or already in the past, scheduling is safely skipped.
  Future<void> scheduleTodoReminder(TodoItemEntity todo) async {
    if (todo.dueDate == null) {
      debugPrint('ℹ️ [NotificationService] Todo "${todo.title}" has no due date. Skipping reminder.');
      return;
    }

    final DateTime due = todo.dueDate!;
    if (due.isBefore(DateTime.now())) {
      debugPrint('ℹ️ [NotificationService] Due date for "${todo.title}" is in the past. Skipping reminder.');
      return;
    }

    try {
      final notification = NotificationItemEntity(
        id: todo.id,
        title: '⏰ Task Reminder: ${todo.title}',
        body: todo.description.isNotEmpty
            ? todo.description
            : 'Your task in ${todo.category} is due now!',
        scheduledDate: due,
        payload: todo.id,
      );

      await scheduleNotificationUseCase(notification);
      debugPrint('✅ [NotificationService] Scheduled reminder for "${todo.title}" at $due');
    } catch (e) {
      debugPrint('❌ [NotificationService] Failed to schedule reminder for "${todo.title}": $e');
    }
  }

  /// ==========================================================================
  /// 3. CANCEL TODO REMINDER
  /// ==========================================================================
  /// Cancels the scheduled system reminder for a specific task using its unique [todoId].
  /// Useful when a task is checked as completed or deleted from the list.
  Future<void> cancelTodoReminder(String todoId) async {
    try {
      await cancelNotificationUseCase(todoId);
      debugPrint('🗑️ [NotificationService] Cancelled reminder for Todo ID: $todoId');
    } catch (e) {
      debugPrint('❌ [NotificationService] Failed to cancel reminder for Todo ID $todoId: $e');
    }
  }

  /// ==========================================================================
  /// 4. SHOW INSTANT ALERT
  /// ==========================================================================
  /// Displays an immediate push banner/status bar notification with custom [title]
  /// and [body] messages.
  Future<void> showInstantAlert({
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      final notification = NotificationItemEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        body: body,
        payload: payload,
      );

      await showInstantNotificationUseCase(notification);
      debugPrint('⚡ [NotificationService] Instant alert sent: "$title"');
    } catch (e) {
      debugPrint('❌ [NotificationService] Failed to send instant alert: $e');
    }
  }
}
