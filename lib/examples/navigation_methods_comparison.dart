import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zjs_flutter_template/core/utils/route_util.dart';

/// 导航方法对比演示页面
class NavigationMethodsComparison extends ConsumerWidget {
  const NavigationMethodsComparison({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('导航方法对比'),
        leading: const IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: RouteUtil.pop,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMethodComparisonCard(),
          const SizedBox(height: 16),
          _buildPushVsGoCard(context),
          const SizedBox(height: 16),
          _buildReplaceMethodsCard(context),
          const SizedBox(height: 16),
          _buildNamedRoutesCard(context),
          const SizedBox(height: 16),
          _buildStackManagementCard(context),
          const SizedBox(height: 16),
          _buildPracticalExamplesCard(context),
        ],
      ),
    );
  }

  Widget _buildMethodComparisonCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '方法对比表',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Table(
              border: TableBorder.all(color: Colors.grey.shade300),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(3),
              },
              children: const [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('方法', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('栈操作', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('可返回', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('使用场景', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(padding: EdgeInsets.all(8), child: Text('push')),
                    Padding(padding: EdgeInsets.all(8), child: Text('添加到栈顶')),
                    Padding(padding: EdgeInsets.all(8), child: Text('✅')),
                    Padding(padding: EdgeInsets.all(8), child: Text('详情页、编辑页')),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(padding: EdgeInsets.all(8), child: Text('go')),
                    Padding(padding: EdgeInsets.all(8), child: Text('灵活配置')),
                    Padding(padding: EdgeInsets.all(8), child: Text('可配置')),
                    Padding(padding: EdgeInsets.all(8), child: Text('通用导航')),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(padding: EdgeInsets.all(8), child: Text('replace')),
                    Padding(padding: EdgeInsets.all(8), child: Text('替换栈顶')),
                    Padding(padding: EdgeInsets.all(8), child: Text('❌')),
                    Padding(padding: EdgeInsets.all(8), child: Text('重定向、替换')),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPushVsGoCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'push vs go 对比',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'push: 总是添加新页面到栈顶，可以返回，可以等待结果',
              style: TextStyle(color: Colors.blue),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _demonstratePush(context),
                    icon: const Icon(Icons.add),
                    label: const Text('push 演示'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _demonstratePushWithResult(context),
                    icon: const Icon(Icons.input),
                    label: const Text('push (等待结果)'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'go: 灵活的导航方式，可配置是否替换当前页面',
              style: TextStyle(color: Colors.green),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _demonstrateGo(context),
                    icon: const Icon(Icons.navigation),
                    label: const Text('go (添加)'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _demonstrateGoReplace(context),
                    icon: const Icon(Icons.swap_horiz),
                    label: const Text('go (替换)'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReplaceMethodsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '替换方法演示',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              '替换方法会移除当前页面，用户无法返回到被替换的页面',
              style: TextStyle(color: Colors.orange),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _demonstrateReplace(context),
                    icon: const Icon(Icons.swap_horiz),
                    label: const Text('replace 演示'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _demonstrateReplaceNamed(context),
                    icon: const Icon(Icons.label),
                    label: const Text('replaceNamed'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNamedRoutesCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '命名路由演示',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              '使用预定义的路由名称，支持参数传递',
              style: TextStyle(color: Colors.purple),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _demonstratePushNamed(context),
                    icon: const Icon(Icons.label),
                    label: const Text('pushNamed'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _demonstrateNamedWithParams(context),
                    icon: const Icon(Icons.settings),
                    label: const Text('带参数'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStackManagementCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '导航栈管理',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              '管理导航栈的高级操作',
              style: TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _demonstratePopUntil(context),
                    icon: const Icon(Icons.home),
                    label: const Text('popUntil'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _demonstratePushAndRemoveUntil(context),
                    icon: const Icon(Icons.clear_all),
                    label: const Text('清空栈'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPracticalExamplesCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '实际应用场景',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildScenarioExample(
              '查看用户详情',
              'push',
              '需要返回到列表页',
              Icons.person,
              () => RouteUtil.showInfoMessage('使用 push 导航到用户详情页'),
            ),
            _buildScenarioExample(
              '登录成功跳转',
              'replace',
              '不希望用户返回登录页',
              Icons.login,
              () => RouteUtil.showInfoMessage('使用 replace 跳转到主页'),
            ),
            _buildScenarioExample(
              '主要页面导航',
              'go',
              '在主要页面间切换',
              Icons.home,
              () => RouteUtil.showInfoMessage('使用 go 在主要页面间导航'),
            ),
            _buildScenarioExample(
              '退出登录',
              'pushAndRemoveUntil',
              '清空所有页面，回到登录页',
              Icons.logout,
              () => RouteUtil.showInfoMessage('使用 pushAndRemoveUntil 回到登录页'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScenarioExample(
    String title,
    String method,
    String description,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('$method: $description', style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onPressed,
            child: Text(method),
          ),
        ],
      ),
    );
  }

  // 演示方法
  void _demonstratePush(BuildContext context) {
    RouteUtil.push('/profile').then((result) {
      RouteUtil.showInfoMessage('push: 已导航到个人资料页，可以返回');
    });
  }

  void _demonstratePushWithResult(BuildContext context) {
    RouteUtil.push<String>('/profile').then((result) {
      if (result != null) {
        RouteUtil.showSuccessMessage('收到返回结果: $result');
      } else {
        RouteUtil.showInfoMessage('push: 用户直接返回，没有结果');
      }
    });
  }

  void _demonstrateGo(BuildContext context) {
    RouteUtil.go('/settings');
    RouteUtil.showInfoMessage('go: 已导航到设置页 (添加到栈)');
  }

  void _demonstrateGoReplace(BuildContext context) {
    RouteUtil.go('/settings', replace: true);
    RouteUtil.showInfoMessage('go (replace=true): 已替换为设置页');
  }

  void _demonstrateReplace(BuildContext context) {
    RouteUtil.replace('/home');
    RouteUtil.showInfoMessage('replace: 已替换为首页，无法返回');
  }

  void _demonstrateReplaceNamed(BuildContext context) {
    RouteUtil.replaceNamed('home');
    RouteUtil.showInfoMessage('replaceNamed: 已替换为首页');
  }

  void _demonstratePushNamed(BuildContext context) {
    RouteUtil.pushNamed('profile');
    RouteUtil.showInfoMessage('pushNamed: 使用路由名称导航');
  }

  void _demonstrateNamedWithParams(BuildContext context) {
    RouteUtil.pushNamed(
      'settings',
      pathParameters: {'section': 'theme'},
      queryParameters: {'highlight': 'true'},
    );
    RouteUtil.showInfoMessage('pushNamed: 带参数导航到设置页');
  }

  void _demonstratePopUntil(BuildContext context) {
    RouteUtil.popUntil('/home');
    RouteUtil.showInfoMessage('popUntil: 返回到首页');
  }

  void _demonstratePushAndRemoveUntil(BuildContext context) {
    RouteUtil.showConfirmDialog(
      title: '确认操作',
      content: '这将清空所有页面并跳转到登录页，确认吗？',
    ).then((confirmed) {
      if (confirmed) {
        RouteUtil.pushAndRemoveUntil('/login');
        RouteUtil.showInfoMessage('pushAndRemoveUntil: 已清空栈并跳转');
      }
    });
  }
}
