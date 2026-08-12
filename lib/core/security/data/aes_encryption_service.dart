import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' as crypto;
import 'package:encrypt/encrypt.dart' as encrypt_pkg;
import 'package:simple_todo/core/security/domain/i_encryption_service.dart';
import 'package:simple_todo/core/security/domain/i_secure_storage_service.dart';

/// ============================================================================
/// [AESEncryptionService] - Concrete AES-256 Implementation
/// ============================================================================
/// 
/// Cryptographic Security Details:
/// 1. **AES-256 Key**: Retrieved from Hardware Secure Storage (Keystore/Keychain).
///    Generates and stores a secure random 256-bit (32 Bytes) key on first launch.
/// 2. **Dynamic IV (Initialization Vector)**: Generates a random 128-bit (16 Bytes) IV
///    for every encryption operation to ensure semantic security.
/// 3. **Output Format**: Encrypted data is stored in `IV_Base64:Ciphertext_Base64` format.
///
/// English Description:
/// Industrial-grade AES-256 CBC encryption service with automated secure key management
/// via hardware-backed [ISecureStorageService] and per-operation dynamic IV generation.
/// ============================================================================
class AESEncryptionService implements IEncryptionService {
  final ISecureStorageService _secureStorageService;

  /// Key name used to persist the Master AES Key in Secure Storage.
  static const String _masterKeyStorageKey = 'simple_todo_aes_master_key_v1';

  /// Cached Key instance in memory.
  encrypt_pkg.Key? _cachedKey;

  AESEncryptionService(this._secureStorageService);

  /// Retrieves or generates a persistent 256-bit AES master key stored in secure storage.
  Future<encrypt_pkg.Key> _getOrCreateMasterKey() async {
    // Return cached key if present in memory for performance.
    if (_cachedKey != null) {
      return _cachedKey!;
    }

    // Try reading existing key from Secure Storage.
    final existingKeyBase64 = await _secureStorageService.read(key: _masterKeyStorageKey);

    if (existingKeyBase64 != null && existingKeyBase64.isNotEmpty) {
      final keyBytes = base64Decode(existingKeyBase64);
      _cachedKey = encrypt_pkg.Key(keyBytes);
      return _cachedKey!;
    }

    // First time launch: Generate 32 secure cryptographic random bytes (256 bits).
    final newKey = encrypt_pkg.Key.fromSecureRandom(32);
    final newKeyBase64 = base64Encode(newKey.bytes);

    // Save newly generated key to Secure Storage.
    await _secureStorageService.write(
      key: _masterKeyStorageKey,
      value: newKeyBase64,
    );

    _cachedKey = newKey;
    return newKey;
  }

  @override
  Future<String> encrypt(String plainText) async {
    if (plainText.isEmpty) return '';

    try {
      // 1. Retrieve Master AES Key.
      final key = await _getOrCreateMasterKey();

      // 2. Generate a unique 128-bit (16 Bytes) Random IV for this encryption operation.
      final iv = encrypt_pkg.IV.fromSecureRandom(16);

      // 3. Create Encrypter using AES CBC Mode.
      final encrypter = encrypt_pkg.Encrypter(
        encrypt_pkg.AES(key, mode: encrypt_pkg.AESMode.cbc),
      );

      // 4. Encrypt data.
      final encrypted = encrypter.encrypt(plainText, iv: iv);

      // 5. Return formatted string `IV:Ciphertext`.
      return '${iv.base64}:${encrypted.base64}';
    } catch (e) {
      throw FormatException('Error encrypting data: $e');
    }
  }

  @override
  Future<String> decrypt(String cipherText) async {
    if (cipherText.isEmpty) return '';

    try {
      // 1. Split string into two components: `IV` and `Ciphertext`.
      final parts = cipherText.split(':');
      if (parts.length != 2) {
        throw const FormatException('Invalid encrypted ciphertext format. Expected "IV:Ciphertext".');
      }

      final ivBase64 = parts[0];
      final encryptedBase64 = parts[1];

      // 2. Reconstruct IV and Encrypted Object from Base64.
      final iv = encrypt_pkg.IV.fromBase64(ivBase64);
      final encrypted = encrypt_pkg.Encrypted.fromBase64(encryptedBase64);

      // 3. Retrieve Master AES Key.
      final key = await _getOrCreateMasterKey();

      // 4. Create Encrypter and decrypt.
      final encrypter = encrypt_pkg.Encrypter(
        encrypt_pkg.AES(key, mode: encrypt_pkg.AESMode.cbc),
      );

      return encrypter.decrypt(encrypted, iv: iv);
    } catch (e) {
      throw FormatException('Error decrypting data: $e');
    }
  }

  @override
  Future<String> encryptJson(Map<String, dynamic> json) async {
    final jsonString = jsonEncode(json);
    return await encrypt(jsonString);
  }

  @override
  Future<Map<String, dynamic>> decryptJson(String cipherText) async {
    final decryptedString = await decrypt(cipherText);
    if (decryptedString.isEmpty) return {};
    return jsonDecode(decryptedString) as Map<String, dynamic>;
  }

  @override
  Future<String> encryptBytes(Uint8List bytes) async {
    final base64String = base64Encode(bytes);
    return await encrypt(base64String);
  }

  @override
  Future<Uint8List> decryptBytes(String cipherText) async {
    final decryptedBase64 = await decrypt(cipherText);
    if (decryptedBase64.isEmpty) return Uint8List(0);
    return base64Decode(decryptedBase64);
  }

  @override
  String hashSha256(String input) {
    final bytes = utf8.encode(input);
    final digest = crypto.sha256.convert(bytes);
    return digest.toString(); // Hexadecimal string
  }

  @override
  String generateHmacSha256(String input, String secretKey) {
    final keyBytes = utf8.encode(secretKey);
    final inputBytes = utf8.encode(input);
    final hmac = crypto.Hmac(crypto.sha256, keyBytes);
    final digest = hmac.convert(inputBytes);
    return digest.toString(); // Hexadecimal string
  }
}
