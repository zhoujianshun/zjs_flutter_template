import 'dart:developer' as developer;

import 'package:injectable/injectable.dart';
import 'package:zjs_flutter_template/core/monitoring/interfaces/error_monitor_interface.dart';
import 'package:zjs_flutter_template/core/utils/logger.dart';

/// 模拟错误监控服务
///
/// 用于开发阶段，将错误信息输出到控制台
/// 后续可以替换为真实的监控服务实现
@Singleton(as: IErrorMonitor)
class MockErrorMonitor implements IErrorMonitor {
  bool _isInitialized = false;
  final List<String> _breadcrumbs = [];
  final Map<String, String> _tags = {};
  final Map<String, Map<String, dynamic>> _contexts = {};
  String? _currentUserId;

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    AppLogger.info('🔧 初始化模拟错误监控服务...');

    // 模拟初始化延迟
    await Future<void>.delayed(const Duration(milliseconds: 10));

    _isInitialized = true;
    AppLogger.info('✅ 模拟错误监控服务初始化完成');
  }

  @override
  Future<void> reportError(
    Object error,
    StackTrace? stackTrace, {
    String? context,
    String? userId,
    Map<String, dynamic>? extra,
  }) async {
    if (!_isInitialized) {
      AppLogger.warning('错误监控服务未初始化，跳过错误上报');
      return;
    }

    // 构建错误信息用于日志记录
    final errorInfo = {
      'error': error.toString(),
      'stackTrace': stackTrace?.toString(),
      'context': context,
      'userId': userId ?? _currentUserId,
      'tags': _tags,
      'contexts': _contexts,
      'breadcrumbs': _breadcrumbs.take(10).toList(), // 最近10个面包屑
      'timestamp': DateTime.now().toIso8601String(),
      if (extra != null) 'extra': extra,
    };

    // 在开发模式下输出详细信息
    if (_isInitialized) {
      print('🐛 错误详情: $errorInfo');
    }

    // 输出到控制台（开发模式）
    AppLogger.error(
      '🐛 [MockErrorMonitor] 错误上报',
      error: error,
      stackTrace: stackTrace,
    );

    // 输出到开发者控制台
    developer.log(
      '🐛 错误上报: $error',
      name: 'MockErrorMonitor',
      error: error,
      stackTrace: stackTrace,
    );

    // 模拟网络请求延迟
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }

  @override
  void addBreadcrumb(
    String message, {
    String? category,
    String? level,
    Map<String, dynamic>? data,
  }) {
    if (!_isInitialized) return;

    final breadcrumb = '${DateTime.now().toIso8601String()} [$level] $category: $message';
    _breadcrumbs.add(breadcrumb);

    // 保持最多50个面包屑
    if (_breadcrumbs.length > 50) {
      _breadcrumbs.removeAt(0);
    }

    AppLogger.debug('🍞 [MockErrorMonitor] 面包屑: $breadcrumb');
  }

  @override
  void setUser({
    required String userId,
    String? email,
    String? username,
    Map<String, dynamic>? extra,
  }) {
    if (!_isInitialized) return;

    _currentUserId = userId;

    // 构建用户信息用于日志记录
    final userInfo = {
      'userId': userId,
      if (email != null) 'email': email,
      if (username != null) 'username': username,
      if (extra != null) ...extra,
    };

    // 在开发模式下输出详细信息
    if (_isInitialized) {
      print('👤 用户信息详情: $userInfo');
    }

    AppLogger.info('👤 [MockErrorMonitor] 设置用户信息');
  }

  @override
  void clearUser() {
    if (!_isInitialized) return;

    _currentUserId = null;
    AppLogger.info('👤 [MockErrorMonitor] 清除用户信息');
  }

  @override
  void setTag(String key, String value) {
    if (!_isInitialized) return;

    _tags[key] = value;
    AppLogger.debug('🏷️ [MockErrorMonitor] 设置标签: $key = $value');
  }

  @override
  void setContext(String key, Map<String, dynamic> context) {
    if (!_isInitialized) return;

    _contexts[key] = context;
    AppLogger.debug('📋 [MockErrorMonitor] 设置上下文: $key');
  }

  @override
  bool get isInitialized => _isInitialized;

  @override
  String get serviceName => 'MockErrorMonitor';

  /// 获取当前状态摘要（用于调试）
  Map<String, dynamic> getStatusSummary() {
    return {
      'service_name': serviceName,
      'is_initialized': isInitialized,
      'current_user_id': _currentUserId,
      'tags_count': _tags.length,
      'contexts_count': _contexts.length,
      'breadcrumbs_count': _breadcrumbs.length,
      'tags': _tags,
      'contexts': _contexts,
      'recent_breadcrumbs': _breadcrumbs.take(5).toList(),
    };
  }

  /// 清除所有数据
  void reset() {
    _breadcrumbs.clear();
    _tags.clear();
    _contexts.clear();
    _currentUserId = null;
    AppLogger.info('🔄 [MockErrorMonitor] 重置所有数据');
  }
}
