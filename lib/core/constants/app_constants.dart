/// 应用核心常量定义
class AppConstants {
  AppConstants._();

  // 应用信息
  static const String appName = 'Sky Eldercare Family';
  static const String appVersion = '1.0.0';

  // API配置
  static const String baseUrl = 'https://api.example.com';
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // 存储Keys
  static const String userTokenKey = 'user_token';
  static const String userInfoKey = 'user_info';
  // static const String themeKey = 'theme_mode';
  // static const String languageKey = 'language_code';

  // Hive Box Names
  static const String userBox = 'user_box';
  static const String settingsBox = 'settings_box';
  static const String cacheBox = 'cache_box';

  // 路由常量
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String homeRoute = '/home';
  static const String profileRoute = '/profile';

  // 动画时长
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration splashDuration = Duration(seconds: 3);

  // UI常量
  static const double defaultPadding = 16;
  static const double defaultRadius = 12;
  static const double defaultElevation = 4;

  // 分页参数
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;
}
