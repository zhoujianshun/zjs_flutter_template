import 'package:shared_preferences/shared_preferences.dart';
import 'package:sky_eldercare_family/core/errors/exceptions.dart';
import 'package:sky_eldercare_family/core/utils/logger.dart';

/// SharedPreferences service for simple key-value storage
class SharedPrefsService {
  SharedPreferences? _prefs;
  static bool _initialized = false;

  /// Initialize SharedPreferences
  Future<void> initialize() async {
    if (_initialized && _prefs != null) return;

    try {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
      AppLogger.i('SharedPrefs service initialized successfully');
    } catch (e) {
      AppLogger.e('SharedPrefs service initialization failed', error: e);
      throw StorageException(message: 'Failed to initialize SharedPreferences: $e');
    }
  }

  /// Get SharedPreferences instance
  SharedPreferences get prefs {
    if (_prefs == null) {
      throw const StorageException(message: 'SharedPreferences is not initialized');
    }
    return _prefs!;
  }

  /// Write string value
  Future<void> setString(String key, String value) async {
    try {
      await prefs.setString(key, value);
      AppLogger.d('SharedPrefs setString successful: $key');
    } catch (e) {
      AppLogger.e('SharedPrefs setString failed: $key', error: e);
      throw StorageException(message: 'Failed to set string in SharedPreferences: $e');
    }
  }

  /// Read string value
  String? getString(String key, {String? defaultValue}) {
    try {
      final value = prefs.getString(key) ?? defaultValue;
      AppLogger.d('SharedPrefs getString: $key ${value != null ? '[EXISTS]' : '[NULL]'}');
      return value;
    } catch (e) {
      AppLogger.e('SharedPrefs getString failed: $key', error: e);
      return defaultValue;
    }
  }

  /// Write integer value
  Future<void> setInt(String key, int value) async {
    try {
      await prefs.setInt(key, value);
      AppLogger.d('SharedPrefs setInt successful: $key = $value');
    } catch (e) {
      AppLogger.e('SharedPrefs setInt failed: $key', error: e);
      throw StorageException(message: 'Failed to set int in SharedPreferences: $e');
    }
  }

  /// Read integer value
  int? getInt(String key, {int? defaultValue}) {
    try {
      final value = prefs.getInt(key) ?? defaultValue;
      AppLogger.d('SharedPrefs getInt: $key = $value');
      return value;
    } catch (e) {
      AppLogger.e('SharedPrefs getInt failed: $key', error: e);
      return defaultValue;
    }
  }

  /// Write double value
  Future<void> setDouble(String key, double value) async {
    try {
      await prefs.setDouble(key, value);
      AppLogger.d('SharedPrefs setDouble successful: $key = $value');
    } catch (e) {
      AppLogger.e('SharedPrefs setDouble failed: $key', error: e);
      throw StorageException(message: 'Failed to set double in SharedPreferences: $e');
    }
  }

  /// Read double value
  double? getDouble(String key, {double? defaultValue}) {
    try {
      final value = prefs.getDouble(key) ?? defaultValue;
      AppLogger.d('SharedPrefs getDouble: $key = $value');
      return value;
    } catch (e) {
      AppLogger.e('SharedPrefs getDouble failed: $key', error: e);
      return defaultValue;
    }
  }

  /// Write boolean value
  Future<void> setBool(String key, bool value) async {
    try {
      await prefs.setBool(key, value);
      AppLogger.d('SharedPrefs setBool successful: $key = $value');
    } catch (e) {
      AppLogger.e('SharedPrefs setBool failed: $key', error: e);
      throw StorageException(message: 'Failed to set bool in SharedPreferences: $e');
    }
  }

  /// Read boolean value
  bool? getBool(String key, {bool? defaultValue}) {
    try {
      final value = prefs.getBool(key) ?? defaultValue;
      AppLogger.d('SharedPrefs getBool: $key = $value');
      return value;
    } catch (e) {
      AppLogger.e('SharedPrefs getBool failed: $key', error: e);
      return defaultValue;
    }
  }

  /// Write string list value
  Future<void> setStringList(String key, List<String> value) async {
    try {
      await prefs.setStringList(key, value);
      AppLogger.d('SharedPrefs setStringList successful: $key (${value.length} items)');
    } catch (e) {
      AppLogger.e('SharedPrefs setStringList failed: $key', error: e);
      throw StorageException(message: 'Failed to set string list in SharedPreferences: $e');
    }
  }

  /// Read string list value
  List<String>? getStringList(String key, {List<String>? defaultValue}) {
    try {
      final value = prefs.getStringList(key) ?? defaultValue;
      AppLogger.d('SharedPrefs getStringList: $key ${value != null ? '(${value.length} items)' : '[NULL]'}');
      return value;
    } catch (e) {
      AppLogger.e('SharedPrefs getStringList failed: $key', error: e);
      return defaultValue;
    }
  }

  /// Remove value by key
  Future<void> remove(String key) async {
    try {
      await prefs.remove(key);
      AppLogger.d('SharedPrefs remove successful: $key');
    } catch (e) {
      AppLogger.e('SharedPrefs remove failed: $key', error: e);
      throw StorageException(message: 'Failed to remove from SharedPreferences: $e');
    }
  }

  /// Check if key exists
  bool containsKey(String key) {
    try {
      final exists = prefs.containsKey(key);
      AppLogger.d('SharedPrefs containsKey: $key = $exists');
      return exists;
    } catch (e) {
      AppLogger.e('SharedPrefs containsKey failed: $key', error: e);
      return false;
    }
  }

  /// Get all keys
  Set<String> getKeys() {
    try {
      final keys = prefs.getKeys();
      AppLogger.d('SharedPrefs getKeys: ${keys.length} keys');
      return keys;
    } catch (e) {
      AppLogger.e('SharedPrefs getKeys failed', error: e);
      return <String>{};
    }
  }

  /// Clear all data
  Future<void> clear() async {
    try {
      await prefs.clear();
      AppLogger.i('SharedPrefs cleared successfully');
    } catch (e) {
      AppLogger.e('SharedPrefs clear failed', error: e);
      throw StorageException(message: 'Failed to clear SharedPreferences: $e');
    }
  }

  /// Reload preferences from storage
  Future<void> reload() async {
    try {
      await prefs.reload();
      AppLogger.d('SharedPrefs reloaded successfully');
    } catch (e) {
      AppLogger.e('SharedPrefs reload failed', error: e);
      throw StorageException(message: 'Failed to reload SharedPreferences: $e');
    }
  }
}
