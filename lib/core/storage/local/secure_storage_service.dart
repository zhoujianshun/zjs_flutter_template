import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sky_eldercare_family/core/errors/exceptions.dart';
import 'package:sky_eldercare_family/core/utils/logger.dart';

/// Secure storage service for sensitive data
class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  /// Write data to secure storage
  Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
      AppLogger.d('Secure storage write successful: $key');
    } catch (e) {
      AppLogger.e('Secure storage write failed: $key', error: e);
      throw StorageException(message: 'Failed to write to secure storage: $e');
    }
  }

  /// Read data from secure storage
  Future<String?> read(String key) async {
    try {
      final value = await _storage.read(key: key);
      AppLogger.d('Secure storage read: $key ${value != null ? '[EXISTS]' : '[NULL]'}');
      return value;
    } catch (e) {
      AppLogger.e('Secure storage read failed: $key', error: e);
      throw StorageException(message: 'Failed to read from secure storage: $e');
    }
  }

  /// Delete data from secure storage
  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
      AppLogger.d('Secure storage delete successful: $key');
    } catch (e) {
      AppLogger.e('Secure storage delete failed: $key', error: e);
      throw StorageException(message: 'Failed to delete from secure storage: $e');
    }
  }

  /// Check if key exists in secure storage
  Future<bool> containsKey(String key) async {
    try {
      return await _storage.containsKey(key: key);
    } catch (e) {
      AppLogger.e('Secure storage containsKey failed: $key', error: e);
      return false;
    }
  }

  /// Get all keys from secure storage
  Future<Map<String, String>> readAll() async {
    try {
      final all = await _storage.readAll();
      AppLogger.d('Secure storage readAll: ${all.keys.length} items');
      return all;
    } catch (e) {
      AppLogger.e('Secure storage readAll failed', error: e);
      throw StorageException(message: 'Failed to read all from secure storage: $e');
    }
  }

  /// Clear all data from secure storage
  Future<void> deleteAll() async {
    try {
      await _storage.deleteAll();
      AppLogger.i('Secure storage cleared successfully');
    } catch (e) {
      AppLogger.e('Secure storage deleteAll failed', error: e);
      throw StorageException(message: 'Failed to clear secure storage: $e');
    }
  }

  /// Write multiple key-value pairs
  Future<void> writeAll(Map<String, String> data) async {
    try {
      for (final entry in data.entries) {
        await write(entry.key, entry.value);
      }
      AppLogger.d('Secure storage writeAll successful: ${data.keys.length} items');
    } catch (e) {
      AppLogger.e('Secure storage writeAll failed', error: e);
      throw StorageException(message: 'Failed to write all to secure storage: $e');
    }
  }
}
