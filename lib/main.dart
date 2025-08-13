import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sky_eldercare_family/config/routes/app_router.dart';
import 'package:sky_eldercare_family/config/themes/app_theme.dart';
import 'package:sky_eldercare_family/core/storage/storage_service.dart';
import 'package:sky_eldercare_family/generated/l10n/app_localizations.dart';
import 'package:sky_eldercare_family/shared/services/language_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化Hive本地数据库
  await Hive.initFlutter();

  // 初始化存储服务
  await StorageService.instance.initialize();

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
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

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
  }
}
