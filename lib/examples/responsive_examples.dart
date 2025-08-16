import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sky_eldercare_family/config/themes/app_theme.dart';
import 'package:sky_eldercare_family/core/utils/responsive_utils.dart';

/// 响应式设计示例
///
/// 展示如何使用 flutter_screenutil 和响应式工具类：
/// - 响应式布局
/// - 自适应字体和间距
/// - 不同屏幕尺寸的适配
/// - 适老化响应式设计
class ResponsiveExamples extends StatelessWidget {
  const ResponsiveExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('响应式设计示例'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => ResponsiveUtils.printScreenInfo(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveUtils.getHorizontalPadding(context)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: ResponsiveUtils.getMaxContentWidth(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === 屏幕信息展示 ===
              _buildScreenInfoSection(context),
              SizedBox(height: AppSpacing.xl),

              // === 响应式文字示例 ===
              _buildResponsiveTextSection(context),
              SizedBox(height: AppSpacing.xl),

              // === 响应式布局示例 ===
              _buildResponsiveLayoutSection(context),
              SizedBox(height: AppSpacing.xl),

              // === 适老化响应式示例 ===
              _buildElderlyResponsiveSection(context),
              SizedBox(height: AppSpacing.xl),

              // === 响应式组件示例 ===
              _buildResponsiveComponentsSection(context),
            ],
          ),
        ),
      ),
    );
  }

  /// 屏幕信息展示
  Widget _buildScreenInfoSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '屏幕信息',
              style: AppTextStyles.h4.copyWith(
                color: AppAdaptiveColors.primary500(context),
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            _buildInfoRow('屏幕尺寸', '${1.sw.toInt()} x ${1.sh.toInt()}'),
            _buildInfoRow(
              '设备类型',
              ResponsiveUtils.isMobile(context)
                  ? '手机'
                  : ResponsiveUtils.isTablet(context)
                      ? '平板'
                      : '桌面',
            ),
            _buildInfoRow('方向', ResponsiveUtils.isLandscape(context) ? '横屏' : '竖屏'),
            _buildInfoRow('像素比', MediaQuery.of(context).devicePixelRatio.toStringAsFixed(2)),
            _buildInfoRow('状态栏高度', '${ResponsiveUtils.getStatusBarHeight(context).toInt()}px'),
            _buildInfoRow('安全区域', '${ResponsiveUtils.getBottomSafeArea(context).toInt()}px'),
            SizedBox(height: AppSpacing.sm),
            Text(
              'ScreenUtil 单位示例:',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppAdaptiveColors.neutral600(context),
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            _buildInfoRow('100.w', '${100.w.toInt()}px'),
            _buildInfoRow('100.h', '${100.h.toInt()}px'),
            _buildInfoRow('16.sp', '${16.sp.toInt()}px'),
            _buildInfoRow('8.r', '${8.r.toInt()}px'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodySmall,
          ),
          Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// 响应式文字示例
  Widget _buildResponsiveTextSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '响应式文字',
              style: AppTextStyles.h4.copyWith(
                color: AppAdaptiveColors.primary500(context),
              ),
            ),
            SizedBox(height: AppSpacing.md),

            // 标题层级展示
            Text('H1 标题 (32.sp)', style: AppTextStyles.h1),
            SizedBox(height: AppSpacing.xs),
            Text('H2 标题 (28.sp)', style: AppTextStyles.h2),
            SizedBox(height: AppSpacing.xs),
            Text('H3 标题 (24.sp)', style: AppTextStyles.h3),
            SizedBox(height: AppSpacing.xs),
            Text('H4 标题 (20.sp)', style: AppTextStyles.h4),
            SizedBox(height: AppSpacing.xs),
            Text('H5 标题 (18.sp)', style: AppTextStyles.h5),
            SizedBox(height: AppSpacing.xs),
            Text('H6 标题 (16.sp)', style: AppTextStyles.h6),

            SizedBox(height: AppSpacing.md),

            // 正文样式展示
            Text('正文大号 (18.sp)', style: AppTextStyles.bodyLarge),
            SizedBox(height: AppSpacing.xs),
            Text('正文标准 (16.sp)', style: AppTextStyles.bodyMedium),
            SizedBox(height: AppSpacing.xs),
            Text('正文小号 (14.sp)', style: AppTextStyles.bodySmall),
            SizedBox(height: AppSpacing.xs),
            Text('按钮文字 (16.sp)', style: AppTextStyles.button),
            SizedBox(height: AppSpacing.xs),
            Text('说明文字 (12.sp)', style: AppTextStyles.caption),

            SizedBox(height: AppSpacing.md),

            // 响应式字体大小展示
            Container(
              padding: EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppAdaptiveColors.primary50(context),
                borderRadius: BorderRadius.circular(AppBorderRadius.sm),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '响应式字体大小:',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppAdaptiveColors.primary700(context),
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    '标题: ${ResponsiveUtils.getHeadingSize(context, 1).toInt()}sp',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getHeadingSize(context, 1),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '正文: ${ResponsiveUtils.getBodySize(context).toInt()}sp',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getBodySize(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 响应式布局示例
  Widget _buildResponsiveLayoutSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '响应式布局',
              style: AppTextStyles.h4.copyWith(
                color: AppAdaptiveColors.primary500(context),
              ),
            ),
            SizedBox(height: AppSpacing.md),

            // 响应式网格
            Text(
              '响应式网格 (${ResponsiveUtils.getGridColumns(context)}列)',
              style: AppTextStyles.h6,
            ),
            SizedBox(height: AppSpacing.sm),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ResponsiveUtils.getGridColumns(context),
                crossAxisSpacing: ResponsiveUtils.getCardSpacing(context),
                mainAxisSpacing: ResponsiveUtils.getCardSpacing(context),
                childAspectRatio: 1.2,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: AppAdaptiveColors.primary100(context),
                    borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: AppTextStyles.h5.copyWith(
                        color: AppAdaptiveColors.primary700(context),
                      ),
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: AppSpacing.lg),

            // 响应式构建器示例
            Text(
              '响应式构建器',
              style: AppTextStyles.h6,
            ),
            SizedBox(height: AppSpacing.sm),

            ResponsiveBuilder(
              mobile: _buildMobileLayout(context),
              tablet: _buildTabletLayout(context),
              desktop: _buildDesktopLayout(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Container(
      height: 100.h,
      decoration: BoxDecoration(
        color: AppAdaptiveColors.success50(context),
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.phone_android, size: 32.w),
            SizedBox(height: 8.h),
            Text('手机布局', style: AppTextStyles.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Container(
      height: 100.h,
      decoration: BoxDecoration(
        color: AppAdaptiveColors.warning50(context),
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.tablet_android, size: 32.w),
            SizedBox(width: 12.w),
            Text('平板布局', style: AppTextStyles.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Container(
      height: 100.h,
      decoration: BoxDecoration(
        color: AppAdaptiveColors.info50(context),
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.desktop_windows, size: 32.w),
                SizedBox(height: 4.h),
                Text('桌面', style: AppTextStyles.caption),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.laptop, size: 32.w),
                SizedBox(height: 4.h),
                Text('笔记本', style: AppTextStyles.caption),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.monitor, size: 32.w),
                SizedBox(height: 4.h),
                Text('显示器', style: AppTextStyles.caption),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 适老化响应式示例
  Widget _buildElderlyResponsiveSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '适老化响应式设计',
              style: AppTextStyles.h4.copyWith(
                color: AppAdaptiveColors.primary500(context),
              ),
            ),
            SizedBox(height: AppSpacing.md),

            // 适老化响应式组件
            ElderlyResponsiveWidget(
              child: Container(
                padding: EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppAdaptiveColors.primary50(context),
                  borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                  border: Border.all(
                    color: AppAdaptiveColors.primary200(context),
                    width: 2.w,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '适老化标题',
                      style: AppTextStyles.elderlyH1.copyWith(
                        color: AppAdaptiveColors.primary700(context),
                      ),
                    ),
                    SizedBox(height: AppSpacing.md),
                    Text(
                      '这是适老化的正文内容，使用了更大的字体和更好的对比度，确保老年用户能够清晰地阅读。',
                      style: AppTextStyles.elderlyBodyLarge.copyWith(
                        color: AppAdaptiveColors.neutral800(context),
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg),

                    // 适老化按钮
                    SizedBox(
                      width: double.infinity,
                      height: ResponsiveUtils.getElderlyButtonHeight(context),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppAdaptiveColors.primary500(context),
                          foregroundColor: Colors.white,
                          textStyle: AppTextStyles.elderlyButton,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                          ),
                        ),
                        child: const Text('适老化大按钮'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: AppSpacing.md),

            // 触摸目标展示
            Text(
              '触摸目标尺寸',
              style: AppTextStyles.h6,
            ),
            SizedBox(height: AppSpacing.sm),

            Row(
              children: [
                _buildTouchTargetDemo(
                  context,
                  '标准',
                  48.w,
                  AppColors.neutral300,
                ),
                SizedBox(width: AppSpacing.md),
                _buildTouchTargetDemo(
                  context,
                  '适老化',
                  ResponsiveUtils.getElderlyTouchTarget(context),
                  AppAdaptiveColors.primary300(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTouchTargetDemo(BuildContext context, String label, double size, Color color) {
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppBorderRadius.sm),
            border: Border.all(
              color: AppAdaptiveColors.neutral400(context),
              width: 1.w,
            ),
          ),
          child: Icon(
            Icons.touch_app,
            size: size * 0.6,
            color: AppAdaptiveColors.neutral600(context),
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          '$label\n${size.toInt()}×${size.toInt()}',
          style: AppTextStyles.caption,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// 响应式组件示例
  Widget _buildResponsiveComponentsSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '响应式组件',
              style: AppTextStyles.h4.copyWith(
                color: AppAdaptiveColors.primary500(context),
              ),
            ),
            SizedBox(height: AppSpacing.md),

            // 响应式按钮
            Text('响应式按钮', style: AppTextStyles.h6),
            SizedBox(height: AppSpacing.sm),

            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                SizedBox(
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('标准按钮 (48.h)'),
                  ),
                ),
                SizedBox(
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('大按钮 (56.h)'),
                  ),
                ),
                SizedBox(
                  height: ResponsiveUtils.getElderlyButtonHeight(context),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      textStyle: AppTextStyles.elderlyButton,
                    ),
                    child: const Text('适老化按钮'),
                  ),
                ),
              ],
            ),

            SizedBox(height: AppSpacing.lg),

            // 响应式图标
            Text('响应式图标', style: AppTextStyles.h6),
            SizedBox(height: AppSpacing.sm),

            Row(
              children: [
                Icon(
                  Icons.home,
                  size: ResponsiveUtils.getIconSize(context),
                ),
                SizedBox(width: AppSpacing.md),
                Icon(
                  Icons.settings,
                  size: ResponsiveUtils.getIconSize(context, isLarge: true),
                ),
                SizedBox(width: AppSpacing.md),
                Icon(
                  Icons.favorite,
                  size: 48.w,
                  color: AppAdaptiveColors.error500(context),
                ),
              ],
            ),

            SizedBox(height: AppSpacing.lg),

            // 响应式输入框
            Text('响应式输入框', style: AppTextStyles.h6),
            SizedBox(height: AppSpacing.sm),

            TextField(
              decoration: InputDecoration(
                labelText: '响应式输入框',
                hintText: '高度和内边距会根据屏幕调整',
                prefixIcon: Icon(
                  Icons.person,
                  size: ResponsiveUtils.getIconSize(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 响应式对比页面
/// 展示开启和关闭响应式设计的对比效果
class ResponsiveComparisonPage extends StatefulWidget {
  const ResponsiveComparisonPage({super.key});

  @override
  State<ResponsiveComparisonPage> createState() => _ResponsiveComparisonPageState();
}

class _ResponsiveComparisonPageState extends State<ResponsiveComparisonPage> {
  bool _useResponsive = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('响应式对比'),
        actions: [
          Switch(
            value: _useResponsive,
            onChanged: (value) {
              setState(() {
                _useResponsive = value;
              });
            },
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(_useResponsive ? AppSpacing.md : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 状态指示
            Container(
              padding: EdgeInsets.all(_useResponsive ? AppSpacing.md : 16),
              decoration: BoxDecoration(
                color: _useResponsive ? AppAdaptiveColors.success50(context) : AppAdaptiveColors.warning50(context),
                borderRadius: BorderRadius.circular(
                  _useResponsive ? AppBorderRadius.md : 8,
                ),
                border: Border.all(
                  color: _useResponsive ? AppAdaptiveColors.success500(context) : AppAdaptiveColors.warning500(context),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _useResponsive ? Icons.check_circle : Icons.warning,
                    color:
                        _useResponsive ? AppAdaptiveColors.success500(context) : AppAdaptiveColors.warning500(context),
                    size: _useResponsive ? ResponsiveUtils.getIconSize(context) : 24,
                  ),
                  SizedBox(width: _useResponsive ? AppSpacing.sm : 8),
                  Text(
                    _useResponsive ? '响应式设计已开启' : '使用固定尺寸',
                    style: _useResponsive
                        ? AppTextStyles.bodyMedium.copyWith(
                            color: AppAdaptiveColors.success700(context),
                          )
                        : const TextStyle(
                            fontSize: 16,
                            color: Color(0xFFF57C00),
                          ),
                  ),
                ],
              ),
            ),

            SizedBox(height: _useResponsive ? AppSpacing.xl : 32),

            // 标题对比
            Text(
              '标题文字对比',
              style: _useResponsive ? AppTextStyles.h2 : const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
            ),

            SizedBox(height: _useResponsive ? AppSpacing.md : 16),

            Text(
              '这是正文内容的对比。响应式设计会根据屏幕尺寸自动调整字体大小、间距和布局，确保在不同设备上都有良好的显示效果。',
              style: _useResponsive ? AppTextStyles.bodyMedium : const TextStyle(fontSize: 16),
            ),

            SizedBox(height: _useResponsive ? AppSpacing.lg : 24),

            // 按钮对比
            SizedBox(
              width: double.infinity,
              height: _useResponsive ? 56.h : 48,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      _useResponsive ? AppBorderRadius.md : 8,
                    ),
                  ),
                ),
                child: Text(
                  _useResponsive ? '响应式按钮' : '固定尺寸按钮',
                  style: _useResponsive
                      ? AppTextStyles.button
                      : const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
