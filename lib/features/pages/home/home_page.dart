import 'package:flutter/material.dart';
import 'package:sky_eldercare_family/shared/widgets/theme_switcher.dart';

/// 首页内容页面
class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
