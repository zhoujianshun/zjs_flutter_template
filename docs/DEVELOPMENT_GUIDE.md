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

```
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
│   └── profile/           # 个人中心模块
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

```
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

项目使用 GoRouter 进行路由管理：

### 1. 路由定义

```dart
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => ProfilePage(),
    ),
  ],
);
```

### 2. 路由跳转

```dart
// 跳转到指定路由
context.go('/profile');

// 推送新路由
context.push('/settings');

// 返回上一页
context.pop();

// 替换当前路由
context.pushReplacement('/login');
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

### 1. 简单数据存储

```dart
// 存储字符串
await StorageService.setString('key', 'value');

// 获取字符串
final value = StorageService.getString('key');

// 存储JSON对象
await StorageService.setJsonData('user', user.toJson());

// 获取JSON对象
final userData = StorageService.getJsonData('user');
```

### 2. 安全数据存储

```dart
// 存储敏感数据（如token）
await StorageService.setSecureData('token', 'jwt_token_here');

// 获取敏感数据
final token = await StorageService.getSecureData('token');
```

### 3. Hive数据库

```dart
// 存储复杂数据
await StorageService.setUserData('profile', user);

// 获取复杂数据
final user = StorageService.getUserData<User>('profile');
```

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
