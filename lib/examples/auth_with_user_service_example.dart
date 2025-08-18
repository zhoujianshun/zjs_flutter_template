import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zjs_flutter_template/features/providers/auth.dart';
import 'package:zjs_flutter_template/shared/models/auth_models.dart';

/// Auth + UserService 集成使用示例
class AuthWithUserServiceExamplePage extends ConsumerStatefulWidget {
  const AuthWithUserServiceExamplePage({super.key});

  @override
  ConsumerState<AuthWithUserServiceExamplePage> createState() => _AuthWithUserServiceExamplePageState();
}

class _AuthWithUserServiceExamplePageState extends ConsumerState<AuthWithUserServiceExamplePage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    // final currentUserAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth + UserService 示例'),
        actions: [
          if (authState.isAuthenticated)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => ref.read(authProvider.notifier).logout(),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 架构说明卡片
            _ArchitectureInfoCard(),

            const SizedBox(height: 16),

            // 状态显示卡片
            _AuthStateCard(authState: authState),

            const SizedBox(height: 16),

            if (!authState.isAuthenticated) ...[
              // 邮箱登录表单
              _EmailLoginForm(
                emailController: _emailController,
                passwordController: _passwordController,
                onLogin: _handleEmailLogin,
                isLoading: authState.isLoading,
              ),

              const SizedBox(height: 16),

              // 手机号登录表单
              _PhoneLoginForm(
                phoneController: _phoneController,
                codeController: _codeController,
                onLogin: _handlePhoneLogin,
                isLoading: authState.isLoading,
              ),
            ] else ...[
              // 用户信息显示
              // currentUserAsync.when(
              //   data: (user) => user != null ? _UserInfoCard(user: user) : const Text('用户信息加载失败'),
              //   loading: () => const Center(child: CircularProgressIndicator()),
              //   error: (error, stack) => Text('错误: $error'),
              // ),

              const SizedBox(height: 16),

              // 用户操作
              _UserActionsCard(),
            ],

            const SizedBox(height: 16),

            // 错误信息显示
            if (authState.hasError)
              _ErrorCard(
                error: authState.errorMessage!,
                onDismiss: () => ref.read(authProvider.notifier).clearError(),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleEmailLogin() async {
    final request = LoginRequest(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      rememberMe: true,
    );

    await ref.read(authProvider.notifier).login(request);
  }

  Future<void> _handlePhoneLogin() async {
    final request = PhoneLoginRequest(
      phone: _phoneController.text.trim(),
      code: _codeController.text,
      rememberMe: true,
    );

    await ref.read(authProvider.notifier).phoneLogin(request);
  }
}

/// 架构信息卡片
class _ArchitectureInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.architecture, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  '架构说明',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('🏗️ 新架构：AuthRepository → UserService → ApiClient'),
            const SizedBox(height: 4),
            const Text('✅ AuthRepository 使用 UserService 进行 API 调用'),
            const SizedBox(height: 4),
            const Text('✅ UserService 负责具体的网络请求和数据处理'),
            const SizedBox(height: 4),
            const Text('✅ 更好的代码复用和分层架构'),
            const SizedBox(height: 4),
            const Text('✅ 支持邮箱登录和手机号登录'),
          ],
        ),
      ),
    );
  }
}

/// 认证状态显示卡片
class _AuthStateCard extends StatelessWidget {
  const _AuthStateCard({required this.authState});

  final AuthState authState;

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (authState.status) {
      case AuthStatus.initial:
        statusColor = Colors.grey;
        statusText = '初始状态';
        statusIcon = Icons.info_outline;
      case AuthStatus.loading:
        statusColor = Colors.orange;
        statusText = '加载中...';
        statusIcon = Icons.hourglass_empty;
      case AuthStatus.authenticated:
        statusColor = Colors.green;
        statusText = '已认证';
        statusIcon = Icons.check_circle;
      case AuthStatus.unauthenticated:
        statusColor = Colors.red;
        statusText = '未认证';
        statusIcon = Icons.cancel;
      case AuthStatus.error:
        statusColor = Colors.red;
        statusText = '错误状态';
        statusIcon = Icons.error;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(statusIcon, color: statusColor),
                const SizedBox(width: 8),
                Text(
                  '认证状态: $statusText',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ],
            ),
            if (authState.user != null) ...[
              const SizedBox(height: 8),
              Text('用户: ${authState.user!.displayName}'),
              Text('邮箱: ${authState.user!.email}'),
            ],
            if (authState.accessToken != null) ...[
              const SizedBox(height: 8),
              Text('Token: ${authState.accessToken!.substring(0, 20)}...'),
            ],
            if (authState.expiresAt != null) ...[
              const SizedBox(height: 4),
              Text('过期时间: ${authState.expiresAt!.toLocal()}'),
            ],
          ],
        ),
      ),
    );
  }
}

/// 邮箱登录表单
class _EmailLoginForm extends StatelessWidget {
  const _EmailLoginForm({
    required this.emailController,
    required this.passwordController,
    required this.onLogin,
    required this.isLoading,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLogin;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '📧 邮箱登录 (通过 UserService)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: '邮箱',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '密码',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : onLogin,
              child: isLoading ? const CircularProgressIndicator() : const Text('邮箱登录'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 手机号登录表单
class _PhoneLoginForm extends StatelessWidget {
  const _PhoneLoginForm({
    required this.phoneController,
    required this.codeController,
    required this.onLogin,
    required this.isLoading,
  });

  final TextEditingController phoneController;
  final TextEditingController codeController;
  final VoidCallback onLogin;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '📱 手机号登录 (通过 UserService)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: '手机号',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: codeController,
                    decoration: const InputDecoration(
                      labelText: '验证码',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.sms),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    // 模拟发送验证码
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('验证码已发送 (模拟)')),
                    );
                  },
                  child: const Text('获取验证码'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : onLogin,
              child: isLoading ? const CircularProgressIndicator() : const Text('手机号登录'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 用户信息卡片
class _UserInfoCard extends StatelessWidget {
  const _UserInfoCard({required this.user});

  final user;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '👤 用户信息 (来自 UserService)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: CircleAvatar(
                child: Text(user.avatarInitial as String),
              ),
              title: Text(user.displayName as String),
              subtitle: Text(user.email as String),
            ),
            const Divider(),
            Text('ID: ${user.id}'),
            Text('角色: ${user.role.displayName}'),
            if (user.phone != null) Text('手机: ${user.phone}'),
            Text('创建时间: ${user.createdAt.toLocal()}'),
          ],
        ),
      ),
    );
  }
}

/// 用户操作卡片
class _UserActionsCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '⚙️ 用户操作 (通过 UserService)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await ref.read(authProvider.notifier).refreshToken();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Token 刷新请求已发送')),
                );
              },
              child: const Text('刷新 Token'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                const request = ChangePasswordRequest(
                  oldPassword: 'old123',
                  newPassword: 'new456',
                  confirmPassword: 'new456',
                );
                await ref.read(authProvider.notifier).changePassword(request);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('修改密码请求已发送')),
                );
              },
              child: const Text('修改密码'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                // final userService = ref.read(userServiceProvider);
                // final result = await userService.getCurrentUser();
                // result.fold(
                //   (failure) => ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(content: Text('获取用户信息失败: ${failure.message}')),
                //   ),
                //   (user) => ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(content: Text('用户信息已更新: ${user.displayName}')),
                //   ),
                // );
              },
              child: const Text('刷新用户信息'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 错误信息卡片
class _ErrorCard extends StatelessWidget {
  const _ErrorCard({
    required this.error,
    required this.onDismiss,
  });

  final String error;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.error, color: Colors.red),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                error,
                style: const TextStyle(color: Colors.red),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: onDismiss,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
