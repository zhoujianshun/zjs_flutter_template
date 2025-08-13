# 主题切换功能指南

本指南介绍如何使用项目中的主题切换功能。

## 🎨 功能特性

- ✅ **三种主题模式**: 浅色、深色、跟随系统
- ✅ **持久化存储**: 用户选择会自动保存
- ✅ **多种UI样式**: 列表项、图标按钮、分段按钮、下拉菜单
- ✅ **自动初始化**: 应用启动时自动加载用户偏好
- ✅ **实时切换**: 无需重启应用即可生效

## 🏗️ 架构设计

### 核心组件

1. **ThemeModeNotifier**: 主题状态管理器
2. **ThemeSwitcher**: 可配置的主题切换UI组件
3. **AppTheme**: 主题配置类

### 状态管理

使用 Riverpod 的 `StateNotifierProvider` 管理主题状态：

```dart
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});
```

## 🎯 使用方法

### 1. 在应用中使用主题

```dart
class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      // ...
    );
  }
}
```

### 2. 添加主题切换UI

#### 列表项样式（推荐用于设置页面）

```dart
const ThemeSwitcher(
  style: ThemeSwitcherStyle.listTile,
)
```

#### 图标按钮样式（推荐用于工具栏）

```dart
const ThemeSwitcher(
  style: ThemeSwitcherStyle.iconButton,
  showLabel: false,
)
```

#### 分段按钮样式（推荐用于设置面板）

```dart
const ThemeSwitcher(
  style: ThemeSwitcherStyle.segmentedButton,
)
```

#### 下拉菜单样式（推荐用于表单）

```dart
const ThemeSwitcher(
  style: ThemeSwitcherStyle.dropdown,
)
```

### 3. 快捷组件

#### 浮动操作按钮

```dart
const ThemeToggleFab()
```

#### 应用栏按钮

```dart
const AppBarThemeButton()
```

### 4. 程序化控制

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeNotifier = ref.read(themeModeProvider.notifier);
    
    return ElevatedButton(
      onPressed: () {
        // 切换到下一个主题
        themeModeNotifier.toggleThemeMode();
        
        // 或设置特定主题
        // themeModeNotifier.setThemeMode(ThemeMode.dark);
      },
      child: Text('切换主题'),
    );
  }
}
```

## 📱 实际应用

### 个人中心页面

在个人中心页面中，主题切换器作为列表项显示：

```dart
_buildMenuSection(
  title: '应用设置',
  customWidgets: [
    const ThemeSwitcher(), // 默认为 listTile 样式
  ],
),
```

### 首页工具栏

在首页的应用栏中添加快速切换按钮：

```dart
AppBar(
  title: const Text('首页'),
  actions: const [
    AppBarThemeButton(),
  ],
),
```

### 浮动操作按钮

在首页添加主题切换的浮动按钮：

```dart
Scaffold(
  // ...
  floatingActionButton: const ThemeToggleFab(),
)
```

## 🔧 自定义配置

### 修改主题颜色

在 `AppTheme` 类中修改主色调：

```dart
class AppTheme {
  // 修改这些颜色常量
  static const Color _primaryColor = Color(0xFF2196F3);
  static const Color _secondaryColor = Color(0xFF03DAC6);
  static const Color _errorColor = Color(0xFFB00020);
}
```

### 添加新的主题模式

1. 在 `ThemeMode` 枚举中添加新模式（如果需要）
2. 在 `ThemeModeNotifier` 中添加相应的处理逻辑
3. 更新 UI 组件以支持新模式

### 自定义存储键

在 `ThemeModeNotifier` 中修改存储键：

```dart
await StorageService.setString('your_custom_theme_key', modeString);
```

## 🧪 测试

项目包含完整的单元测试：

```bash
# 运行主题相关测试
flutter test test/unit/config/themes/theme_switcher_test.dart

# 运行所有测试
flutter test
```

## 🎨 UI 展示

### 主题模式对比

- **浅色主题**: 白色背景，深色文字，适合白天使用
- **深色主题**: 深色背景，浅色文字，适合夜间使用
- **跟随系统**: 自动跟随系统设置

### 切换动画

主题切换是平滑的，无需重启应用，用户体验流畅。

## 📚 最佳实践

1. **合理放置**: 在设置页面使用列表项样式，在工具栏使用图标按钮
2. **用户友好**: 提供清晰的视觉反馈和说明文字
3. **持久化**: 确保用户选择能够保存并在下次启动时恢复
4. **测试覆盖**: 为主题切换功能编写测试用例
5. **性能考虑**: 避免频繁的主题切换影响性能

## 🔍 故障排除

### 主题没有保存

检查 `StorageService` 是否正确初始化：

```dart
await StorageService.init();
```

### 主题切换没有生效

确保在 `MaterialApp` 中正确使用了主题提供者：

```dart
final themeMode = ref.watch(themeModeProvider);
```

### 测试中的存储错误

在测试环境中，存储服务可能未初始化，这是正常的。测试仍会通过，只是会有警告信息。

---

通过以上配置，您就拥有了一个功能完整、用户友好的主题切换系统！🎉
