import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zjs_flutter_template/config/themes/app_theme.dart';

void main() {
  group('ThemeModeNotifier', () {
    late ThemeModeNotifier notifier;

    setUp(() {
      notifier = ThemeModeNotifier();
    });

    test('should initialize with system theme mode', () {
      expect(notifier.state, ThemeMode.system);
    });

    test('should toggle theme mode correctly', () async {
      // 初始状态: system
      expect(notifier.state, ThemeMode.system);

      // 切换到 light
      await notifier.toggleThemeMode();
      expect(notifier.state, ThemeMode.light);

      // 切换到 dark
      await notifier.toggleThemeMode();
      expect(notifier.state, ThemeMode.dark);

      // 切换回 system
      await notifier.toggleThemeMode();
      expect(notifier.state, ThemeMode.system);
    });

    test('should set specific theme mode', () async {
      await notifier.setThemeMode(ThemeMode.dark);
      expect(notifier.state, ThemeMode.dark);

      await notifier.setThemeMode(ThemeMode.light);
      expect(notifier.state, ThemeMode.light);
    });

    test('should return correct display names', () {
      notifier.state = ThemeMode.light;
      expect(notifier.getThemeModeDisplayName(), '浅色主题');

      notifier.state = ThemeMode.dark;
      expect(notifier.getThemeModeDisplayName(), '深色主题');

      notifier.state = ThemeMode.system;
      expect(notifier.getThemeModeDisplayName(), '跟随系统');
    });

    test('should return correct icons', () {
      notifier.state = ThemeMode.light;
      expect(notifier.getThemeModeIcon(), Icons.light_mode);

      notifier.state = ThemeMode.dark;
      expect(notifier.getThemeModeIcon(), Icons.dark_mode);

      notifier.state = ThemeMode.system;
      expect(notifier.getThemeModeIcon(), Icons.brightness_auto);
    });
  });

  group('AppTheme', () {
    test('should provide light theme', () {
      final lightTheme = AppTheme.lightTheme;
      expect(lightTheme.brightness, Brightness.light);
      expect(lightTheme.useMaterial3, true);
    });

    test('should provide dark theme', () {
      final darkTheme = AppTheme.darkTheme;
      expect(darkTheme.brightness, Brightness.dark);
      expect(darkTheme.useMaterial3, true);
    });

    test('light and dark themes should have different colors', () {
      final lightTheme = AppTheme.lightTheme;
      final darkTheme = AppTheme.darkTheme;

      expect(lightTheme.colorScheme.brightness, Brightness.light);
      expect(darkTheme.colorScheme.brightness, Brightness.dark);
    });
  });
}
