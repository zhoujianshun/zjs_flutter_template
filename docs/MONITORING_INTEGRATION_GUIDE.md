# 监控平台接入指南

## 📋 概述

本项目已预留监控接口，当前使用模拟服务进行开发。当需要接入真实监控平台时，可以按照本指南进行配置。

## 🏗️ 当前架构

### 接口设计

```
lib/core/monitoring/interfaces/
├── error_monitor_interface.dart      # 错误监控接口
├── analytics_interface.dart          # 分析服务接口
└── performance_monitor_interface.dart # 性能监控接口
```

### 模拟实现

```
lib/core/monitoring/
├── mock_error_monitor.dart           # 模拟错误监控
├── mock_analytics_service.dart       # 模拟分析服务
├── mock_performance_monitor.dart     # 模拟性能监控
└── simple_monitoring_manager.dart    # 统一管理器
```

### 服务注册

在 `lib/di/service_locator.dart` 中：

```dart
@singleton
IErrorMonitor get errorMonitor => MockErrorMonitor();

@singleton  
IAnalyticsService get analyticsService => MockAnalyticsService();

@singleton
IPerformanceMonitor get performanceMonitor => MockPerformanceMonitor();
```

## 🚀 接入真实监控平台

### 方案一：Firebase Crashlytics + Analytics

#### 1. 添加依赖

```yaml
dependencies:
  firebase_core: ^3.6.0
  firebase_crashlytics: ^4.1.3
  firebase_analytics: ^11.3.3
```

#### 2. Firebase 配置

- 在 Firebase 控制台创建项目
- 下载 `google-services.json` (Android) 和 `GoogleService-Info.plist` (iOS)
- 配置 Android 和 iOS 项目

#### 3. 创建 Firebase 实现

```dart
// lib/core/monitoring/firebase_error_monitor.dart
@singleton
class FirebaseErrorMonitor implements IErrorMonitor {
  @override
  Future<void> initialize() async {
    await Firebase.initializeApp();
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  }

  @override
  Future<void> reportError(Object error, StackTrace? stackTrace, {
    String? context,
    String? userId, 
    Map<String, dynamic>? extra,
  }) async {
    await FirebaseCrashlytics.instance.recordError(error, stackTrace);
  }
  
  // 实现其他接口方法...
}
```

#### 4. 更新服务注册

```dart
// lib/di/service_locator.dart
@singleton
IErrorMonitor get errorMonitor => FirebaseErrorMonitor();

@singleton
IAnalyticsService get analyticsService => FirebaseAnalyticsService();
```

### 方案二：Sentry

#### 1. 添加依赖

```yaml
dependencies:
  sentry_flutter: ^8.9.0
```

#### 2. 环境变量配置

```bash
# .env
SENTRY_DSN=your_sentry_dsn_here
```

#### 3. 创建 Sentry 实现

```dart
// lib/core/monitoring/sentry_error_monitor.dart
@singleton
class SentryErrorMonitor implements IErrorMonitor {
  @override
  Future<void> initialize() async {
    await SentryFlutter.init((options) {
      options.dsn = const String.fromEnvironment('SENTRY_DSN');
      options.environment = AppConfig.environment;
    });
  }

  @override
  Future<void> reportError(Object error, StackTrace? stackTrace, {
    String? context,
    String? userId,
    Map<String, dynamic>? extra,
  }) async {
    await Sentry.captureException(error, stackTrace: stackTrace);
  }
  
  // 实现其他接口方法...
}
```

### 方案三：混合模式

可以同时使用多个监控平台：

```dart
// lib/core/monitoring/hybrid_error_monitor.dart
@singleton
class HybridErrorMonitor implements IErrorMonitor {
  final FirebaseErrorMonitor _firebase = FirebaseErrorMonitor();
  final SentryErrorMonitor _sentry = SentryErrorMonitor();

  @override
  Future<void> initialize() async {
    await Future.wait([
      _firebase.initialize(),
      _sentry.initialize(),
    ]);
  }

  @override
  Future<void> reportError(Object error, StackTrace? stackTrace, {
    String? context,
    String? userId,
    Map<String, dynamic>? extra,
  }) async {
    await Future.wait([
      _firebase.reportError(error, stackTrace, context: context, userId: userId, extra: extra),
      _sentry.reportError(error, stackTrace, context: context, userId: userId, extra: extra),
    ]);
  }
  
  // 实现其他接口方法...
}
```

## 🔧 配置管理

### 环境变量配置

```bash
# .env.development
MONITORING_PLATFORM=mock

# .env.staging  
MONITORING_PLATFORM=firebase

# .env.production
MONITORING_PLATFORM=sentry
SENTRY_DSN=your_production_dsn
```

### 动态配置

```dart
// lib/core/monitoring/monitoring_factory.dart
class MonitoringFactory {
  static IErrorMonitor createErrorMonitor() {
    switch (AppConfig.monitoringPlatform) {
      case 'firebase':
        return FirebaseErrorMonitor();
      case 'sentry':
        return SentryErrorMonitor();
      case 'hybrid':
        return HybridErrorMonitor();
      default:
        return MockErrorMonitor();
    }
  }
}
```

## 📊 平台对比

| 特性 | Firebase Crashlytics | Sentry | 混合模式 |
|------|---------------------|--------|----------|
| **成本** | 免费 | 免费层有限 | 取决于组合 |
| **设置复杂度** | 低 | 中等 | 高 |
| **功能丰富度** | 基础 | 高级 | 最全面 |
| **性能影响** | 低 | 中等 | 最高 |
| **数据控制** | 有限 | 高 | 高 |

## 🎯 推荐策略

### 开发阶段

- 使用 `MockErrorMonitor`（当前状态）
- 输出到控制台，方便调试

### 测试阶段

- 选择一个主要平台进行集成测试
- 推荐从 Firebase Crashlytics 开始

### 生产阶段

- 根据需求选择合适的平台
- 考虑混合模式以获得最佳覆盖

## 📝 迁移步骤

### 从模拟服务迁移到真实平台

1. **准备工作**

   ```bash
   # 添加依赖
   flutter pub add firebase_crashlytics firebase_core
   
   # 或
   flutter pub add sentry_flutter
   ```

2. **实现接口**
   - 创建对应的监控服务实现类
   - 确保实现所有接口方法

3. **更新注册**

   ```dart
   // 在 service_locator.dart 中更新
   @singleton
   IErrorMonitor get errorMonitor => FirebaseErrorMonitor(); // 替换 MockErrorMonitor
   ```

4. **配置验证**
   - 测试错误上报功能
   - 验证分析事件记录
   - 检查性能监控数据

5. **渐进式部署**
   - 先在测试环境验证
   - 逐步推广到生产环境

## 🔍 测试验证

### 错误监控测试

```dart
// 手动触发测试错误
await SimpleMonitoringManager.instance.reportError(
  Exception('测试错误'),
  StackTrace.current,
  context: 'integration_test',
);
```

### 分析事件测试

```dart
// 记录测试事件
await SimpleMonitoringManager.instance.trackEvent(
  'integration_test',
  parameters: {'platform': 'flutter'},
);
```

### 性能监控测试

```dart
// 测试性能监控
final result = await SimpleMonitoringManager.instance.measureAsync(
  'test_operation',
  () async => await Future.delayed(Duration(seconds: 1)),
);
```

## 🚨 注意事项

1. **数据隐私**
   - 确保遵守数据保护法规
   - 配置适当的数据保留策略

2. **性能影响**
   - 监控过多的事件可能影响应用性能
   - 合理设置采样率

3. **错误处理**
   - 监控服务本身的错误不应影响应用功能
   - 实现降级机制

4. **版本兼容性**
   - 注意监控SDK的版本兼容性
   - 定期更新依赖版本

## 📚 参考资源

- [Firebase Crashlytics 文档](https://firebase.google.com/docs/crashlytics)
- [Firebase Analytics 文档](https://firebase.google.com/docs/analytics)
- [Sentry Flutter 文档](https://docs.sentry.io/platforms/flutter/)
- [项目监控示例](../lib/examples/simple_monitoring_examples.dart)

---

**维护说明**: 本文档会随着项目需求变化而更新，请定期检查最新版本。
