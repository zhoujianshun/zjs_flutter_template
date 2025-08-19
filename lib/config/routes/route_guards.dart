import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zjs_flutter_template/config/routes/route_paths.dart';
import 'package:zjs_flutter_template/core/constants/storage_keys.dart';
import 'package:zjs_flutter_template/core/storage/storage_service.dart';
import 'package:zjs_flutter_template/core/utils/logger.dart';
import 'package:zjs_flutter_template/di/service_locator.dart';

/// Route guard for authentication and navigation control
class RouteGuards {
  // 防重定向循环的状态管理
  static final Set<String> _redirectingPaths = <String>{};
  static const int _maxRedirectCount = 3;
  static final Map<String, int> _redirectCounts = <String, int>{};

  /// Main redirect logic for authentication
  static Future<String?> authRedirect(BuildContext context, GoRouterState state) async {
    final location = state.uri.path;

    // 防止重定向循环
    if (_isRedirectLoop(location)) {
      AppLogger.error('Redirect loop detected for path: $location');
      return RoutePaths.home; // 回到安全的默认路由
    }

    try {
      _redirectingPaths.add(location);

      final result = await _performRedirect(context, state);

      if (result != null) {
        _incrementRedirectCount(location);
      } else {
        _resetRedirectCount(location);
      }

      return result;
    } finally {
      _redirectingPaths.remove(location);
    }
  }

  /// 检查是否存在重定向循环
  static bool _isRedirectLoop(String location) {
    if (_redirectingPaths.contains(location)) {
      return true;
    }

    final count = _redirectCounts[location] ?? 0;
    return count >= _maxRedirectCount;
  }

  /// 增加重定向计数
  static void _incrementRedirectCount(String location) {
    _redirectCounts[location] = (_redirectCounts[location] ?? 0) + 1;
  }

  /// 重置重定向计数
  static void _resetRedirectCount(String location) {
    _redirectCounts.remove(location);
  }

  /// 执行实际的重定向逻辑
  static Future<String?> _performRedirect(BuildContext context, GoRouterState state) async {
    final location = state.uri.path;

    AppLogger.debug('Route guard check: $location');

    // Check if user is authenticated
    final isAuthenticated = await _isUserAuthenticated();
    final isFirstLaunch = _isFirstLaunch();
    final hasCompletedOnboarding = _hasCompletedOnboarding();

    AppLogger.debug(
      'Auth status - isAuthenticated: $isAuthenticated, isFirstLaunch: $isFirstLaunch, hasCompletedOnboarding: $hasCompletedOnboarding',
    );

    // Handle first launch and onboarding
    if (isFirstLaunch && location != RoutePaths.onboarding) {
      AppLogger.info('Redirecting to onboarding - first launch');
      return RoutePaths.onboarding;
    }

    // If not completed onboarding and trying to access protected routes
    if (!hasCompletedOnboarding && location != RoutePaths.onboarding && RoutePaths.requiresAuth(location)) {
      AppLogger.info('Redirecting to onboarding - not completed and accessing protected route');
      return RoutePaths.onboarding;
    }

    // Handle authentication for protected routes
    if (RoutePaths.requiresAuth(location)) {
      if (!isAuthenticated) {
        AppLogger.info('Redirecting to login - not authenticated');
        return RoutePaths.login;
      }
    } else {
      // If user is authenticated and trying to access auth pages
      if (isAuthenticated && RoutePaths.isAuthRoute(location)) {
        AppLogger.info('Redirecting authenticated user to home');
        return RoutePaths.home;
      }
    }

    // No redirect needed
    return null;
  }

  /// Check if user is authenticated
  static Future<bool> _isUserAuthenticated() async {
    try {
      // return true;
      // final isLoggedIn = _storageService.prefs.getBool(StorageKeys.isLoggedIn) ?? false;
      // final hasToken = _storageService.hive.getUser<String>('access_token') != null;
      final storageService = ServiceLocator.get<StorageService>();
      // return isLoggedIn && hasToken;
      return await storageService.isLoggedIn();
    } on Exception catch (e) {
      AppLogger.error('Failed to check authentication status', error: e);
      return Future.value(false);
    }
  }

  /// Check if this is first launch
  static bool _isFirstLaunch() {
    try {
      final storageService = ServiceLocator.get<StorageService>();
      return storageService.prefs.getBool(StorageKeys.isFirstLaunch) ?? false;
    } on Exception catch (e) {
      AppLogger.error('Failed to check first launch status', error: e);
      return true;
    }
  }

  /// Check if onboarding is completed
  static bool _hasCompletedOnboarding() {
    try {
      final storageService = ServiceLocator.get<StorageService>();
      return storageService.prefs.getBool(StorageKeys.onboardingCompleted) ?? false;
    } on Exception catch (e) {
      AppLogger.error('Failed to check onboarding status', error: e);
      return false;
    }
  }

  /// Mark first launch as completed
  static Future<void> completeFirstLaunch() async {
    try {
      final storageService = ServiceLocator.get<StorageService>();
      await storageService.prefs.setBool(StorageKeys.isFirstLaunch, false);
      AppLogger.info('First launch completed');
    } on Exception catch (e) {
      AppLogger.error('Failed to mark first launch as completed', error: e);
    }
  }

  /// Mark onboarding as completed
  static Future<void> completeOnboarding() async {
    try {
      final storageService = ServiceLocator.get<StorageService>();
      await storageService.prefs.setBool(StorageKeys.onboardingCompleted, true);
      AppLogger.info('Onboarding completed');
    } on Exception catch (e) {
      AppLogger.error('Failed to mark onboarding as completed', error: e);
    }
  }

  /// Set user authentication status
  // static Future<void> setAuthenticated(bool isAuthenticated) async {
  //   try {
  //     await _storageService.prefs.setBool(StorageKeys.isLoggedIn, isAuthenticated);

  //     if (!isAuthenticated) {
  //       // Clear user data on logout
  //       await _storageService.hive.clearUserData();
  //       await _storageService.secure.deleteAll();
  //     }

  //     AppLogger.info('Authentication status updated: $isAuthenticated');
  //   } catch (e) {
  //     AppLogger.error('Failed to set authentication status', error: e);
  //   }
  // }
}
