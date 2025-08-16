import 'package:flutter/material.dart';
import 'package:sky_eldercare_family/config/themes/app_theme.dart';
import 'package:sky_eldercare_family/examples/dartz_examples.dart';

/// Dartz 函数式编程示例页面
///
/// 展示如何在 Flutter 项目中使用 Dartz 进行函数式编程：
/// - Either 类型的使用
/// - Option 类型的使用
/// - 错误处理最佳实践
/// - 函数式编程模式
class DartzExamplesPage extends StatefulWidget {
  const DartzExamplesPage({super.key});

  @override
  State<DartzExamplesPage> createState() => _DartzExamplesPageState();
}

class _DartzExamplesPageState extends State<DartzExamplesPage> {
  String _divisionResult = '';
  String _validationResult = '';
  String _chainResult = '';
  String _asyncResult = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dartz 函数式编程示例'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === Either 基础示例 ===
            _buildSectionCard(
              title: 'Either 基础使用',
              description: 'Either<L, R> 表示一个值要么是错误(L)，要么是成功(R)',
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _testDivision(10, 2),
                          child: const Text('10 ÷ 2'),
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _testDivision(10, 0),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppAdaptiveColors.error500(context),
                          ),
                          child: const Text('10 ÷ 0'),
                        ),
                      ),
                    ],
                  ),
                  if (_divisionResult.isNotEmpty) ...[
                    SizedBox(height: AppSpacing.sm),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppAdaptiveColors.neutral100(context),
                        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                      ),
                      child: Text(
                        _divisionResult,
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            SizedBox(height: AppSpacing.lg),

            // === Option 示例 ===
            _buildSectionCard(
              title: 'Option 类型使用',
              description: 'Option<T> 表示一个值可能存在(Some)或不存在(None)',
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _testValidation('user@example.com'),
                          child: const Text('验证邮箱'),
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _testValidation('invalid-email'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppAdaptiveColors.warning500(context),
                          ),
                          child: const Text('无效邮箱'),
                        ),
                      ),
                    ],
                  ),
                  if (_validationResult.isNotEmpty) ...[
                    SizedBox(height: AppSpacing.sm),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppAdaptiveColors.neutral100(context),
                        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                      ),
                      child: Text(
                        _validationResult,
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            SizedBox(height: AppSpacing.lg),

            // === 链式调用示例 ===
            _buildSectionCard(
              title: '链式调用和组合',
              description: '使用 flatMap 和 map 进行函数式编程',
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _testChaining(true),
                          child: const Text('成功链式调用'),
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _testChaining(false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppAdaptiveColors.error500(context),
                          ),
                          child: const Text('失败链式调用'),
                        ),
                      ),
                    ],
                  ),
                  if (_chainResult.isNotEmpty) ...[
                    SizedBox(height: AppSpacing.sm),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppAdaptiveColors.neutral100(context),
                        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                      ),
                      child: Text(
                        _chainResult,
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            SizedBox(height: AppSpacing.lg),

            // === 异步操作示例 ===
            _buildSectionCard(
              title: '异步操作处理',
              description: '使用 TaskEither 处理异步操作',
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _testAsync(true),
                          child: const Text('模拟成功请求'),
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _testAsync(false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppAdaptiveColors.error500(context),
                          ),
                          child: const Text('模拟失败请求'),
                        ),
                      ),
                    ],
                  ),
                  if (_asyncResult.isNotEmpty) ...[
                    SizedBox(height: AppSpacing.sm),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppAdaptiveColors.neutral100(context),
                        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                      ),
                      child: Text(
                        _asyncResult,
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            SizedBox(height: AppSpacing.lg),

            // === 最佳实践说明 ===
            _buildSectionCard(
              title: '最佳实践',
              description: 'Dartz 在项目中的应用建议',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPracticeItem(
                    '1. 错误处理',
                    '使用 Either<Failure, T> 统一处理业务逻辑中的错误',
                    Icons.error_outline,
                    AppAdaptiveColors.error500(context),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  _buildPracticeItem(
                    '2. 空值处理',
                    '使用 Option<T> 替代 nullable 类型，明确表达可能为空的语义',
                    Icons.help_outline,
                    AppAdaptiveColors.warning500(context),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  _buildPracticeItem(
                    '3. 函数组合',
                    '使用 flatMap、map 等方法进行函数式编程，提高代码可读性',
                    Icons.link,
                    AppAdaptiveColors.info500(context),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  _buildPracticeItem(
                    '4. 异步处理',
                    '使用 TaskEither 处理异步操作，保持函数式编程风格',
                    Icons.sync,
                    AppAdaptiveColors.success500(context),
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSpacing.lg),

            // === 代码示例 ===
            _buildSectionCard(
              title: '代码示例',
              description: '查看具体的代码实现',
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppAdaptiveColors.neutral900(context),
                  borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                ),
                child: Text(
                  r'''
// Either 基础使用
Either<String, int> divide(int a, int b) {
  if (b == 0) {
    return const Left('除数不能为零');
  }
  return Right(a ~/ b);
}

// 处理结果
final result = divide(10, 2);
result.fold(
  (error) => print('错误: $error'),
  (value) => print('结果: $value'),
);''',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppAdaptiveColors.neutral100(context),
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String description,
    required Widget child,
  }) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.h5.copyWith(
                color: AppAdaptiveColors.primary500(context),
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            Text(
              description,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppAdaptiveColors.neutral600(context),
              ),
            ),
            SizedBox(height: AppSpacing.md),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildPracticeItem(String title, String description, IconData icon, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 20),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                description,
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _testDivision(int a, int b) {
    final result = DartzExamples.divide(a, b);
    final message = result.fold(
      (error) => '❌ 错误: $error',
      (value) => '✅ 结果: $value',
    );
    setState(() {
      _divisionResult = message;
    });
  }

  void _testValidation(String email) {
    // 简单的邮箱验证示例
    final isValid = email.contains('@') && email.contains('.');
    final message = isValid ? '✅ 有效邮箱: $email' : '❌ 邮箱格式无效';
    setState(() {
      _validationResult = message;
    });
  }

  Future<void> _testChaining(bool shouldSucceed) async {
    setState(() {
      _chainResult = '⏳ 处理中...';
    });

    try {
      final result = await DartzExamples.getUserDisplayName('user123');
      final message = result.fold(
        (failure) => '❌ 处理失败: ${failure.message}',
        (data) => '✅ 处理成功: $data',
      );
      setState(() {
        _chainResult = message;
      });
    } catch (e) {
      setState(() {
        _chainResult = '❌ 处理异常: $e';
      });
    }
  }

  Future<void> _testAsync(bool shouldSucceed) async {
    setState(() {
      _asyncResult = '⏳ 处理中...';
    });

    try {
      final result = await DartzExamples.fetchUser(shouldSucceed ? 'valid_user' : 'invalid_user');
      final message = result.fold(
        (failure) => '❌ 异步操作失败: ${failure.message}',
        (user) => '✅ 异步操作成功: 获取到用户 ${user.name}',
      );
      setState(() {
        _asyncResult = message;
      });
    } catch (e) {
      setState(() {
        _asyncResult = '❌ 异步操作异常: $e';
      });
    }
  }
}
