import 'package:zjs_flutter_template/config/env/app_config.dart';

/// 简化的监控配置
///
/// 当前使用模拟服务，预留接口方便后续接入真实监控平台
class MonitoringConfigSimple {
  MonitoringConfigSimple._();

  /// 是否启用监控（开发阶段始终启用模拟服务）
  static bool get enableMonitoring => true;

  /// 当前监控模式
  static MonitoringMode get mode => MonitoringMode.mock;

  /// 是否在生产环境
  static bool get isProduction => AppConfig.isProduction;

  /// 获取配置摘要
  static Map<String, dynamic> getConfigSummary() {
    return {
      'monitoring_enabled': enableMonitoring,
      'monitoring_mode': mode.name,
      'environment': AppConfig.environment,
      'is_production': isProduction,
      'description': mode.description,
      'services': {
        'error_monitor': 'MockErrorMonitor',
        'analytics_service': 'MockAnalyticsService',
        'performance_monitor': 'MockPerformanceMonitor',
      },
    };
  }

  /// 获取后续接入指南
  static Map<String, dynamic> getIntegrationGuide() {
    return {
      'current_status': '接口已预留，使用模拟服务',
      'next_steps': [
        '根据需求选择监控平台（Firebase Crashlytics、Sentry等）',
        '在pubspec.yaml中添加相应依赖',
        '实现对应的监控服务接口',
        '更新service_locator.dart中的服务注册',
        '配置相应的环境变量和密钥',
      ],
      'available_platforms': {
        'firebase_crashlytics': {
          'description': '免费，简单易用，适合移动应用',
          'dependency': 'firebase_crashlytics: ^4.1.3',
          'setup_complexity': '低',
        },
        'sentry': {
          'description': '功能强大，支持全平台，适合高级需求',
          'dependency': 'sentry_flutter: ^8.9.0',
          'setup_complexity': '中等',
        },
        'custom': {
          'description': '自定义监控服务，完全控制',
          'dependency': '根据具体服务而定',
          'setup_complexity': '高',
        },
      },
    };
  }
}

/// 监控模式枚举
enum MonitoringMode {
  /// 模拟模式（当前）
  mock('mock'),

  /// Firebase模式
  firebase('firebase'),

  /// Sentry模式
  sentry('sentry'),

  /// 混合模式
  hybrid('hybrid'),

  /// 禁用模式
  disabled('disabled');

  const MonitoringMode(this.name);
  final String name;

  /// 模式描述
  String get description {
    switch (this) {
      case MonitoringMode.mock:
        return '模拟模式：使用模拟服务，输出到控制台，适合开发阶段';
      case MonitoringMode.firebase:
        return 'Firebase模式：使用Firebase Crashlytics和Analytics';
      case MonitoringMode.sentry:
        return 'Sentry模式：使用Sentry进行错误监控和性能分析';
      case MonitoringMode.hybrid:
        return '混合模式：同时使用多个监控平台';
      case MonitoringMode.disabled:
        return '禁用模式：不进行任何监控';
    }
  }
}

/// 监控平台信息
class MonitoringPlatform {
  const MonitoringPlatform({
    required this.name,
    required this.description,
    required this.dependency,
    required this.setupComplexity,
    required this.cost,
    required this.features,
  });

  final String name;
  final String description;
  final String dependency;
  final String setupComplexity;
  final String cost;
  final List<String> features;

  static const List<MonitoringPlatform> availablePlatforms = [
    MonitoringPlatform(
      name: 'Firebase Crashlytics',
      description: '谷歌提供的免费崩溃报告服务',
      dependency: 'firebase_crashlytics: ^4.1.3\nfirebase_core: ^3.6.0',
      setupComplexity: '低',
      cost: '免费',
      features: [
        '崩溃报告',
        '错误分组',
        '用户影响分析',
        '版本追踪',
        '实时监控',
      ],
    ),
    MonitoringPlatform(
      name: 'Sentry',
      description: '功能强大的错误监控和性能分析平台',
      dependency: 'sentry_flutter: ^8.9.0',
      setupComplexity: '中等',
      cost: r'免费层：5K错误/月，付费层：$26+/月',
      features: [
        '错误监控',
        '性能监控',
        '发布追踪',
        '自定义仪表板',
        '智能告警',
        '面包屑追踪',
        '用户上下文',
      ],
    ),
    MonitoringPlatform(
      name: 'Firebase Analytics',
      description: '谷歌提供的免费应用分析服务',
      dependency: 'firebase_analytics: ^11.3.3\nfirebase_core: ^3.6.0',
      setupComplexity: '低',
      cost: '免费',
      features: [
        '用户行为分析',
        '事件追踪',
        '用户属性',
        '转化漏斗',
        '受众分析',
      ],
    ),
  ];
}
