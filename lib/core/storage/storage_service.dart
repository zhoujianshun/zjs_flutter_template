import 'package:sky_eldercare_family/core/constants/storage_keys.dart';
import 'package:sky_eldercare_family/core/errors/exceptions.dart';
import 'package:sky_eldercare_family/core/storage/local/hive_service.dart';
import 'package:sky_eldercare_family/core/storage/local/secure_storage_service.dart';
import 'package:sky_eldercare_family/core/storage/local/shared_prefs_service.dart';
import 'package:sky_eldercare_family/core/utils/logger.dart';

/// Unified storage service that manages all storage types
class StorageService {
  StorageService._({
    required HiveService hiveService,
    required SharedPrefsService sharedPrefsService,
    required SecureStorageService secureStorageService,
  })  : _hiveService = hiveService,
        _sharedPrefsService = sharedPrefsService,
        _secureStorageService = secureStorageService;
  final HiveService _hiveService;
  final SharedPrefsService _sharedPrefsService;
  final SecureStorageService _secureStorageService;

  static StorageService? _instance;

  /// Get singleton instance
  static StorageService get instance {
    _instance ??= StorageService._(
      hiveService: HiveService(),
      sharedPrefsService: SharedPrefsService(),
      secureStorageService: SecureStorageService(),
    );
    return _instance!;
  }

  /// Initialize all storage services
  Future<void> initialize() async {
    try {
      AppLogger.i('Initializing storage services...');

      await Future.wait([
        _hiveService.initialize(),
        _sharedPrefsService.initialize(),
      ]);

      AppLogger.i('All storage services initialized successfully');
    } catch (e) {
      AppLogger.e('Storage service initialization failed', error: e);
      throw StorageException(message: 'Failed to initialize storage services: $e');
    }
  }

  /// Close all storage services
  Future<void> close() async {
    try {
      await _hiveService.close();
      AppLogger.i('Storage services closed successfully');
    } catch (e) {
      AppLogger.i('Storage service close failed', error: e);
    }
  }

  // Hive Service Delegation
  HiveService get hive => _hiveService;

  // SharedPreferences Service Delegation
  SharedPrefsService get prefs => _sharedPrefsService;

  // Secure Storage Service Delegation
  SecureStorageService get secure => _secureStorageService;

  /// Clear all storage data (use with caution)
  Future<void> clearAll() async {
    try {
      AppLogger.w('Clearing all storage data...');

      await Future.wait([
        _hiveService.clearUserData(),
        _hiveService.clearSettings(),
        _hiveService.clearCache(),
        _sharedPrefsService.clear(),
        _secureStorageService.deleteAll(),
      ]);

      AppLogger.i('All storage data cleared successfully');
    } catch (e) {
      AppLogger.e('Failed to clear all storage data', error: e);
      throw StorageException(message: 'Failed to clear all storage: $e');
    }
  }

  /// Get storage information for debugging
  Future<Map<String, dynamic>> getStorageInfo() async {
    try {
      final hiveUserKeys = _hiveService.getKeys('user_box').length;
      final hiveSettingsKeys = _hiveService.getKeys('settings_box').length;
      final hiveCacheKeys = _hiveService.getKeys('cache_box').length;
      final prefsKeys = _sharedPrefsService.getKeys().length;
      final secureKeys = (await _secureStorageService.readAll()).keys.length;

      return {
        'hive': {
          'user_keys': hiveUserKeys,
          'settings_keys': hiveSettingsKeys,
          'cache_keys': hiveCacheKeys,
        },
        'shared_preferences': {
          'keys': prefsKeys,
        },
        'secure_storage': {
          'keys': secureKeys,
        },
      };
    } catch (e) {
      AppLogger.e('Failed to get storage info', error: e);
      return {};
    }
  }

  // ==================== Hive 操作 ====================

  /// 用户数据操作
  Future<void> setUserData(String key, dynamic value) async {
    await hive.userBox.put(key, value);
  }

  T? getUserData<T>(String key) {
    return hive.userBox.get(key) as T?;
  }

  Future<void> removeUserData(String key) async {
    await hive.userBox.delete(key);
  }

  Future<void> clearUserData() async {
    await hive.userBox.clear();
  }

  /// 存储用户令牌
  Future<void> setUserToken(String token) async {
    await secure.write(StorageKeys.userTokenKey, token);
  }

  /// 获取用户令牌
  Future<String?> getUserToken() async {
    return secure.read(StorageKeys.userTokenKey);
  }

  /// 移除用户令牌
  Future<void> removeUserToken() async {
    await secure.delete(StorageKeys.userTokenKey);
  }

  /// 检查是否登录
  Future<bool> isLoggedIn() async {
    // return Future.value(true);
    final token = await getUserToken();
    return token != null && token.isNotEmpty;
  }
}
