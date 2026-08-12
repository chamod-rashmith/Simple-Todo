import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:simple_todo/core/security/domain/i_secure_storage_service.dart';

/// ============================================================================
/// [FlutterSecureStorageService] - Hardware-backed Secure Storage Implementation
/// ============================================================================
/// 
/// Data-layer implementation of [ISecureStorageService] using `FlutterSecureStorage`
/// configured with Android `EncryptedSharedPreferences` for hardware security.
/// ============================================================================
class FlutterSecureStorageService implements ISecureStorageService {
  final FlutterSecureStorage _storage;

  /// Default Constructor - Configures platform options for Android & iOS.
  FlutterSecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock,
              ),
            );

  @override
  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Future<String?> read({required String key}) async {
    return await _storage.read(key: key);
  }

  @override
  Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }

  @override
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  @override
  Future<bool> containsKey({required String key}) async {
    return await _storage.containsKey(key: key);
  }
}
