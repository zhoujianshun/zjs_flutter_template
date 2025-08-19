# 全局异常捕获系统使用指南

## 📋 概述

本项目实现了完整的全局异常捕获系统，能够自动捕获和处理应用中的所有类型异常，包括 Flutter 框架错误、Dart 运行时错误、Zone 错误、Isolate 错误等，并提供多种错误恢复机制。

## 🏗️ 系统架构

### 核心组件

```
lib/core/error_handling/
├── global_error_handler.dart       # 全局异常捕获处理器
├── error_recovery.dart             # 错误恢复和重试机制
└── interfaces/                     # 监控接口（与监控系统集成）
```

### 异常捕获范围

- **Flutter框架异常**: `FlutterError.onError`
- **Dart运行时异常**: `PlatformDispatcher.instance.onError`
- **Zone异常**: `runZonedGuarded` + `ZoneSpecification`
- **Isolate异常**: `Isolate.current.addErrorListener`
- **平台通道异常**: `PlatformDispatcher.instance.onPlatformMessage`
- **Print输出异常**: 通过Zone拦截包含ERROR/EXCEPTION的输出

## 🚀 快速开始

### 1. 系统初始化

全局异常捕获系统在应用启动时自动初始化：

```dart
// lib/main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化依赖注入容器
  await ServiceLocator.initialize();

  // 初始化监控系统
  await SimpleMonitoringManager.instance.initialize();

  // 初始化全局异常捕获系统
  await GlobalErrorHandler.instance.initialize();

  // 在错误隔离Zone中运行应用
  GlobalErrorHandler.instance.runAppInErrorZone(
    const ProviderScope(child: MyApp()),
  );
}
```

### 2. 手动错误上报

```dart
// 基础错误上报
GlobalErrorHandler.instance.reportError(
  Exception('用户操作异常'),
  StackTrace.current,
  context: 'UserAction',
);

// 带详细上下文的错误上报
GlobalErrorHandler.instance.reportError(
  error,
  stackTrace,
  context: 'PaymentProcess',
  errorType: ErrorType.manualReport,
  additionalInfo: {
    'user_id': 'user123',
    'payment_amount': 99.99,
    'payment_method': 'credit_card',
  },
);
```

### 3. 错误边界Widget

```dart
// 使用错误边界保护Widget
ErrorHandlerUtils.errorBoundary(
  context: 'ProductList',
  child: ProductListWidget(),
  fallback: ProductListErrorWidget(),
)
```

## 🔄 错误恢复机制

### 1. 重试机制

```dart
// 带重试的异步操作
final result = await ErrorRecovery.retryAsync(
  () async {
    // 可能失败的操作
    return await apiService.fetchData();
  },
  maxRetries: 3,
  delay: Duration(seconds: 1),
  backoffMultiplier: 2.0,
  shouldRetry: (error) => error is NetworkException,
  context: 'DataFetch',
);
```

### 2. 降级机制

```dart
// 主要操作 + 降级方案
final result = await ErrorRecovery.withFallback(
  () async {
    // 主要操作（可能失败）
    return await remoteDataService.getData();
  },
  () async {
    // 降级方案（从缓存获取）
    return await localCacheService.getCachedData();
  },
  context: 'DataAccess',
);
```

### 3. 断路器模式

```dart
// 创建断路器
final circuitBreaker = ErrorRecovery.createCircuitBreaker(
  name: 'PaymentService',
  failureThreshold: 5,      // 失败5次后开启断路器
  timeout: Duration(seconds: 30),
  resetTimeout: Duration(minutes: 1),
);

// 使用断路器执行操作
try {
  final result = await circuitBreaker.execute(() async {
    return await paymentService.processPayment(paymentData);
  });
} on CircuitBreakerOpenException {
  // 断路器开启，使用降级方案
  return await fallbackPaymentProcessor.process(paymentData);
}
```

### 4. 批量操作错误处理

```dart
// 批量操作，继续处理其他项目即使部分失败
final operations = users.map((user) => () async {
  return await notificationService.sendNotification(user);
}).toList();

final results = await ErrorRecovery.batchWithErrorHandling(
  operations,
  context: 'BulkNotification',
  continueOnError: true,
  concurrency: 5,  // 最多5个并发
);

final successCount = results.where((r) => r != null).length;
print('成功发送 $successCount/${results.length} 条通知');
```

### 5. 安全执行包装

```dart
// 同步操作安全执行
final result = ErrorHandlerUtils.safeExecute(
  () {
    return riskyCalculation();
  },
  context: 'Calculation',
  fallbackValue: 0,
);

// 异步操作安全执行
final result = await ErrorHandlerUtils.safeExecuteAsync(
  () async {
    return await riskyAsyncOperation();
  },
  context: 'AsyncOperation',
  fallbackValue: defaultValue,
);
```

## 📊 错误分类和处理

### 错误类型

```dart
enum ErrorType {
  flutterError,        // Flutter框架错误
  dartError,           // Dart运行时错误
  zoneError,           // Zone错误
  isolateError,        // Isolate错误
  platformChannelError,// 平台通道错误
  printError,          // Print输出错误
  manualReport,        // 手动上报
}
```

### 错误严重程度

```dart
enum ErrorSeverity {
  fatal,    // 致命错误
  error,    // 错误
  warning,  // 警告
  info,     // 信息
  debug,    // 调试
}
```

## 🔧 配置和自定义

### 1. 自定义错误处理逻辑

```dart
// 扩展GlobalErrorHandler
class CustomErrorHandler extends GlobalErrorHandler {
  @override
  void _reportError(ErrorInfo errorInfo) {
    // 自定义错误处理逻辑
    super._reportError(errorInfo);
    
    // 添加自定义处理
    if (errorInfo.errorType == ErrorType.flutterError) {
      // 特殊处理Flutter错误
      customFlutterErrorHandler(errorInfo);
    }
  }
}
```

### 2. 错误过滤

```dart
// 在重试机制中使用自定义过滤器
final result = await ErrorRecovery.retryAsync(
  operation,
  shouldRetry: (error) {
    // 只重试网络相关错误
    return error is SocketException || 
           error is TimeoutException ||
           error is HttpException;
  },
);
```

### 3. 环境相关配置

```dart
// 根据环境调整错误处理策略
class EnvironmentAwareErrorHandler {
  static void configure() {
    if (kDebugMode) {
      // 开发环境：详细错误信息
      FlutterError.presentError = FlutterError.presentError;
    } else {
      // 生产环境：静默处理
      FlutterError.presentError = (details) {
        // 只记录，不显示红屏
        GlobalErrorHandler.instance.reportError(
          details.exception,
          details.stack,
        );
      };
    }
  }
}
```

## 🎯 最佳实践

### 1. 错误上下文

始终提供有意义的错误上下文：

```dart
// ❌ 不好的做法
GlobalErrorHandler.instance.reportError(error, stackTrace);

// ✅ 好的做法
GlobalErrorHandler.instance.reportError(
  error,
  stackTrace,
  context: 'UserProfileUpdate',
  additionalInfo: {
    'user_id': currentUser.id,
    'action': 'update_avatar',
    'step': 'image_upload',
  },
);
```

### 2. 分层错误处理

```dart
// 数据层
class UserRepository {
  Future<User> getUser(String id) async {
    return await ErrorRecovery.retryAsync(
      () async {
        final response = await apiClient.get('/users/$id');
        return User.fromJson(response.data);
      },
      context: 'UserRepository.getUser',
      maxRetries: 3,
    );
  }
}

// 业务层
class UserService {
  Future<User> getCurrentUser() async {
    return await ErrorRecovery.withFallback(
      () async {
        return await userRepository.getUser(currentUserId);
      },
      () async {
        // 从缓存获取
        return await cacheService.getCachedUser(currentUserId);
      },
      context: 'UserService.getCurrentUser',
    );
  }
}

// UI层
class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ErrorHandlerUtils.errorBoundary(
      context: 'UserProfilePage',
      child: UserProfileContent(),
      fallback: UserProfileErrorWidget(),
    );
  }
}
```

### 3. 性能考虑

```dart
// 避免过度使用错误恢复机制
class OptimizedService {
  // ✅ 对关键操作使用错误恢复
  Future<PaymentResult> processPayment(PaymentData data) async {
    return await ErrorRecovery.retryAsync(
      () => paymentGateway.charge(data),
      maxRetries: 3,
      context: 'PaymentProcessing',
    );
  }
  
  // ✅ 对非关键操作使用简单错误处理
  Future<void> logUserAction(String action) async {
    try {
      await analyticsService.track(action);
    } catch (e) {
      // 静默失败，不影响用户体验
      GlobalErrorHandler.instance.reportError(e, StackTrace.current);
    }
  }
}
```

## 🧪 测试

### 1. 错误处理测试

```dart
// 测试错误恢复机制
testWidgets('should retry failed operations', (tester) async {
  var attempts = 0;
  final result = await ErrorRecovery.retryAsync(
    () async {
      attempts++;
      if (attempts < 3) {
        throw Exception('Simulated failure');
      }
      return 'success';
    },
    maxRetries: 3,
  );
  
  expect(result, equals('success'));
  expect(attempts, equals(3));
});
```

### 2. 错误边界测试

```dart
testWidgets('error boundary should catch widget errors', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: ErrorHandlerUtils.errorBoundary(
        child: ThrowingWidget(),
        fallback: Text('Error occurred'),
      ),
    ),
  );
  
  expect(find.text('Error occurred'), findsOneWidget);
});
```

## 📈 监控集成

全局异常捕获系统与项目的监控系统完全集成：

- **自动上报**: 所有捕获的异常自动上报到监控系统
- **面包屑**: 错误发生时自动添加面包屑用于调试
- **用户上下文**: 自动关联用户信息和错误
- **性能监控**: 错误恢复操作的性能数据自动记录

## 🔍 调试和排查

### 1. 开发环境调试

在开发环境中，所有错误信息会详细输出到控制台：

```
🚨 GLOBAL ERROR CAUGHT
================================================================================
Type: flutterError
Context: UserProfilePage
Library: flutter
Error: Exception: Failed to load user data
Time: 2024-01-15 10:30:45
Additional Info:
  user_id: user123
  action: profile_load
  network_status: connected
Stack Trace:
#0      UserService.loadProfile (package:app/services/user_service.dart:45:7)
...
================================================================================
```

### 2. 生产环境监控

生产环境中的错误会：

- 静默处理，不影响用户体验
- 详细记录到监控系统
- 触发告警（如果配置）
- 提供错误统计和趋势分析

## 🚀 高级功能

### 1. 自定义错误分组

```dart
class CustomErrorInfo extends ErrorInfo {
  final String businessModule;
  final String userAction;
  
  const CustomErrorInfo({
    required super.error,
    required super.stackTrace,
    required super.errorType,
    required super.context,
    required this.businessModule,
    required this.userAction,
    super.additionalInfo = const {},
  });
}
```

### 2. 错误趋势分析

```dart
class ErrorAnalytics {
  static final Map<String, int> _errorCounts = {};
  
  static void recordError(String errorType) {
    _errorCounts[errorType] = (_errorCounts[errorType] ?? 0) + 1;
  }
  
  static Map<String, int> getErrorStats() => Map.from(_errorCounts);
}
```

## 📚 示例代码

完整的使用示例请参考：

- [全局异常捕获演示页面](../lib/examples/global_error_examples.dart)
- [错误恢复机制示例](../lib/core/error_handling/error_recovery.dart)
- [全局错误处理器](../lib/core/error_handling/global_error_handler.dart)

## ⚠️ 注意事项

1. **性能影响**: 全局异常捕获会有轻微的性能开销，但在可接受范围内
2. **内存管理**: 错误信息和面包屑会占用内存，系统会自动清理历史数据
3. **递归错误**: 系统有保护机制防止错误处理本身导致的递归错误
4. **平台差异**: 某些平台特定的错误可能需要额外处理
5. **调试模式**: 开发环境中会显示详细错误信息，生产环境中会静默处理

---

通过这个全局异常捕获系统，您的应用将具备强大的错误处理和恢复能力，大大提高应用的稳定性和用户体验。
