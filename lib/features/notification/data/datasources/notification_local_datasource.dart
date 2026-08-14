import '../models/notification_item_model.dart';

/// ============================================================================
/// NotificationLocalDataSource
/// ============================================================================
///
/// **Clean Architecture Data Source Contract:**
/// Low-level abstraction for interacting with local device notification services.
///
/// **Rule:** Accepts and returns **ONLY Data Models (`NotificationItemModel`)**,
/// NEVER Domain Entities!
abstract class NotificationLocalDataSource {
  /// Initializes local notification plugin, setup notification channels, and timezone.
  Future<void> initialize();

  /// Requests runtime notification permission on Android 13+ and iOS.
  Future<bool> requestPermission();

  /// Schedules a future local notification using [NotificationItemModel].
  Future<void> scheduleNotification(NotificationItemModel model);

  /// Dispatches an immediate local notification using [NotificationItemModel].
  Future<void> showInstantNotification(NotificationItemModel model);

  /// Cancels a scheduled local notification matching the given string [id].
  Future<void> cancelNotification(String id);

  /// Cancels all pending notifications across the entire app.
  Future<void> cancelAllNotifications();
}
