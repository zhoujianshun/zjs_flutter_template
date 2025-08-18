import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zjs_flutter_template/config/routes/route_guards.dart';
import 'package:zjs_flutter_template/config/routes/route_paths.dart';
import 'package:zjs_flutter_template/core/utils/logger.dart';
import 'package:zjs_flutter_template/features/pages/app_shell.dart';
import 'package:zjs_flutter_template/features/pages/auth/login_page.dart';
import 'package:zjs_flutter_template/features/pages/home/home_page.dart';
import 'package:zjs_flutter_template/features/pages/onboarding/onboarding_page.dart';
import 'package:zjs_flutter_template/features/pages/pages/profile_page.dart';
import 'package:zjs_flutter_template/features/pages/settings/language_settings_page.dart';
import 'package:zjs_flutter_template/features/pages/settings/theme_settings_page.dart';
import 'package:zjs_flutter_template/shared/widgets/splash_screen.dart';

/// Application router configuration using GoRouter
class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

  static GlobalKey<NavigatorState> get rootNavigatorKey => _rootNavigatorKey;
  static GlobalKey<NavigatorState> get shellNavigatorKey => _shellNavigatorKey;

  /// Create GoRouter instance
  static GoRouter createRouter() {
    AppLogger.info('Creating app router');

    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: RoutePaths.splash,
      debugLogDiagnostics: true,
      redirect: RouteGuards.authRedirect,
      errorBuilder: _buildErrorPage,
      routes: _routes,
    );
  }

  /// 路由列表
  static List<RouteBase> get _routes => [
        // 启动页
        GoRoute(
          path: RoutePaths.splash,
          name: 'splash',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context,
            state,
            const SplashScreen(),
            transitionType: RouteTransitionType.fade,
          ),
        ),

        // Onboarding Route
        GoRoute(
          path: RoutePaths.onboarding,
          name: 'onboarding',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context,
            state,
            const OnboardingPage(),
          ),
        ),

        // 登录页
        GoRoute(
          path: RoutePaths.login,
          name: 'login',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context,
            state,
            const LoginPage(),
          ),
        ),
        GoRoute(
          // 设置parentNavigatorKey，push跳转时首页的tabbar才会隐藏
          parentNavigatorKey: _rootNavigatorKey,
          path: RoutePaths.languageSettings,
          name: 'languageSettings',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context,
            state,
            transitionType: RouteTransitionType.bottomSheet,
            const LanguageSettingsPage(),
          ),
        ),

        // 首页（底部导航）
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return AppShell(navigationShell: navigationShell);
          },
          branches: [
            // 首页标签
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RoutePaths.home,
                  name: 'home',
                  builder: (context, state) => const HomePage(),
                ),
              ],
            ),

            // 个人中心标签
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RoutePaths.profile,
                  name: 'profile',
                  builder: (context, state) => const ProfilePage(),
                  routes: [
                    // 子路由
                    GoRoute(
                      parentNavigatorKey: _rootNavigatorKey,
                      path: RoutePaths.getSubPath(RoutePaths.themeSettings, RoutePaths.profile),
                      name: 'themeSettings',
                      builder: (context, state) => const ThemeSettingsPage(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ];

  /// Build error page
  static Widget _buildErrorPage(BuildContext context, GoRouterState state) {
    AppLogger.error('Router error: ${state.error}');

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
              '页面未找到',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              '请求的页面不存在或已被移动',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(RoutePaths.home),
              child: const Text('返回首页'),
            ),
          ],
        ),
      ),
    );
  }

  /// Custom page transition builder
  static Page<T> _buildPageWithTransition<T extends Object?>(
    BuildContext context,
    GoRouterState state,
    Widget child, {
    RouteTransitionType transitionType = RouteTransitionType.slide,
  }) {
    switch (transitionType) {
      // 淡入淡出
      case RouteTransitionType.fade:
        return CustomTransitionPage<T>(
          key: state.pageKey,
          child: child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );

      // 缩放
      case RouteTransitionType.scale:
        return CustomTransitionPage<T>(
          key: state.pageKey,
          child: child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return ScaleTransition(scale: animation, child: child);
          },
        );

      // 底部弹出
      case RouteTransitionType.bottomSheet:
        return CustomTransitionPage<T>(
          key: state.pageKey,
          child: child,
          transitionsBuilder: (context, animation, secondaryAnimation, childP) {
            const begin = Offset(0, 1);
            const end = Offset.zero;
            const curve = Curves.ease;
            final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: childP,
            );
          },
        );
      // 滑动
      case RouteTransitionType.slide:
        return CustomTransitionPage<T>(
          key: state.pageKey,
          child: child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1, 0);
            const end = Offset.zero;
            const curve = Curves.ease;

            final tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
    }
  }
}

/// Route transition types
enum RouteTransitionType {
  /// 滑动
  slide,

  /// 淡入淡出
  fade,

  /// 缩放
  scale,

  /// 底部弹出
  bottomSheet,
}

/// 路由提供者
final appRouterProvider = Provider<GoRouter>((ref) {
  return AppRouter.createRouter();
});
