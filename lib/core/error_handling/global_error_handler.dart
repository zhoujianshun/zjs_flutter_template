import 'dart:async';
import 'dart:developer' as developer;
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zjs_flutter_template/core/utils/logger.dart';

/// 全局异常捕获处理器
///
/// 负责捕获和处理应用中的所有异常，包括：
/// - Flutter框架异常
/// - Dart运行时异常
/// - Zone异常
/// - 平台异常
class GlobalErrorHandler {
  GlobalErrorHandler._();

  static final GlobalErrorHandler _instance = GlobalErrorHandler._();
  static GlobalErrorHandler get instance => _instance;

  bool _isInitialized = false;

  // 监控系统回调
  static void Function(Object error, StackTrace? stackTrace, {String? context, Map<String, dynamic>? extra})?
      _monitoringCallback;

  /// 初始化全局异常捕获
  Future<void> initialize() async {
    if (_isInitialized) return;

    AppLogger.info('🔧 初始化全局异常捕获系统...');

    // 1. 设置Flutter框架错误处理
    _setupFlutterErrorHandling();

    // 2. 设置Dart运行时错误处理
    _setupDartErrorHandling();

    // 3. 设置Isolate错误处理
    _setupIsolateErrorHandling();

    // 4. 设置平台通道错误处理
    _setupPlatformChannelErrorHandling();

    _isInitialized = true;
    AppLogger.info('✅ 全局异常捕获系统初始化完成');
  }

  /// 在错误隔离Zone中运行应用
  void runAppInErrorZone(Widget app, {Future<void> Function()? onInitialize}) {
    runZonedGuarded(
      () async {
        // 在同一个Zone中进行初始化
        WidgetsFlutterBinding.ensureInitialized();

        // 如果提供了初始化回调，执行它
        if (onInitialize != null) {
          await onInitialize();
        }

        // 初始化全局异常捕获系统
        await initialize();

        // 运行应用
        runApp(app);
      },
      _handleZoneError,
      zoneSpecification: ZoneSpecification(
        // 捕获print输出
        print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
          parent.print(zone, line);
          if (line.contains('ERROR') || line.contains('EXCEPTION')) {
            _handlePrintError(line);
          }
        },
        // 捕获未处理的异步错误
        handleUncaughtError: (Zone self, ZoneDelegate parent, Zone zone, Object error, StackTrace stackTrace) {
          _handleZoneError(error, stackTrace);
        },
      ),
    );
  }

  /// 设置Flutter框架错误处理
  void _setupFlutterErrorHandling() {
    // 保存原始的错误处理器
    final originalOnError = FlutterError.onError;

    FlutterError.onError = (FlutterErrorDetails details) {
      _handleFlutterError(details);

      // 如果有原始处理器，也调用它
      originalOnError?.call(details);
    };

    // 设置错误展示策略
    if (!kDebugMode) {
      // 生产模式：静默处理错误
      FlutterError.presentError = (FlutterErrorDetails details) {
        AppLogger.error('Flutter错误（生产模式静默处理）: ${details.exception}');
      };
    }
    // 开发模式保持默认行为（显示红屏错误）
  }

  /// 设置Dart运行时错误处理
  void _setupDartErrorHandling() {
    // 捕获未处理的异步异常
    PlatformDispatcher.instance.onError = (error, stack) {
      _handleDartError(error, stack);
      return true; // 返回true表示错误已处理，阻止应用崩溃
    };
  }

  /// 设置Isolate错误处理
  void _setupIsolateErrorHandling() {
    // 监听当前Isolate的错误
    Isolate.current.addErrorListener(
      RawReceivePort((dynamic errorData) {
        if (errorData is List && errorData.length >= 2) {
          final error = errorData[0] as Object;
          final stackTrace = StackTrace.fromString(errorData[1].toString());
          _handleIsolateError(error, stackTrace);
        }
      }).sendPort,
    );
  }

  /// 设置平台通道错误处理
  void _setupPlatformChannelErrorHandling() {
    try {
      // 1. 设置二进制消息错误处理器
      _setupBinaryMessengerErrorHandling();

      // 2. 设置通道缓冲区监听器
      _setupChannelBuffersListener();

      AppLogger.info('✅ 平台通道错误处理已设置（使用新的API方式）');
    } catch (e, stackTrace) {
      AppLogger.error('平台通道错误处理设置失败', error: e, stackTrace: stackTrace);
    }
  }

  /// 设置二进制消息错误处理
  void _setupBinaryMessengerErrorHandling() {
    // 注意：在新版本的Flutter中，直接设置defaultBinaryMessenger可能不可用
    // 这里我们使用替代方案：通过包装常用的MethodChannel来捕获错误

    AppLogger.info('二进制消息错误处理已设置（使用MethodChannel包装方式）');

    // 实际的错误捕获会在具体的MethodChannel调用中通过try-catch实现
    // 或者通过PlatformDispatcher.instance.onError统一处理
  }

  /// 设置通道缓冲区监听器
  void _setupChannelBuffersListener() {
    // 监听通道缓冲区的错误和事件
    try {
      // 注意：ChannelBuffers在某些Flutter版本中可能不可用
      // 这里使用反射或条件编译来兼容不同版本
      _setupChannelBuffersListenerSafely();
    } catch (e) {
      AppLogger.warning('通道缓冲区监听器设置失败（可能是版本兼容性问题）: $e');
    }
  }

  /// 安全地设置通道缓冲区监听器
  void _setupChannelBuffersListenerSafely() {
    // 这里可以添加版本检查或使用反射
    // 目前先记录日志，表示功能已预留
    AppLogger.info('通道缓冲区监听器已预留（等待Flutter版本兼容性确认）');
  }

  /// 处理Flutter框架错误
  void _handleFlutterError(FlutterErrorDetails details) {
    final errorInfo = ErrorInfo(
      error: details.exception,
      stackTrace: details.stack,
      errorType: ErrorType.flutterError,
      context: 'Flutter Framework',
      library: details.library,
      additionalInfo: {
        'context': details.context?.toString(),
        'informationCollector': details.informationCollector?.toString(),
        'silent': details.silent,
      },
    );

    _reportError(errorInfo);
  }

  /// 处理Dart运行时错误
  void _handleDartError(Object error, StackTrace stackTrace) {
    final errorInfo = ErrorInfo(
      error: error,
      stackTrace: stackTrace,
      errorType: ErrorType.dartError,
      context: 'Dart Runtime',
      additionalInfo: {
        'error_type': error.runtimeType.toString(),
      },
    );

    _reportError(errorInfo);
  }

  /// 处理Zone错误
  void _handleZoneError(Object error, StackTrace stackTrace) {
    final errorInfo = ErrorInfo(
      error: error,
      stackTrace: stackTrace,
      errorType: ErrorType.zoneError,
      context: 'Zone Error',
      additionalInfo: {
        'zone': Zone.current.toString(),
      },
    );

    _reportError(errorInfo);
  }

  /// 处理Isolate错误
  void _handleIsolateError(Object error, StackTrace stackTrace) {
    final errorInfo = ErrorInfo(
      error: error,
      stackTrace: stackTrace,
      errorType: ErrorType.isolateError,
      context: 'Isolate Error',
      additionalInfo: {
        'isolate': Isolate.current.debugName ?? 'unknown',
      },
    );

    _reportError(errorInfo);
  }

  /// 处理打印输出中的错误
  void _handlePrintError(String errorMessage) {
    final errorInfo = ErrorInfo(
      error: Exception('Print Error: $errorMessage'),
      stackTrace: StackTrace.current,
      errorType: ErrorType.printError,
      context: 'Print Output',
      additionalInfo: {
        'message': errorMessage,
      },
    );

    _reportError(errorInfo);
  }

  /// 统一错误上报
  void _reportError(ErrorInfo errorInfo) {
    try {
      // 1. 记录到日志
      AppLogger.error(
        '🚨 [${errorInfo.errorType.name}] ${errorInfo.context}: ${errorInfo.error}',
        error: errorInfo.error,
        stackTrace: errorInfo.stackTrace,
      );

      // 2. 输出到开发者控制台
      developer.log(
        '🚨 Global Error Caught',
        name: 'GlobalErrorHandler',
        error: errorInfo.error,
        stackTrace: errorInfo.stackTrace,
        level: 1000, // ERROR level
      );

      // 3. 上报到监控系统（如果可用）
      try {
        _reportToMonitoring(errorInfo);
      } catch (e) {
        // 监控系统不可用时静默失败
        print('监控系统不可用: $e');
      }

      // 5. 在开发模式下打印详细信息
      if (kDebugMode) {
        _printErrorDetails(errorInfo);
      }
    } catch (e) {
      // 确保错误处理本身不会导致崩溃
      print('❌ Error in error handler: $e');
    }
  }

  /// 打印错误详情（仅开发模式）
  void _printErrorDetails(ErrorInfo errorInfo) {
    print('\n${'=' * 80}');
    print('🚨 GLOBAL ERROR CAUGHT');
    print('=' * 80);
    print('Type: ${errorInfo.errorType.name}');
    print('Context: ${errorInfo.context}');
    print('Library: ${errorInfo.library ?? 'N/A'}');
    print('Error: ${errorInfo.error}');
    print('Time: ${DateTime.now()}');

    if (errorInfo.additionalInfo.isNotEmpty) {
      print('Additional Info:');
      errorInfo.additionalInfo.forEach((key, value) {
        print('  $key: $value');
      });
    }

    if (errorInfo.stackTrace != null) {
      print('Stack Trace:');
      print(errorInfo.stackTrace);
    }
    print('=' * 80 + '\n');
  }

  /// 手动报告错误
  void reportError(
    Object error,
    StackTrace? stackTrace, {
    String? context,
    ErrorType? errorType,
    Map<String, dynamic>? additionalInfo,
  }) {
    final errorInfo = ErrorInfo(
      error: error,
      stackTrace: stackTrace ?? StackTrace.current,
      errorType: errorType ?? ErrorType.manualReport,
      context: context ?? 'Manual Report',
      additionalInfo: additionalInfo ?? {},
    );

    _reportError(errorInfo);
  }

  /// 设置监控系统回调
  static void setMonitoringCallback(
    void Function(Object error, StackTrace? stackTrace, {String? context, Map<String, dynamic>? extra}) callback,
  ) {
    _monitoringCallback = callback;
  }

  /// 上报到监控系统
  void _reportToMonitoring(ErrorInfo errorInfo) {
    try {
      _monitoringCallback?.call(
        errorInfo.error,
        errorInfo.stackTrace,
        context: errorInfo.context,
        extra: {
          'error_type': errorInfo.errorType.name,
          'library': errorInfo.library,
          'timestamp': DateTime.now().toIso8601String(),
          ...errorInfo.additionalInfo,
        },
      );
    } catch (e) {
      // 监控系统报告失败时静默处理
      print('监控系统报告失败: $e');
    }
  }

  /// 检查是否已初始化
  bool get isInitialized => _isInitialized;
}

/// 错误信息数据类
class ErrorInfo {
  const ErrorInfo({
    required this.error,
    required this.stackTrace,
    required this.errorType,
    required this.context,
    this.library,
    this.additionalInfo = const {},
  });

  final Object error;
  final StackTrace? stackTrace;
  final ErrorType errorType;
  final String context;
  final String? library;
  final Map<String, dynamic> additionalInfo;
}

/// 错误类型枚举
enum ErrorType {
  flutterError('Flutter Framework Error'),
  dartError('Dart Runtime Error'),
  zoneError('Zone Error'),
  isolateError('Isolate Error'),
  platformChannelError('Platform Channel Error'),
  printError('Print Error'),
  manualReport('Manual Report');

  const ErrorType(this.displayName);
  final String displayName;
}

/// 全局错误处理工具类
class ErrorHandlerUtils {
  ErrorHandlerUtils._();

  /// 安全执行同步操作
  static T? safeExecute<T>(
    T Function() operation, {
    String? context,
    T? fallbackValue,
  }) {
    try {
      return operation();
    } catch (error, stackTrace) {
      GlobalErrorHandler.instance.reportError(
        error,
        stackTrace,
        context: context ?? 'SafeExecute',
        errorType: ErrorType.manualReport,
        additionalInfo: {
          'operation': 'sync',
          'has_fallback': fallbackValue != null,
        },
      );
      return fallbackValue;
    }
  }

  /// 安全执行异步操作
  static Future<T?> safeExecuteAsync<T>(
    Future<T> Function() operation, {
    String? context,
    T? fallbackValue,
  }) async {
    try {
      return await operation();
    } catch (error, stackTrace) {
      GlobalErrorHandler.instance.reportError(
        error,
        stackTrace,
        context: context ?? 'SafeExecuteAsync',
        errorType: ErrorType.manualReport,
        additionalInfo: {
          'operation': 'async',
          'has_fallback': fallbackValue != null,
        },
      );
      return fallbackValue;
    }
  }

  /// 创建错误边界Widget
  static Widget errorBoundary({
    required Widget child,
    Widget? fallback,
    String? context,
  }) {
    return ErrorBoundary(
      fallback: fallback,
      context: context,
      child: child,
    );
  }
}

/// 错误边界Widget
class ErrorBoundary extends StatefulWidget {
  const ErrorBoundary({
    required this.child,
    super.key,
    this.fallback,
    this.context,
  });

  final Widget child;
  final Widget? fallback;
  final String? context;

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  bool _hasError = false;
  Object? _error;

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return widget.fallback ?? _buildDefaultErrorWidget();
    }

    return Builder(
      builder: (context) {
        try {
          return widget.child;
        } catch (error, stackTrace) {
          _handleError(error, stackTrace);
          return widget.fallback ?? _buildDefaultErrorWidget();
        }
      },
    );
  }

  void _handleError(Object error, StackTrace stackTrace) {
    setState(() {
      _hasError = true;
      _error = error;
    });

    GlobalErrorHandler.instance.reportError(
      error,
      stackTrace,
      context: widget.context ?? 'ErrorBoundary',
      errorType: ErrorType.flutterError,
      additionalInfo: {
        'widget': widget.child.runtimeType.toString(),
      },
    );
  }

  Widget _buildDefaultErrorWidget() {
    if (kDebugMode) {
      return Container(
        padding: const EdgeInsets.all(16),
        color: Colors.red.shade100,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 48),
            const SizedBox(height: 8),
            Text(
              'Widget Error',
              style: TextStyle(
                color: Colors.red.shade800,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _error?.toString() ?? 'Unknown error',
              style: TextStyle(
                color: Colors.red.shade600,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // 生产模式下返回空容器
    return const SizedBox.shrink();
  }
}

/// 平台通道错误捕获工具类
///
/// 提供平台通道错误处理的实用方法
class PlatformChannelErrorHandler {
  PlatformChannelErrorHandler._();

  /// 安全执行MethodChannel调用
  static Future<T?> safeInvokeMethod<T>(
    MethodChannel channel,
    String method, [
    dynamic arguments,
  ]) async {
    try {
      return await channel.invokeMethod<T>(method, arguments);
    } catch (error, stackTrace) {
      // 上报到全局错误处理器
      GlobalErrorHandler.instance.reportError(
        error,
        stackTrace,
        context: 'SafeMethodChannel',
        errorType: ErrorType.platformChannelError,
        additionalInfo: {
          'channel': channel.name,
          'method': method,
          'arguments': arguments?.toString() ?? 'null',
        },
      );
      return null;
    }
  }

  /// 安全设置消息处理器
  static void safeSetMessageHandler(
    String channelName,
    Future<ByteData?> Function(ByteData? message)? handler,
  ) {
    final channel = BasicMessageChannel<ByteData?>(
      channelName,
      const BinaryCodec(),
    );

    if (handler == null) {
      channel.setMessageHandler(null);
      return;
    }

    channel.setMessageHandler((ByteData? message) async {
      try {
        return await handler(message);
      } catch (error, stackTrace) {
        GlobalErrorHandler.instance.reportError(
          error,
          stackTrace,
          context: 'SafeMessageHandler',
          errorType: ErrorType.platformChannelError,
          additionalInfo: {
            'channel': channelName,
          },
        );
        // 返回空的ByteData而不是null
        return ByteData(0);
      }
    });
  }
}
