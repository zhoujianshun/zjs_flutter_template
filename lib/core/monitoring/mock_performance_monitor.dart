import 'dart:developer' as developer;

import 'package:injectable/injectable.dart';
import 'package:zjs_flutter_template/core/monitoring/interfaces/performance_monitor_interface.dart';
import 'package:zjs_flutter_template/core/utils/logger.dart';

/// 模拟性能监控服务
///
/// 用于开发阶段，将性能数据输出到控制台
/// 后续可以替换为真实的性能监控服务实现
@Singleton(as: IPerformanceMonitor)
class MockPerformanceMonitor implements IPerformanceMonitor {
  bool _isInitialized = false;
  final Map<String, Stopwatch> _activeTimers = {};
  final List<PerformanceMetric> _metrics = [];

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    AppLogger.info('🔧 初始化模拟性能监控服务...');

    // 模拟初始化延迟
    await Future<void>.delayed(const Duration(milliseconds: 10));

    _isInitialized = true;
    AppLogger.info('✅ 模拟性能监控服务初始化完成');
  }

  @override
  T measureSync<T>(
    String operationName,
    T Function() operation, {
    Map<String, dynamic>? metadata,
  }) {
    if (!_isInitialized) {
      AppLogger.warning('性能监控服务未初始化，直接执行操作');
      return operation();
    }

    final stopwatch = Stopwatch()..start();

    try {
      final result = operation();
      stopwatch.stop();

      _recordMetric(
        operationName,
        PerformanceMetricType.custom,
        stopwatch.elapsed,
        metadata,
      );

      return result;
    } catch (e) {
      stopwatch.stop();
      _recordMetric(
        '$operationName (失败)',
        PerformanceMetricType.custom,
        stopwatch.elapsed,
        {
          ...?metadata,
          'error': e.toString(),
          'success': false,
        },
      );
      rethrow;
    }
  }

  @override
  Future<T> measureAsync<T>(
    String operationName,
    Future<T> Function() operation, {
    Map<String, dynamic>? metadata,
  }) async {
    if (!_isInitialized) {
      AppLogger.warning('性能监控服务未初始化，直接执行操作');
      return operation();
    }

    final stopwatch = Stopwatch()..start();

    try {
      final result = await operation();
      stopwatch.stop();

      _recordMetric(
        operationName,
        PerformanceMetricType.custom,
        stopwatch.elapsed,
        metadata,
      );

      return result;
    } catch (e) {
      stopwatch.stop();
      _recordMetric(
        '$operationName (失败)',
        PerformanceMetricType.custom,
        stopwatch.elapsed,
        {
          ...?metadata,
          'error': e.toString(),
          'success': false,
        },
      );
      rethrow;
    }
  }

  @override
  void startTimer(String operationName) {
    if (!_isInitialized) return;

    if (_activeTimers.containsKey(operationName)) {
      AppLogger.warning('计时器 $operationName 已经在运行，将重新开始');
    }

    _activeTimers[operationName] = Stopwatch()..start();
    AppLogger.debug('⏱️ [MockPerformanceMonitor] 开始计时: $operationName');
  }

  @override
  void endTimer(String operationName, {Map<String, dynamic>? metadata}) {
    if (!_isInitialized) return;

    final stopwatch = _activeTimers.remove(operationName);
    if (stopwatch == null) {
      AppLogger.warning('计时器 $operationName 不存在或已经结束');
      return;
    }

    stopwatch.stop();
    _recordMetric(
      operationName,
      PerformanceMetricType.custom,
      stopwatch.elapsed,
      metadata,
    );
  }

  @override
  Future<void> trackNetworkPerformance(
    String url,
    String method,
    int statusCode,
    Duration duration, {
    int? requestSize,
    int? responseSize,
  }) async {
    if (!_isInitialized) return;

    _recordMetric(
      '网络请求: $method $url',
      PerformanceMetricType.network,
      duration,
      {
        'url': url,
        'method': method,
        'status_code': statusCode,
        'success': statusCode >= 200 && statusCode < 300,
        if (requestSize != null) 'request_size': requestSize,
        if (responseSize != null) 'response_size': responseSize,
      },
    );

    // 模拟上报延迟
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }

  @override
  Future<void> trackDatabaseOperation(
    String operationType,
    String tableName,
    Duration duration, {
    int? recordCount,
  }) async {
    if (!_isInitialized) return;

    _recordMetric(
      '数据库操作: $operationType $tableName',
      PerformanceMetricType.database,
      duration,
      {
        'operation_type': operationType,
        'table_name': tableName,
        if (recordCount != null) 'record_count': recordCount,
      },
    );

    // 模拟上报延迟
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }

  @override
  Future<void> trackAppStartup(Duration duration) async {
    if (!_isInitialized) return;

    _recordMetric(
      '应用启动',
      PerformanceMetricType.appStartup,
      duration,
      {
        'startup_time_ms': duration.inMilliseconds,
      },
    );

    // 模拟上报延迟
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }

  @override
  Future<void> trackPageRender(String pageName, Duration renderTime) async {
    if (!_isInitialized) return;

    _recordMetric(
      '页面渲染: $pageName',
      PerformanceMetricType.pageRender,
      renderTime,
      {
        'page_name': pageName,
        'render_time_ms': renderTime.inMilliseconds,
      },
    );

    // 模拟上报延迟
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }

  @override
  Future<void> trackMemoryUsage(int usedMemory, int totalMemory) async {
    if (!_isInitialized) return;

    _recordMetric(
      '内存使用',
      PerformanceMetricType.memoryUsage,
      Duration.zero, // 内存使用不是时间指标
      {
        'used_memory': usedMemory,
        'total_memory': totalMemory,
        'memory_usage_percent': (usedMemory / totalMemory * 100).toStringAsFixed(2),
      },
    );

    // 模拟上报延迟
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }

  @override
  Map<String, dynamic> getAllMetrics() {
    final metricsByType = <String, List<PerformanceMetric>>{};

    for (final metric in _metrics) {
      metricsByType.putIfAbsent(metric.type.type, () => []).add(metric);
    }

    return {
      'total_metrics': _metrics.length,
      'metrics_by_type': metricsByType.map(
        (type, metrics) => MapEntry(type, metrics.map((m) => m.toJson()).toList()),
      ),
      'summary': _generateSummary(),
    };
  }

  @override
  void clearMetrics() {
    _metrics.clear();
    _activeTimers.clear();
    AppLogger.info('🔄 [MockPerformanceMonitor] 清除所有性能指标');
  }

  @override
  bool get isInitialized => _isInitialized;

  @override
  String get serviceName => 'MockPerformanceMonitor';

  /// 记录性能指标
  void _recordMetric(
    String name,
    PerformanceMetricType type,
    Duration duration,
    Map<String, dynamic>? metadata,
  ) {
    final metric = PerformanceMetric(
      name: name,
      type: type,
      duration: duration,
      timestamp: DateTime.now(),
      metadata: metadata,
    );

    _metrics.add(metric);

    // 保持最多5000个指标
    if (_metrics.length > 5000) {
      _metrics.removeAt(0);
    }

    AppLogger.info(
      '⚡ [MockPerformanceMonitor] 性能指标: $name (${duration.inMilliseconds}ms)',
    );

    developer.log(
      '⚡ 性能指标: $name - ${duration.inMilliseconds}ms',
      name: 'MockPerformanceMonitor',
    );
  }

  /// 生成性能摘要
  Map<String, dynamic> _generateSummary() {
    if (_metrics.isEmpty) {
      return {'message': '暂无性能数据'};
    }

    final durations = _metrics
        .where((m) => m.type != PerformanceMetricType.memoryUsage)
        .map((m) => m.duration.inMilliseconds)
        .toList();

    if (durations.isEmpty) {
      return {'message': '暂无时间性能数据'};
    }

    durations.sort();

    return {
      'total_operations': durations.length,
      'avg_duration_ms': durations.isEmpty ? 0 : durations.reduce((a, b) => a + b) / durations.length,
      'min_duration_ms': durations.isEmpty ? 0 : durations.first,
      'max_duration_ms': durations.isEmpty ? 0 : durations.last,
      'p50_duration_ms': durations.isEmpty ? 0 : durations[(durations.length * 0.5).floor()],
      'p95_duration_ms': durations.isEmpty ? 0 : durations[(durations.length * 0.95).floor()],
      'p99_duration_ms': durations.isEmpty ? 0 : durations[(durations.length * 0.99).floor()],
    };
  }

  /// 获取当前状态摘要（用于调试）
  Map<String, dynamic> getStatusSummary() {
    return {
      'service_name': serviceName,
      'is_initialized': isInitialized,
      'active_timers': _activeTimers.keys.toList(),
      'total_metrics': _metrics.length,
      'recent_metrics': _metrics.take(5).map((m) => m.toJson()).toList(),
      'performance_summary': _generateSummary(),
    };
  }
}
