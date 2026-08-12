import 'dart:typed_data';

/// ============================================================================
/// [IEncryptionService] - Domain Interface / Contract for Data Encryption
/// ============================================================================
/// 
/// Abstract contract for cryptographically securing sensitive string data, JSON payloads, 
/// and binary bytes using AES-256 encryption & cryptographic hashing (SHA-256 / HMAC).
/// ============================================================================
abstract class IEncryptionService {
  /// Encrypts a plain text string into an AES-256 encrypted Base64 string.
  /// 
  /// - [plainText]: The original string value to be encrypted.
  /// - Returns: `Future<String>` formatted as `IV:Ciphertext` in Base64 encoding.
  Future<String> encrypt(String plainText);

  /// Decrypts an AES-256 encrypted string back to its original plain text.
  /// 
  /// - [cipherText]: The encrypted string (Format: `IV:Ciphertext`).
  /// - Returns: `Future<String>` decrypted plain text string.
  Future<String> decrypt(String cipherText);

  /// Encrypts a Map / JSON object into an encrypted string.
  /// 
  /// - [json]: The `Map<String, dynamic>` object to be encrypted.
  /// - Returns: `Future<String>` encrypted string.
  Future<String> encryptJson(Map<String, dynamic> json);

  /// Decrypts an encrypted string back into a `Map<String, dynamic>` JSON object.
  /// 
  /// - [cipherText]: The encrypted string.
  /// - Returns: `Future<Map<String, dynamic>>` decrypted Map object.
  Future<Map<String, dynamic>> decryptJson(String cipherText);

  /// Encrypts raw binary data (`Uint8List`) using AES-256.
  /// 
  /// - [bytes]: The raw byte array to be encrypted.
  /// - Returns: `Future<String>` Encrypted string.
  Future<String> encryptBytes(Uint8List bytes);

  /// Decrypts an encrypted string back into raw binary bytes (`Uint8List`).
  /// 
  /// - [cipherText]: The encrypted string.
  /// - Returns: `Future<Uint8List>` Decrypted byte array.
  Future<Uint8List> decryptBytes(String cipherText);

  /// Computes a one-way cryptographic SHA-256 hash of a string (irreversible).
  /// 
  /// - [input]: The string to hash.
  /// - Returns: `String` Hexadecimal formatted SHA-256 hash string.
  String hashSha256(String input);

  /// Generates an HMAC-SHA256 hash using a secret key for signature validation.
  /// 
  /// - [input]: The string to hash.
  /// - [secretKey]: The secret key used for HMAC signing.
  /// - Returns: `String` Hexadecimal formatted HMAC signature string.
  String generateHmacSha256(String input, String secretKey);
}
