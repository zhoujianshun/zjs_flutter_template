import 'package:zjs_flutter_template/core/utils/logger.dart';

/// Application route paths constants
class RoutePaths {
  // Root routes
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';

  // Authentication routes
  static const String authBase = '/auth';
  static const String login = '$authBase/login';
  static const String register = '$authBase/register';
  static const String forgotPassword = '$authBase/forgot-password';
  static const String resetPassword = '$authBase/reset-password';

  // Main application routes
  static const String home = '/home';
  static const String profile = '/profile';
  static const String settings = '/settings';

  // Feature routes
  static const String dashboard = '/dashboard';
  static const String notifications = '/notifications';
  static const String search = '/search';

  // Settings sub-routes
  static const String accountSettings = '/settings/account';
  static const String privacySettings = '/settings/privacy';
  static const String notificationSettings = '/settings/notifications';
  static const String themeSettings = '/profile/theme';
  static const String languageSettings = '/settings/language';
  static const String aboutSettings = '/settings/about';

  // Error routes
  static const String notFound = '/404';
  static const String error = '/error';

  static const List<String> publicRoutes = [
    splash,
    onboarding,
    login,
    register,
    forgotPassword,
    resetPassword,
    notFound,
    error,
  ];

  /// Get route name from path
  static String getRouteName(String path) {
    switch (path) {
      case splash:
        return 'Splash';
      case onboarding:
        return 'Onboarding';
      case login:
        return 'Login';
      case register:
        return 'Register';
      case forgotPassword:
        return 'Forgot Password';
      case resetPassword:
        return 'Reset Password';
      case home:
        return 'Home';
      case profile:
        return 'Profile';
      case settings:
        return 'Settings';
      case dashboard:
        return 'Dashboard';
      case notifications:
        return 'Notifications';
      case search:
        return 'Search';
      case accountSettings:
        return 'Account Settings';
      case privacySettings:
        return 'Privacy Settings';
      case notificationSettings:
        return 'Notification Settings';
      case themeSettings:
        return 'Theme Settings';
      case languageSettings:
        return 'Language Settings';
      case aboutSettings:
        return 'About';
      case notFound:
        return '404 Not Found';
      case error:
        return 'Error';
      default:
        return 'Unknown';
    }
  }

  /// Check if route requires authentication
  static bool requiresAuth(String path) {
    return !publicRoutes.contains(path);
  }

  /// Check if route is authentication route
  static bool isAuthRoute(String path) {
    return path.startsWith(authBase);
  }

  /// Check if route is public (doesn't require auth)
  static bool isPublicRoute(String path) {
    return !requiresAuth(path);
  }

  /// Get sub-path from path
  static String getSubPath(String path, String subpath) {
    // 从path中剔除subpath
    // 剔除开头的/
    var newPath = path.replaceAll(subpath, '');
    if (newPath.startsWith('/')) {
      newPath = newPath.replaceFirst('/', '');
    }
    AppLogger.info('getSubPath: $newPath');
    return newPath;
  }
}
