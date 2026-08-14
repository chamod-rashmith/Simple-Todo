import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/notification_item_model.dart';
import 'notification_local_datasource.dart';

/// ============================================================================
/// NotificationLocalDataSourceImpl
/// ============================================================================
///
/// **Implementation of Local Notification Engine:**
/// This class directly wraps the `flutter_local_notifications` plugin and
/// the `timezone` library to manage platform-level alarms and notification alerts.
///
/// **Key Responsibilities:**
/// 1. **Timezone Configuration**: Initializes IANA database and resolves the device's
///    active local timezone string using `flutter_timezone`.
/// 2. **Platform Channels Setup**: Creates high-importance Android Notification Channels
///    with customized sounds, lights, and vibration patterns.
/// 3. **Permission Handling**: Requests push notification runtime permissions on Android 13+ (API 33+)
///    and iOS/macOS Darwin systems.
/// 4. **Precise Scheduling**: Uses `zonedSchedule` with `AndroidScheduleMode.exactAllowWhileIdle`
///    to trigger exact alerts even when the device enters Android Doze / power saving modes.
/// 5. **Safe ID Conversion**: Safely hashes unique string IDs into 32-bit non-negative integers
///    required by the native notification managers (`id.hashCode & 0x7FFFFFFF`).
class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  /// Default notification channel ID for task reminders
  static const String _channelId = 'todo_reminders_channel';
  /// Human-readable channel name visible in Android app settings
  static const String _channelName = 'Task Reminders';
  /// Description of the notification channel
  static const String _channelDescription = 'Notifications and reminders for your upcoming tasks and todos';

  NotificationLocalDataSourceImpl(this.flutterLocalNotificationsPlugin);

  // ===========================================================================
  // 1. INITIALIZATION & SETUP
  // ===========================================================================

  @override
  Future<void> initialize() async {
    // Step A: Initialize Timezone database for accurate time-based scheduling
    await _configureLocalTimeZone();

    // Step B: Define Android-specific initialization settings (App Icon)
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Step C: Define iOS/Darwin-specific initialization settings
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false, // Permissions requested separately via use case
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    // Step D: Combine platform initialization settings
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    // Step E: Initialize the Flutter Local Notifications plugin
    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('🔔 [Notification Clicked]: payload=${response.payload}');
      },
    );

    // Step F: Create the Android Notification Channel
    await _createNotificationChannel();
  }

  /// Configures and synchronizes the IANA timezone database with the host device's local timezone.
  Future<void> _configureLocalTimeZone() async {
    try {
      tz.initializeTimeZones();
      final timezoneInfo = await FlutterTimezone.getLocalTimezone();
      final String timeZoneName = timezoneInfo.identifier;
      tz.setLocalLocation(tz.getLocation(timeZoneName));
      debugPrint('⏰ [Timezone Synchronized]: $timeZoneName');
    } catch (e) {
      debugPrint('⚠️ [Timezone Warning]: Failed to get device timezone ($e). Defaulting to UTC.');
      tz.setLocalLocation(tz.UTC);
    }
  }

  /// Registers a dedicated Android Notification Channel with maximum priority.
  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    final androidImplementation = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      await androidImplementation.createNotificationChannel(channel);
      debugPrint('📢 [Android Channel Created]: $_channelId');
    }
  }

  // ===========================================================================
  // 2. PERMISSIONS
  // ===========================================================================

  @override
  Future<bool> requestPermission() async {
    try {
      if (kIsWeb) return false;

      if (Platform.isAndroid) {
        final androidImplementation = flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
        final bool? granted = await androidImplementation?.requestNotificationsPermission();
        return granted ?? false;
      } else if (Platform.isIOS || Platform.isMacOS) {
        final iosImplementation = flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
        final bool? granted = await iosImplementation?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return granted ?? false;
      }
      return true;
    } catch (e) {
      debugPrint('❌ [Permission Error]: $e');
      return false;
    }
  }

  // ===========================================================================
  // 3. SCHEDULING NOTIFICATIONS
  // ===========================================================================

  @override
  Future<void> scheduleNotification(NotificationItemModel model) async {
    if (model.scheduledDate == null) {
      debugPrint('⚠️ [Schedule Skipped]: No scheduled date provided for ID=${model.id}');
      return;
    }

    final DateTime scheduleTime = model.scheduledDate!;

    // Safety check: Cannot schedule notifications in the past
    if (scheduleTime.isBefore(DateTime.now())) {
      debugPrint('⚠️ [Schedule Skipped]: Scheduled time is in the past ($scheduleTime)');
      return;
    }

    // Convert DateTime to TZDateTime in local timezone
    final tz.TZDateTime tzScheduledTime = tz.TZDateTime.from(scheduleTime, tz.local);
    final int notificationId = _generateSafeNotificationId(model.id);

    final NotificationDetails notificationDetails = _buildNotificationDetails();

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: notificationId,
      title: model.title,
      body: model.body,
      scheduledDate: tzScheduledTime,
      notificationDetails: notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: model.payload ?? model.id,
    );

    debugPrint('🔔 [Notification Scheduled]: ID=$notificationId (${model.id}) at $tzScheduledTime');
  }

  // ===========================================================================
  // 4. INSTANT NOTIFICATIONS
  // ===========================================================================

  @override
  Future<void> showInstantNotification(NotificationItemModel model) async {
    final int notificationId = _generateSafeNotificationId(model.id);
    final NotificationDetails notificationDetails = _buildNotificationDetails();

    await flutterLocalNotificationsPlugin.show(
      id: notificationId,
      title: model.title,
      body: model.body,
      notificationDetails: notificationDetails,
      payload: model.payload ?? model.id,
    );

    debugPrint('⚡ [Instant Notification Sent]: ID=$notificationId (${model.id})');
  }

  // ===========================================================================
  // 5. CANCELLATION
  // ===========================================================================

  @override
  Future<void> cancelNotification(String id) async {
    final int notificationId = _generateSafeNotificationId(id);
    await flutterLocalNotificationsPlugin.cancel(id: notificationId);
    debugPrint('🚫 [Notification Cancelled]: ID=$notificationId ($id)');
  }

  @override
  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    debugPrint('🗑️ [All Notifications Cancelled]');
  }

  // ===========================================================================
  // HELPER UTILITIES
  // ===========================================================================

  /// Converts any string ID (like UUID or timestamp) into a guaranteed positive 32-bit integer.
  int _generateSafeNotificationId(String id) {
    final parsed = int.tryParse(id);
    if (parsed != null) {
      return (parsed.abs() % 2147483647);
    }
    // Hash string to 31-bit non-negative integer
    return (id.hashCode & 0x7FFFFFFF);
  }

  /// Builds platform-specific notification visual and audio presentation configurations.
  NotificationDetails _buildNotificationDetails() {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    return const NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );
  }
}
