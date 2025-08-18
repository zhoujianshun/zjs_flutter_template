import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zjs_flutter_template/config/routes/route_paths.dart';
import 'package:zjs_flutter_template/config/themes/app_theme.dart';
import 'package:zjs_flutter_template/core/storage/storage_service.dart';
import 'package:zjs_flutter_template/di/service_locator.dart';
import 'package:zjs_flutter_template/examples/dark_mode_examples.dart';
import 'package:zjs_flutter_template/examples/dartz_examples_page.dart';
import 'package:zjs_flutter_template/examples/responsive_examples.dart';
import 'package:zjs_flutter_template/examples/riverpod_examples.dart';
import 'package:zjs_flutter_template/examples/theme_usage_examples.dart';
import 'package:zjs_flutter_template/generated/l10n/app_localizations.dart';
import 'package:zjs_flutter_template/shared/widgets/language_switcher.dart';
import 'package:zjs_flutter_template/shared/widgets/theme_switcher.dart';

/// 个人中心页面
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  /// 加载用户信息
  Future<void> _loadUserInfo() async {
    final storageService = ServiceLocator.get<StorageService>();
    final email = storageService.getUserData<String>('user_email');
    if (email != null) {
      setState(() {
        _userEmail = email;
      });
    }
  }

  /// 退出登录
  Future<void> _handleLogout() async {
    final confirmed = await _showLogoutDialog();
    if (confirmed ?? false) {
      final storageService = ServiceLocator.get<StorageService>();
      await storageService.removeUserToken();
      await storageService.clearUserData();

      if (!mounted) return;
      // context.go(AppConstants.loginRoute);
      context.go(RoutePaths.login);
    }
  }

  /// 显示退出登录确认对话框
  Future<bool?> _showLogoutDialog() async {
    final l10n = AppLocalizations.of(context);

    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.auth_logout),
        content: const Text('确定要退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.common_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.common_confirm),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile_title),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: const [
          LanguageSwitcherButton(),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            // 用户信息卡片
            Card(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: theme.colorScheme.primary,
                      child: Text(
                        _userEmail.isNotEmpty ? _userEmail[0].toUpperCase() : 'U',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _userEmail.isNotEmpty ? _userEmail : '用户',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: AppSpacing.xs),
                          Text(
                            '普通用户',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('编辑个人信息功能待开发')),
                        );
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: AppSpacing.xl),

            // 功能菜单
            _buildMenuSection(
              title: l10n.profile_personal_info,
              items: [
                _MenuItem(
                  icon: Icons.person_outline,
                  title: '个人资料',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('个人资料功能待开发')),
                    );
                  },
                ),
                _MenuItem(
                  icon: Icons.security,
                  title: l10n.profile_account_security,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('账户安全功能待开发')),
                    );
                  },
                ),
              ],
            ),

            SizedBox(height: AppSpacing.md),

            _buildMenuSection(
              title: l10n.profile_app_settings,
              items: [
                _MenuItem(
                  icon: Icons.notifications_outlined,
                  title: l10n.settings_notification,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('通知设置功能待开发')),
                    );
                  },
                ),
                _MenuItem(
                  icon: Icons.language,
                  title: l10n.profile_language,
                  onTap: () {
                    context.push(RoutePaths.languageSettings);
                  },
                ),
                _MenuItem(
                  icon: Icons.language,
                  title: l10n.profile_theme,
                  onTap: () {
                    context.push(RoutePaths.themeSettings);
                  },
                ),
              ],
              customWidgets: [
                // 语言切换组件
                const LanguageSwitcher(),
                SizedBox(height: AppSpacing.md),
                // 主题切换组件
                const ThemeSwitcher(),
              ],
            ),

            SizedBox(height: AppSpacing.md),

            // 示例展示区域
            _buildMenuSection(
              title: '🎨 功能示例展示',
              items: [
                _MenuItem(
                  icon: Icons.palette_outlined,
                  title: '主题系统示例',
                  subtitle: '颜色、字体、间距系统展示',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => const ThemeUsageExamples(),
                      ),
                    );
                  },
                ),
                _MenuItem(
                  icon: Icons.dark_mode_outlined,
                  title: '暗黑模式适配',
                  subtitle: '深色主题和自适应颜色展示',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => const DarkModeExamples(),
                      ),
                    );
                  },
                ),
                _MenuItem(
                  icon: Icons.phone_android_outlined,
                  title: '响应式设计',
                  subtitle: 'ScreenUtil 响应式布局展示',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => const ResponsiveExamples(),
                      ),
                    );
                  },
                ),
                _MenuItem(
                  icon: Icons.compare_arrows_outlined,
                  title: '响应式对比',
                  subtitle: '开启/关闭响应式设计对比',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => const ResponsiveComparisonPage(),
                      ),
                    );
                  },
                ),
                _MenuItem(
                  icon: Icons.swap_horiz_outlined,
                  title: '暗黑模式对比',
                  subtitle: '浅色/深色主题切换对比',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => const DarkModeComparisonPage(),
                      ),
                    );
                  },
                ),
              ],
            ),

            SizedBox(height: AppSpacing.md),

            // 开发示例区域
            _buildMenuSection(
              title: '⚡ 开发技术示例',
              items: [
                _MenuItem(
                  icon: Icons.code_outlined,
                  title: 'Riverpod 状态管理',
                  subtitle: '状态管理、依赖注入示例',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => const RiverpodExamplesPage(),
                      ),
                    );
                  },
                ),
                _MenuItem(
                  icon: Icons.functions_outlined,
                  title: 'Dartz 函数式编程',
                  subtitle: 'Either、Option 等函数式编程示例',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => const DartzExamplesPage(),
                      ),
                    );
                  },
                ),
              ],
            ),

            SizedBox(height: AppSpacing.md),

            _buildMenuSection(
              title: '其他',
              items: [
                _MenuItem(
                  icon: Icons.help_outline,
                  title: '帮助与反馈',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('帮助与反馈功能待开发')),
                    );
                  },
                ),
                _MenuItem(
                  icon: Icons.info_outline,
                  title: '关于我们',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('关于我们功能待开发')),
                    );
                  },
                ),
              ],
            ),

            SizedBox(height: AppSpacing.xxxl),

            // 退出登录按钮
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _handleLogout,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                ),
                child: Text(l10n.auth_logout),
              ),
            ),

            SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }

  /// 构建菜单分组
  Widget _buildMenuSection({
    required String title,
    required List<_MenuItem> items,
    List<Widget> customWidgets = const [],
  }) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            ...customWidgets,
            if (customWidgets.isNotEmpty && items.isNotEmpty) const SizedBox(height: 8),
            ...items.map(_buildMenuItem),
          ],
        ),
      ),
    );
  }

  /// 构建菜单项
  Widget _buildMenuItem(_MenuItem item) {
    return ListTile(
      leading: Icon(item.icon),
      title: Text(item.title),
      subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: item.onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}

/// 菜单项数据模型
class _MenuItem {
  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
  });
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
}
