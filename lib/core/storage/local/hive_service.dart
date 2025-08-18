import 'package:hive_flutter/hive_flutter.dart';
import 'package:zjs_flutter_template/core/errors/exceptions.dart';
import 'package:zjs_flutter_template/core/utils/logger.dart';

/// Hive service for local data storage
class HiveService {
  static const String _userBoxName = 'user_box';
  static const String _settingsBoxName = 'settings_box';
  static const String _cacheBoxName = 'cache_box';

  Box? _userBox;
  Box? _settingsBox;
  Box? _cacheBox;

  static bool _initialized = false;

  /// Initialize Hive database
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      await Hive.initFlutter();

      // Register adapters here if needed
      // Hive.registerAdapter(UserModelAdapter());

      // Open boxes
      _userBox = await Hive.openBox(_userBoxName);
      _settingsBox = await Hive.openBox(_settingsBoxName);
      _cacheBox = await Hive.openBox(_cacheBoxName);

      _initialized = true;
      AppLogger.i('Hive service initialized successfully');
    } catch (e) {
      AppLogger.e('Hive service initialization failed', error: e);
      throw StorageException(message: 'Failed to initialize Hive: $e');
    }
  }

  /// Get user data box
  Box get userBox {
    if (_userBox == null || !_userBox!.isOpen) {
      throw const StorageException(message: 'User box is not initialized or closed');
    }
    return _userBox!;
  }

  /// Get settings box
  Box get settingsBox {
    if (_settingsBox == null || !_settingsBox!.isOpen) {
      throw const StorageException(message: 'Settings box is not initialized or closed');
    }
    return _settingsBox!;
  }

  /// Get cache box
  Box get cacheBox {
    if (_cacheBox == null || !_cacheBox!.isOpen) {
      throw const StorageException(message: 'Cache box is not initialized or closed');
    }
    return _cacheBox!;
  }

  /// Store data in specific box
  Future<void> put(String boxName, String key, dynamic value) async {
    try {
      final box = await _getBox(boxName);
      await box.put(key, value);
      AppLogger.d('Hive put successful: $boxName.$key');
    } catch (e) {
      AppLogger.e('Hive put failed: $boxName.$key', error: e);
      throw StorageException(message: 'Failed to put data in Hive: $e');
    }
  }

  /// Get data from specific box
  T? get<T>(String boxName, String key, {T? defaultValue}) {
    try {
      final box = _getBoxSync(boxName);
      if (box == null) return defaultValue;

      final value = box.get(key, defaultValue: defaultValue);
      AppLogger.d('Hive get: $boxName.$key ${value != null ? '[EXISTS]' : '[NULL]'}');
      return value as T?;
    } catch (e) {
      AppLogger.e('Hive get failed: $boxName.$key', error: e);
      return defaultValue;
    }
  }

  /// Delete data from specific box
  Future<void> delete(String boxName, String key) async {
    try {
      final box = await _getBox(boxName);
      await box.delete(key);
      AppLogger.d('Hive delete successful: $boxName.$key');
    } catch (e) {
      AppLogger.e('Hive delete failed: $boxName.$key', error: e);
      throw StorageException(message: 'Failed to delete data from Hive: $e');
    }
  }

  /// Check if key exists in specific box
  bool containsKey(String boxName, String key) {
    try {
      final box = _getBoxSync(boxName);
      return box?.containsKey(key) ?? false;
    } catch (e) {
      AppLogger.e('Hive containsKey failed: $boxName.$key', error: e);
      return false;
    }
  }

  /// Get all keys from specific box
  Iterable<dynamic> getKeys(String boxName) {
    try {
      final box = _getBoxSync(boxName);
      return box?.keys ?? [];
    } catch (e) {
      AppLogger.e('Hive getKeys failed: $boxName', error: e);
      return [];
    }
  }

  /// Get all values from specific box
  Iterable<dynamic> getValues(String boxName) {
    try {
      final box = _getBoxSync(boxName);
      return box?.values ?? [];
    } catch (e) {
      AppLogger.e('Hive getValues failed: $boxName', error: e);
      return [];
    }
  }

  /// Clear all data from specific box
  Future<void> clear(String boxName) async {
    try {
      final box = await _getBox(boxName);
      await box.clear();
      AppLogger.i('Hive box cleared: $boxName');
    } catch (e) {
      AppLogger.e('Hive clear failed: $boxName', error: e);
      throw StorageException(message: 'Failed to clear Hive box: $e');
    }
  }

  /// Close all boxes and clean up
  Future<void> close() async {
    try {
      await _userBox?.close();
      await _settingsBox?.close();
      await _cacheBox?.close();

      _userBox = null;
      _settingsBox = null;
      _cacheBox = null;
      _initialized = false;

      AppLogger.i('Hive service closed successfully');
    } catch (e) {
      AppLogger.e('Hive service close failed', error: e);
    }
  }

  /// Get box by name (async)
  Future<Box> _getBox(String boxName) async {
    switch (boxName) {
      case _userBoxName:
        return _userBox ?? await Hive.openBox(_userBoxName);
      case _settingsBoxName:
        return _settingsBox ?? await Hive.openBox(_settingsBoxName);
      case _cacheBoxName:
        return _cacheBox ?? await Hive.openBox(_cacheBoxName);
      default:
        return Hive.openBox(boxName);
    }
  }

  /// Get box by name (sync)
  Box? _getBoxSync(String boxName) {
    switch (boxName) {
      case _userBoxName:
        return _userBox;
      case _settingsBoxName:
        return _settingsBox;
      case _cacheBoxName:
        return _cacheBox;
      default:
        return Hive.isBoxOpen(boxName) ? Hive.box(boxName) : null;
    }
  }

  /// User data convenience methods
  Future<void> putUser(String key, dynamic value) => put(_userBoxName, key, value);
  T? getUser<T>(String key, {T? defaultValue}) => get<T>(_userBoxName, key, defaultValue: defaultValue);
  Future<void> deleteUser(String key) => delete(_userBoxName, key);
  Future<void> clearUserData() => clear(_userBoxName);

  /// Settings convenience methods
  Future<void> putSetting(String key, dynamic value) => put(_settingsBoxName, key, value);
  T? getSetting<T>(String key, {T? defaultValue}) => get<T>(_settingsBoxName, key, defaultValue: defaultValue);
  Future<void> deleteSetting(String key) => delete(_settingsBoxName, key);
  Future<void> clearSettings() => clear(_settingsBoxName);

  /// Cache convenience methods
  Future<void> putCache(String key, dynamic value) => put(_cacheBoxName, key, value);
  T? getCache<T>(String key, {T? defaultValue}) => get<T>(_cacheBoxName, key, defaultValue: defaultValue);
  Future<void> deleteCache(String key) => delete(_cacheBoxName, key);
  Future<void> clearCache() => clear(_cacheBoxName);
}
