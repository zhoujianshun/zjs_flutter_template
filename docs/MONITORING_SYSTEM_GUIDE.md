# 监控系统使用指南

## 📋 概述

本项目集成了完整的应用监控系统，包括全局异常捕获、用户事件统计、性能监控等功能。监控系统采用模块化设计，支持多种第三方服务集成。

## 🏗️ 系统架构

```
监控系统架构
├── MonitoringManager (统一管理器)
├── ErrorMonitor (错误监控)
├── AnalyticsService (事件统计)
├── PerformanceMonitor (性能监控)
└── 第三方服务集成
    ├── Firebase Crashlytics
    ├── Firebase Analytics
    └── Sentry
```

## 🚀 快速开始

### 1. 基础配置

监控系统已在应用启动时自动初始化，无需额外配置即可使用基本功能。

```dart
// main.dart - 已自动集成
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化依赖注入
  await ServiceLocator.initialize();
  
  // 初始化监控系统
  await MonitoringManager.instance.initialize();
  
  runApp(MyApp());
}
```

### 2. 环境变量配置

为了使用完整的监控功能，需要配置以下环境变量：

```bash
# Sentry配置
SENTRY_DSN=your_sentry_dsn_here

# Firebase配置（通过firebase_options.dart）
# Google Services配置文件已包含所需信息
```

## 📊 事件统计

### 基础事件记录

```dart
import 'package:zjs_flutter_template/core/monitoring/monitoring_manager.dart';

// 记录页面访问
await MonitoringManager.instance.trackPageView(
  'home_page',
  parameters: {
    'user_type': 'premium',
    'source': 'navigation',
  },
);

// 记录用户操作
await MonitoringManager.instance.trackUserAction(
  'button_click',
  category: 'ui_interaction',
  label: 'login_button',
  parameters: {
    'page': 'login',
    'position': 'top',
  },
);

// 记录业务事件
await MonitoringManager.instance.trackBusinessEvent(
  'purchase_completed',
  parameters: {
    'product_id': 'premium_plan',
    'amount': 99.99,
    'currency': 'USD',
  },
);
```

### 预定义事件

使用预定义的事件名称和参数，确保数据一致性：

```dart
import 'package:zjs_flutter_template/core/monitoring/analytics_service.dart';

// 使用预定义事件名称
await AnalyticsService.instance.trackEvent(
  AnalyticsEvents.login,
  parameters: {
    AnalyticsParameters.userId: 'user_123',
    'login_method': 'email',
  },
);

// 其他预定义事件
await AnalyticsService.instance.trackEvent(AnalyticsEvents.pageView);
await AnalyticsService.instance.trackEvent(AnalyticsEvents.buttonClick);
await AnalyticsService.instance.trackEvent(AnalyticsEvents.searchQuery);
```

### 用户属性管理

```dart
// 设置用户信息（登录后）
await MonitoringManager.instance.setUser(
  userId: 'user_123',
  email: 'user@example.com',
  username: 'john_doe',
  properties: {
    'subscription_type': 'premium',
    'registration_date': '2024-01-01',
    'country': 'US',
  },
);

// 清除用户信息（登出时）
await MonitoringManager.instance.clearUser();
```

## 🚨 错误监控

### 自动错误捕获

系统会自动捕获以下类型的错误：

1. **Flutter框架错误**：Widget构建错误、渲染错误等
2. **未处理的异常**：Dart运行时异常
3. **平台错误**：iOS/Android平台相关错误

### 手动错误上报

```dart
import 'package:zjs_flutter_template/core/monitoring/monitoring_manager.dart';

// 上报自定义错误
await MonitoringManager.instance.reportError(
  Exception('自定义错误信息'),
  StackTrace.current,
  context: 'user_operation',
  extra: {
    'operation': 'data_sync',
    'user_id': 'user_123',
    'retry_count': 3,
  },
);

// 在try-catch中上报错误
try {
  await riskyOperation();
} catch (error, stackTrace) {
  await MonitoringManager.instance.reportError(
    error,
    stackTrace,
    context: 'risky_operation',
    extra: {'operation_id': 'op_123'},
  );
}
```

### 错误处理装饰器

使用装饰器自动处理错误：

```dart
import 'package:zjs_flutter_template/core/monitoring/error_monitor.dart';

// 包装异步方法
final result = await ErrorHandler.handleAsync<String>(
  () => performNetworkRequest(),
  context: 'network_request',
  fallbackValue: 'default_value',
  rethrow: false,
);

// 包装同步方法
final result = ErrorHandler.handleSync<int>(
  () => complexCalculation(),
  context: 'calculation',
  fallbackValue: 0,
);
```

## ⚡ 性能监控

### 基础性能跟踪

```dart
import 'package:zjs_flutter_template/core/monitoring/performance_monitor.dart';

// 手动计时
PerformanceMonitor.instance.startOperation('data_processing');
await processLargeDataSet();
await PerformanceMonitor.instance.endOperation('data_processing');

// 使用装饰器自动计时
final result = await PerformanceTracker.trackAsync(
  'api_call',
  () => apiClient.getData(),
  metadata: {
    'endpoint': '/api/users',
    'method': 'GET',
  },
);
```

### 专门的性能监控

```dart
// 网络请求性能
await PerformanceMonitor.instance.trackNetworkPerformance(
  '/api/users',
  'POST',
  Duration(milliseconds: 500),
  200,
  requestSize: 1024,
  responseSize: 2048,
);

// 数据库操作性能
await PerformanceMonitor.instance.trackDatabaseOperation(
  'insert',
  Duration(milliseconds: 50),
  table: 'users',
  recordCount: 1,
);

// 文件操作性能
await PerformanceMonitor.instance.trackFileOperation(
  'read',
  Duration(milliseconds: 100),
  filePath: '/path/to/file.json',
  fileSize: 1024,
);
```

### 应用启动时间监控

```dart
// 在应用启动完成后调用
await PerformanceMonitor.instance.trackAppStartup(
  Duration(milliseconds: 1200),
);

// 页面渲染时间
await PerformanceMonitor.instance.trackPageRenderTime(
  'home_page',
  Duration(milliseconds: 300),
);
```

## 🔧 高级功能

### 统一方法包装

使用`MonitoringUtils`同时启用性能监控和错误处理：

```dart
import 'package:zjs_flutter_template/core/monitoring/monitoring_manager.dart';

// 自动包装异步方法
final result = await MonitoringUtils.wrapAsync(
  'complex_operation',
  () async {
    // 执行复杂操作
    await Future.delayed(Duration(seconds: 2));
    return 'operation_result';
  },
  metadata: {
    'operation_type': 'data_processing',
    'complexity': 'high',
  },
  errorContext: 'user_initiated_operation',
);

// 自动包装同步方法
final result = MonitoringUtils.wrapSync(
  'calculation',
  () {
    return performComplexCalculation();
  },
  metadata: {'calculation_type': 'statistical'},
);
```

### 面包屑追踪

添加调试面包屑，帮助错误排查：

```dart
import 'package:zjs_flutter_template/core/monitoring/error_monitor.dart';

// 添加面包屑
ErrorMonitor.instance.addBreadcrumb(
  '用户开始登录流程',
  category: 'auth',
  data: {
    'login_method': 'email',
    'timestamp': DateTime.now().toIso8601String(),
  },
);

ErrorMonitor.instance.addBreadcrumb('API请求开始');
ErrorMonitor.instance.addBreadcrumb('数据验证完成');
ErrorMonitor.instance.addBreadcrumb('用户登录成功');
```

### 自定义属性设置

```dart
import 'package:zjs_flutter_template/core/monitoring/error_monitor.dart';

// 设置自定义属性
await ErrorMonitor.instance.setCustomAttribute('app_theme', 'dark');
await ErrorMonitor.instance.setCustomAttribute('user_level', 'premium');
await ErrorMonitor.instance.setCustomAttribute('feature_flags', 'experimental_ui');
```

## 📱 在实际页面中的集成

### Widget生命周期监控

```dart
class MonitoredPage extends ConsumerStatefulWidget {
  @override
  _MonitoredPageState createState() => _MonitoredPageState();
}

class _MonitoredPageState extends ConsumerState<MonitoredPage> {
  @override
  void initState() {
    super.initState();
    // 页面初始化监控
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MonitoringManager.instance.trackPageView(
        'monitored_page',
        parameters: {
          'entry_time': DateTime.now().toIso8601String(),
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('监控页面')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _handleButtonClick,
            child: Text('监控按钮'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleButtonClick() async {
    // 记录用户交互
    await MonitoringManager.instance.trackUserAction(
      'button_click',
      category: 'ui_interaction',
      parameters: {
        'button_name': 'monitored_button',
        'page': 'monitored_page',
      },
    );

    // 执行带监控的操作
    try {
      final result = await MonitoringUtils.wrapAsync(
        'button_action',
        () => performButtonAction(),
        metadata: {'action_type': 'user_initiated'},
      );
      
      // 处理成功结果
      _showSuccess(result);
    } catch (e) {
      // 错误已自动上报，这里处理UI反馈
      _showError(e);
    }
  }

  @override
  void dispose() {
    // 页面销毁监控
    MonitoringManager.instance.trackUserAction(
      'page_exit',
      category: 'navigation',
      parameters: {
        'exit_time': DateTime.now().toIso8601String(),
      },
    );
    super.dispose();
  }
}
```

### 网络请求监控集成

```dart
// 在ApiClient中集成监控
class MonitoredApiClient {
  Future<Response> get(String path) async {
    final startTime = DateTime.now();
    
    try {
      final response = await dio.get(path);
      final duration = DateTime.now().difference(startTime);
      
      // 记录成功的网络请求
      await PerformanceMonitor.instance.trackNetworkPerformance(
        path,
        'GET',
        duration,
        response.statusCode ?? 0,
        responseSize: response.data?.toString().length,
      );
      
      return response;
    } catch (error, stackTrace) {
      final duration = DateTime.now().difference(startTime);
      
      // 记录失败的网络请求
      await MonitoringManager.instance.reportError(
        error,
        stackTrace,
        context: 'network_request',
        extra: {
          'endpoint': path,
          'method': 'GET',
          'duration_ms': duration.inMilliseconds,
        },
      );
      
      rethrow;
    }
  }
}
```

## 🔍 监控数据查看

### 获取监控摘要

```dart
// 获取当前监控状态
final summary = MonitoringManager.instance.getMonitoringSummary();
print('监控摘要: $summary');

// 获取性能指标
final metrics = PerformanceMonitor.instance.getAllMetrics();
for (final entry in metrics.entries) {
  final metric = entry.value;
  print('${entry.key}: 平均耗时 ${metric.averageDuration.inMilliseconds}ms');
}
```

### 调试模式下的监控

在开发环境中，监控数据会输出到控制台：

```dart
// AppConfig.isDevelopment 为 true 时
// 所有事件和错误都会在控制台显示详细信息
```

## 📊 第三方服务配置

### Firebase配置

1. 添加`google-services.json`（Android）和`GoogleService-Info.plist`（iOS）
2. 配置Firebase项目并启用Analytics和Crashlytics
3. 确保在生产环境中启用数据收集

### Sentry配置

1. 在Sentry创建项目并获取DSN
2. 设置环境变量`SENTRY_DSN`
3. 配置发布版本和环境标识

## ⚙️ 配置选项

### 启用/禁用监控

```dart
// 动态控制监控状态
await MonitoringManager.instance.setMonitoringEnabled(false);

// 在AppConfig中配置
class AppConfig {
  static bool get enableAnalytics => 
    bool.fromEnvironment('ENABLE_ANALYTICS', defaultValue: isProduction);
  
  static bool get enableCrashReporting => 
    bool.fromEnvironment('ENABLE_CRASH_REPORTING', defaultValue: isProduction);
}
```

### 环境特定配置

```dart
// 不同环境的监控配置
if (AppConfig.isDevelopment) {
  // 开发环境：详细日志，本地存储
  await AnalyticsService.instance.setAnalyticsEnabled(false);
} else if (AppConfig.isStaging) {
  // 测试环境：有限监控
  await AnalyticsService.instance.setAnalyticsEnabled(true);
} else {
  // 生产环境：完整监控
  await AnalyticsService.instance.setAnalyticsEnabled(true);
}
```

## 🧪 测试和调试

### 测试监控功能

```dart
// 测试错误上报（仅在非生产环境）
if (!AppConfig.isProduction) {
  await ErrorMonitor.instance.testCrash();
}

// 测试事件记录
await AnalyticsService.instance.trackEvent('test_event', parameters: {
  'test': true,
  'timestamp': DateTime.now().toIso8601String(),
});
```

### 调试技巧

1. **查看控制台日志**：开发环境下所有监控活动都会记录到控制台
2. **使用Flutter Inspector**：查看Widget构建错误
3. **检查网络请求**：使用Dio的日志拦截器
4. **Sentry面板**：查看实时错误报告
5. **Firebase控制台**：查看用户行为和崩溃报告

## 📋 最佳实践

### 1. 事件命名规范

```dart
// 推荐的命名方式
'page_view'           // 页面访问
'button_click'        // 按钮点击
'api_request'         // API请求
'user_registration'   // 用户注册
'purchase_completed'  // 购买完成

// 避免的命名方式
'click'              // 太模糊
'pageView'           // 驼峰命名
'user-action'        // 连字符
```

### 2. 参数设计

```dart
// 好的参数设计
await trackEvent('button_click', parameters: {
  'button_id': 'login_button',
  'page': 'login_page',
  'position': 'header',
  'user_type': 'guest',
});

// 避免的参数设计
await trackEvent('click', parameters: {
  'data': 'some_data',  // 不明确
  'x': 100,            // 无意义的键名
});
```

### 3. 错误上报

```dart
// 提供足够的上下文信息
await reportError(
  error,
  stackTrace,
  context: 'user_profile_update',
  extra: {
    'user_id': userId,
    'field_name': fieldName,
    'operation': 'update',
    'retry_count': retryCount,
  },
);
```

### 4. 性能监控

```dart
// 监控关键路径
await PerformanceTracker.trackAsync(
  'app_startup',
  () => initializeApp(),
);

await PerformanceTracker.trackAsync(
  'data_sync',
  () => syncUserData(),
);

// 避免监控过于频繁的操作
// ❌ 不要监控每个setState调用
// ✅ 监控重要的业务操作
```

## 🔒 隐私和合规

### 数据收集原则

1. **最小化原则**：只收集必要的数据
2. **透明性**：告知用户数据收集情况
3. **用户控制**：允许用户选择退出
4. **数据安全**：确保数据传输和存储安全

### 敏感数据处理

```dart
// 避免记录敏感信息
// ❌ 不要记录
await trackEvent('login', parameters: {
  'password': password,        // 密码
  'credit_card': cardNumber,   // 信用卡号
  'ssn': socialSecurityNumber, // 社会安全号
});

// ✅ 记录非敏感信息
await trackEvent('login', parameters: {
  'login_method': 'email',
  'user_type': 'premium',
  'success': true,
});
```

## 📞 故障排除

### 常见问题

1. **Firebase初始化失败**
   - 检查配置文件是否正确放置
   - 确认Bundle ID/Package Name匹配

2. **Sentry事件未上报**
   - 检查DSN配置是否正确
   - 确认网络连接正常

3. **事件未记录**
   - 检查是否在生产环境启用了分析
   - 确认初始化是否完成

4. **性能数据异常**
   - 检查计时器是否正确配对
   - 确认操作名称唯一性

### 调试命令

```dart
// 获取监控系统状态
final summary = MonitoringManager.instance.getMonitoringSummary();
print('监控状态: $summary');

// 检查Firebase连接
await Firebase.initializeApp();
print('Firebase已连接');

// 测试事件发送
await AnalyticsService.instance.trackEvent('debug_test');
print('测试事件已发送');
```

---

*最后更新：2024年12月*
