import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zjs_flutter_template/config/language/app_language.dart';
import 'package:zjs_flutter_template/config/routes/app_router.dart';
import 'package:zjs_flutter_template/config/themes/app_theme.dart';
import 'package:zjs_flutter_template/di/service_locator.dart';
import 'package:zjs_flutter_template/generated/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化GetIt依赖注入容器
  await ServiceLocator.initialize();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    // final router = AppRouter.createRouter();

    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return ScreenUtilInit(
      // 设计稿的设备尺寸（iPhone 14 Pro）
      designSize: const Size(393, 852),
      // 最小文字适配
      minTextAdapt: true,
      // 支持分屏
      splitScreenMode: true,
      // 适配方向
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Sky Eldercare Family',

          // 路由配置
          routerConfig: router,

          // 主题配置
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,

          // 国际化配置
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: locale,

          // 调试配置
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
