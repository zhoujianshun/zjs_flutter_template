/// 应用核心常量定义
class AppConstants {
  AppConstants._();

  // API配置
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

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
