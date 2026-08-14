import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';

import '../../../features/notification/data/datasources/notification_local_datasource.dart';
import '../../../features/notification/data/datasources/notification_local_datasource_impl.dart';
import '../../../features/notification/data/repositories/notification_repository_impl.dart';
import '../../../features/notification/domain/repositories/notification_repository.dart';
import '../../../features/notification/domain/usecases/cancel_notification_usecase.dart';
import '../../../features/notification/domain/usecases/request_permission_usecase.dart';
import '../../../features/notification/domain/usecases/schedule_notification_usecase.dart';
import '../../../features/notification/domain/usecases/show_instant_notification_usecase.dart';
import '../../services/notification_service.dart';

/// ============================================================================
/// initNotificationModule
/// ============================================================================
///
/// **Clean Architecture Modular DI Registration (GetIt):**
/// Configures all notification-related dependencies following the feature-first modular DI pattern.
///
/// **Dependency Tree:**
/// 1. `FlutterLocalNotificationsPlugin` (External Engine)
/// 2. `NotificationLocalDataSource` (Data Layer Source)
/// 3. `NotificationRepository` (Data Layer Implementation of Domain Contract)
/// 4. Use Cases (Domain Layer Business Actions)
/// 5. `NotificationService` (High-level Developer Facade)
Future<void> initNotificationModule(GetIt sl) async {
  // 1. External Notification Plugin
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  sl.registerLazySingleton<FlutterLocalNotificationsPlugin>(
    () => flutterLocalNotificationsPlugin,
  );

  // 2. Data Source
  sl.registerLazySingleton<NotificationLocalDataSource>(
    () => NotificationLocalDataSourceImpl(sl<FlutterLocalNotificationsPlugin>()),
  );

  // 3. Repository
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(sl<NotificationLocalDataSource>()),
  );

  // 4. Use Cases
  sl.registerLazySingleton<ScheduleNotificationUseCase>(
    () => ScheduleNotificationUseCase(sl<NotificationRepository>()),
  );
  sl.registerLazySingleton<CancelNotificationUseCase>(
    () => CancelNotificationUseCase(sl<NotificationRepository>()),
  );
  sl.registerLazySingleton<RequestNotificationPermissionUseCase>(
    () => RequestNotificationPermissionUseCase(sl<NotificationRepository>()),
  );
  sl.registerLazySingleton<ShowInstantNotificationUseCase>(
    () => ShowInstantNotificationUseCase(sl<NotificationRepository>()),
  );

  // 5. Developer-Friendly Facade Service
  sl.registerLazySingleton<NotificationService>(
    () => NotificationService(
      scheduleNotificationUseCase: sl(),
      cancelNotificationUseCase: sl(),
      requestPermissionUseCase: sl(),
      showInstantNotificationUseCase: sl(),
    ),
  );

  // 6. Initialize local notification channels and timezones on startup
  final repository = sl<NotificationRepository>();
  await repository.initialize();
}
