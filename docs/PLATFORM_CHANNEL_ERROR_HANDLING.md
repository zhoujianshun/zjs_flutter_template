# 平台通道错误处理指南

## 概述

本项目使用现代的Flutter API来处理平台通道错误，提供了全面的错误捕获和处理机制。

## 新的API方式

### 1. 全局错误捕获

所有平台通道错误都会被全局异常捕获系统自动处理：

```dart
// 平台通道错误会被自动捕获并上报
try {
  await MethodChannel('my_channel').invokeMethod('my_method');
} on PlatformException catch (e) {
  // 会被全局错误处理器捕获
  print('平台异常: ${e.code} - ${e.message}');
}
```

### 2. 安全的平台通道调用

使用`PlatformChannelErrorHandler`提供的安全方法：

```dart
import 'package:zjs_flutter_template/core/error_handling/global_error_handler.dart';

// 安全调用MethodChannel
final result = await PlatformChannelErrorHandler.safeInvokeMethod<String>(
  const MethodChannel('my_channel'),
  'get_data',
  {'param': 'value'},
);

if (result != null) {
  print('调用成功: $result');
} else {
  print('调用失败，已自动上报错误');
}
```

### 3. 安全的消息处理器设置

```dart
// 安全设置消息处理器
PlatformChannelErrorHandler.safeSetMessageHandler(
  'my_message_channel',
  (ByteData? message) async {
    // 处理消息
    return ByteData.view(Uint8List.fromList([1, 2, 3]).buffer);
  },
);
```

## 错误类型和处理

### 支持的平台通道错误类型

1. **PlatformException**: 平台特定的异常
2. **MissingPluginException**: 缺少插件异常
3. **TimeoutException**: 调用超时异常
4. **FormatException**: 数据格式异常

### 错误信息收集

每个平台通道错误都会收集以下信息：

- 错误类型和消息
- 调用的通道名称
- 调用的方法名称
- 传递的参数
- 完整的堆栈跟踪
- 时间戳

## 最佳实践

### 1. 使用安全方法

推荐使用`PlatformChannelErrorHandler`提供的安全方法，而不是直接调用原生API：

```dart
// ❌ 不推荐
try {
  await MethodChannel('channel').invokeMethod('method');
} catch (e) {
  // 手动处理错误
}

// ✅ 推荐
final result = await PlatformChannelErrorHandler.safeInvokeMethod(
  const MethodChannel('channel'),
  'method',
);
```

### 2. 错误恢复策略

结合错误恢复机制使用：

```dart
import 'package:zjs_flutter_template/core/error_handling/error_recovery.dart';

// 带重试的平台通道调用
final result = await ErrorRecovery.retryAsync(
  () => PlatformChannelErrorHandler.safeInvokeMethod(
    const MethodChannel('unstable_channel'),
    'unreliable_method',
  ),
  maxRetries: 3,
  delay: const Duration(seconds: 1),
  context: 'UnstableChannelCall',
);
```

### 3. 降级处理

```dart
// 带降级的平台通道调用
final result = await ErrorRecovery.withFallback(
  () => PlatformChannelErrorHandler.safeInvokeMethod(
    const MethodChannel('primary_channel'),
    'get_data',
  ),
  fallbackOperation: () async {
    // 使用本地缓存或默认值
    return 'fallback_data';
  },
  context: 'DataRetrieval',
);
```

## 监控和调试

### 1. 错误日志

所有平台通道错误都会被记录到应用日志中：

```
🚨 全局错误捕获: platformChannelError
Context: Platform Channel Error
Channel: my_channel
Method: my_method
Error: PlatformException(error_code, Error message, null, null)
```

### 2. 错误统计

错误会被上报到监控系统（如果已配置）：

- 错误频率统计
- 错误类型分布
- 影响的用户数量
- 性能影响分析

### 3. 开发调试

在开发模式下，可以使用示例页面测试平台通道错误处理：

```dart
// 导航到全局错误示例页面
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const GlobalErrorExamplesPage(),
  ),
);
```

## 版本兼容性

### Flutter版本要求

- Flutter 3.0+
- Dart 2.17+

### API变更说明

本实现使用了现代的Flutter API，避免了已弃用的方法：

- ❌ 不再使用 `ServicesBinding.defaultBinaryMessenger` 直接设置
- ❌ 不再使用已弃用的 `ChannelBuffers` API
- ✅ 使用 `PlatformDispatcher.instance.onError` 统一处理
- ✅ 使用包装模式安全调用平台通道

## 故障排除

### 常见问题

1. **错误没有被捕获**
   - 确保全局错误处理器已正确初始化
   - 检查是否在错误隔离Zone中运行

2. **性能影响**
   - 安全包装器的性能开销可忽略不计
   - 错误上报是异步进行的，不会阻塞主线程

3. **调试信息不足**
   - 检查日志级别设置
   - 确保在开发模式下运行

### 调试技巧

```dart
// 开启详细的平台通道日志
import 'package:zjs_flutter_template/core/utils/logger.dart';

// 在应用启动时设置
AppLogger.setLevel(LogLevel.debug);
```

## 扩展和自定义

### 自定义错误处理

可以扩展`PlatformChannelErrorHandler`来添加自定义逻辑：

```dart
class CustomPlatformChannelHandler extends PlatformChannelErrorHandler {
  static Future<T?> customSafeInvokeMethod<T>(
    MethodChannel channel,
    String method, [
    dynamic arguments,
  ]) async {
    // 添加自定义的前置处理
    print('调用平台方法: ${channel.name}.$method');
    
    // 调用基础的安全方法
    return safeInvokeMethod<T>(channel, method, arguments);
  }
}
```

### 集成第三方监控

```dart
// 在GlobalErrorHandler的监控回调中集成第三方服务
GlobalErrorHandler.setMonitoringCallback((error, stackTrace, {context, extra}) {
  // 上报到自定义监控系统
  if (extra?['error_type'] == 'platformChannelError') {
    MyCustomMonitoring.reportPlatformChannelError(
      error,
      stackTrace,
      channel: extra?['channel'],
      method: extra?['method'],
    );
  }
});
```

## 总结

新的平台通道错误处理API提供了：

- ✅ **全面的错误捕获**: 自动捕获所有平台通道错误
- ✅ **安全的调用方式**: 提供包装方法避免崩溃
- ✅ **详细的错误信息**: 收集完整的错误上下文
- ✅ **灵活的恢复机制**: 支持重试、降级等策略
- ✅ **现代的API设计**: 使用最新的Flutter API
- ✅ **良好的性能**: 最小化性能开销
- ✅ **易于扩展**: 支持自定义错误处理逻辑

通过使用这套平台通道错误处理系统，您的应用将具备更好的稳定性和用户体验。
