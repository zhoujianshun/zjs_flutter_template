import 'package:flutter/foundation.dart';

/// 应用环境配置
class AppConfig {
  AppConfig._();

  /// 是否为调试模式
  // static const bool isDebug = bool.fromEnvironment('DEBUG', defaultValue: true);
  static bool get isDebug {
    return kDebugMode;
  }

  /// 日志级别
  // static const String logLevel = String.fromEnvironment('LOG_LEVEL', defaultValue: 'debug');
  static String get logLevel {
    return kDebugMode ? 'debug' : 'release';
  }

  /// 环境类型
  // static const String environment = String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');
  static String get environment {
    return kDebugMode ? 'development' : 'production';
  }

  static String get baseUrl {
    return kDebugMode
        ? 'https://m1.apifoxmock.com/m1/6726754-6437921-default/api'
        : 'https://m1.apifoxmock.com/m1/6726754-6437921-default/api';
  }

  // /// API基础URL
  // static const String apiBaseUrl = String.fromEnvironment(
  //   'API_BASE_URL',
  //   defaultValue: 'https://m1.apifoxmock.com/m1/6726754-6437921-default/api',
  // );

  // /// 是否启用分析统计
  // static const bool enableAnalytics = bool.fromEnvironment('ENABLE_ANALYTICS');

  // /// 是否启用崩溃报告
  // static const bool enableCrashReporting = bool.fromEnvironment('ENABLE_CRASH_REPORTING');

  // /// 是否启用性能监控
  // static const bool enablePerformanceMonitoring = bool.fromEnvironment('ENABLE_PERFORMANCE_MONITORING');

  // /// 是否启用生物识别
  // static const bool enableBiometric = bool.fromEnvironment('ENABLE_BIOMETRIC', defaultValue: true);

  // /// 是否启用推送通知
  // static const bool enablePushNotifications = bool.fromEnvironment('ENABLE_PUSH_NOTIFICATIONS', defaultValue: true);

  // /// 连接超时时间（毫秒）
  // static const int connectTimeout = int.fromEnvironment('CONNECT_TIMEOUT', defaultValue: 30000);

  // /// 接收超时时间（毫秒）
  // static const int receiveTimeout = int.fromEnvironment('RECEIVE_TIMEOUT', defaultValue: 30000);

  // /// 最大重试次数
  // static const int maxRetries = int.fromEnvironment('MAX_RETRIES', defaultValue: 3);

  // /// 重试延迟时间（毫秒）
  // static const int retryDelay = int.fromEnvironment('RETRY_DELAY', defaultValue: 1000);

  /// 是否为生产环境
  static bool get isProduction => environment == 'production';

  /// 是否为开发环境
  static bool get isDevelopment => environment == 'development';

  /// 是否为测试环境
  static bool get isStaging => environment == 'staging';

  /// 获取环境显示名称
  static String get environmentDisplayName {
    switch (environment) {
      case 'production':
        return '生产环境';
      case 'staging':
        return '测试环境';
      case 'development':
      default:
        return '开发环境';
    }
  }
}
