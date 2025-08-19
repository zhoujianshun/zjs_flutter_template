import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zjs_flutter_template/config/routes/app_router.dart';
import 'package:zjs_flutter_template/config/routes/route_paths.dart';
import 'package:zjs_flutter_template/core/error_handling/global_error_handler.dart';
import 'package:zjs_flutter_template/core/utils/logger.dart';

/// 路由导航工具类
///
/// 提供了常用的导航方法，包括：
/// - 基础导航（push、pop、replace等）
/// - 命名路由导航
/// - 路径导航
/// - 对话框导航
/// - 底部表单导航
/// - 路由状态管理
/// - 错误处理和日志记录
class RouteUtil {
  RouteUtil._();

  /// 获取当前上下文
  static BuildContext? get _context => AppRouter.rootNavigatorKey.currentContext;

  /// 获取当前GoRouter实例
  static GoRouter? get _router => _context != null ? GoRouter.of(_context!) : null;

  /// 获取当前路由路径
  static String get currentPath {
    try {
      return _router?.routerDelegate.currentConfiguration.uri.path ?? '/';
    } catch (e) {
      AppLogger.error('获取当前路由路径失败', error: e);
      return '/';
    }
  }

  /// 获取当前路由名称
  static String get currentRouteName {
    return RoutePaths.getRouteName(currentPath);
  }

  /// 检查当前路由是否需要认证
  static bool get currentRouteRequiresAuth {
    return RoutePaths.requiresAuth(currentPath);
  }

  // ===== 基础导航方法 =====

  /// 导航到指定路径
  ///
  /// [path] 目标路径
  /// [extra] 额外数据
  /// [replace] 是否替换当前路由
  static Future<T?> go<T extends Object?>(
    String path, {
    Object? extra,
    bool replace = false,
  }) async {
    try {
      if (_context == null) {
        throw Exception('Navigation context is null');
      }

      AppLogger.info('导航到: $path, replace: $replace');

      if (replace) {
        _context!.go(path, extra: extra);
        return null;
      } else {
        return await _context!.push<T>(path, extra: extra);
      }
    } catch (e, stackTrace) {
      GlobalErrorHandler.instance.reportError(
        e,
        stackTrace,
        context: 'RouteUtil.go',
        errorType: ErrorType.manualReport,
        additionalInfo: {
          'path': path,
          'replace': replace,
          'has_extra': extra != null,
        },
      );
      return null;
    }
  }

  /// 推送新路由
  ///
  /// [path] 目标路径
  /// [extra] 额外数据
  static Future<T?> push<T extends Object?>(
    String path, {
    Object? extra,
  }) async {
    try {
      if (_context == null) {
        throw Exception('Navigation context is null');
      }

      AppLogger.info('推送路由: $path');
      return await _context!.push<T>(path, extra: extra);
    } catch (e, stackTrace) {
      GlobalErrorHandler.instance.reportError(
        e,
        stackTrace,
        context: 'RouteUtil.push',
        errorType: ErrorType.manualReport,
        additionalInfo: {
          'path': path,
          'has_extra': extra != null,
        },
      );
      return null;
    }
  }

  /// 推送命名路由
  ///
  /// [name] 路由名称
  /// [pathParameters] 路径参数
  /// [queryParameters] 查询参数
  /// [extra] 额外数据
  static Future<T?> pushNamed<T extends Object?>(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) async {
    try {
      if (_context == null) {
        throw Exception('Navigation context is null');
      }

      AppLogger.info('推送命名路由: $name');
      return await _context!.pushNamed<T>(
        name,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        extra: extra,
      );
    } catch (e, stackTrace) {
      GlobalErrorHandler.instance.reportError(
        e,
        stackTrace,
        context: 'RouteUtil.pushNamed',
        errorType: ErrorType.manualReport,
        additionalInfo: {
          'name': name,
          'pathParameters': pathParameters,
          'queryParameters': queryParameters,
          'has_extra': extra != null,
        },
      );
      return null;
    }
  }

  /// 替换当前路由
  ///
  /// [path] 目标路径
  /// [extra] 额外数据
  static void replace(String path, {Object? extra}) {
    try {
      if (_context == null) {
        throw Exception('Navigation context is null');
      }

      AppLogger.info('替换路由: $path');
      _context!.pushReplacement(path, extra: extra);
    } catch (e, stackTrace) {
      GlobalErrorHandler.instance.reportError(
        e,
        stackTrace,
        context: 'RouteUtil.replace',
        errorType: ErrorType.manualReport,
        additionalInfo: {
          'path': path,
          'has_extra': extra != null,
        },
      );
    }
  }

  /// 替换命名路由
  ///
  /// [name] 路由名称
  /// [pathParameters] 路径参数
  /// [queryParameters] 查询参数
  /// [extra] 额外数据
  static void replaceNamed(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    try {
      if (_context == null) {
        throw Exception('Navigation context is null');
      }

      AppLogger.info('替换命名路由: $name');
      _context!.pushReplacementNamed(
        name,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        extra: extra,
      );
    } catch (e, stackTrace) {
      GlobalErrorHandler.instance.reportError(
        e,
        stackTrace,
        context: 'RouteUtil.replaceNamed',
        errorType: ErrorType.manualReport,
        additionalInfo: {
          'name': name,
          'pathParameters': pathParameters,
          'queryParameters': queryParameters,
          'has_extra': extra != null,
        },
      );
    }
  }

  /// 返回上一页
  ///
  /// [result] 返回结果
  static void pop<T extends Object?>([T? result]) {
    try {
      if (_context == null) {
        throw Exception('Navigation context is null');
      }

      if (canPop()) {
        AppLogger.info('返回上一页');
        _context!.pop(result);
      } else {
        AppLogger.warning('无法返回上一页，已在根路由');
      }
    } catch (e, stackTrace) {
      GlobalErrorHandler.instance.reportError(
        e,
        stackTrace,
        context: 'RouteUtil.pop',
        errorType: ErrorType.manualReport,
        additionalInfo: {
          'has_result': result != null,
        },
      );
    }
  }

  /// 检查是否可以返回
  static bool canPop() {
    try {
      return _context?.canPop() ?? false;
    } catch (e) {
      AppLogger.error('检查canPop失败', error: e);
      return false;
    }
  }

  /// 返回到指定路由
  ///
  /// [path] 目标路径
  static void popUntil(String path) {
    try {
      if (_context == null) {
        throw Exception('Navigation context is null');
      }

      AppLogger.info('返回到路由: $path');
      _context!.go(path);
    } catch (e, stackTrace) {
      GlobalErrorHandler.instance.reportError(
        e,
        stackTrace,
        context: 'RouteUtil.popUntil',
        errorType: ErrorType.manualReport,
        additionalInfo: {
          'path': path,
        },
      );
    }
  }

  /// 清空路由栈并导航到指定路径
  ///
  /// [path] 目标路径
  /// [extra] 额外数据
  static void pushAndRemoveUntil(String path, {Object? extra}) {
    try {
      if (_context == null) {
        throw Exception('Navigation context is null');
      }

      AppLogger.info('清空栈并导航到: $path');
      _context!.go(path, extra: extra);
    } catch (e, stackTrace) {
      GlobalErrorHandler.instance.reportError(
        e,
        stackTrace,
        context: 'RouteUtil.pushAndRemoveUntil',
        errorType: ErrorType.manualReport,
        additionalInfo: {
          'path': path,
          'has_extra': extra != null,
        },
      );
    }
  }

  // ===== 常用页面导航 =====

  /// 导航到首页
  static void goHome() {
    go(RoutePaths.home);
  }

  /// 导航到登录页
  static void goLogin() {
    go(RoutePaths.login);
  }

  /// 导航到个人资料页
  static void goProfile() {
    go(RoutePaths.profile);
  }

  /// 导航到设置页
  static void goSettings() {
    go(RoutePaths.settings);
  }

  /// 导航到主题设置页
  static void goThemeSettings() {
    go(RoutePaths.themeSettings);
  }

  /// 导航到语言设置页
  static void goLanguageSettings() {
    go(RoutePaths.languageSettings);
  }

  /// 导航到引导页
  static void goOnboarding() {
    go(RoutePaths.onboarding);
  }

  /// 导航到启动页
  static void goSplash() {
    go(RoutePaths.splash);
  }

  /// 导航到404页面
  static void goNotFound() {
    go(RoutePaths.notFound);
  }

  /// 导航到错误页面
  static void goError() {
    go(RoutePaths.error);
  }

  // ===== 对话框导航 =====

  /// 显示模态对话框
  ///
  /// [builder] 对话框构建器
  /// [barrierDismissible] 是否可以通过点击背景关闭
  /// [barrierColor] 背景颜色
  /// [useSafeArea] 是否使用安全区域
  static Future<T?> showModalDialog<T>({
    required WidgetBuilder builder,
    bool barrierDismissible = true,
    Color? barrierColor,
    bool useSafeArea = true,
    RouteSettings? routeSettings,
  }) async {
    try {
      if (_context == null) {
        throw Exception('Navigation context is null');
      }

      AppLogger.info('显示对话框');
      return await showDialog<T>(
        context: _context!,
        builder: builder,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        useSafeArea: useSafeArea,
        routeSettings: routeSettings,
      );
    } catch (e, stackTrace) {
      GlobalErrorHandler.instance.reportError(
        e,
        stackTrace,
        context: 'RouteUtil.showModalDialog',
        errorType: ErrorType.manualReport,
        additionalInfo: {
          'barrierDismissible': barrierDismissible,
          'useSafeArea': useSafeArea,
        },
      );
      return null;
    }
  }

  /// 显示警告对话框
  ///
  /// [title] 标题
  /// [content] 内容
  /// [confirmText] 确认按钮文本
  /// [cancelText] 取消按钮文本
  /// [onConfirm] 确认回调
  /// [onCancel] 取消回调
  static Future<bool?> showAlertDialog({
    required String title,
    required String content,
    String confirmText = '确定',
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) async {
    try {
      if (_context == null) {
        throw Exception('Navigation context is null');
      }

      AppLogger.info('显示警告对话框: $title');
      return await showDialog<bool>(
        context: _context!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              if (cancelText != null)
                TextButton(
                  onPressed: () {
                    onCancel?.call();
                    Navigator.of(context).pop(false);
                  },
                  child: Text(cancelText),
                ),
              TextButton(
                onPressed: () {
                  onConfirm?.call();
                  Navigator.of(context).pop(true);
                },
                child: Text(confirmText),
              ),
            ],
          );
        },
      );
    } catch (e, stackTrace) {
      GlobalErrorHandler.instance.reportError(
        e,
        stackTrace,
        context: 'RouteUtil.showAlertDialog',
        errorType: ErrorType.manualReport,
        additionalInfo: {
          'title': title,
          'content': content,
        },
      );
      return null;
    }
  }

  /// 显示确认对话框
  ///
  /// [title] 标题
  /// [content] 内容
  /// [confirmText] 确认按钮文本
  /// [cancelText] 取消按钮文本
  static Future<bool> showConfirmDialog({
    required String title,
    required String content,
    String confirmText = '确定',
    String cancelText = '取消',
  }) async {
    final result = await showAlertDialog(
      title: title,
      content: content,
      confirmText: confirmText,
      cancelText: cancelText,
    );
    return result ?? false;
  }

  // ===== 底部表单导航 =====

  /// 显示底部表单
  ///
  /// [builder] 表单构建器
  /// [isScrollControlled] 是否可滚动控制
  /// [isDismissible] 是否可以通过下拉关闭
  /// [enableDrag] 是否启用拖拽
  /// [backgroundColor] 背景颜色
  /// [elevation] 阴影高度
  /// [shape] 形状
  static Future<T?> showBottomSheet<T>({
    required WidgetBuilder builder,
    bool isScrollControlled = false,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    RouteSettings? routeSettings,
  }) async {
    try {
      if (_context == null) {
        throw Exception('Navigation context is null');
      }

      AppLogger.info('显示底部表单');
      return await showModalBottomSheet<T>(
        context: _context!,
        builder: builder,
        isScrollControlled: isScrollControlled,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        backgroundColor: backgroundColor,
        elevation: elevation,
        shape: shape,
        clipBehavior: clipBehavior,
        routeSettings: routeSettings,
      );
    } catch (e, stackTrace) {
      GlobalErrorHandler.instance.reportError(
        e,
        stackTrace,
        context: 'RouteUtil.showBottomSheet',
        errorType: ErrorType.manualReport,
        additionalInfo: {
          'isScrollControlled': isScrollControlled,
          'isDismissible': isDismissible,
          'enableDrag': enableDrag,
        },
      );
      return null;
    }
  }

  // ===== SnackBar 相关 =====

  /// 显示SnackBar
  ///
  /// [message] 消息内容
  /// [duration] 显示时长
  /// [action] 操作按钮
  /// [backgroundColor] 背景颜色
  static void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    Color? backgroundColor,
  }) {
    try {
      if (_context == null) {
        throw Exception('Navigation context is null');
      }

      AppLogger.info('显示SnackBar: $message');
      ScaffoldMessenger.of(_context!).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: duration,
          action: action,
          backgroundColor: backgroundColor,
        ),
      );
    } catch (e, stackTrace) {
      GlobalErrorHandler.instance.reportError(
        e,
        stackTrace,
        context: 'RouteUtil.showSnackBar',
        errorType: ErrorType.manualReport,
        additionalInfo: {
          'message': message,
          'duration_ms': duration.inMilliseconds,
        },
      );
    }
  }

  /// 显示成功消息
  static void showSuccessMessage(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.green,
    );
  }

  /// 显示错误消息
  static void showErrorMessage(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 5),
    );
  }

  /// 显示警告消息
  static void showWarningMessage(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.orange,
    );
  }

  /// 显示信息消息
  static void showInfoMessage(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.blue,
    );
  }

  // ===== 路由状态管理 =====

  /// 获取路由参数
  static Map<String, String> getPathParameters() {
    try {
      final state = _router?.routerDelegate.currentConfiguration;
      return state?.pathParameters ?? {};
    } catch (e) {
      AppLogger.error('获取路由参数失败', error: e);
      return {};
    }
  }

  /// 获取查询参数
  static Map<String, String> getQueryParameters() {
    try {
      final state = _router?.routerDelegate.currentConfiguration;
      return state?.uri.queryParameters ?? {};
    } catch (e) {
      AppLogger.error('获取查询参数失败', error: e);
      return {};
    }
  }

  /// 获取额外数据
  static Object? getExtra() {
    try {
      final state = _router?.routerDelegate.currentConfiguration;
      return state?.extra;
    } catch (e) {
      AppLogger.error('获取额外数据失败', error: e);
      return null;
    }
  }

  /// 检查当前是否在指定路由
  static bool isCurrentRoute(String path) {
    return currentPath == path;
  }

  /// 检查当前路由是否匹配模式
  static bool matchesRoute(String pattern) {
    try {
      final regex = RegExp(pattern);
      return regex.hasMatch(currentPath);
    } catch (e) {
      AppLogger.error('路由模式匹配失败', error: e);
      return false;
    }
  }

  // ===== 工具方法 =====

  /// 安全执行导航操作
  static Future<T?> safeNavigate<T>(Future<T?> Function() navigation) async {
    try {
      return await navigation();
    } catch (e, stackTrace) {
      GlobalErrorHandler.instance.reportError(
        e,
        stackTrace,
        context: 'RouteUtil.safeNavigate',
        errorType: ErrorType.manualReport,
      );
      return null;
    }
  }

  /// 延迟导航
  static Future<void> delayedNavigate(
    Duration delay,
    Future<void> Function() navigation,
  ) async {
    try {
      await Future<void>.delayed(delay);
      await navigation();
    } catch (e, stackTrace) {
      GlobalErrorHandler.instance.reportError(
        e,
        stackTrace,
        context: 'RouteUtil.delayedNavigate',
        errorType: ErrorType.manualReport,
        additionalInfo: {
          'delay_ms': delay.inMilliseconds,
        },
      );
    }
  }

  /// 条件导航
  static Future<void> conditionalNavigate({
    required bool condition,
    required Future<void> Function() navigation,
    Future<void> Function()? elseNavigation,
  }) async {
    try {
      if (condition) {
        await navigation();
      } else if (elseNavigation != null) {
        await elseNavigation();
      }
    } catch (e, stackTrace) {
      GlobalErrorHandler.instance.reportError(
        e,
        stackTrace,
        context: 'RouteUtil.conditionalNavigate',
        errorType: ErrorType.manualReport,
        additionalInfo: {
          'condition': condition,
          'has_else_navigation': elseNavigation != null,
        },
      );
    }
  }

  /// 打印当前路由状态（仅调试模式）
  static void debugPrintRouteState() {
    if (!kDebugMode) return;

    try {
      AppLogger.debug('=== 当前路由状态 ===');
      AppLogger.debug('路径: $currentPath');
      AppLogger.debug('名称: $currentRouteName');
      AppLogger.debug('需要认证: $currentRouteRequiresAuth');
      AppLogger.debug('路径参数: ${getPathParameters()}');
      AppLogger.debug('查询参数: ${getQueryParameters()}');
      AppLogger.debug('可以返回: ${canPop()}');
      AppLogger.debug('==================');
    } catch (e) {
      AppLogger.error('打印路由状态失败', error: e);
    }
  }
}

/// 路由导航扩展
extension RouteUtilExtension on BuildContext {
  /// 快速导航到指定路径
  void goTo(String path, {Object? extra}) {
    RouteUtil.go(path, extra: extra);
  }

  /// 快速返回
  void goBack<T>([T? result]) {
    RouteUtil.pop(result);
  }

  /// 快速显示消息
  void showMessage(String message) {
    RouteUtil.showSnackBar(message);
  }

  /// 快速显示成功消息
  void showSuccess(String message) {
    RouteUtil.showSuccessMessage(message);
  }

  /// 快速显示错误消息
  void showError(String message) {
    RouteUtil.showErrorMessage(message);
  }
}
