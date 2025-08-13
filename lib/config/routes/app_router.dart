import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sky_eldercare_family/core/constants/app_constants.dart';
import 'package:sky_eldercare_family/core/storage/storage_service.dart';
import 'package:sky_eldercare_family/features/auth/presentation/pages/login_page.dart';
import 'package:sky_eldercare_family/features/home/presentation/pages/home_page.dart';
import 'package:sky_eldercare_family/features/profile/presentation/pages/profile_page.dart';
import 'package:sky_eldercare_family/shared/widgets/splash_screen.dart';
import 'package:sky_eldercare_family/shared/widgets/theme_switcher.dart';

/// 路由配置类
class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  /// 创建路由配置
  static GoRouter createRouter() {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: AppConstants.splashRoute,
      redirect: _redirect,
      routes: _routes,
      errorBuilder: (context, state) => _ErrorPage(error: state.error),
    );
  }

  /// 路由重定向逻辑
  static Future<String?> _redirect(BuildContext context, GoRouterState state) async {
    // 获取当前路径
    final location = state.uri.toString();

    // 检查用户登录状态
    final isLoggedIn = await StorageService.isLoggedIn();

    // 如果在启动页，不需要重定向
    if (location == AppConstants.splashRoute) {
      return null;
    }

    // 如果未登录且不在登录页，重定向到登录页
    if (!isLoggedIn && location != AppConstants.loginRoute) {
      return AppConstants.loginRoute;
    }

    // 如果已登录且在登录页，重定向到首页
    if (isLoggedIn && location == AppConstants.loginRoute) {
      return AppConstants.homeRoute;
    }

    return null;
  }

  /// 路由列表
  static List<RouteBase> get _routes => [
        // 启动页
        GoRoute(
          path: AppConstants.splashRoute,
          name: 'splash',
          builder: (context, state) => const SplashScreen(),
        ),

        // 登录页
        GoRoute(
          path: AppConstants.loginRoute,
          name: 'login',
          builder: (context, state) => const LoginPage(),
        ),

        // 首页（底部导航）
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return HomePage(navigationShell: navigationShell);
          },
          branches: [
            // 首页标签
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppConstants.homeRoute,
                  name: 'home',
                  builder: (context, state) => const HomeTabPage(),
                ),
              ],
            ),

            // 个人中心标签
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppConstants.profileRoute,
                  name: 'profile',
                  builder: (context, state) => const ProfilePage(),
                ),
              ],
            ),
          ],
        ),
      ];
}

/// 错误页面
class _ErrorPage extends StatelessWidget {
  const _ErrorPage({this.error});
  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('页面错误'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              '页面加载失败',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              error?.toString() ?? '未知错误',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppConstants.homeRoute),
              child: const Text('返回首页'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 首页内容页面
class HomeTabPage extends StatelessWidget {
  const HomeTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('首页'),
        actions: const [
          // 应用栏主题切换按钮
          AppBarThemeButton(),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, size: 64),
            SizedBox(height: 16),
            Text(
              '首页内容',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 32),
            Text(
              '点击右上角图标可以快速切换主题',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
      // 主题切换浮动按钮（可选）
      floatingActionButton: const ThemeToggleFab(),
    );
  }
}

/// 路由提供者
final appRouterProvider = Provider<GoRouter>((ref) {
  return AppRouter.createRouter();
});
