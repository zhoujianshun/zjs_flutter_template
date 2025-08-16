import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sky_eldercare_family/config/routes/route_paths.dart';
import 'package:sky_eldercare_family/core/storage/storage_service.dart';
import 'package:sky_eldercare_family/examples/riverpod_examples.dart';
import 'package:sky_eldercare_family/generated/l10n/app_localizations.dart';
import 'package:sky_eldercare_family/shared/widgets/language_switcher.dart';
import 'package:sky_eldercare_family/shared/widgets/theme_switcher.dart';

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
    final email = StorageService.instance.getUserData<String>('user_email');
    if (email != null) {
      setState(() {
        _userEmail = email;
      });
    }
  }

  /// 退出登录
  Future<void> _handleLogout() async {
    final confirmed = await _showLogoutDialog();
    if (confirmed == true) {
      await StorageService.instance.removeUserToken();
      await StorageService.instance.clearUserData();

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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 用户信息卡片
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
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
                    const SizedBox(width: 16),
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
                          const SizedBox(height: 4),
                          Text(
                            '普通用户',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
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

            const SizedBox(height: 24),

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

            const SizedBox(height: 16),

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
                const SizedBox(height: 16),
                // 主题切换组件
                const ThemeSwitcher(),
              ],
            ),

            const SizedBox(height: 16),

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
                _MenuItem(
                  icon: Icons.code,
                  title: 'Riverpod示例',
                  subtitle: '学习状态管理',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => const RiverpodExamplesPage(),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),

            // 退出登录按钮
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _handleLogout,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(l10n.auth_logout),
              ),
            ),

            const SizedBox(height: 32),
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
        padding: const EdgeInsets.all(16),
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
            const SizedBox(height: 16),
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
