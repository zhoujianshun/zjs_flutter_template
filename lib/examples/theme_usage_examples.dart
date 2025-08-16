import 'package:flutter/material.dart';
import 'package:sky_eldercare_family/config/themes/app_theme.dart';

/// 主题使用示例
///
/// 此文件展示了如何使用新的主题扩展系统，包括：
/// - 自定义颜色系统
/// - 自定义字体样式
/// - 间距和圆角系统
/// - 养老应用特定的颜色和样式
class ThemeUsageExamples extends StatelessWidget {
  const ThemeUsageExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('主题使用示例'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === 颜色系统示例 ===
            _buildColorSection(),
            const SizedBox(height: AppSpacing.xl),

            // === 字体样式示例 ===
            _buildTypographySection(),
            const SizedBox(height: AppSpacing.xl),

            // === 养老应用特色示例 ===
            _buildEldercareSection(),
            const SizedBox(height: AppSpacing.xl),

            // === 组件样式示例 ===
            _buildComponentSection(),
          ],
        ),
      ),
    );
  }

  /// 颜色系统示例
  Widget _buildColorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '颜色系统',
          style: AppTextStyles.h3.copyWith(color: AppColors.neutral900),
        ),
        const SizedBox(height: AppSpacing.md),

        // 品牌色系
        _buildColorRow('主色系', [
          const _ColorCard('Primary 500', AppColors.primary500),
          const _ColorCard('Primary 700', AppColors.primary700),
          const _ColorCard('Primary 300', AppColors.primary300),
        ]),

        // 功能色系
        _buildColorRow('功能色系', [
          const _ColorCard('Success', AppColors.success500),
          const _ColorCard('Warning', AppColors.warning500),
          const _ColorCard('Error', AppColors.error500),
          const _ColorCard('Info', AppColors.info500),
        ]),

        // 中性色系
        _buildColorRow('中性色系', [
          const _ColorCard('Neutral 900', AppColors.neutral900),
          const _ColorCard('Neutral 600', AppColors.neutral600),
          const _ColorCard('Neutral 300', AppColors.neutral300),
          const _ColorCard('Neutral 100', AppColors.neutral100),
        ]),
      ],
    );
  }

  /// 字体样式示例
  Widget _buildTypographySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '字体样式',
          style: AppTextStyles.h3.copyWith(color: AppColors.neutral900),
        ),
        const SizedBox(height: AppSpacing.md),

        // 标题样式
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.neutral50,
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
            border: Border.all(color: AppColors.neutral200),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('H1 标题', style: AppTextStyles.h1),
              Text('H2 标题', style: AppTextStyles.h2),
              Text('H3 标题', style: AppTextStyles.h3),
              Text('H4 标题', style: AppTextStyles.h4),
              Text('H5 标题', style: AppTextStyles.h5),
              Text('H6 标题', style: AppTextStyles.h6),
              SizedBox(height: AppSpacing.sm),
              Text('正文大号', style: AppTextStyles.bodyLarge),
              Text('正文中号', style: AppTextStyles.bodyMedium),
              Text('正文小号', style: AppTextStyles.bodySmall),
              SizedBox(height: AppSpacing.sm),
              Text('按钮文字', style: AppTextStyles.button),
              Text('说明文字', style: AppTextStyles.caption),
              Text('标签文字', style: AppTextStyles.overline),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // 适老化字体
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.primary50,
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
            border: Border.all(color: AppColors.primary200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '适老化大字体样式',
                style: AppTextStyles.h6.copyWith(color: AppColors.primary700),
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text('适老化标题', style: AppTextStyles.elderlyH1),
              const Text('适老化正文', style: AppTextStyles.elderlyBodyLarge),
              const Text('适老化按钮', style: AppTextStyles.elderlyButton),
            ],
          ),
        ),
      ],
    );
  }

  /// 养老应用特色示例
  Widget _buildEldercareSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '养老应用特色',
          style: AppTextStyles.h3.copyWith(color: AppColors.neutral900),
        ),
        const SizedBox(height: AppSpacing.md),

        // 健康状态卡片
        Row(
          children: [
            Expanded(
              child: _buildStatusCard(
                '健康良好',
                AppColors.healthGood,
                AppColors.success50,
                Icons.favorite,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildStatusCard(
                '需要注意',
                AppColors.healthWarning,
                AppColors.warning50,
                Icons.warning,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildStatusCard(
                '紧急情况',
                AppColors.healthDanger,
                AppColors.error50,
                Icons.emergency,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.md),

        // 护理服务卡片
        Row(
          children: [
            Expanded(
              child: _buildServiceCard(
                '医疗护理',
                AppColors.careBlue,
                Icons.medical_services,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildServiceCard(
                '生活护理',
                AppColors.careGreen,
                Icons.home_filled,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildServiceCard(
                '康复护理',
                AppColors.carePurple,
                Icons.accessibility,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.md),

        // 紧急按钮示例
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.emergencyBg,
            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            border: Border.all(color: AppColors.emergency, width: 2),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.emergency,
                color: AppColors.emergency,
                size: 48,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '紧急呼叫',
                style: AppTextStyles.elderlyButton.copyWith(
                  color: AppColors.emergency,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '点击此按钮进行紧急求助',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.neutral700,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 组件样式示例
  Widget _buildComponentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '组件样式',
          style: AppTextStyles.h3.copyWith(color: AppColors.neutral900),
        ),
        const SizedBox(height: AppSpacing.md),

        // 按钮示例
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

        // 输入框示例
        const Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: '标准输入框',
                hintText: '请输入内容',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: AppSpacing.md),
            TextField(
              decoration: InputDecoration(
                labelText: '错误状态',
                hintText: '请输入正确的内容',
                prefixIcon: Icon(Icons.error),
                errorText: '输入内容有误',
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
                const Text(
                  '卡片标题',
                  style: AppTextStyles.h5,
                ),
                const SizedBox(height: AppSpacing.sm),
                const Text(
                  '这是一个使用新主题系统的卡片示例。卡片使用了统一的圆角、间距和颜色配置。',
                  style: AppTextStyles.bodyMedium,
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

  Widget _buildColorRow(String title, List<Widget> colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.h6.copyWith(color: AppColors.neutral700),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: colors.map((color) => Expanded(child: color)).toList(),
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }

  Widget _buildStatusCard(String title, Color color, Color bgColor, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppSpacing.xs),
          Text(
            title,
            style: AppTextStyles.caption.copyWith(color: color),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(String title, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(color: color.withOpacity(0.3)),
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
}

class _ColorCard extends StatelessWidget {
  const _ColorCard(this.name, this.color);
  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: AppSpacing.xs),
      child: Column(
        children: [
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppBorderRadius.sm),
              border: Border.all(color: AppColors.neutral300),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            name,
            style: AppTextStyles.caption.copyWith(color: AppColors.neutral600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// 高对比度主题示例页面
class HighContrastThemeExample extends StatelessWidget {
  const HighContrastThemeExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.highContrastBg,
      appBar: AppBar(
        title: Text(
          '高对比度模式',
          style: AppTextStyles.h5.copyWith(color: AppColors.highContrastText),
        ),
        backgroundColor: AppColors.highContrastBg,
        foregroundColor: AppColors.highContrastText,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '适老化高对比度界面',
              style: AppTextStyles.elderlyH1.copyWith(
                color: AppColors.highContrastText,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              '这是专为视力不佳的老年用户设计的高对比度界面。使用了更大的字体、更高的对比度和更清晰的视觉层次。',
              style: AppTextStyles.elderlyBodyLarge.copyWith(
                color: AppColors.highContrastText,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.highContrastAccent,
                  foregroundColor: AppColors.highContrastBg,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  textStyle: AppTextStyles.elderlyButton,
                ),
                child: const Text('大按钮示例'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
