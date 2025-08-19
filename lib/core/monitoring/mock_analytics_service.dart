import 'dart:developer' as developer;

import 'package:injectable/injectable.dart';
import 'package:zjs_flutter_template/core/monitoring/interfaces/analytics_interface.dart';
import 'package:zjs_flutter_template/core/utils/logger.dart';

/// 模拟分析服务
///
/// 用于开发阶段，将分析事件输出到控制台
/// 后续可以替换为真实的分析服务实现
@Singleton(as: IAnalyticsService)
class MockAnalyticsService implements IAnalyticsService {
  bool _isInitialized = false;
  final List<Map<String, dynamic>> _events = [];
  final Map<String, dynamic> _userProperties = {};
  String? _currentUserId;

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    AppLogger.info('🔧 初始化模拟分析服务...');

    // 模拟初始化延迟
    await Future<void>.delayed(const Duration(milliseconds: 10));

    _isInitialized = true;
    AppLogger.info('✅ 模拟分析服务初始化完成');
  }

  @override
  Future<void> trackEvent(String eventName, {Map<String, dynamic>? parameters}) async {
    if (!_isInitialized) {
      AppLogger.warning('分析服务未初始化，跳过事件记录');
      return;
    }

    final event = {
      'event_name': eventName,
      'parameters': parameters ?? {},
      'user_id': _currentUserId,
      'timestamp': DateTime.now().toIso8601String(),
      'session_id': _generateSessionId(),
    };

    _events.add(event);

    // 保持最多1000个事件
    if (_events.length > 1000) {
      _events.removeAt(0);
    }

    AppLogger.info('📊 [MockAnalyticsService] 事件记录: $eventName');

    developer.log(
      '📊 分析事件: $eventName',
      name: 'MockAnalyticsService',
    );

    // 模拟网络请求延迟
    await Future<void>.delayed(const Duration(milliseconds: 30));
  }

  @override
  Future<void> trackPageView(String screenName, {String? screenClass}) async {
    await trackEvent(AnalyticsEvents.pageView, parameters: {
      'screen_name': screenName,
      if (screenClass != null) 'screen_class': screenClass,
    });
  }

  @override
  Future<void> setUserProperties({
    String? userId,
    Map<String, dynamic>? properties,
  }) async {
    if (!_isInitialized) return;

    if (userId != null) {
      _currentUserId = userId;
      _userProperties[UserProperties.userId] = userId;
    }

    if (properties != null) {
      _userProperties.addAll(properties);
    }

    AppLogger.info('👤 [MockAnalyticsService] 设置用户属性');

    // 模拟网络请求延迟
    await Future<void>.delayed(const Duration(milliseconds: 30));
  }

  @override
  Future<void> trackLogin({String? method}) async {
    await trackEvent(AnalyticsEvents.login, parameters: {
      if (method != null) 'method': method,
    });
  }

  @override
  Future<void> trackSignUp({String? method}) async {
    await trackEvent(AnalyticsEvents.signUp, parameters: {
      if (method != null) 'method': method,
    });
  }

  @override
  Future<void> trackSearch(String searchTerm, {String? category}) async {
    await trackEvent(AnalyticsEvents.search, parameters: {
      'search_term': searchTerm,
      if (category != null) 'category': category,
    });
  }

  @override
  Future<void> trackShare({
    required String contentType,
    required String itemId,
    required String method,
  }) async {
    await trackEvent(AnalyticsEvents.share, parameters: {
      'content_type': contentType,
      'item_id': itemId,
      'method': method,
    });
  }

  @override
  Future<void> trackAppLifecycle(String event) async {
    await trackEvent(event, parameters: {
      'lifecycle_event': event,
    });
  }

  @override
  bool get isInitialized => _isInitialized;

  @override
  String get serviceName => 'MockAnalyticsService';

  /// 获取当前状态摘要（用于调试）
  Map<String, dynamic> getStatusSummary() {
    return {
      'service_name': serviceName,
      'is_initialized': isInitialized,
      'current_user_id': _currentUserId,
      'user_properties': _userProperties,
      'total_events': _events.length,
      'recent_events': _events.take(5).toList(),
    };
  }

  /// 获取所有事件
  List<Map<String, dynamic>> getAllEvents() {
    return List.unmodifiable(_events);
  }

  /// 获取特定类型的事件
  List<Map<String, dynamic>> getEventsByName(String eventName) {
    return _events.where((event) => event['event_name'] == eventName).toList();
  }

  /// 清除所有数据
  void reset() {
    _events.clear();
    _userProperties.clear();
    _currentUserId = null;
    AppLogger.info('🔄 [MockAnalyticsService] 重置所有数据');
  }

  /// 生成会话ID（简单实现）
  String _generateSessionId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// 获取事件统计
  Map<String, int> getEventStatistics() {
    final stats = <String, int>{};
    for (final event in _events) {
      final eventName = event['event_name'] as String;
      stats[eventName] = (stats[eventName] ?? 0) + 1;
    }
    return stats;
  }
}
