/// ============================================================================
/// [ISecureStorageService] - Secure Key-Value Storage Contract
/// ============================================================================
/// 
/// Abstract contract for reading, writing, and deleting secure key-value pairs
/// backed by hardware security modules (Android Keystore & iOS Keychain).
/// ============================================================================
abstract class ISecureStorageService {
  /// Stores a sensitive string under the specified key.
  Future<void> write({required String key, required String value});

  /// Reads a sensitive string for the specified key.
  Future<String?> read({required String key});

  /// Deletes a key-value pair from secure storage.
  Future<void> delete({required String key});

  /// Clears all entries in secure storage.
  Future<void> deleteAll();

  /// Checks if a given key exists in secure storage.
  Future<bool> containsKey({required String key});
}
