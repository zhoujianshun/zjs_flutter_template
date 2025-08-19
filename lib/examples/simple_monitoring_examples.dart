import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zjs_flutter_template/core/monitoring/interfaces/analytics_interface.dart';
import 'package:zjs_flutter_template/core/monitoring/monitoring_config_simple.dart';
import 'package:zjs_flutter_template/core/monitoring/simple_monitoring_manager.dart';

/// 简化的监控系统使用示例
///
/// 展示如何使用预留的监控接口
class SimpleMonitoringExamplesPage extends ConsumerWidget {
  const SimpleMonitoringExamplesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('监控系统示例'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildStatusCard(),
          const SizedBox(height: 16),
          _buildErrorMonitoringCard(context),
          const SizedBox(height: 16),
          _buildAnalyticsCard(context),
          const SizedBox(height: 16),
          _buildPerformanceCard(context),
          const SizedBox(height: 16),
          _buildIntegrationGuideCard(context),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    final config = MonitoringConfigSimple.getConfigSummary();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.blue,
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  '当前监控状态',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('模式', config['monitoring_mode']?.toString() ?? '未知'),
            _buildInfoRow('环境', config['environment']?.toString() ?? '未知'),
            _buildInfoRow('状态', (config['monitoring_enabled'] as bool?) ?? false ? '已启用' : '已禁用'),
            _buildInfoRow('描述', config['description']?.toString() ?? '无描述'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.orange.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '当前使用模拟服务，数据仅输出到控制台',
                      style: TextStyle(color: Colors.orange.shade700),
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

  Widget _buildErrorMonitoringCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🐛 错误监控示例',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _reportTestError,
                    icon: const Icon(Icons.bug_report),
                    label: const Text('上报测试错误'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _addBreadcrumb,
                    icon: const Icon(Icons.add_circle),
                    label: const Text('添加面包屑'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _setTestUser,
                icon: const Icon(Icons.person),
                label: const Text('设置测试用户'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📊 分析统计示例',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _trackCustomEvent,
                    icon: const Icon(Icons.analytics),
                    label: const Text('自定义事件'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _trackPageView,
                    icon: const Icon(Icons.pageview),
                    label: const Text('页面访问'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _trackLogin,
                    icon: const Icon(Icons.login),
                    label: const Text('登录事件'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _trackSearch,
                    icon: const Icon(Icons.search),
                    label: const Text('搜索事件'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '⚡ 性能监控示例',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _measureSyncOperation,
                    icon: const Icon(Icons.timer),
                    label: const Text('同步操作'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _measureAsyncOperation,
                    icon: const Icon(Icons.hourglass_empty),
                    label: const Text('异步操作'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _trackNetworkRequest,
                icon: const Icon(Icons.network_check),
                label: const Text('网络请求性能'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntegrationGuideCard(BuildContext context) {
    final guide = MonitoringConfigSimple.getIntegrationGuide();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🔧 后续接入指南',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '当前状态：${guide['current_status']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('下一步操作：', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 4),
                  ...((guide['next_steps'] as List).map((step) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('• ', style: TextStyle(color: Colors.blue.shade600)),
                            Expanded(child: Text(step.toString())),
                          ],
                        ),
                      ))),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showPlatformComparison,
                icon: const Icon(Icons.compare),
                label: const Text('查看平台对比'),
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

  // 示例方法实现
  Future<void> _reportTestError() async {
    await SimpleMonitoringManager.instance.reportError(
      Exception('这是一个测试错误 - ${DateTime.now()}'),
      StackTrace.current,
      context: 'monitoring_example_test',
      extra: {
        'test_type': 'manual_error_report',
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
    print('✅ 测试错误已上报（查看控制台输出）');
  }

  void _addBreadcrumb() {
    SimpleMonitoringManager.instance.addBreadcrumb(
      '用户点击了添加面包屑按钮',
      category: 'ui_interaction',
      level: 'info',
      data: {
        'button': 'add_breadcrumb',
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
    print('✅ 面包屑已添加（查看控制台输出）');
  }

  Future<void> _setTestUser() async {
    await SimpleMonitoringManager.instance.setUser(
      userId: 'test_user_${DateTime.now().millisecondsSinceEpoch}',
      email: 'test@example.com',
      username: 'TestUser',
      properties: {
        'user_type': 'demo',
        'registration_date': DateTime.now().toIso8601String(),
      },
    );
    print('✅ 测试用户信息已设置（查看控制台输出）');
  }

  Future<void> _trackCustomEvent() async {
    await SimpleMonitoringManager.instance.trackEvent(
      AnalyticsEvents.buttonClick,
      parameters: {
        'button_name': 'custom_event_demo',
        'screen_name': 'monitoring_examples',
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
    print('✅ 自定义事件已记录（查看控制台输出）');
  }

  Future<void> _trackPageView() async {
    await SimpleMonitoringManager.instance.trackPageView(
      'monitoring_examples_page',
      screenClass: 'SimpleMonitoringExamplesPage',
    );
    print('✅ 页面访问已记录（查看控制台输出）');
  }

  Future<void> _trackLogin() async {
    await SimpleMonitoringManager.instance.trackEvent(
      AnalyticsEvents.login,
      parameters: {
        'method': 'demo_login',
        'success': true,
      },
    );
    print('✅ 登录事件已记录（查看控制台输出）');
  }

  Future<void> _trackSearch() async {
    await SimpleMonitoringManager.instance.trackEvent(
      AnalyticsEvents.search,
      parameters: {
        'search_term': 'monitoring examples',
        'category': 'demo',
        'results_count': 5,
      },
    );
    print('✅ 搜索事件已记录（查看控制台输出）');
  }

  Future<void> _measureSyncOperation() async {
    final result = SimpleMonitoringManager.instance.measureSync(
      '同步计算操作',
      () {
        // 模拟计算密集型操作
        var sum = 0;
        for (var i = 0; i < 1000000; i++) {
          sum += i;
        }
        return sum;
      },
      metadata: {
        'operation_type': 'calculation',
        'iterations': 1000000,
      },
    );
    print('✅ 同步操作完成，结果: $result（查看控制台性能数据）');
  }

  Future<void> _measureAsyncOperation() async {
    final result = await SimpleMonitoringManager.instance.measureAsync(
      '异步网络模拟',
      () async {
        // 模拟异步操作
        await Future<void>.delayed(const Duration(milliseconds: 500));
        return 'async_operation_completed';
      },
      metadata: {
        'operation_type': 'network_simulation',
        'delay_ms': 500,
      },
    );
    print('✅ 异步操作完成，结果: $result（查看控制台性能数据）');
  }

  Future<void> _trackNetworkRequest() async {
    await SimpleMonitoringManager.instance.trackNetworkPerformance(
      'https://api.example.com/users',
      'GET',
      200,
      const Duration(milliseconds: 350),
      requestSize: 0,
      responseSize: 1024,
    );
    print('✅ 网络请求性能已记录（查看控制台输出）');
  }

  void _showPlatformComparison() {
    // 这里可以导航到平台对比页面或显示对话框
    print('📋 平台对比信息：');
    for (final platform in MonitoringPlatform.availablePlatforms) {
      print('${platform.name}: ${platform.description}');
      print('  依赖: ${platform.dependency}');
      print('  复杂度: ${platform.setupComplexity}');
      print('  成本: ${platform.cost}');
      print('  特性: ${platform.features.join(', ')}');
      print('');
    }
  }
}
