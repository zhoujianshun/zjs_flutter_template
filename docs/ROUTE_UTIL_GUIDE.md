# RouteUtil 路由导航工具指南

## 概述

`RouteUtil` 是一个功能强大的路由导航工具类，基于 GoRouter 封装，提供了统一、安全、便捷的导航方法。

## 核心特性

- ✅ **统一API**: 封装了所有常用的导航操作
- ✅ **错误处理**: 自动捕获和处理导航错误
- ✅ **类型安全**: 完整的TypeScript支持
- ✅ **日志记录**: 自动记录导航操作日志
- ✅ **扩展方法**: 提供BuildContext扩展方法
- ✅ **状态管理**: 获取当前路由状态信息

## 基础用法

### 导入

```dart
import 'package:zjs_flutter_template/core/utils/route_util.dart';
```

### 基础导航

```dart
// 推送新页面
RouteUtil.push('/profile');

// 推送并等待返回结果
final result = await RouteUtil.push<String>('/profile');

// 替换当前页面
RouteUtil.replace('/settings');

// 返回上一页
RouteUtil.pop();

// 返回上一页并传递结果
RouteUtil.pop('result_data');

// 返回到指定路由
RouteUtil.popUntil('/home');

// 清空栈并导航
RouteUtil.pushAndRemoveUntil('/login');
```

### 命名路由导航

```dart
// 基础命名路由
RouteUtil.pushNamed('profile');

// 带参数的命名路由
RouteUtil.pushNamed(
  'user_detail',
  pathParameters: {'userId': '123'},
  queryParameters: {'tab': 'settings'},
  extra: {'user': userObject},
);

// 替换命名路由
RouteUtil.replaceNamed('login');
```

## 快速导航方法

```dart
// 常用页面快速导航
RouteUtil.goHome();          // 首页
RouteUtil.goLogin();         // 登录页
RouteUtil.goProfile();       // 个人资料
RouteUtil.goSettings();      // 设置页
RouteUtil.goThemeSettings(); // 主题设置
RouteUtil.goLanguageSettings(); // 语言设置
```

## 对话框和弹窗

### 自定义对话框

```dart
final result = await RouteUtil.showModalDialog<String>(
  builder: (context) => AlertDialog(
    title: Text('标题'),
    content: Text('内容'),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop('confirm'),
        child: Text('确定'),
      ),
    ],
  ),
);
```

### 预设对话框

```dart
// 警告对话框
RouteUtil.showAlertDialog(
  title: '警告',
  content: '确定要删除这个项目吗？',
  confirmText: '删除',
  cancelText: '取消',
  onConfirm: () => print('用户确认删除'),
  onCancel: () => print('用户取消操作'),
);

// 确认对话框
final confirmed = await RouteUtil.showConfirmDialog(
  title: '确认操作',
  content: '您确定要执行此操作吗？',
);

if (confirmed) {
  // 执行操作
}
```

### 底部表单

```dart
// 简单底部表单
RouteUtil.showBottomSheet(
  builder: (context) => Container(
    height: 200,
    child: Column(
      children: [
        Text('底部表单内容'),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('关闭'),
        ),
      ],
    ),
  ),
);

// 可滚动底部表单
RouteUtil.showBottomSheet(
  isScrollControlled: true,
  builder: (context) => DraggableScrollableSheet(
    initialChildSize: 0.6,
    builder: (context, scrollController) => ListView.builder(
      controller: scrollController,
      itemCount: 100,
      itemBuilder: (context, index) => ListTile(
        title: Text('项目 $index'),
      ),
    ),
  ),
);
```

## 消息提示

```dart
// 基础消息
RouteUtil.showSnackBar('这是一条消息');

// 预设类型消息
RouteUtil.showSuccessMessage('操作成功！');
RouteUtil.showErrorMessage('操作失败！');
RouteUtil.showWarningMessage('警告信息！');
RouteUtil.showInfoMessage('提示信息！');

// 带操作的消息
RouteUtil.showSnackBar(
  '文件已删除',
  action: SnackBarAction(
    label: '撤销',
    onPressed: () => print('撤销删除'),
  ),
);
```

## 路由状态管理

```dart
// 获取当前路由信息
String currentPath = RouteUtil.currentPath;
String routeName = RouteUtil.currentRouteName;
bool requiresAuth = RouteUtil.currentRouteRequiresAuth;
bool canGoBack = RouteUtil.canPop();

// 获取路由参数
Map<String, String> pathParams = RouteUtil.getPathParameters();
Map<String, String> queryParams = RouteUtil.getQueryParameters();
Object? extraData = RouteUtil.getExtra();

// 路由检查
bool isHome = RouteUtil.isCurrentRoute('/home');
bool isSettings = RouteUtil.matchesRoute(r'^/settings');
```

## 高级功能

### 安全导航

```dart
// 安全执行导航操作，自动处理异常
final result = await RouteUtil.safeNavigate(() async {
  return await RouteUtil.push('/risky_page');
});

if (result != null) {
  print('导航成功');
} else {
  print('导航失败，已记录错误');
}
```

### 延迟导航

```dart
// 3秒后导航到设置页
RouteUtil.delayedNavigate(
  Duration(seconds: 3),
  () => RouteUtil.go('/settings'),
);
```

### 条件导航

```dart
// 根据条件选择不同的导航路径
RouteUtil.conditionalNavigate(
  user.isLoggedIn,
  () => RouteUtil.go('/dashboard'),
  elseNavigation: () => RouteUtil.go('/login'),
);
```

## BuildContext 扩展方法

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => context.goTo('/profile'),
          child: Text('使用扩展导航'),
        ),
        ElevatedButton(
          onPressed: () => context.goBack(),
          child: Text('使用扩展返回'),
        ),
        ElevatedButton(
          onPressed: () => context.showSuccess('成功消息'),
          child: Text('显示成功消息'),
        ),
        ElevatedButton(
          onPressed: () => context.showError('错误消息'),
          child: Text('显示错误消息'),
        ),
      ],
    );
  }
}
```

## 错误处理

RouteUtil 会自动处理以下情况：

1. **Context 为空**: 自动检查并记录错误
2. **导航异常**: 捕获异常并上报到全局错误处理器
3. **参数错误**: 验证参数并提供默认值
4. **状态异常**: 安全地获取路由状态信息

所有错误都会被记录到日志系统，便于调试和监控。

## 调试功能

```dart
// 打印当前路由状态（仅在调试模式下）
RouteUtil.debugPrintRouteState();
```

输出示例：

```
=== 当前路由状态 ===
路径: /profile
名称: Profile
需要认证: true
路径参数: {userId: 123}
查询参数: {tab: settings}
可以返回: true
==================
```

## 最佳实践

### 1. 使用类型安全的导航

```dart
// 推荐：指定返回类型
final result = await RouteUtil.push<UserData>('/user_editor');

// 不推荐：不指定类型
final result = await RouteUtil.push('/user_editor');
```

### 2. 合理使用快速导航方法

```dart
// 推荐：使用快速方法
RouteUtil.goHome();

// 不推荐：手动拼接路径
RouteUtil.go('/home');
```

### 3. 错误处理

```dart
// 推荐：使用安全导航
final result = await RouteUtil.safeNavigate(() async {
  return await someRiskyNavigation();
});

// 不推荐：不处理异常
try {
  await someRiskyNavigation();
} catch (e) {
  // 手动处理
}
```

### 4. 消息提示

```dart
// 推荐：使用预设类型
RouteUtil.showSuccessMessage('操作成功');

// 不推荐：手动设置颜色
RouteUtil.showSnackBar('操作成功', backgroundColor: Colors.green);
```

## 性能优化

1. **避免频繁导航**: 防止用户快速点击导致多次导航
2. **合理使用缓存**: 对于复杂的页面，考虑使用页面缓存
3. **延迟加载**: 对于不常用的页面，使用延迟导航
4. **内存管理**: 及时释放页面资源

## 故障排除

### 常见问题

1. **导航不生效**
   - 检查路由路径是否正确
   - 确认路由是否已在 GoRouter 中定义
   - 检查路由守卫是否阻止了导航

2. **Context 错误**
   - 确保在 Widget 的 build 方法中调用
   - 检查是否在异步操作后使用了已销毁的 Context

3. **参数传递问题**
   - 使用正确的参数类型
   - 检查参数名称是否匹配路由定义

### 调试技巧

```dart
// 开启详细日志
RouteUtil.debugPrintRouteState();

// 检查当前状态
print('Current path: ${RouteUtil.currentPath}');
print('Can pop: ${RouteUtil.canPop()}');
```

## 扩展开发

如果需要添加自定义导航方法，可以扩展 RouteUtil：

```dart
extension CustomRouteUtil on RouteUtil {
  static void goToUserProfile(String userId) {
    RouteUtil.pushNamed(
      'user_profile',
      pathParameters: {'userId': userId},
    );
  }
  
  static Future<void> showCustomDialog() async {
    return RouteUtil.showModalDialog(
      builder: (context) => MyCustomDialog(),
    );
  }
}
```

## 总结

RouteUtil 提供了：

- ✅ **完整的导航功能**: 覆盖所有常用导航场景
- ✅ **错误处理机制**: 自动捕获和处理导航异常
- ✅ **类型安全**: 完整的泛型支持
- ✅ **便捷的API**: 简化复杂的导航操作
- ✅ **扩展性强**: 支持自定义扩展
- ✅ **调试友好**: 提供丰富的调试信息

通过使用 RouteUtil，您可以大大简化应用的导航逻辑，提高代码的可维护性和稳定性。
