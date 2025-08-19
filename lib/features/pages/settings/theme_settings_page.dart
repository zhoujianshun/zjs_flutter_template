import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zjs_flutter_template/config/themes/app_theme.dart';
import 'package:zjs_flutter_template/core/utils/route_util.dart';
import 'package:zjs_flutter_template/shared/widgets/theme_switcher.dart';

/// 主题设置页面
class ThemeSettingsPage extends ConsumerWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final themeModeNotifier = ref.read(themeModeProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('主题设置'),
        leading: const IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: RouteUtil.pop,
          tooltip: '返回',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => RouteUtil.showInfoMessage('这是使用RouteUtil显示的消息'),
            tooltip: '信息',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 当前主题显示
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      themeModeNotifier.getThemeModeIcon(),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '当前主题',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          themeModeNotifier.getThemeModeDisplayName(),
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 主题选择区域
            Text(
              '选择主题',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),

            const SizedBox(height: 16),

            // 主题切换组件
            const ThemeSwitcher(
              style: ThemeSwitcherStyle.segmentedButton,
            ),

            const SizedBox(height: 24),

            // 主题预览区域
            Text(
              '主题预览',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),

            const SizedBox(height: 16),

            // 预览卡片
            _buildThemePreview(context, themeMode),

            const SizedBox(height: 32),

            // 说明文本
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '主题设置说明',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '• 浅色主题：适合白天使用，护眼舒适\n'
                      '• 深色主题：适合夜间使用，节省电量\n'
                      '• 跟随系统：自动跟随系统主题设置\n'
                      '• 主题设置会自动保存并立即生效',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            height: 1.5,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建主题预览
  Widget _buildThemePreview(BuildContext context, ThemeMode themeMode) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '应用预览',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Icon(
                  Icons.visibility,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 模拟应用栏
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.menu,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Sky Eldercare Family',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 模拟内容区域
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '内容区域',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '这里是应用的主要内容区域，会根据选择的主题自动调整颜色。',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => _showRouteUtilDemo(context),
                    child: const Text('RouteUtil演示'),
                  ),
                ],
              ),
            ),

            // RouteUtil 演示区域
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RouteUtil 导航演示',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton.icon(
                          onPressed: RouteUtil.goHome,
                          icon: const Icon(Icons.home, size: 16),
                          label: const Text('首页'),
                        ),
                        ElevatedButton.icon(
                          onPressed: RouteUtil.goProfile,
                          icon: const Icon(Icons.person, size: 16),
                          label: const Text('个人资料'),
                        ),
                        ElevatedButton.icon(
                          onPressed: RouteUtil.goLanguageSettings,
                          icon: const Icon(Icons.language, size: 16),
                          label: const Text('语言设置'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => context.showSuccess('使用扩展方法显示成功消息！'),
                          icon: const Icon(Icons.check_circle, size: 16),
                          label: const Text('成功消息'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 显示RouteUtil功能演示对话框
  void _showRouteUtilDemo(BuildContext context) {
    RouteUtil.showModalDialog<void>(
      builder: (context) => AlertDialog(
        title: const Text('RouteUtil 功能演示'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('当前路由信息:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('路径: ${RouteUtil.currentPath}'),
              Text('名称: ${RouteUtil.currentRouteName}'),
              Text('需要认证: ${RouteUtil.currentRouteRequiresAuth}'),
              Text('可以返回: ${RouteUtil.canPop()}'),
              const SizedBox(height: 16),
              const Text('功能演示:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      RouteUtil.showSuccessMessage('演示：成功消息');
                    },
                    child: const Text('成功消息'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      RouteUtil.showErrorMessage('演示：错误消息');
                    },
                    child: const Text('错误消息'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      RouteUtil.showWarningMessage('演示：警告消息');
                    },
                    child: const Text('警告消息'),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // 导航到RouteUtil示例页面
              RouteUtil.push('/examples/route_util');
            },
            child: const Text('查看完整示例'),
          ),
        ],
      ),
    );
  }
}
