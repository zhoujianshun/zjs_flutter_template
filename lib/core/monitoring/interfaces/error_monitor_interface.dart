/// 错误监控接口
///
/// 定义了错误监控服务的标准接口，方便后续接入不同的监控平台
abstract class IErrorMonitor {
  /// 初始化错误监控系统
  Future<void> initialize();

  /// 手动上报错误
  ///
  /// [error] 错误对象
  /// [stackTrace] 堆栈跟踪
  /// [context] 错误上下文描述
  /// [userId] 用户ID
  /// [extra] 额外信息
  Future<void> reportError(
    Object error,
    StackTrace? stackTrace, {
    String? context,
    String? userId,
    Map<String, dynamic>? extra,
  });

  /// 添加面包屑（用于错误调试的上下文信息）
  ///
  /// [message] 面包屑消息
  /// [category] 分类
  /// [level] 级别
  /// [data] 附加数据
  void addBreadcrumb(
    String message, {
    String? category,
    String? level,
    Map<String, dynamic>? data,
  });

  /// 设置用户信息
  ///
  /// [userId] 用户ID
  /// [email] 用户邮箱
  /// [username] 用户名
  /// [extra] 其他用户属性
  void setUser({
    required String userId,
    String? email,
    String? username,
    Map<String, dynamic>? extra,
  });

  /// 清除用户信息
  void clearUser();

  /// 设置自定义标签
  ///
  /// [key] 标签键
  /// [value] 标签值
  void setTag(String key, String value);

  /// 设置自定义上下文
  ///
  /// [key] 上下文键
  /// [context] 上下文数据
  void setContext(String key, Map<String, dynamic> context);

  /// 检查监控服务是否已初始化
  bool get isInitialized;

  /// 获取监控服务名称
  String get serviceName;
}

/// 错误严重程度枚举
enum ErrorSeverity {
  /// 致命错误
  fatal('fatal'),

  /// 错误
  error('error'),

  /// 警告
  warning('warning'),

  /// 信息
  info('info'),

  /// 调试
  debug('debug');

  const ErrorSeverity(this.level);
  final String level;
}

/// 面包屑级别枚举
enum BreadcrumbLevel {
  /// 致命
  fatal('fatal'),

  /// 错误
  error('error'),

  /// 警告
  warning('warning'),

  /// 信息
  info('info'),

  /// 调试
  debug('debug');

  const BreadcrumbLevel(this.level);
  final String level;
}
