import 'package:zjs_flutter_template/core/monitoring/interfaces/analytics_interface.dart';
import 'package:zjs_flutter_template/core/monitoring/interfaces/error_monitor_interface.dart';
import 'package:zjs_flutter_template/core/monitoring/interfaces/performance_monitor_interface.dart';
import 'package:zjs_flutter_template/core/utils/logger.dart';
import 'package:zjs_flutter_template/di/service_locator.dart';

/// 简化的监控管理器
///
/// 使用接口抽象，方便后续替换为真实的监控服务
class SimpleMonitoringManager {
  SimpleMonitoringManager._();

  static final SimpleMonitoringManager _instance = SimpleMonitoringManager._();
  static SimpleMonitoringManager get instance => _instance;

  late final IErrorMonitor _errorMonitor;
  late final IAnalyticsService _analyticsService;
  late final IPerformanceMonitor _performanceMonitor;

  bool _isInitialized = false;

  /// 初始化所有监控服务
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      AppLogger.info('🔧 初始化监控管理器...');

      // 从服务定位器获取实现
      _errorMonitor = getIt<IErrorMonitor>();
      _analyticsService = getIt<IAnalyticsService>();
      _performanceMonitor = getIt<IPerformanceMonitor>();

      // 初始化各个服务
      await Future.wait([
        _errorMonitor.initialize(),
        _analyticsService.initialize(),
        _performanceMonitor.initialize(),
      ]);

      _isInitialized = true;
      AppLogger.info('✅ 监控管理器初始化完成');
    } catch (e, stackTrace) {
      AppLogger.error('监控管理器初始化失败', error: e, stackTrace: stackTrace);
    }
  }

  /// 报告错误
  Future<void> reportError(
    Object error,
    StackTrace? stackTrace, {
    String? context,
    String? userId,
    Map<String, dynamic>? extra,
  }) async {
    if (!_isInitialized) {
      AppLogger.warning('监控管理器未初始化，跳过错误上报');
      return;
    }

    try {
      await _errorMonitor.reportError(
        error,
        stackTrace,
        context: context,
        userId: userId,
        extra: extra,
      );
    } catch (e) {
      AppLogger.error('错误上报失败', error: e);
    }
  }

  /// 记录自定义事件
  Future<void> trackEvent(String eventName, {Map<String, dynamic>? parameters}) async {
    if (!_isInitialized) {
      AppLogger.warning('监控管理器未初始化，跳过事件记录');
      return;
    }

    try {
      await _analyticsService.trackEvent(eventName, parameters: parameters);
    } catch (e) {
      AppLogger.error('事件记录失败', error: e);
    }
  }

  /// 记录页面访问
  Future<void> trackPageView(String screenName, {String? screenClass}) async {
    if (!_isInitialized) {
      AppLogger.warning('监控管理器未初始化，跳过页面访问记录');
      return;
    }

    try {
      await _analyticsService.trackPageView(screenName, screenClass: screenClass);
    } catch (e) {
      AppLogger.error('页面访问记录失败', error: e);
    }
  }

  /// 测量同步操作耗时
  T measureSync<T>(
    String operationName,
    T Function() operation, {
    Map<String, dynamic>? metadata,
  }) {
    if (!_isInitialized) {
      return operation();
    }

    try {
      return _performanceMonitor.measureSync(operationName, operation, metadata: metadata);
    } catch (e) {
      AppLogger.error('同步操作测量失败', error: e);
      return operation();
    }
  }

  /// 测量异步操作耗时
  Future<T> measureAsync<T>(
    String operationName,
    Future<T> Function() operation, {
    Map<String, dynamic>? metadata,
  }) async {
    if (!_isInitialized) {
      return operation();
    }

    try {
      return _performanceMonitor.measureAsync(operationName, operation, metadata: metadata);
    } catch (e) {
      AppLogger.error('异步操作测量失败', error: e);
      return operation();
    }
  }

  /// 设置用户信息
  Future<void> setUser({
    required String userId,
    String? email,
    String? username,
    Map<String, dynamic>? properties,
  }) async {
    if (!_isInitialized) return;

    try {
      // 设置错误监控的用户信息
      _errorMonitor.setUser(
        userId: userId,
        email: email,
        username: username,
        extra: properties,
      );

      // 设置分析服务的用户属性
      await _analyticsService.setUserProperties(
        userId: userId,
        properties: {
          if (email != null) UserProperties.email: email,
          if (username != null) UserProperties.username: username,
          ...?properties,
        },
      );

      AppLogger.info('👤 用户信息已设置到监控系统');
    } catch (e) {
      AppLogger.error('设置用户信息失败', error: e);
    }
  }

  /// 清除用户信息
  Future<void> clearUser() async {
    if (!_isInitialized) return;

    try {
      _errorMonitor.clearUser();
      await _analyticsService.setUserProperties();
      AppLogger.info('👤 用户信息已从监控系统清除');
    } catch (e) {
      AppLogger.error('清除用户信息失败', error: e);
    }
  }

  /// 添加面包屑
  void addBreadcrumb(
    String message, {
    String? category,
    String? level,
    Map<String, dynamic>? data,
  }) {
    if (!_isInitialized) return;

    try {
      _errorMonitor.addBreadcrumb(
        message,
        category: category,
        level: level,
        data: data,
      );
    } catch (e) {
      AppLogger.error('添加面包屑失败', error: e);
    }
  }

  /// 记录网络请求性能
  Future<void> trackNetworkPerformance(
    String url,
    String method,
    int statusCode,
    Duration duration, {
    int? requestSize,
    int? responseSize,
  }) async {
    if (!_isInitialized) return;

    try {
      await _performanceMonitor.trackNetworkPerformance(
        url,
        method,
        statusCode,
        duration,
        requestSize: requestSize,
        responseSize: responseSize,
      );
    } catch (e) {
      AppLogger.error('网络性能记录失败', error: e);
    }
  }

  /// 获取监控系统摘要
  Map<String, dynamic> getMonitoringSummary() {
    return {
      'is_initialized': _isInitialized,
      'error_monitor': _errorMonitor.serviceName,
      'analytics_service': _analyticsService.serviceName,
      'performance_monitor': _performanceMonitor.serviceName,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// 检查是否已初始化
  bool get isInitialized => _isInitialized;
}

/// 监控工具类
class MonitoringUtils {
  MonitoringUtils._();

  /// 包装可能抛出异常的同步操作
  static T wrapSync<T>(
    String operationName,
    T Function() operation, {
    Map<String, dynamic>? metadata,
  }) {
    return SimpleMonitoringManager.instance.measureSync(
      operationName,
      () {
        try {
          return operation();
        } catch (e, s) {
          SimpleMonitoringManager.instance.reportError(
            e,
            s,
            context: 'sync_operation_failed',
            extra: {
              'operation_name': operationName,
              if (metadata != null) ...metadata,
            },
          );
          rethrow;
        }
      },
      metadata: metadata,
    );
  }

  /// 包装可能抛出异常的异步操作
  static Future<T> wrapAsync<T>(
    String operationName,
    Future<T> Function() operation, {
    Map<String, dynamic>? metadata,
  }) async {
    return SimpleMonitoringManager.instance.measureAsync(
      operationName,
      () async {
        try {
          return await operation();
        } catch (e, s) {
          SimpleMonitoringManager.instance.reportError(
            e,
            s,
            context: 'async_operation_failed',
            extra: {
              'operation_name': operationName,
              if (metadata != null) ...metadata,
            },
          );
          rethrow;
        }
      },
      metadata: metadata,
    );
  }
}
