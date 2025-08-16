import 'package:flutter/material.dart';
import 'package:sky_eldercare_family/config/themes/app_theme.dart';

/// 暗黑模式适配示例
///
/// 展示如何使用新的暗黑模式颜色系统：
/// - 自适应颜色系统
/// - 深色主题专用颜色
/// - 养老应用暗黑模式特色
class DarkModeExamples extends StatelessWidget {
  const DarkModeExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('暗黑模式适配示例'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === 自适应颜色对比展示 ===
            _buildAdaptiveColorsSection(context),
            const SizedBox(height: AppSpacing.xl),

            // === 养老应用暗黑模式特色 ===
            _buildEldercareSection(context),
            const SizedBox(height: AppSpacing.xl),

            // === 组件在暗黑模式下的表现 ===
            _buildComponentsSection(context),
            const SizedBox(height: AppSpacing.xl),

            // === 高对比度暗黑模式 ===
            _buildHighContrastSection(context),
          ],
        ),
      ),
    );
  }

  /// 自适应颜色对比展示
  Widget _buildAdaptiveColorsSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '自适应颜色系统',
          style: AppTextStyles.h3.copyWith(
            color: AppAdaptiveColors.onSurface(context),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppAdaptiveColors.surface(context),
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
            border: Border.all(color: AppAdaptiveColors.outline(context)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '当前主题: ${isDark ? '暗黑模式' : '浅色模式'}',
                style: AppTextStyles.h6.copyWith(
                  color: AppAdaptiveColors.primary500(context),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              // 颜色对比展示
              Row(
                children: [
                  Expanded(
                    child: _buildColorCard(
                      context,
                      '主色调',
                      AppAdaptiveColors.primary500(context),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _buildColorCard(
                      context,
                      '表面色',
                      AppAdaptiveColors.surface(context),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _buildColorCard(
                      context,
                      '文字色',
                      AppAdaptiveColors.onSurface(context),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // 功能色展示
              Row(
                children: [
                  Expanded(
                    child: _buildColorCard(
                      context,
                      '成功',
                      AppAdaptiveColors.success500(context),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _buildColorCard(
                      context,
                      '警告',
                      AppAdaptiveColors.warning500(context),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _buildColorCard(
                      context,
                      '错误',
                      AppAdaptiveColors.error500(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 养老应用暗黑模式特色
  Widget _buildEldercareSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '养老应用暗黑模式特色',
          style: AppTextStyles.h3.copyWith(
            color: AppAdaptiveColors.onSurface(context),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // 健康状态卡片 - 暗黑模式优化
        Row(
          children: [
            Expanded(
              child: _buildHealthCard(
                context,
                '健康良好',
                AppAdaptiveColors.healthGood(context),
                Icons.favorite,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildHealthCard(
                context,
                '需要注意',
                AppAdaptiveColors.healthWarning(context),
                Icons.warning,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildHealthCard(
                context,
                '危险状态',
                AppAdaptiveColors.healthDanger(context),
                Icons.emergency,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.md),

        // 护理服务卡片 - 暗黑模式优化
        Row(
          children: [
            Expanded(
              child: _buildServiceCard(
                context,
                '医疗护理',
                AppAdaptiveColors.careBlue(context),
                Icons.medical_services,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildServiceCard(
                context,
                '生活护理',
                AppAdaptiveColors.careGreen(context),
                Icons.home_filled,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildServiceCard(
                context,
                '康复护理',
                AppAdaptiveColors.carePurple(context),
                Icons.accessibility,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.md),

        // 紧急按钮 - 暗黑模式优化
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppAdaptiveColors.emergencyBg(context),
            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            border: Border.all(
              color: AppAdaptiveColors.emergency(context),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.emergency,
                color: AppAdaptiveColors.emergency(context),
                size: 48,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '紧急呼叫',
                style: AppTextStyles.elderlyButton.copyWith(
                  color: AppAdaptiveColors.emergency(context),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '暗黑模式下依然保持高可见性',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppAdaptiveColors.onSurfaceVariant(context),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 组件在暗黑模式下的表现
  Widget _buildComponentsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '组件暗黑模式表现',
          style: AppTextStyles.h3.copyWith(
            color: AppAdaptiveColors.onSurface(context),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // 按钮组合
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: const Text('主要按钮'),
            ),
            OutlinedButton(
              onPressed: () {},
              child: const Text('次要按钮'),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('文本按钮'),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.lg),

        // 输入框
        const Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: '暗黑模式输入框',
                hintText: '优化的对比度和可见性',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: AppSpacing.md),
            TextField(
              decoration: InputDecoration(
                labelText: '错误状态',
                hintText: '暗黑模式下的错误提示',
                prefixIcon: Icon(Icons.error),
                errorText: '暗黑模式下依然清晰可见',
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.lg),

        // 卡片示例
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '暗黑模式卡片',
                  style: AppTextStyles.h5.copyWith(
                    color: AppAdaptiveColors.onSurface(context),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '在暗黑模式下，卡片使用了深色背景色和优化的文字对比度，确保内容清晰可读。',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppAdaptiveColors.onSurfaceVariant(context),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text('取消'),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('确定'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 高对比度暗黑模式
  Widget _buildHighContrastSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '高对比度暗黑模式',
          style: AppTextStyles.h3.copyWith(
            color: AppAdaptiveColors.onSurface(context),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppAdaptiveColors.highContrastBg(context),
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
            border: Border.all(
              color: AppAdaptiveColors.highContrastAccent(context),
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '适老化高对比度模式',
                style: AppTextStyles.elderlyH1.copyWith(
                  color: AppAdaptiveColors.highContrastText(context),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                '为视力不佳的老年用户提供极高对比度的显示效果，在暗黑模式下使用纯白文字和纯黑背景。',
                style: AppTextStyles.elderlyBodyLarge.copyWith(
                  color: AppAdaptiveColors.highContrastText(context),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppAdaptiveColors.highContrastAccent(context),
                    foregroundColor: AppAdaptiveColors.highContrastBg(context),
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                    textStyle: AppTextStyles.elderlyButton,
                  ),
                  child: const Text('高对比度按钮'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildColorCard(BuildContext context, String name, Color color) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
        border: Border.all(color: AppAdaptiveColors.outline(context)),
      ),
      child: Center(
        child: Text(
          name,
          style: AppTextStyles.caption.copyWith(
            color: _getContrastColor(color),
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildHealthCard(BuildContext context, String title, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: AppSpacing.xs),
          Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(color: color),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, String title, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: AppSpacing.xs),
          Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(color: color),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 根据背景色获取对比色
  Color _getContrastColor(Color backgroundColor) {
    // 简单的对比度计算
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

/// 暗黑模式对比展示页面
class DarkModeComparisonPage extends StatefulWidget {
  const DarkModeComparisonPage({super.key});

  @override
  State<DarkModeComparisonPage> createState() => _DarkModeComparisonPageState();
}

class _DarkModeComparisonPageState extends State<DarkModeComparisonPage> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('暗黑模式对比'),
          actions: [
            Switch(
              value: _isDarkMode,
              onChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                });
              },
            ),
            const SizedBox(width: AppSpacing.md),
          ],
        ),
        body: const DarkModeExamples(),
      ),
    );
  }
}
