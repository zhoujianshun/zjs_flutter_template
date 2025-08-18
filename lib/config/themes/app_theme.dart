import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zjs_flutter_template/core/storage/storage_service.dart';
import 'package:zjs_flutter_template/di/service_locator.dart';

/// 自定义颜色扩展
class AppColors {
  AppColors._();

  // === 品牌色系 ===
  static const Color primary50 = Color(0xFFE3F2FD);
  static const Color primary100 = Color(0xFFBBDEFB);
  static const Color primary200 = Color(0xFF90CAF9);
  static const Color primary300 = Color(0xFF64B5F6);
  static const Color primary400 = Color(0xFF42A5F5);
  static const Color primary500 = Color(0xFF2196F3); // 主色
  static const Color primary600 = Color(0xFF1E88E5);
  static const Color primary700 = Color(0xFF1976D2);
  static const Color primary800 = Color(0xFF1565C0);
  static const Color primary900 = Color(0xFF0D47A1);

  // === 功能色系 ===
  static const Color success50 = Color(0xFFE8F5E8);
  static const Color success500 = Color(0xFF4CAF50);
  static const Color success700 = Color(0xFF388E3C);

  static const Color warning50 = Color(0xFFFFF3E0);
  static const Color warning500 = Color(0xFFFF9800);
  static const Color warning700 = Color(0xFFF57C00);

  static const Color error50 = Color(0xFFFFEBEE);
  static const Color error500 = Color(0xFFF44336);
  static const Color error700 = Color(0xFFD32F2F);

  static const Color info50 = Color(0xFFE1F5FE);
  static const Color info500 = Color(0xFF03DAC6);
  static const Color info700 = Color(0xFF00ACC1);

  // === 中性色系 ===
  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral200 = Color(0xFFEEEEEE);
  static const Color neutral300 = Color(0xFFE0E0E0);
  static const Color neutral400 = Color(0xFFBDBDBD);
  static const Color neutral500 = Color(0xFF9E9E9E);
  static const Color neutral600 = Color(0xFF757575);
  static const Color neutral700 = Color(0xFF616161);
  static const Color neutral800 = Color(0xFF424242);
  static const Color neutral900 = Color(0xFF212121);

  // === 养老应用专用颜色 ===
  // 健康状态相关
  static const Color healthGood = Color(0xFF66BB6A);
  static const Color healthWarning = Color(0xFFFFCA28);
  static const Color healthDanger = Color(0xFFEF5350);

  // 紧急情况
  static const Color emergency = Color(0xFFD50000);
  static const Color emergencyBg = Color(0xFFFFCDD2);

  // 护理相关
  static const Color careBlue = Color(0xFF42A5F5);
  static const Color careGreen = Color(0xFF66BB6A);
  static const Color carePurple = Color(0xFFAB47BC);

  // 适老化高对比度色彩
  static const Color highContrastText = Color(0xFF000000);
  static const Color highContrastBg = Color(0xFFFFFFFF);
  static const Color highContrastAccent = Color(0xFF0D47A1);

  // === 深色主题专用颜色 ===
  // 深色主题品牌色（更亮更饱和）
  static const Color darkPrimary50 = Color(0xFF0D47A1);
  static const Color darkPrimary100 = Color(0xFF1565C0);
  static const Color darkPrimary200 = Color(0xFF1976D2);
  static const Color darkPrimary300 = Color(0xFF1E88E5);
  static const Color darkPrimary400 = Color(0xFF2196F3);
  static const Color darkPrimary500 = Color(0xFF42A5F5); // 深色主题主色
  static const Color darkPrimary600 = Color(0xFF64B5F6);
  static const Color darkPrimary700 = Color(0xFF90CAF9);
  static const Color darkPrimary800 = Color(0xFFBBDEFB);
  static const Color darkPrimary900 = Color(0xFFE3F2FD);

  // 深色主题功能色（增强可见性）
  static const Color darkSuccess50 = Color(0xFF1B5E20);
  static const Color darkSuccess500 = Color(0xFF66BB6A);
  static const Color darkSuccess700 = Color(0xFF81C784);

  static const Color darkWarning50 = Color(0xFFE65100);
  static const Color darkWarning500 = Color(0xFFFFB74D);
  static const Color darkWarning700 = Color(0xFFFFCC02);

  static const Color darkError50 = Color(0xFFB71C1C);
  static const Color darkError500 = Color(0xFFEF5350);
  static const Color darkError700 = Color(0xFFFF8A80);

  static const Color darkInfo50 = Color(0xFF006064);
  static const Color darkInfo500 = Color(0xFF26C6DA);
  static const Color darkInfo700 = Color(0xFF4DD0E1);

  // 深色主题中性色（优化对比度）
  static const Color darkNeutral50 = Color(0xFF121212); // 深色背景
  static const Color darkNeutral100 = Color(0xFF1E1E1E); // 卡片背景
  static const Color darkNeutral200 = Color(0xFF2D2D2D); // 输入框背景
  static const Color darkNeutral300 = Color(0xFF3E3E3E); // 分割线
  static const Color darkNeutral400 = Color(0xFF5E5E5E); // 禁用元素
  static const Color darkNeutral500 = Color(0xFF7E7E7E); // 次要文字
  static const Color darkNeutral600 = Color(0xFF9E9E9E); // 图标
  static const Color darkNeutral700 = Color(0xFFBEBEBE); // 正文
  static const Color darkNeutral800 = Color(0xFFDEDEDE); // 标题
  static const Color darkNeutral900 = Color(0xFFFAFAFA); // 主要文字

  // 深色主题养老应用专用色（增强对比）
  static const Color darkHealthGood = Color(0xFF81C784);
  static const Color darkHealthWarning = Color(0xFFFFD54F);
  static const Color darkHealthDanger = Color(0xFFFF8A80);

  static const Color darkEmergency = Color(0xFFFF5252);
  static const Color darkEmergencyBg = Color(0xFF3E2723);

  static const Color darkCareBlue = Color(0xFF64B5F6);
  static const Color darkCareGreen = Color(0xFF81C784);
  static const Color darkCarePurple = Color(0xFFBA68C8);

  // 深色主题高对比度（适老化）
  static const Color darkHighContrastText = Color(0xFFFFFFFF);
  static const Color darkHighContrastBg = Color(0xFF000000);
  static const Color darkHighContrastAccent = Color(0xFF64B5F6);
}

/// 自适应颜色工具类
/// 根据当前主题模式自动选择合适的颜色
class AppAdaptiveColors {
  AppAdaptiveColors._();

  /// 获取当前主题模式
  static bool _isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  // === 品牌色自适应 ===
  static Color primary50(BuildContext context) => _isDarkMode(context) ? AppColors.darkPrimary50 : AppColors.primary50;

  static Color primary100(BuildContext context) =>
      _isDarkMode(context) ? AppColors.darkPrimary100 : AppColors.primary100;

  static Color primary200(BuildContext context) =>
      _isDarkMode(context) ? AppColors.darkPrimary200 : AppColors.primary200;

  static Color primary300(BuildContext context) =>
      _isDarkMode(context) ? AppColors.darkPrimary300 : AppColors.primary300;

  static Color primary400(BuildContext context) =>
      _isDarkMode(context) ? AppColors.darkPrimary400 : AppColors.primary400;

  static Color primary500(BuildContext context) =>
      _isDarkMode(context) ? AppColors.darkPrimary500 : AppColors.primary500;

  static Color primary600(BuildContext context) =>
      _isDarkMode(context) ? AppColors.darkPrimary600 : AppColors.primary600;

  static Color primary700(BuildContext context) =>
      _isDarkMode(context) ? AppColors.darkPrimary700 : AppColors.primary700;

  static Color primary800(BuildContext context) =>
      _isDarkMode(context) ? AppColors.darkPrimary800 : AppColors.primary800;

  static Color primary900(BuildContext context) =>
      _isDarkMode(context) ? AppColors.darkPrimary900 : AppColors.primary900;

  // === 功能色自适应 ===
  static Color success50(BuildContext context) => _isDarkMode(context) ? AppColors.darkSuccess50 : AppColors.success50;

  static Color success500(BuildContext context) =>
      _isDarkMode(context) ? AppColors.darkSuccess500 : AppColors.success500;

  static Color success700(BuildContext context) =>
      _isDarkMode(context) ? AppColors.darkSuccess700 : AppColors.success700;

  static Color warning50(BuildContext context) => _isDarkMode(context) ? AppColors.darkWarning50 : AppColors.warning50;

  static Color warning500(BuildContext context) =>
      _isDarkMode(context) ? AppColors.darkWarning500 : AppColors.warning500;

  static Color warning700(BuildContext context) =>
      _isDarkMode(context) ? AppColors.darkWarning700 : AppColors.warning700;

  static Color error50(BuildContext context) => _isDarkMode(context) ? AppColors.darkError50 : AppColors.error50;

  static Color error500(BuildContext context) => _isDarkMode(context) ? AppColors.darkError500 : AppColors.error500;

  static Color error700(BuildContext context) => _isDarkMode(context) ? AppColors.darkError700 : AppColors.error700;

  static Color info50(BuildContext context) => _isDarkMode(context) ? AppColors.darkInfo50 : AppColors.info50;

  static Color info500(BuildContext context) => _isDarkMode(context) ? AppColors.darkInfo500 : AppColors.info500;

  static Color info700(BuildContext context) => _isDarkMode(context) ? AppColors.darkInfo700 : AppColors.info700;

  // === 中性色自适应 ===
  static Color neutral50(BuildContext context) => _isDarkMode(context) ? AppColors.darkNeutral50 : AppColors.neutral50;

  static Color neutral100(BuildContext context) =>
      _isDarkMode(context) ? AppColors.darkNeutral100 : AppColors.neutral100;

  static Color neutral200(BuildContext context) =>
      _isDarkMode(context) ? AppColors.darkNeutral200 : AppColors.neutral200;

  static Color neutral300(BuildContext context) =>
      _isDarkMode(context) ? AppColors.darkNeutral300 : AppColors.neutral300;

  static Color neutral400(BuildContext context) =>
      _isDarkMode(context) ? AppColors.darkNeutral400 : AppColors.neutral400;

  static Color neutral500(BuildContext context) =>
      _isDarkMode(context) ? AppColors.darkNeutral500 : AppColors.neutral500;

  static Color neutral600(BuildContext context) =>
      _isDarkMode(context) ? AppColors.darkNeutral600 : AppColors.neutral600;

  static Color neutral700(BuildContext context) =>
      _isDarkMode(context) ? AppColors.darkNeutral700 : AppColors.neutral700;

  static Color neutral800(BuildContext context) =>
      _isDarkMode(context) ? AppColors.darkNeutral800 : AppColors.neutral800;

  static Color neutral900(BuildContext context) =>
      _isDarkMode(context) ? AppColors.darkNeutral900 : AppColors.neutral900;

  // === 养老应用专用色自适应 ===
  static Color healthGood(BuildContext context) =>
      _isDarkMode(context) ? AppColors.darkHealthGood : AppColors.healthGood;

  static Color healthWarning(BuildContext context) =>
      _isDarkMode(context) ? AppColors.darkHealthWarning : AppColors.healthWarning;

  static Color healthDanger(BuildContext context) =>
      _isDarkMode(context) ? AppColors.darkHealthDanger : AppColors.healthDanger;

  static Color emergency(BuildContext context) => _isDarkMode(context) ? AppColors.darkEmergency : AppColors.emergency;

  static Color emergencyBg(BuildContext context) =>
      _isDarkMode(context) ? AppColors.darkEmergencyBg : AppColors.emergencyBg;

  static Color careBlue(BuildContext context) => _isDarkMode(context) ? AppColors.darkCareBlue : AppColors.careBlue;

  static Color careGreen(BuildContext context) => _isDarkMode(context) ? AppColors.darkCareGreen : AppColors.careGreen;

  static Color carePurple(BuildContext context) =>
      _isDarkMode(context) ? AppColors.darkCarePurple : AppColors.carePurple;

  // === 高对比度自适应 ===
  static Color highContrastText(BuildContext context) =>
      _isDarkMode(context) ? AppColors.darkHighContrastText : AppColors.highContrastText;

  static Color highContrastBg(BuildContext context) =>
      _isDarkMode(context) ? AppColors.darkHighContrastBg : AppColors.highContrastBg;

  static Color highContrastAccent(BuildContext context) =>
      _isDarkMode(context) ? AppColors.darkHighContrastAccent : AppColors.highContrastAccent;

  // === 便捷方法 ===
  /// 获取表面颜色（卡片、对话框等）
  static Color surface(BuildContext context) => neutral100(context);

  /// 获取背景颜色
  static Color background(BuildContext context) => neutral50(context);

  /// 获取主要文字颜色
  static Color onSurface(BuildContext context) => neutral900(context);

  /// 获取次要文字颜色
  static Color onSurfaceVariant(BuildContext context) => neutral700(context);

  /// 获取边框颜色
  static Color outline(BuildContext context) => neutral300(context);

  /// 获取分割线颜色
  static Color divider(BuildContext context) => neutral200(context);
}

/// 自定义字体样式扩展
class AppTextStyles {
  AppTextStyles._();

  // === 标题样式 ===
  static TextStyle get h1 => TextStyle(
        fontSize: 32.sp,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.5,
      );

  static TextStyle get h2 => TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.w600,
        height: 1.25,
        letterSpacing: -0.25,
      );

  static TextStyle get h3 => TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  static TextStyle get h4 => TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        height: 1.35,
      );

  static TextStyle get h5 => TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
        height: 1.4,
      );

  static TextStyle get h6 => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        height: 1.4,
      );

  // === 正文样式 ===
  static TextStyle get bodyLarge => TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0.15,
      );

  static TextStyle get bodyMedium => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0.25,
      );

  static TextStyle get bodySmall => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        height: 1.43,
        letterSpacing: 0.4,
      );

  // === 特殊用途样式 ===
  static TextStyle get button => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        height: 1.25,
        letterSpacing: 0.5,
      );

  static TextStyle get buttonLarge => TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        height: 1.25,
        letterSpacing: 0.5,
      );

  static TextStyle get caption => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        height: 1.33,
        letterSpacing: 0.4,
      );

  static TextStyle get overline => TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
        height: 1.6,
        letterSpacing: 1.5,
      );

  // === 适老化大字体样式 ===
  static TextStyle get elderlyH1 => TextStyle(
        fontSize: 36.sp,
        fontWeight: FontWeight.w700,
        height: 1.3,
        letterSpacing: -0.5,
      );

  static TextStyle get elderlyBodyLarge => TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w400,
        height: 1.6,
        letterSpacing: 0.15,
      );

  static TextStyle get elderlyButton => TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: 0.5,
      );
}

/// 自定义间距系统
class AppSpacing {
  AppSpacing._();

  static double get xs => 4.w;
  static double get sm => 8.w;
  static double get md => 16.w;
  static double get lg => 24.w;
  static double get xl => 32.w;
  static double get xxl => 48.w;
  static double get xxxl => 64.w;
}

/// 自定义圆角系统
class AppBorderRadius {
  AppBorderRadius._();

  static double get xs => 4.r;
  static double get sm => 8.r;
  static double get md => 12.r;
  static double get lg => 16.r;
  static double get xl => 24.r;
  static double get full => 999.r;
}

/// 应用主题配置
class AppTheme {
  AppTheme._();

  // 主色调（保持向后兼容）
  static const Color _primaryColor = AppColors.primary500;
  static const Color _secondaryColor = AppColors.info500;
  static const Color _errorColor = AppColors.error500;

  // 浅色主题
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
      ).copyWith(
        secondary: _secondaryColor,
        error: _errorColor,
        surface: AppColors.neutral50,
        onSurface: AppColors.neutral900,
        surfaceContainerHighest: AppColors.neutral100,
        outline: AppColors.neutral300,
      ),

      // 文本主题 - 使用自定义字体样式
      textTheme: TextTheme(
        displayLarge: AppTextStyles.h1.copyWith(color: AppColors.neutral900),
        displayMedium: AppTextStyles.h2.copyWith(color: AppColors.neutral900),
        displaySmall: AppTextStyles.h3.copyWith(color: AppColors.neutral900),
        headlineLarge: AppTextStyles.h4.copyWith(color: AppColors.neutral900),
        headlineMedium: AppTextStyles.h5.copyWith(color: AppColors.neutral900),
        headlineSmall: AppTextStyles.h6.copyWith(color: AppColors.neutral900),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.neutral800),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral800),
        bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.neutral700),
        labelLarge: AppTextStyles.button.copyWith(color: AppColors.neutral900),
        labelMedium: AppTextStyles.caption.copyWith(color: AppColors.neutral600),
        labelSmall: AppTextStyles.overline.copyWith(color: AppColors.neutral600),
      ),

      // AppBar主题
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.neutral900,
        titleTextStyle: AppTextStyles.h5.copyWith(
          color: AppColors.neutral900,
        ),
      ),

      // 底部导航栏主题
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedItemColor: _primaryColor,
        unselectedItemColor: AppColors.neutral600,
        selectedLabelStyle: AppTextStyles.caption.copyWith(
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: AppTextStyles.caption,
      ),

      // 卡片主题
      cardTheme: CardThemeData(
        elevation: 2,
        color: AppColors.neutral50,
        surfaceTintColor: AppColors.primary50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
        margin: EdgeInsets.all(AppSpacing.sm),
      ),

      // 按钮主题
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),

      // 输入框主题
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.neutral100,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(color: AppColors.neutral300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(color: AppColors.neutral300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(color: _primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(color: _errorColor, width: 2),
        ),
        labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral700),
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral500),
      ),

      // 对话框主题
      dialogTheme: DialogThemeData(
        elevation: 8,
        backgroundColor: AppColors.neutral50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        ),
        titleTextStyle: AppTextStyles.h4.copyWith(
          color: AppColors.neutral900,
        ),
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.neutral700,
        ),
      ),

      // FloatingActionButton主题
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        ),
      ),
    );
  }

  // 深色主题
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.darkPrimary500,
        brightness: Brightness.dark,
      ).copyWith(
        primary: AppColors.darkPrimary500,
        secondary: AppColors.darkInfo500,
        error: AppColors.darkError500,
        surface: AppColors.darkNeutral50,
        onSurface: AppColors.darkNeutral900,
        surfaceContainerHighest: AppColors.darkNeutral100,
        outline: AppColors.darkNeutral400,
      ),

      // 文本主题 - 深色版本
      textTheme: TextTheme(
        displayLarge: AppTextStyles.h1.copyWith(color: AppColors.darkNeutral900),
        displayMedium: AppTextStyles.h2.copyWith(color: AppColors.darkNeutral900),
        displaySmall: AppTextStyles.h3.copyWith(color: AppColors.darkNeutral900),
        headlineLarge: AppTextStyles.h4.copyWith(color: AppColors.darkNeutral900),
        headlineMedium: AppTextStyles.h5.copyWith(color: AppColors.darkNeutral900),
        headlineSmall: AppTextStyles.h6.copyWith(color: AppColors.darkNeutral900),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.darkNeutral800),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.darkNeutral800),
        bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.darkNeutral700),
        labelLarge: AppTextStyles.button.copyWith(color: AppColors.darkNeutral900),
        labelMedium: AppTextStyles.caption.copyWith(color: AppColors.darkNeutral600),
        labelSmall: AppTextStyles.overline.copyWith(color: AppColors.darkNeutral600),
      ),

      // AppBar主题
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.darkNeutral900,
        titleTextStyle: AppTextStyles.h5.copyWith(
          color: AppColors.darkNeutral900,
        ),
      ),

      // 底部导航栏主题
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        backgroundColor: AppColors.darkNeutral50,
        selectedItemColor: AppColors.darkInfo500,
        unselectedItemColor: AppColors.darkNeutral600,
        selectedLabelStyle: AppTextStyles.caption.copyWith(
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: AppTextStyles.caption,
      ),

      // 卡片主题
      cardTheme: CardThemeData(
        elevation: 2,
        color: AppColors.darkNeutral100,
        surfaceTintColor: AppColors.darkPrimary200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
        margin: EdgeInsets.all(AppSpacing.sm),
      ),

      // 按钮主题
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),

      // 输入框主题
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkNeutral200,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(color: AppColors.darkNeutral400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(color: AppColors.darkNeutral400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(color: AppColors.darkInfo500, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(color: AppColors.darkError500, width: 2),
        ),
        labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.darkNeutral700),
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.darkNeutral500),
      ),

      // 对话框主题
      dialogTheme: DialogThemeData(
        elevation: 8,
        backgroundColor: AppColors.darkNeutral100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        ),
        titleTextStyle: AppTextStyles.h4.copyWith(
          color: AppColors.darkNeutral900,
        ),
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.darkNeutral800,
        ),
      ),

      // FloatingActionButton主题
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        ),
      ),
    );
  }
}

/// 主题模式提供者 - 支持持久化存储
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

/// 主题模式状态管理器
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadThemeMode();
  }

  static const String themeKey = 'theme_mode';

  /// 从本地存储加载主题模式
  Future<void> _loadThemeMode() async {
    try {
      final storageService = ServiceLocator.get<StorageService>();
      final savedTheme = storageService.prefs.getString(themeKey);
      if (savedTheme != null) {
        switch (savedTheme) {
          case 'light':
            state = ThemeMode.light;
          case 'dark':
            state = ThemeMode.dark;
          case 'system':
          default:
            state = ThemeMode.system;
        }
      }
    } catch (e) {
      // 如果加载失败，使用默认主题
      state = ThemeMode.system;
    }
  }

  /// 切换到下一个主题模式
  Future<void> toggleThemeMode() async {
    ThemeMode newMode;
    switch (state) {
      case ThemeMode.system:
        newMode = ThemeMode.light;
      case ThemeMode.light:
        newMode = ThemeMode.dark;
      case ThemeMode.dark:
        newMode = ThemeMode.system;
    }
    await setThemeMode(newMode);
  }

  /// 设置特定的主题模式
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _saveThemeMode(mode);
  }

  /// 保存主题模式到本地存储
  Future<void> _saveThemeMode(ThemeMode mode) async {
    try {
      String modeString;
      switch (mode) {
        case ThemeMode.light:
          modeString = 'light';
        case ThemeMode.dark:
          modeString = 'dark';
        case ThemeMode.system:
          modeString = 'system';
      }
      await StorageService.instance.prefs.setString(themeKey, modeString);
    } catch (e) {
      // 保存失败时的错误处理
      debugPrint('Failed to save theme mode: $e');
    }
  }

  /// 获取当前主题模式的显示名称
  String getThemeModeDisplayName() {
    switch (state) {
      case ThemeMode.light:
        return '浅色主题';
      case ThemeMode.dark:
        return '深色主题';
      case ThemeMode.system:
        return '跟随系统';
    }
  }

  /// 获取当前主题模式的图标
  IconData getThemeModeIcon() {
    switch (state) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }
}
