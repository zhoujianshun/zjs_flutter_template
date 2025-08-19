import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:zjs_flutter_template/core/error_handling/global_error_handler.dart';
import 'package:zjs_flutter_template/core/utils/logger.dart';

/// 错误恢复和重试机制
class ErrorRecovery {
  ErrorRecovery._();

  /// 带重试的异步操作执行器
  static Future<T> retryAsync<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
    double backoffMultiplier = 2.0,
    bool Function(Object error)? shouldRetry,
    String? context,
  }) async {
    var currentDelay = delay;
    Object? lastError;
    StackTrace? lastStackTrace;

    for (var attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        final result = await operation();

        // 如果不是第一次尝试，记录恢复成功
        if (attempt > 0) {
          AppLogger.info('🔄 操作重试成功');

          GlobalErrorHandler.instance.reportError(
            Exception('Operation recovered after $attempt retries'),
            StackTrace.current,
            context: context ?? 'RetryRecovery',
            errorType: ErrorType.manualReport,
            additionalInfo: {
              'recovery_type': 'retry_success',
              'attempts': attempt + 1,
              'original_error': lastError?.toString(),
            },
          );
        }

        return result;
      } catch (error, stackTrace) {
        lastError = error;
        lastStackTrace = stackTrace;

        // 检查是否应该重试
        if (attempt >= maxRetries || (shouldRetry != null && !shouldRetry(error))) {
          break;
        }

        AppLogger.warning('⚠️ 操作失败，准备重试');

        // 等待后重试
        await Future<void>.delayed(currentDelay);

        // 指数退避
        currentDelay = Duration(
          milliseconds: (currentDelay.inMilliseconds * backoffMultiplier).round(),
        );
      }
    }

    // 所有重试都失败了，上报最终错误
    GlobalErrorHandler.instance.reportError(
      lastError!,
      lastStackTrace,
      context: context ?? 'RetryFailed',
      errorType: ErrorType.manualReport,
      additionalInfo: {
        'recovery_type': 'retry_failed',
        'total_attempts': maxRetries + 1,
        'final_error': lastError.toString(),
      },
    );

    throw lastError;
  }

  /// 带降级的操作执行器
  static Future<T> withFallback<T>(
    Future<T> Function() primaryOperation,
    Future<T> Function() fallbackOperation, {
    String? context,
    bool reportFallback = true,
  }) async {
    try {
      return await primaryOperation();
    } catch (primaryError, primaryStackTrace) {
      try {
        if (reportFallback) {
          AppLogger.warning('⬇️ 主要操作失败，使用降级方案');

          GlobalErrorHandler.instance.reportError(
            primaryError,
            primaryStackTrace,
            context: context ?? 'FallbackActivated',
            errorType: ErrorType.manualReport,
            additionalInfo: {
              'recovery_type': 'fallback_activated',
              'primary_error': primaryError.toString(),
            },
          );
        }

        final result = await fallbackOperation();

        if (reportFallback) {
          AppLogger.info('✅ 降级方案执行成功');
        }

        return result;
      } catch (fallbackError, fallbackStackTrace) {
        // 降级方案也失败了
        GlobalErrorHandler.instance.reportError(
          fallbackError,
          fallbackStackTrace,
          context: context ?? 'FallbackFailed',
          errorType: ErrorType.manualReport,
          additionalInfo: {
            'recovery_type': 'fallback_failed',
            'primary_error': primaryError.toString(),
            'fallback_error': fallbackError.toString(),
          },
        );

        // 抛出原始错误
        throw primaryError;
      }
    }
  }

  /// 断路器模式
  static CircuitBreaker createCircuitBreaker({
    required String name,
    int failureThreshold = 5,
    Duration timeout = const Duration(seconds: 30),
    Duration resetTimeout = const Duration(minutes: 1),
  }) {
    return CircuitBreaker(
      name: name,
      failureThreshold: failureThreshold,
      timeout: timeout,
      resetTimeout: resetTimeout,
    );
  }

  /// 批量操作错误处理
  static Future<List<T?>> batchWithErrorHandling<T>(
    List<Future<T> Function()> operations, {
    String? context,
    bool continueOnError = true,
    int? concurrency,
  }) async {
    final results = <T?>[];
    final errors = <Object>[];

    if (concurrency != null && concurrency > 0) {
      // 并发执行（有限制）
      final semaphore = Semaphore(concurrency);
      final futures = operations.map((operation) async {
        await semaphore.acquire();
        try {
          return await operation();
        } catch (error, stackTrace) {
          if (continueOnError) {
            errors.add(error);
            GlobalErrorHandler.instance.reportError(
              error,
              stackTrace,
              context: context ?? 'BatchOperation',
              errorType: ErrorType.manualReport,
              additionalInfo: {
                'batch_operation': true,
                'continue_on_error': continueOnError,
              },
            );
            return null;
          } else {
            rethrow;
          }
        } finally {
          semaphore.release();
        }
      }).toList();

      results.addAll(await Future.wait(futures));
    } else {
      // 串行执行
      for (var i = 0; i < operations.length; i++) {
        try {
          final result = await operations[i]();
          results.add(result);
        } catch (error, stackTrace) {
          if (continueOnError) {
            errors.add(error);
            results.add(null);
            GlobalErrorHandler.instance.reportError(
              error,
              stackTrace,
              context: context ?? 'BatchOperation',
              errorType: ErrorType.manualReport,
              additionalInfo: {
                'batch_operation': true,
                'operation_index': i,
                'continue_on_error': continueOnError,
              },
            );
          } else {
            rethrow;
          }
        }
      }
    }

    // 报告批量操作摘要
    if (errors.isNotEmpty) {
      AppLogger.warning('⚠️ 批量操作完成，部分失败');
    }

    return results;
  }
}

/// 断路器实现
class CircuitBreaker {
  CircuitBreaker({
    required this.name,
    required this.failureThreshold,
    required this.timeout,
    required this.resetTimeout,
  });

  final String name;
  final int failureThreshold;
  final Duration timeout;
  final Duration resetTimeout;

  CircuitBreakerState _state = CircuitBreakerState.closed;
  int _failureCount = 0;
  DateTime? _lastFailureTime;

  /// 执行操作
  Future<T> execute<T>(Future<T> Function() operation) async {
    if (_state == CircuitBreakerState.open) {
      if (_shouldAttemptReset()) {
        _state = CircuitBreakerState.halfOpen;
        AppLogger.info('🔄 断路器进入半开状态');
      } else {
        throw CircuitBreakerOpenException(name);
      }
    }

    try {
      final result = await operation().timeout(timeout);

      if (_state == CircuitBreakerState.halfOpen) {
        _reset();
      }

      return result;
    } catch (error, stackTrace) {
      _recordFailure();

      GlobalErrorHandler.instance.reportError(
        error,
        stackTrace,
        context: 'CircuitBreaker($name)',
        errorType: ErrorType.manualReport,
        additionalInfo: {
          'circuit_breaker_name': name,
          'circuit_breaker_state': _state.name,
          'failure_count': _failureCount,
        },
      );

      rethrow;
    }
  }

  void _recordFailure() {
    _failureCount++;
    _lastFailureTime = DateTime.now();

    if (_failureCount >= failureThreshold) {
      _state = CircuitBreakerState.open;
      AppLogger.warning('🚫 断路器开启');
    }
  }

  void _reset() {
    _failureCount = 0;
    _lastFailureTime = null;
    _state = CircuitBreakerState.closed;
    AppLogger.info('✅ 断路器重置');
  }

  bool _shouldAttemptReset() {
    if (_lastFailureTime == null) return false;
    return DateTime.now().difference(_lastFailureTime!) >= resetTimeout;
  }

  CircuitBreakerState get state => _state;
  int get failureCount => _failureCount;
}

/// 断路器状态
enum CircuitBreakerState {
  closed, // 正常状态
  open, // 断开状态
  halfOpen, // 半开状态
}

/// 断路器开启异常
class CircuitBreakerOpenException implements Exception {
  const CircuitBreakerOpenException(this.circuitBreakerName);

  final String circuitBreakerName;

  @override
  String toString() => 'Circuit breaker "$circuitBreakerName" is open';
}

/// 信号量实现（用于限制并发）
class Semaphore {
  Semaphore(this._maxCount) : _currentCount = _maxCount;

  final int _maxCount;
  int _currentCount;
  final Queue<Completer<void>> _waitQueue = Queue<Completer<void>>();

  Future<void> acquire() async {
    if (_currentCount > 0) {
      _currentCount--;
      return;
    }

    final completer = Completer<void>();
    _waitQueue.add(completer);
    return completer.future;
  }

  void release() {
    if (_waitQueue.isNotEmpty) {
      final completer = _waitQueue.removeFirst();
      completer.complete();
    } else {
      _currentCount = min(_currentCount + 1, _maxCount);
    }
  }

  int get availablePermits => _currentCount;
  int get queueLength => _waitQueue.length;
}
