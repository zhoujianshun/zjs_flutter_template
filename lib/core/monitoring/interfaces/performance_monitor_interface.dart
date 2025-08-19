/// 性能监控接口
///
/// 定义了性能监控服务的标准接口，方便后续接入不同的性能监控平台
abstract class IPerformanceMonitor {
  /// 初始化性能监控服务
  Future<void> initialize();

  /// 测量同步操作的耗时
  ///
  /// [operationName] 操作名称
  /// [operation] 要测量的操作
  /// [metadata] 附加元数据
  T measureSync<T>(
    String operationName,
    T Function() operation, {
    Map<String, dynamic>? metadata,
  });

  /// 测量异步操作的耗时
  ///
  /// [operationName] 操作名称
  /// [operation] 要测量的异步操作
  /// [metadata] 附加元数据
  Future<T> measureAsync<T>(
    String operationName,
    Future<T> Function() operation, {
    Map<String, dynamic>? metadata,
  });

  /// 开始性能计时
  ///
  /// [operationName] 操作名称
  void startTimer(String operationName);

  /// 结束性能计时
  ///
  /// [operationName] 操作名称
  /// [metadata] 附加元数据
  void endTimer(String operationName, {Map<String, dynamic>? metadata});

  /// 记录网络请求性能
  ///
  /// [url] 请求URL
  /// [method] 请求方法
  /// [statusCode] 状态码
  /// [duration] 请求耗时
  /// [requestSize] 请求大小（字节）
  /// [responseSize] 响应大小（字节）
  Future<void> trackNetworkPerformance(
    String url,
    String method,
    int statusCode,
    Duration duration, {
    int? requestSize,
    int? responseSize,
  });

  /// 记录数据库操作性能
  ///
  /// [operationType] 操作类型（select, insert, update, delete等）
  /// [tableName] 表名
  /// [duration] 操作耗时
  /// [recordCount] 影响的记录数
  Future<void> trackDatabaseOperation(
    String operationType,
    String tableName,
    Duration duration, {
    int? recordCount,
  });

  /// 记录应用启动时间
  ///
  /// [duration] 启动耗时
  Future<void> trackAppStartup(Duration duration);

  /// 记录页面渲染性能
  ///
  /// [pageName] 页面名称
  /// [renderTime] 渲染时间
  Future<void> trackPageRender(String pageName, Duration renderTime);

  /// 记录内存使用情况
  ///
  /// [usedMemory] 已使用内存（字节）
  /// [totalMemory] 总内存（字节）
  Future<void> trackMemoryUsage(int usedMemory, int totalMemory);

  /// 获取所有性能指标
  Map<String, dynamic> getAllMetrics();

  /// 清除性能指标
  void clearMetrics();

  /// 检查性能监控是否已初始化
  bool get isInitialized;

  /// 获取性能监控服务名称
  String get serviceName;
}

/// 性能指标类型枚举
enum PerformanceMetricType {
  /// 网络请求
  network('network'),

  /// 数据库操作
  database('database'),

  /// 应用启动
  appStartup('app_startup'),

  /// 页面渲染
  pageRender('page_render'),

  /// 内存使用
  memoryUsage('memory_usage'),

  /// 自定义操作
  custom('custom');

  const PerformanceMetricType(this.type);
  final String type;
}

/// 性能指标数据模型
class PerformanceMetric {
  const PerformanceMetric({
    required this.name,
    required this.type,
    required this.duration,
    required this.timestamp,
    this.metadata,
  });

  final String name;
  final PerformanceMetricType type;
  final Duration duration;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type.type,
        'duration_ms': duration.inMilliseconds,
        'timestamp': timestamp.toIso8601String(),
        if (metadata != null) 'metadata': metadata,
      };
}
