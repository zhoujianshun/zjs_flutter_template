import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zjs_flutter_template/core/utils/route_util.dart';

/// RouteUtil 使用示例页面
///
/// 展示如何使用 RouteUtil 进行各种导航操作
class RouteUtilExamplesPage extends ConsumerWidget {
  const RouteUtilExamplesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RouteUtil 使用示例'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showRouteInfo(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildRouteStatusCard(),
          const SizedBox(height: 16),
          _buildBasicNavigationCard(context),
          const SizedBox(height: 16),
          _buildNamedNavigationCard(context),
          const SizedBox(height: 16),
          _buildDialogExamplesCard(context),
          const SizedBox(height: 16),
          _buildBottomSheetCard(context),
          const SizedBox(height: 16),
          _buildSnackBarCard(context),
          const SizedBox(height: 16),
          _buildQuickNavigationCard(context),
          const SizedBox(height: 16),
          _buildAdvancedFeaturesCard(context),
        ],
      ),
    );
  }

  /// 路由状态信息卡片
  Widget _buildRouteStatusCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.route, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  '当前路由状态',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('当前路径', RouteUtil.currentPath),
            _buildInfoRow('路由名称', RouteUtil.currentRouteName),
            _buildInfoRow('需要认证', RouteUtil.currentRouteRequiresAuth ? '是' : '否'),
            _buildInfoRow('可以返回', RouteUtil.canPop() ? '是' : '否'),
            _buildInfoRow('路径参数', RouteUtil.getPathParameters().toString()),
            _buildInfoRow('查询参数', RouteUtil.getQueryParameters().toString()),
          ],
        ),
      ),
    );
  }

  /// 基础导航卡片
  Widget _buildBasicNavigationCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '基础导航',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _testPushNavigation(context),
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Push 导航'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _testReplaceNavigation(context),
                    icon: const Icon(Icons.swap_horiz),
                    label: const Text('Replace 导航'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: RouteUtil.pop,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('返回'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _testPopUntil(context),
                    icon: const Icon(Icons.home),
                    label: const Text('返回首页'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 命名导航卡片
  Widget _buildNamedNavigationCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '命名路由导航',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _testNamedNavigation(context),
                    icon: const Icon(Icons.label),
                    label: const Text('命名导航'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _testParameterNavigation(context),
                    icon: const Icon(Icons.settings),
                    label: const Text('参数导航'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 对话框示例卡片
  Widget _buildDialogExamplesCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '对话框示例',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showCustomDialog(context),
                    icon: const Icon(Icons.chat),
                    label: const Text('自定义对话框'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showAlertDialog(context),
                    icon: const Icon(Icons.warning),
                    label: const Text('警告对话框'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showConfirmDialog(context),
                icon: const Icon(Icons.help),
                label: const Text('确认对话框'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 底部表单卡片
  Widget _buildBottomSheetCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '底部表单',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showSimpleBottomSheet(context),
                    icon: const Icon(Icons.view_agenda),
                    label: const Text('简单表单'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showScrollableBottomSheet(context),
                    icon: const Icon(Icons.view_stream),
                    label: const Text('可滚动表单'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// SnackBar 卡片
  Widget _buildSnackBarCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'SnackBar 消息',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => RouteUtil.showSuccessMessage('操作成功！'),
                    icon: const Icon(Icons.check_circle, color: Colors.green),
                    label: const Text('成功消息'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => RouteUtil.showErrorMessage('操作失败！'),
                    icon: const Icon(Icons.error, color: Colors.red),
                    label: const Text('错误消息'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => RouteUtil.showWarningMessage('注意事项！'),
                    icon: const Icon(Icons.warning, color: Colors.orange),
                    label: const Text('警告消息'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => RouteUtil.showInfoMessage('提示信息！'),
                    icon: const Icon(Icons.info, color: Colors.blue),
                    label: const Text('信息消息'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 快速导航卡片
  Widget _buildQuickNavigationCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '快速导航',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: RouteUtil.goHome,
                  icon: const Icon(Icons.home),
                  label: const Text('首页'),
                ),
                ElevatedButton.icon(
                  onPressed: RouteUtil.goProfile,
                  icon: const Icon(Icons.person),
                  label: const Text('个人资料'),
                ),
                ElevatedButton.icon(
                  onPressed: RouteUtil.goSettings,
                  icon: const Icon(Icons.settings),
                  label: const Text('设置'),
                ),
                ElevatedButton.icon(
                  onPressed: RouteUtil.goThemeSettings,
                  icon: const Icon(Icons.palette),
                  label: const Text('主题设置'),
                ),
                ElevatedButton.icon(
                  onPressed: RouteUtil.goLanguageSettings,
                  icon: const Icon(Icons.language),
                  label: const Text('语言设置'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 高级功能卡片
  Widget _buildAdvancedFeaturesCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '高级功能',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _testSafeNavigation(context),
                    icon: const Icon(Icons.security),
                    label: const Text('安全导航'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _testDelayedNavigation(context),
                    icon: const Icon(Icons.timer),
                    label: const Text('延迟导航'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _testConditionalNavigation(context),
                    icon: const Icon(Icons.rule),
                    label: const Text('条件导航'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: RouteUtil.debugPrintRouteState,
                    icon: const Icon(Icons.bug_report),
                    label: const Text('调试状态'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }

  // ===== 测试方法 =====

  void _testPushNavigation(BuildContext context) {
    RouteUtil.push('/profile').then((result) {
      if (result != null) {
        RouteUtil.showInfoMessage('返回结果: $result');
      }
    });
  }

  void _testReplaceNavigation(BuildContext context) {
    RouteUtil.replace('/settings');
  }

  void _testPopUntil(BuildContext context) {
    RouteUtil.popUntil('/home');
  }

  void _testNamedNavigation(BuildContext context) {
    RouteUtil.pushNamed('profile');
  }

  void _testParameterNavigation(BuildContext context) {
    RouteUtil.pushNamed(
      'settings',
      pathParameters: {'section': 'theme'},
      queryParameters: {'highlight': 'true'},
    );
  }

  void _showCustomDialog(BuildContext context) {
    RouteUtil.showModalDialog<void>(
      builder: (context) => AlertDialog(
        title: const Text('自定义对话框'),
        content: const Text('这是一个使用 RouteUtil.showModalDialog 创建的对话框'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    RouteUtil.showAlertDialog(
      title: '警告',
      content: '这是一个警告对话框示例',
      cancelText: '取消',
      onConfirm: () => RouteUtil.showSuccessMessage('用户点击了确定'),
      onCancel: () => RouteUtil.showInfoMessage('用户点击了取消'),
    );
  }

  Future<void> _showConfirmDialog(BuildContext context) async {
    final confirmed = await RouteUtil.showConfirmDialog(
      title: '确认操作',
      content: '您确定要执行此操作吗？',
    );

    if (confirmed) {
      RouteUtil.showSuccessMessage('用户确认了操作');
    } else {
      RouteUtil.showInfoMessage('用户取消了操作');
    }
  }

  void _showSimpleBottomSheet(BuildContext context) {
    RouteUtil.showBottomSheet<void>(
      builder: (context) => Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '简单底部表单',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('这是一个简单的底部表单示例'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop('result'),
              child: const Text('关闭'),
            ),
          ],
        ),
      ),
    );
  }

  void _showScrollableBottomSheet(BuildContext context) {
    RouteUtil.showBottomSheet<void>(
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: ListView.builder(
            controller: scrollController,
            itemCount: 50,
            itemBuilder: (context, index) => ListTile(
              leading: CircleAvatar(child: Text('${index + 1}')),
              title: Text('列表项 ${index + 1}'),
              subtitle: Text('这是第 ${index + 1} 个列表项'),
            ),
          ),
        ),
      ),
    );
  }

  void _testSafeNavigation(BuildContext context) {
    RouteUtil.safeNavigate(() async {
      // 模拟可能失败的导航操作
      await Future<void>.delayed(const Duration(milliseconds: 500));
      if (DateTime.now().millisecond.isEven) {
        throw Exception('模拟导航失败');
      }
      return RouteUtil.push('/profile');
    }).then((result) {
      if (result != null) {
        RouteUtil.showSuccessMessage('安全导航成功');
      } else {
        RouteUtil.showErrorMessage('安全导航失败，已记录错误');
      }
    });
  }

  void _testDelayedNavigation(BuildContext context) {
    RouteUtil.showInfoMessage('3秒后将导航到设置页面...');
    RouteUtil.delayedNavigate(
      const Duration(seconds: 3),
      () => RouteUtil.go('/settings'),
    );
  }

  void _testConditionalNavigation(BuildContext context) {
    final shouldNavigate = DateTime.now().second.isEven;
    RouteUtil.showInfoMessage(
      shouldNavigate ? '条件满足，将导航到个人资料页' : '条件不满足，将导航到设置页',
    );

    RouteUtil.conditionalNavigate(
      condition: shouldNavigate,
      navigation: () => RouteUtil.go('/profile'),
      elseNavigation: () => RouteUtil.go('/settings'),
    );
  }

  void _showRouteInfo(BuildContext context) {
    final pathParams = RouteUtil.getPathParameters();
    final queryParams = RouteUtil.getQueryParameters();
    final extra = RouteUtil.getExtra();

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('路由信息'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('当前路径: ${RouteUtil.currentPath}'),
              Text('路由名称: ${RouteUtil.currentRouteName}'),
              Text('需要认证: ${RouteUtil.currentRouteRequiresAuth}'),
              Text('可以返回: ${RouteUtil.canPop()}'),
              const SizedBox(height: 8),
              const Text('路径参数:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(pathParams.toString()),
              const SizedBox(height: 8),
              const Text('查询参数:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(queryParams.toString()),
              const SizedBox(height: 8),
              const Text('额外数据:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(extra?.toString() ?? 'null'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }
}

/// RouteUtil 扩展使用示例
class RouteUtilExtensionExampleWidget extends StatelessWidget {
  const RouteUtilExtensionExampleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => context.goTo('/profile'),
          child: const Text('使用扩展导航'),
        ),
        ElevatedButton(
          onPressed: () => context.goBack<void>(),
          child: const Text('使用扩展返回'),
        ),
        ElevatedButton(
          onPressed: () => context.showSuccess('扩展方法成功消息'),
          child: const Text('使用扩展显示成功消息'),
        ),
        ElevatedButton(
          onPressed: () => context.showError('扩展方法错误消息'),
          child: const Text('使用扩展显示错误消息'),
        ),
      ],
    );
  }
}
