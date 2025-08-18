import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sky_eldercare_family/features/providers/auth.dart';
import 'package:sky_eldercare_family/shared/models/auth_models.dart';

/// Auth 功能使用示例
class AuthExamplesPage extends ConsumerStatefulWidget {
  const AuthExamplesPage({super.key});

  @override
  ConsumerState<AuthExamplesPage> createState() => _AuthExamplesPageState();
}

class _AuthExamplesPageState extends ConsumerState<AuthExamplesPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth 功能示例'),
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
            // 状态显示卡片
            _AuthStateCard(authState: authState),

            const SizedBox(height: 16),

            if (!authState.isAuthenticated) ...[
              // 登录表单
              _LoginForm(
                emailController: _emailController,
                passwordController: _passwordController,
                onLogin: _handleLogin,
                isLoading: authState.isLoading,
              ),

              const SizedBox(height: 16),

              // 注册表单
              _RegisterForm(
                emailController: _emailController,
                passwordController: _passwordController,
                nameController: _nameController,
                onRegister: _handleRegister,
                isLoading: authState.isLoading,
              ),
            ] else ...[
              // 用户信息和操作
              _UserInfoCard(user: authState.user),

              const SizedBox(height: 16),

              // 其他操作
              _AuthActionsCard(),
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

  Future<void> _handleLogin() async {
    final request = LoginRequest(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      rememberMe: true,
    );

    await ref.read(authProvider.notifier).login(request);
  }

  Future<void> _handleRegister() async {
    final request = RegisterRequest(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      confirmPassword: _passwordController.text,
      name: _nameController.text.trim(),
    );

    await ref.read(authProvider.notifier).register(request);
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

/// 登录表单
class _LoginForm extends StatelessWidget {
  const _LoginForm({
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
              '登录',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: '邮箱',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '密码',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : onLogin,
              child: isLoading ? const CircularProgressIndicator() : const Text('登录'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 注册表单
class _RegisterForm extends StatelessWidget {
  const _RegisterForm({
    required this.emailController,
    required this.passwordController,
    required this.nameController,
    required this.onRegister,
    required this.isLoading,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController nameController;
  final VoidCallback onRegister;
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
              '注册',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: '姓名',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: '邮箱',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '密码',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : onRegister,
              child: isLoading ? const CircularProgressIndicator() : const Text('注册'),
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
              '用户信息',
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

/// 认证操作卡片
class _AuthActionsCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '操作',
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
                final request = ResetPasswordRequest(
                  email: ref.read(authProvider).user!.email,
                );
                await ref.read(authProvider.notifier).resetPassword(request);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('重置密码邮件已发送')),
                );
              },
              child: const Text('重置密码'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                final request = VerificationCodeRequest(
                  email: ref.read(authProvider).user!.email,
                  type: VerificationCodeType.login,
                );
                await ref.read(authProvider.notifier).sendVerificationCode(request);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('验证码已发送')),
                );
              },
              child: const Text('发送验证码'),
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
