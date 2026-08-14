import '../../../../core/usecases/usecase.dart';
import '../repositories/notification_repository.dart';

/// ============================================================================
/// RequestNotificationPermissionUseCase
/// ============================================================================
///
/// **Clean Architecture Use Case:**
/// Encapsulates the user interaction and business rule of checking and requesting
/// device-level notification permissions (Android 13+ runtime permissions & iOS prompt).
///
/// **Returns:**
/// `Future<bool>`: `true` if permission is granted, otherwise `false`.
///
/// **How to Use:**
/// ```dart
/// final requestPermissionUseCase = sl<RequestNotificationPermissionUseCase>();
/// final bool isGranted = await requestPermissionUseCase(NoParams());
/// if (!isGranted) {
///   print('Notifications permission denied');
/// }
/// ```
class RequestNotificationPermissionUseCase implements UseCase<bool, NoParams> {
  final NotificationRepository repository;

  RequestNotificationPermissionUseCase(this.repository);

  @override
  Future<bool> call(NoParams params) async {
    return await repository.requestPermission();
  }
}
