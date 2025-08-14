import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sky_eldercare_family/config/routes/route_paths.dart';
import 'package:sky_eldercare_family/core/constants/storage_keys.dart';
import 'package:sky_eldercare_family/core/storage/storage_service.dart';
import 'package:sky_eldercare_family/core/utils/logger.dart';

/// Route guard for authentication and navigation control
class RouteGuards {
  static final StorageService _storageService = StorageService.instance;

  /// Main redirect logic for authentication
  static Future<String?> authRedirect(BuildContext context, GoRouterState state) async {
    final location = state.uri.path;

    AppLogger.debug('Route guard check: $location');

    // Check if user is authenticated
    final isAuthenticated = await _isUserAuthenticated();
    final isFirstLaunch = _isFirstLaunch();
    final hasCompletedOnboarding = _hasCompletedOnboarding();

    AppLogger.debug(
      'Auth status - isAuthenticated: $isAuthenticated, isFirstLaunch: $isFirstLaunch, hasCompletedOnboarding: $hasCompletedOnboarding',
    );

    // Handle first launch and onboarding (only redirect from splash)
    // if (isFirstLaunch && location == RoutePaths.splash) {
    if (isFirstLaunch) {
      AppLogger.info('Redirecting to onboarding - first launch');
      return RoutePaths.onboarding;
    }

    // If not completed onboarding and trying to access protected routes
    if (!hasCompletedOnboarding && RoutePaths.requiresAuth(location)) {
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
      // If user is authenticated and trying to access login/register
      if (isAuthenticated && (location == RoutePaths.login || location == RoutePaths.register)) {
        AppLogger.info('Redirecting to home - already authenticated');
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

      // return isLoggedIn && hasToken;
      return await _storageService.isLoggedIn();
    } catch (e) {
      AppLogger.error('Failed to check authentication status', error: e);
      return Future.value(false);
    }
  }

  /// Check if this is first launch
  static bool _isFirstLaunch() {
    try {
      return _storageService.prefs.getBool(StorageKeys.isFirstLaunch) ?? false;
    } catch (e) {
      AppLogger.error('Failed to check first launch status', error: e);
      return true;
    }
  }

  /// Check if onboarding is completed
  static bool _hasCompletedOnboarding() {
    try {
      return _storageService.prefs.getBool(StorageKeys.onboardingCompleted) ?? false;
    } catch (e) {
      AppLogger.error('Failed to check onboarding status', error: e);
      return false;
    }
  }

  /// Mark first launch as completed
  static Future<void> completeFirstLaunch() async {
    try {
      await _storageService.prefs.setBool(StorageKeys.isFirstLaunch, false);
      AppLogger.info('First launch completed');
    } catch (e) {
      AppLogger.error('Failed to mark first launch as completed', error: e);
    }
  }

  /// Mark onboarding as completed
  static Future<void> completeOnboarding() async {
    try {
      await _storageService.prefs.setBool(StorageKeys.onboardingCompleted, true);
      AppLogger.info('Onboarding completed');
    } catch (e) {
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
