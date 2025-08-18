import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:zjs_flutter_template/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('should show splash screen and navigate to login', (WidgetTester tester) async {
      // 启动应用
      app.main();
      await tester.pumpAndSettle();

      // 验证启动页面显示
      expect(find.text('Sky Eldercare Family'), findsOneWidget);

      // 等待启动页面结束并跳转到登录页
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // 验证跳转到登录页面
      expect(find.text('欢迎回来'), findsOneWidget);
      expect(find.text('登录'), findsWidgets);
    });

    testWidgets('should perform login flow', (WidgetTester tester) async {
      // 启动应用并等待加载完成
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // 输入邮箱
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'test@example.com');
      await tester.pump();

      // 输入密码
      final passwordField = find.byType(TextFormField).at(1);
      await tester.enterText(passwordField, 'password123');
      await tester.pump();

      // 点击登录按钮
      final loginButton = find.text('登录').first;
      await tester.tap(loginButton);

      // 等待登录加载和跳转
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 验证跳转到首页
      expect(find.text('首页'), findsOneWidget);
      expect(find.text('个人中心'), findsOneWidget);
    });

    testWidgets('should navigate between tabs', (WidgetTester tester) async {
      // 完成登录流程
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // 登录
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.tap(find.text('登录').first);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 验证在首页
      expect(find.text('首页内容'), findsOneWidget);

      // 点击个人中心标签
      await tester.tap(find.text('个人中心'));
      await tester.pumpAndSettle();

      // 验证切换到个人中心页面
      expect(find.text('个人信息'), findsOneWidget);
      expect(find.text('应用设置'), findsOneWidget);

      // 点击首页标签
      await tester.tap(find.text('首页'));
      await tester.pumpAndSettle();

      // 验证切换回首页
      expect(find.text('首页内容'), findsOneWidget);
    });

    testWidgets('should perform logout flow', (WidgetTester tester) async {
      // 完成登录流程
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.tap(find.text('登录').first);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 切换到个人中心
      await tester.tap(find.text('个人中心'));
      await tester.pumpAndSettle();

      // 点击退出登录按钮
      await tester.tap(find.text('退出登录'));
      await tester.pumpAndSettle();

      // 确认退出登录
      await tester.tap(find.text('确认'));
      await tester.pumpAndSettle();

      // 验证返回到登录页面
      expect(find.text('欢迎回来'), findsOneWidget);
      expect(find.text('登录'), findsWidgets);
    });

    testWidgets('should validate login form', (WidgetTester tester) async {
      // 启动应用并等待加载完成
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // 不输入任何内容直接点击登录
      final loginButton = find.text('登录').first;
      await tester.tap(loginButton);
      await tester.pump();

      // 验证显示表单验证错误
      expect(find.text('请输入邮箱地址'), findsOneWidget);
      expect(find.text('请输入密码'), findsOneWidget);

      // 输入无效邮箱
      await tester.enterText(find.byType(TextFormField).first, 'invalid-email');
      await tester.tap(loginButton);
      await tester.pump();

      // 验证邮箱格式错误提示
      expect(find.text('请输入有效的邮箱地址'), findsOneWidget);

      // 输入短密码
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(1), '123');
      await tester.tap(loginButton);
      await tester.pump();

      // 验证密码长度错误提示
      expect(find.text('密码长度至少6位'), findsOneWidget);
    });
  });
}
