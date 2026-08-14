import '../entities/notification_item.dart';

/// ============================================================================
/// NotificationRepository
/// ============================================================================
///
/// **Clean Architecture Contract (Domain Layer):**
/// Defines the abstract boundary for scheduling, cancelling, and dispatching
/// notifications across the device.
///
/// The Domain Layer does NOT know which plugin (e.g. `flutter_local_notifications`,
/// Firebase Cloud Messaging, OneSignal) is doing the actual delivery; it only
/// relies on this contract.
///
/// **Available Methods:**
/// 1. `initialize()`: Prepares notification channels, icons, and timezone data.
/// 2. `requestPermission()`: Requests push/local notification permissions (iOS/Android 13+).
/// 3. `scheduleNotification()`: Schedules a notification for a future date/time.
/// 4. `showInstantNotification()`: Dispatches an immediate notification.
/// 5. `cancelNotification()`: Cancels a specific scheduled reminder by its string ID.
/// 6. `cancelAllNotifications()`: Removes all pending notifications.
abstract class NotificationRepository {
  /// Initializes the underlying notification system and platform-specific channels.
  Future<void> initialize();

  /// Requests notification permissions from the operating system (e.g. POST_NOTIFICATIONS on Android 13+, permissions on iOS/macOS).
  /// Returns `true` if permission is granted, otherwise `false`.
  Future<bool> requestPermission();

  /// Schedules a reminder for a specific date & time using [NotificationItemEntity].
  Future<void> scheduleNotification(NotificationItemEntity notification);

  /// Shows an instant, immediate notification to the user.
  Future<void> showInstantNotification(NotificationItemEntity notification);

  /// Cancels an existing notification matching the given [id].
  Future<void> cancelNotification(String id);

  /// Cancels all scheduled and active notifications for this app.
  Future<void> cancelAllNotifications();
}
