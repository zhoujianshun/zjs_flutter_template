import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zjs_flutter_template/core/error_handling/error_recovery.dart';
import 'package:zjs_flutter_template/core/error_handling/global_error_handler.dart';
import 'package:zjs_flutter_template/core/utils/logger.dart';

/// 全局异常捕获演示页面
class GlobalErrorExamplesPage extends ConsumerWidget {
  const GlobalErrorExamplesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('全局异常捕获演示'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildStatusCard(),
          const SizedBox(height: 16),
          _buildBasicErrorsCard(context),
          const SizedBox(height: 16),
          _buildAsyncErrorsCard(context),
          const SizedBox(height: 16),
          _buildWidgetErrorsCard(context),
          const SizedBox(height: 16),
          _buildRecoveryMechanismsCard(context),
          const SizedBox(height: 16),
          _buildAdvancedFeaturesCard(context),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.shield_outlined, color: Colors.green, size: 24),
                SizedBox(width: 8),
                Text(
                  '全局异常捕获状态',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('系统状态', GlobalErrorHandler.instance.isInitialized ? '已初始化' : '未初始化'),
            _buildInfoRow('捕获范围', 'Flutter框架、Dart运行时、Zone、Isolate、平台通道'),
            _buildInfoRow('错误处理', '自动上报、面包屑记录、开发调试'),
            _buildInfoRow('恢复机制', '重试、降级、断路器、批量处理'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green.shade700),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      '全局异常捕获系统已激活，所有错误都会被自动捕获和处理',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicErrorsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🐛 基础错误测试',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _throwSyncError,
                    icon: const Icon(Icons.error),
                    label: const Text('同步异常'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _throwAsyncError,
                    icon: const Icon(Icons.timer),
                    label: const Text('异步异常'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _throwZoneError,
                    icon: const Icon(Icons.layers),
                    label: const Text('Zone异常'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _throwPlatformError,
                    icon: const Icon(Icons.phone_android),
                    label: const Text('平台异常'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _reportManualError(context),
                icon: const Icon(Icons.report),
                label: const Text('手动上报错误'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAsyncErrorsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '⏰ 异步错误测试',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _testFutureError(context),
                    icon: const Icon(Icons.access_time),
                    label: const Text('Future错误'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _testStreamError(context),
                    icon: const Icon(Icons.stream),
                    label: const Text('Stream错误'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _testTimerError(context),
                    icon: const Icon(Icons.schedule),
                    label: const Text('Timer错误'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _testIsolateError(context),
                    icon: const Icon(Icons.memory),
                    label: const Text('Isolate错误'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetErrorsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🎨 Widget错误测试',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showErrorWidget(context),
                    icon: const Icon(Icons.widgets),
                    label: const Text('Widget异常'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showErrorBoundary(context),
                    icon: const Icon(Icons.security),
                    label: const Text('错误边界'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showBuildError(context),
                icon: const Icon(Icons.build),
                label: const Text('Build方法异常'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecoveryMechanismsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🔄 错误恢复机制',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _testRetryMechanism(context),
                    icon: const Icon(Icons.refresh),
                    label: const Text('重试机制'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _testFallbackMechanism(context),
                    icon: const Icon(Icons.backup),
                    label: const Text('降级机制'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _testCircuitBreaker(context),
                    icon: const Icon(Icons.electrical_services),
                    label: const Text('断路器'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _testBatchProcessing(context),
                    icon: const Icon(Icons.batch_prediction),
                    label: const Text('批量处理'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedFeaturesCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🚀 高级功能测试',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _testSafeExecution(context),
                    icon: const Icon(Icons.safety_check),
                    label: const Text('安全执行'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _testErrorContext(context),
                    icon: const Icon(Icons.menu),
                    label: const Text('错误上下文'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _testPlatformChannelErrors(context),
                    icon: const Icon(Icons.link),
                    label: const Text('平台通道测试'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _testMethodChannelErrors(context),
                    icon: const Icon(Icons.api),
                    label: const Text('方法通道测试'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _testComplexScenario(context),
                icon: const Icon(Icons.psychology),
                label: const Text('复杂场景测试'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  // 基础错误测试方法
  void _throwSyncError() {
    throw Exception('这是一个同步异常测试 - ${DateTime.now()}');
  }

  Future<void> _throwAsyncError() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    throw Exception('这是一个异步异常测试 - ${DateTime.now()}');
  }

  void _throwZoneError() {
    runZoned(() {
      throw Exception('这是一个Zone异常测试 - ${DateTime.now()}');
    });
  }

  Future<void> _throwPlatformError() async {
    try {
      // 测试多种平台通道错误场景

      // 1. 调用不存在的平台方法
      await const MethodChannel('test_channel').invokeMethod('nonexistent_method');
    } on PlatformException catch (e) {
      // 平台异常会被新的BinaryMessenger包装器捕获
      AppLogger.info('捕获到平台异常: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      // 其他错误也会被全局捕获器捕获
      AppLogger.info('捕获到其他平台错误: $e');
      rethrow;
    }
  }

  void _reportManualError(BuildContext context) {
    GlobalErrorHandler.instance.reportError(
      Exception('手动上报的错误示例'),
      StackTrace.current,
      context: 'ManualErrorReport',
      errorType: ErrorType.manualReport,
      additionalInfo: {
        'user_action': 'manual_report_button_clicked',
        'timestamp': DateTime.now().toIso8601String(),
      },
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ 错误已手动上报')),
    );
  }

  // 异步错误测试方法
  Future<void> _testFutureError(BuildContext context) async {
    // 创建一个会失败的Future
    Future.delayed(const Duration(milliseconds: 200), () {
      throw Exception('Future中的异常 - ${DateTime.now()}');
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🔄 Future错误已触发，请查看控制台')),
    );
  }

  void _testStreamError(BuildContext context) {
    // 创建一个会产生错误的Stream
    Stream.periodic(const Duration(milliseconds: 100), (count) {
      if (count >= 3) {
        throw Exception('Stream中的异常 - ${DateTime.now()}');
      }
      return count;
    }).listen(
      (data) => print('Stream data: $data'),
      onError: (Object error) {
        // 这个错误会被全局捕获器捕获
        throw error;
      },
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🌊 Stream错误已触发，请查看控制台')),
    );
  }

  void _testTimerError(BuildContext context) {
    Timer(const Duration(milliseconds: 300), () {
      throw Exception('Timer中的异常 - ${DateTime.now()}');
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('⏲️ Timer错误已触发，请查看控制台')),
    );
  }

  void _testIsolateError(BuildContext context) {
    // 注意：这个示例可能在某些平台上不工作
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('💭 Isolate错误测试（模拟）')),
    );

    // 模拟Isolate错误
    Future.delayed(const Duration(milliseconds: 100), () {
      throw Exception('模拟Isolate异常 - ${DateTime.now()}');
    });
  }

  // Widget错误测试方法
  void _showErrorWidget(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const _ErrorWidget(),
      ),
    );
  }

  void _showErrorBoundary(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('错误边界测试')),
          body: Center(
            child: ErrorHandlerUtils.errorBoundary(
              context: 'ErrorBoundaryTest',
              child: const _ErrorWidget(),
              fallback: const _ErrorFallbackWidget(),
            ),
          ),
        ),
      ),
    );
  }

  void _showBuildError(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const _BuildErrorWidget(),
      ),
    );
  }

  // 错误恢复机制测试方法
  Future<void> _testRetryMechanism(BuildContext context) async {
    try {
      final result = await ErrorRecovery.retryAsync(
        () async {
          // 模拟不稳定的操作
          if (Random().nextBool()) {
            throw Exception('随机失败');
          }
          return '操作成功';
        },
        delay: const Duration(milliseconds: 500),
        context: 'RetryTest',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ 重试成功: $result')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ 重试失败: $e')),
      );
    }
  }

  Future<void> _testFallbackMechanism(BuildContext context) async {
    try {
      final result = await ErrorRecovery.withFallback(
        () async {
          throw Exception('主要操作失败');
        },
        () async {
          return '降级方案结果';
        },
        context: 'FallbackTest',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ 降级成功: $result')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ 降级失败: $e')),
      );
    }
  }

  Future<void> _testCircuitBreaker(BuildContext context) async {
    final circuitBreaker = ErrorRecovery.createCircuitBreaker(
      name: 'TestCircuitBreaker',
      failureThreshold: 2,
      timeout: const Duration(seconds: 1),
    );

    // 连续失败几次来触发断路器
    for (var i = 0; i < 4; i++) {
      try {
        await circuitBreaker.execute(() async {
          throw Exception('模拟服务不可用');
        });
      } catch (e) {
        print('断路器测试 $i: $e');
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🔌 断路器状态: ${circuitBreaker.state.name}'),
      ),
    );
  }

  Future<void> _testBatchProcessing(BuildContext context) async {
    final operations = List.generate(
        5,
        (index) => () async {
              if (index == 2) {
                throw Exception('批量操作 $index 失败');
              }
              return '结果 $index';
            });

    final results = await ErrorRecovery.batchWithErrorHandling(
      operations,
      context: 'BatchTest',
    );

    final successCount = results.where((r) => r != null).length;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('📦 批量处理完成: $successCount/${results.length} 成功'),
      ),
    );
  }

  // 高级功能测试方法
  void _testSafeExecution(BuildContext context) {
    final result = ErrorHandlerUtils.safeExecute(
      () {
        if (Random().nextBool()) {
          throw Exception('随机异常');
        }
        return '安全执行成功';
      },
      context: 'SafeExecutionTest',
      fallbackValue: '降级值',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('🛡️ 安全执行结果: $result')),
    );
  }

  void _testErrorContext(BuildContext context) {
    GlobalErrorHandler.instance.reportError(
      Exception('带上下文的错误'),
      StackTrace.current,
      context: 'ErrorContextTest',
      errorType: ErrorType.manualReport,
      additionalInfo: {
        'user_id': 'test_user_123',
        'screen': 'GlobalErrorExamplesPage',
        'action': 'test_error_context',
        'device_info': 'Flutter Demo Device',
        'app_version': '1.0.0',
        'timestamp': DateTime.now().toIso8601String(),
      },
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('📝 带上下文的错误已上报')),
    );
  }

  Future<void> _testComplexScenario(BuildContext context) async {
    // 复杂场景：嵌套异步操作 + 重试 + 降级
    try {
      await ErrorRecovery.retryAsync(
        () async {
          return ErrorRecovery.withFallback(
            () async {
              await Future<void>.delayed(const Duration(milliseconds: 100));
              if (Random().nextDouble() < 0.7) {
                throw Exception('复杂场景主要操作失败');
              }
              return '主要操作成功';
            },
            () async {
              await Future<void>.delayed(const Duration(milliseconds: 50));
              if (Random().nextDouble() < 0.3) {
                throw Exception('复杂场景降级操作也失败');
              }
              return '降级操作成功';
            },
            context: 'ComplexScenarioFallback',
          );
        },
        maxRetries: 2,
        context: 'ComplexScenarioRetry',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🎯 复杂场景测试完成')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('💥 复杂场景最终失败: $e')),
      );
    }
  }

  /// 测试平台通道错误处理
  Future<void> _testPlatformChannelErrors(BuildContext context) async {
    try {
      // 测试不同类型的平台通道错误

      // 1. 调用不存在的通道
      await const MethodChannel('nonexistent_channel_12345').invokeMethod('test_method');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ 平台通道错误已被捕获: ${e.runtimeType}')),
      );
    }
  }

  /// 测试方法通道错误处理
  Future<void> _testMethodChannelErrors(BuildContext context) async {
    const methodChannel = MethodChannel('test_error_channel');

    try {
      // 测试多种方法通道错误场景
      final futures = <Future<dynamic>>[
        // 1. 调用不存在的方法
        methodChannel.invokeMethod('nonexistent_method'),

        // 2. 传递错误的参数类型
        methodChannel.invokeMethod('test_method', {'invalid': Object()}),

        // 3. 调用会超时的方法
        methodChannel.invokeMethod('timeout_method').timeout(
              const Duration(milliseconds: 100),
            ),
      ];

      // 并发执行所有测试
      await Future.wait(futures);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ 方法通道错误测试完成，错误类型: ${e.runtimeType}'),
          duration: const Duration(seconds: 3),
        ),
      );

      // 显示详细信息
      AppLogger.info('方法通道错误详情: $e');
    }
  }
}

// 测试用的错误Widget
class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget();

  @override
  Widget build(BuildContext context) {
    throw Exception('Widget构建时异常 - ${DateTime.now()}');
  }
}

// 错误降级Widget
class _ErrorFallbackWidget extends StatelessWidget {
  const _ErrorFallbackWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade300),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning_amber, color: Colors.orange.shade700, size: 48),
          const SizedBox(height: 12),
          Text(
            '组件加载失败',
            style: TextStyle(
              color: Colors.orange.shade800,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '使用降级方案显示此内容',
            style: TextStyle(
              color: Colors.orange.shade700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// Build错误Widget
class _BuildErrorWidget extends StatelessWidget {
  const _BuildErrorWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Build错误测试')),
      body: Center(
        child: Builder(
          builder: (context) {
            throw Exception('Build方法中的异常 - ${DateTime.now()}');
          },
        ),
      ),
    );
  }
}
