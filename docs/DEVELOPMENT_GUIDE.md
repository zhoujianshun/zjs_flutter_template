# 开发指南

本指南将帮助您快速上手项目开发，了解项目结构和开发规范。

## 📋 目录

- [项目结构](#项目结构)
- [开发环境配置](#开发环境配置)
- [编码规范](#编码规范)
- [状态管理](#状态管理)
- [路由导航](#路由导航)
- [网络请求](#网络请求)
- [数据存储](#数据存储)
- [测试指南](#测试指南)
- [性能优化](#性能优化)

## 项目结构

### 核心目录说明

```text
lib/
├── core/                    # 核心基础设施
│   ├── constants/          # 应用常量定义
│   ├── errors/             # 错误和异常处理
│   ├── network/            # 网络配置和API客户端
│   ├── storage/            # 数据存储服务
│   └── utils/              # 工具类和帮助方法
├── features/               # 功能模块（按业务划分）
│   ├── auth/              # 认证模块
│   │   └── presentation/  # UI层
│   │       ├── pages/     # 页面
│   │       └── widgets/   # 组件
│   ├── home/              # 首页模块
│   ├── profile/           # 个人中心模块
│   ├── settings/          # 设置模块
│   │   └── presentation/  # UI层
│   │       └── pages/     # 设置页面
│   ├── onboarding/        # 引导页模块
│   └── app_shell.dart     # 应用外壳（底部导航）
├── shared/                # 共享组件和服务
│   ├── widgets/           # 通用UI组件
│   ├── models/            # 数据模型
│   └── services/          # 共享业务服务
├── config/                # 配置文件
│   ├── routes/            # 路由配置
│   ├── themes/            # 主题配置
│   └── env/               # 环境配置
└── l10n/                  # 国际化文件
```

## 开发环境配置

### 1. IDE配置

推荐使用 VS Code 作为开发IDE，项目已包含相关配置：

```json
// .vscode/settings.json
{
  "dart.flutterSdkPath": "[your-flutter-sdk-path]",
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": true
  }
}
```

### 2. 必要插件

- Flutter
- Dart
- Flutter Riverpod Snippets
- Flutter Tree
- Awesome Flutter Snippets

### 3. 代码生成

项目使用代码生成来减少样板代码：

```bash
# 生成所有代码
flutter packages pub run build_runner build

# 监听文件变化自动生成
flutter packages pub run build_runner watch

# 清理后重新生成
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## 编码规范

### 1. 命名约定

- **文件命名**: 使用蛇形命名法 `snake_case`
- **类命名**: 使用帕斯卡命名法 `PascalCase`
- **变量/方法命名**: 使用驼峰命名法 `camelCase`
- **常量命名**: 使用全大写蛇形命名法 `SCREAMING_SNAKE_CASE`

### 2. 目录组织

```text
feature_name/
├── data/                  # 数据层（如果需要）
│   ├── models/           # 数据模型
│   ├── repositories/     # 数据仓库实现
│   └── data_sources/     # 数据源（API/本地）
├── domain/                # 业务层（如果需要）
│   ├── entities/         # 业务实体
│   ├── repositories/     # 数据仓库接口
│   └── use_cases/        # 业务用例
└── presentation/          # 表现层
    ├── pages/            # 页面
    ├── widgets/          # 组件
    └── providers/        # 状态提供者
```

### 3. 代码注释

```dart
/// 用户数据模型
/// 
/// 包含用户的基本信息和权限设置
class User {
  /// 用户唯一标识符
  final String id;
  
  /// 用户邮箱地址
  final String email;
  
  /// 创建用户实例
  /// 
  /// [id] 用户唯一标识符
  /// [email] 用户邮箱地址
  const User({
    required this.id,
    required this.email,
  });
}
```

## 状态管理

项目使用 Riverpod 进行状态管理，以下是基本使用方法：

### 1. Provider定义

```dart
// 简单状态
final counterProvider = StateProvider<int>((ref) => 0);

// 异步状态
final userProvider = FutureProvider<User?>((ref) async {
  final userService = ref.watch(userServiceProvider);
  final result = await userService.getCurrentUser();
  return result.fold((l) => null, (r) => r);
});

// 通知者Provider
final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
```

### 2. 在Widget中使用

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);
    final userAsync = ref.watch(userProvider);
    
    return Column(
      children: [
        Text('Counter: $counter'),
        userAsync.when(
          data: (user) => Text('User: ${user?.name ?? 'Unknown'}'),
          loading: () => CircularProgressIndicator(),
          error: (error, stack) => Text('Error: $error'),
        ),
        ElevatedButton(
          onPressed: () {
            ref.read(counterProvider.notifier).state++;
          },
          child: Text('Increment'),
        ),
      ],
    );
  }
}
```

## 路由导航

项目使用 GoRouter 进行路由管理，支持嵌套路由、路由守卫和自定义转场动画。

### 1. 路由架构

```dart
AppRouter.createRouter()
├── 启动页 (/splash)
├── 引导页 (/onboarding)
├── 登录页 (/login)
├── 语言设置 (/language-settings)
└── 底部导航 (StatefulShellRoute)
    ├── 首页 (/)
    ├── 个人中心 (/profile)
    │   └── 主题设置 (/profile/theme-settings)  // 嵌套路由
    └── 其他标签页...
```

### 2. 路由定义

```dart
// 简单路由
GoRoute(
  path: RoutePaths.login,
  name: 'login',
  builder: (context, state) => const LoginPage(),
),

// 带自定义转场的路由
GoRoute(
  path: RoutePaths.splash,
  name: 'splash',
  pageBuilder: (context, state) => _buildPageWithTransition(
    context,
    state,
    const SplashScreen(),
    transitionType: RouteTransitionType.fade,
  ),
),

// 嵌套路由
GoRoute(
  path: RoutePaths.profile,
  name: 'profile',
  builder: (context, state) => const ProfilePage(),
  routes: [
    GoRoute(
      path: RoutePaths.getSubPath(RoutePaths.themeSettings, RoutePaths.profile),
      name: 'themeSettings',
      builder: (context, state) => const ThemeSettingsPage(),
    ),
  ],
),

// 底部导航（StatefulShellRoute）
StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    return AppShell(navigationShell: navigationShell);
  },
  branches: [
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: RoutePaths.home,
          name: 'home',
          builder: (context, state) => const HomePage(),
        ),
      ],
    ),
  ],
),
```

### 3. 路由跳转

```dart
// 跳转到指定路由
context.go('/profile');
context.go(RoutePaths.profile);

// 推送新路由
context.push('/settings');
context.push(RoutePaths.languageSettings);

// 返回上一页
context.pop();

// 替换当前路由
context.pushReplacement('/login');
context.pushReplacement(RoutePaths.login);

// 嵌套路由跳转
context.go('/profile/theme-settings');

// 带参数的路由跳转
context.go('/user/123');
context.goNamed('user', pathParameters: {'id': '123'});
```

### 4. 路由守卫

```dart
// 在GoRouter中配置重定向
GoRouter(
  redirect: RouteGuards.authRedirect,
  routes: [...],
);

// 路由守卫实现
class RouteGuards {
  static String? authRedirect(BuildContext context, GoRouterState state) {
    // 检查用户是否已登录
    final isLoggedIn = /* 检查登录状态 */;
    final isAuthRoute = state.uri.toString().startsWith('/auth');
    
    if (!isLoggedIn && !isAuthRoute) {
      return RoutePaths.login;
    }
    
    if (isLoggedIn && isAuthRoute) {
      return RoutePaths.home;
    }
    
    return null; // 无需重定向
  }
}
```

### 5. 自定义转场动画

```dart
// 支持的转场类型
enum RouteTransitionType {
  slide,        // 滑动（默认）
  fade,         // 淡入淡出
  scale,        // 缩放
  bottomSheet,  // 底部弹出
}

// 使用自定义转场
GoRoute(
  path: '/settings',
  pageBuilder: (context, state) => _buildPageWithTransition(
    context,
    state,
    const SettingsPage(),
    transitionType: RouteTransitionType.bottomSheet,
  ),
),

// 自定义转场实现
static Page<T> _buildPageWithTransition<T extends Object?>(
  BuildContext context,
  GoRouterState state,
  Widget child, {
  RouteTransitionType transitionType = RouteTransitionType.slide,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // 根据transitionType返回不同的转场动画
      switch (transitionType) {
        case RouteTransitionType.fade:
          return FadeTransition(opacity: animation, child: child);
        case RouteTransitionType.scale:
          return ScaleTransition(scale: animation, child: child);
        // ... 其他转场类型
      }
    },
  );
}
```

### 6. 路由路径管理

```dart
// 使用路径常量类
class RoutePaths {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String home = '/';
  static const String profile = '/profile';
  static const String themeSettings = '/theme-settings';
  static const String languageSettings = '/language-settings';
  
  // 获取子路径的辅助方法
  static String getSubPath(String subPath, String parentPath) {
    return subPath.replaceFirst('/', '');
  }
}
```

### 7. 底部导航集成

```dart
// AppShell处理底部导航
class AppShell extends StatelessWidget {
  const AppShell({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
        ],
      ),
    );
  }
}
```

### 8. 错误处理

```dart
// 路由错误页面
GoRouter(
  errorBuilder: (context, state) => ErrorPage(error: state.error),
  routes: [...],
);

// 自定义错误页面
class ErrorPage extends StatelessWidget {
  const ErrorPage({required this.error, super.key});
  
  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('页面错误')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64),
            Text('页面不存在或发生错误'),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('返回首页'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 9. 调试路由

```dart
// 开启路由调试日志
GoRouter(
  debugLogDiagnostics: true,  // 开发环境下开启
  routes: [...],
);
```

## 网络请求

### 1. API客户端使用

```dart
class UserRepository {
  final ApiClient _apiClient;
  
  UserRepository(this._apiClient);
  
  Future<Either<Failure, User>> getUser(String id) async {
    try {
      final response = await _apiClient.get('/users/$id');
      final user = User.fromJson(response.data);
      return Right(user);
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
```

### 2. 错误处理

```dart
final result = await userRepository.getUser('123');
result.fold(
  (failure) {
    // 处理错误
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(failure.message)),
    );
  },
  (user) {
    // 处理成功
    print('User loaded: ${user.name}');
  },
);
```

## 数据存储

项目采用统一的存储服务架构，集成了三种存储方式：Hive数据库、SharedPreferences和安全存储。

### 1. 存储服务架构

```dart
/// 统一存储服务入口
StorageService.instance
├── hive          // Hive数据库服务
├── prefs         // SharedPreferences服务
└── secure        // 安全存储服务
```

### 2. 初始化存储服务

```dart
// 在main()函数中初始化
await StorageService.instance.initialize();
```

### 3. Hive数据库存储（复杂数据）

```dart
// 用户数据操作
await StorageService.instance.setUserData('profile', userModel);
final user = StorageService.instance.getUserData<UserModel>('profile');
await StorageService.instance.removeUserData('profile');
await StorageService.instance.clearUserData(); // 清空所有用户数据

// 直接访问Hive服务
final hive = StorageService.instance.hive;

// 用户数据盒子操作
await hive.putUser('key', value);
final value = hive.getUser<T>('key');
await hive.deleteUser('key');
await hive.clearUserData();

// 设置数据盒子操作
await hive.putSetting('theme_mode', 'dark');
final theme = hive.getSetting<String>('theme_mode');
await hive.deleteSetting('theme_mode');
await hive.clearSettings();

// 缓存数据盒子操作
await hive.putCache('api_cache_key', data);
final cache = hive.getCache<Map>('api_cache_key');
await hive.deleteCache('api_cache_key');
await hive.clearCache();

// 通用操作
await hive.put('custom_box', 'key', value);
final value = hive.get<T>('custom_box', 'key', defaultValue: defaultValue);
await hive.delete('custom_box', 'key');
final exists = hive.containsKey('custom_box', 'key');
final keys = hive.getKeys('custom_box');
final values = hive.getValues('custom_box');
await hive.clear('custom_box');
```

### 4. SharedPreferences存储（简单数据）

```dart
// 直接访问SharedPreferences服务
final prefs = StorageService.instance.prefs;

// 字符串操作
await prefs.setString('key', 'value');
final value = prefs.getString('key', defaultValue: 'default');

// 整数操作
await prefs.setInt('count', 10);
final count = prefs.getInt('count', defaultValue: 0);

// 布尔值操作
await prefs.setBool('isEnabled', true);
final isEnabled = prefs.getBool('isEnabled', defaultValue: false);

// 浮点数操作
await prefs.setDouble('price', 99.99);
final price = prefs.getDouble('price', defaultValue: 0.0);

// 字符串列表操作
await prefs.setStringList('tags', ['tag1', 'tag2']);
final tags = prefs.getStringList('tags', defaultValue: []);

// 其他操作
await prefs.remove('key');
final exists = prefs.containsKey('key');
final keys = prefs.getKeys();
await prefs.clear();
await prefs.reload();
```

### 5. 安全存储（敏感数据）

```dart
// 直接访问安全存储服务
final secure = StorageService.instance.secure;

// 存储敏感数据（如token、密码等）
await secure.write('user_token', 'jwt_token_here');
await secure.write('api_key', 'sensitive_api_key');

// 读取敏感数据
final token = await secure.read('user_token');
final apiKey = await secure.read('api_key');

// 删除敏感数据
await secure.delete('user_token');

// 检查是否存在
final exists = await secure.containsKey('user_token');

// 批量操作
final allData = await secure.readAll();
await secure.writeAll({
  'key1': 'value1',
  'key2': 'value2',
});
await secure.deleteAll(); // 清空所有安全数据

// 便捷方法（推荐使用）
await StorageService.instance.setUserToken('jwt_token_here');
final token = await StorageService.instance.getUserToken();
await StorageService.instance.removeUserToken();
final isLoggedIn = await StorageService.instance.isLoggedIn();
```

### 6. 存储键管理

```dart
// 使用统一的存储键常量
class StorageKeys {
  static const String userTokenKey = 'user_token';
  static const String userInfoKey = 'user_info';
  static const String isFirstLaunch = 'is_first_launch';
  static const String onboardingCompleted = 'onboarding_completed';
}

// 使用示例
await StorageService.instance.secure.write(
  StorageKeys.userTokenKey, 
  token
);
```

### 7. 存储信息调试

```dart
// 获取存储统计信息
final info = await StorageService.instance.getStorageInfo();
print('Storage Info: $info');
// 输出: {
//   'hive': {'user_keys': 5, 'settings_keys': 3, 'cache_keys': 10},
//   'shared_preferences': {'keys': 8},
//   'secure_storage': {'keys': 2}
// }
```

### 8. 清理存储数据

```dart
// 清理所有存储数据（谨慎使用）
await StorageService.instance.clearAll();

// 分别清理不同类型的数据
await StorageService.instance.clearUserData();
await StorageService.instance.hive.clearSettings();
await StorageService.instance.hive.clearCache();
await StorageService.instance.prefs.clear();
await StorageService.instance.secure.deleteAll();
```

### 9. 存储服务关闭

```dart
// 应用关闭时清理资源
await StorageService.instance.close();
```

### 10. 存储选择建议

| 数据类型 | 推荐存储方式 | 说明 |
|---------|-------------|-----|
| 用户Token | 安全存储 | 敏感数据，需要加密 |
| 用户设置 | SharedPreferences | 简单键值对 |
| 用户资料 | Hive | 复杂对象数据 |
| 缓存数据 | Hive | 需要高性能读写 |
| 临时标记 | SharedPreferences | 简单标识符 |

## 测试指南

### 1. 单元测试

```dart
void main() {
  group('Validators', () {
    test('should validate email correctly', () {
      expect(Validators.isEmail('test@example.com'), true);
      expect(Validators.isEmail('invalid'), false);
    });
  });
}
```

### 2. Widget测试

```dart
void main() {
  testWidgets('LoadingButton shows loading indicator', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoadingButton(
          isLoading: true,
          onPressed: () {},
          child: Text('Test'),
        ),
      ),
    );
    
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
```

### 3. 集成测试

```dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  testWidgets('full app test', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    
    // 测试应用流程
    expect(find.text('Welcome'), findsOneWidget);
  });
}
```

## 性能优化

### 1. 图片优化

```dart
// 使用缓存图片组件
CachedNetworkImage(
  imageUrl: 'https://example.com/image.jpg',
  placeholder: (context, url) => Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(height: 200, color: Colors.white),
  ),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

### 2. 列表优化

```dart
// 使用ListView.builder构建大列表
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(items[index].title),
    );
  },
)
```

### 3. 状态优化

```dart
// 使用select避免不必要的重建
Widget build(BuildContext context, WidgetRef ref) {
  final userName = ref.watch(userProvider.select((user) => user?.name));
  return Text(userName ?? 'Unknown');
}
```

## 常用命令

```bash
# 运行应用
flutter run

# 构建APK
flutter build apk

# 构建iOS
flutter build ios

# 运行测试
flutter test

# 分析代码
flutter analyze

# 格式化代码
dart format lib/

# 清理项目
flutter clean
```

## 开发技巧

### 1. 快速导航

- `Cmd/Ctrl + P`: 快速打开文件
- `Cmd/Ctrl + Shift + P`: 命令面板
- `F12`: 跳转到定义
- `Shift + F12`: 查找引用

### 2. 调试技巧

- 使用 `debugPrint()` 代替 `print()`
- 使用 Flutter Inspector 调试UI
- 使用断点调试代码逻辑
- 使用 `AppLogger` 记录重要信息

### 3. 代码片段

项目提供了常用的代码片段模版，输入以下前缀快速生成代码：

- `stless`: StatelessWidget模版
- `stful`: StatefulWidget模版
- `provider`: Riverpod Provider模版
- `cubit`: Cubit模版

---

有问题欢迎提出Issue或贡献代码！
