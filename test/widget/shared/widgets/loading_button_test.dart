import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sky_eldercare_family/shared/widgets/loading_button.dart';

void main() {
  group('LoadingButton', () {
    testWidgets('should display child when not loading', (WidgetTester tester) async {
      const buttonText = 'Test Button';
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingButton(
              isLoading: false,
              onPressed: () => pressed = true,
              child: const Text(buttonText),
            ),
          ),
        ),
      );

      // 验证按钮文本显示
      expect(find.text(buttonText), findsOneWidget);
      
      // 验证没有加载指示器
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // 点击按钮
      await tester.tap(find.byType(LoadingButton));
      await tester.pump();

      // 验证回调被调用
      expect(pressed, true);
    });

    testWidgets('should display loading indicator when loading', (WidgetTester tester) async {
      const buttonText = 'Test Button';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingButton(
              isLoading: true,
              onPressed: () {},
              child: const Text(buttonText),
            ),
          ),
        ),
      );

      // 验证显示加载指示器
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      // 验证不显示按钮文本
      expect(find.text(buttonText), findsNothing);
    });

    testWidgets('should disable button when loading', (WidgetTester tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingButton(
              isLoading: true,
              onPressed: () => pressed = true,
              child: const Text('Test Button'),
            ),
          ),
        ),
      );

      // 尝试点击按钮
      await tester.tap(find.byType(LoadingButton));
      await tester.pump();

      // 验证回调没有被调用
      expect(pressed, false);
    });

    testWidgets('should apply custom styling', (WidgetTester tester) async {
      const backgroundColor = Colors.red;
      const foregroundColor = Colors.white;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingButton(
              isLoading: false,
              onPressed: () {},
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              child: const Text('Test Button'),
            ),
          ),
        ),
      );

      // 获取ElevatedButton widget
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      
      // 验证样式设置
      expect(button.style?.backgroundColor?.resolve({}), backgroundColor);
      expect(button.style?.foregroundColor?.resolve({}), foregroundColor);
    });

    testWidgets('should respect custom width and height', (WidgetTester tester) async {
      const customWidth = 200.0;
      const customHeight = 60.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingButton(
              isLoading: false,
              onPressed: () {},
              width: customWidth,
              height: customHeight,
              child: const Text('Test Button'),
            ),
          ),
        ),
      );

      // 获取SizedBox widget
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      
      // 验证尺寸设置
      expect(sizedBox.width, customWidth);
      expect(sizedBox.height, customHeight);
    });
  });
}
