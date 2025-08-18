# 依赖注入最佳实践指南

## 概述

本项目使用 **GetIt + Riverpod** 混合架构：

- **GetIt**：负责业务层和基础设施层的依赖注入
- **Riverpod**：负责UI层的状态管理

## 🎯 架构原则

### 1. 职责分离

```dart
// ✅ 正确：GetIt 管理服务依赖
final userService = getIt<UserService>();

// ✅ 正确：Riverpod 管理UI状态
final themeMode = ref.watch(themeModeProvider);

// ❌ 错误：不要用 Riverpod 做依赖注入
final userServiceProvider = Provider<UserService>((ref) => UserService());
```

### 2. 统一的获取方式

```dart
// ✅ 推荐：使用 getIt<T>() 函数（最简洁）
final apiClient = getIt<ApiClient>();
final userService = getIt<UserService>();

// ✅ 可选：使用扩展方法（语义化）
final apiClient = sl.apiClient;
final userService = sl.userService;

// ✅ 可选：使用封装接口（测试友好）
final apiClient = ServiceLocator.get<ApiClient>();
final userService = ServiceLocator.get<UserService>();

// ❌ 避免：直接使用 sl<T>()（不够语义化）
final apiClient = sl<ApiClient>();
```

## 📋 使用场景

### 1. Widget 中获取服务

```dart
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 直接获取业务服务
    final userService = getIt<UserService>();
    
    return FutureBuilder(
      future: userService.getCurrentUser().then(
        (result) => result.fold(
          (failure) => null,
          (user) => user,
        ),
      ),
      builder: (context, snapshot) {
        // UI 构建逻辑
        return snapshot.hasData 
          ? Text('用户: ${snapshot.data?.name}')
          : CircularProgressIndicator();
      },
    );
  }
}
```

### 2. 业务逻辑类中注入依赖

```dart
class OrderService {
  // 构造函数注入
  OrderService() 
    : _userService = getIt<UserService>(),
      _apiClient = getIt<ApiClient>();

  final UserService _userService;
  final ApiClient _apiClient;

  Future<Either<Failure, Order>> createOrder(OrderData data) async {
    // 使用注入的依赖
    final userResult = await _userService.getCurrentUser();
    return userResult.fold(
      (failure) => Left(failure),
      (user) async {
        final response = await _apiClient.post('/orders', {
          'userId': user.id,
          'data': data.toJson(),
        });
        return Right(Order.fromJson(response.data));
      },
    );
  }
}
```

### 3. Riverpod Provider 中桥接 GetIt

```dart
class AppProviders {
  // 桥接 GetIt 服务到 Riverpod
  static final apiClientProvider = Provider<ApiClient>((ref) {
    return getIt<ApiClient>();
  });
  
  // UI 状态管理仍使用 Riverpod
  static final isLoadingProvider = StateProvider<bool>((ref) => false);
}
```

## 🔧 配置和注册

### 1. 服务注册（service_locator.dart）

```dart
@module
abstract class RegisterModule {
  @singleton
  ApiClient get apiClient => ApiClient(
    BaseOptions(baseUrl: AppConstants.baseUrl),
  );
  
  @preResolve
  @singleton
  Future<StorageService> get storageService async {
    final service = StorageService.instance;
    await service.initialize();
    return service;
  }
}
```

### 2. 初始化顺序

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. 首先初始化 GetIt
  await ServiceLocator.initialize();
  
  // 2. 然后启动 Riverpod 应用
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
```

## 🧪 测试策略

### 1. 单元测试中模拟依赖

```dart
void main() {
  group('OrderService Tests', () {
    late MockUserService mockUserService;
    late MockApiClient mockApiClient;

    setUp(() async {
      // 重置 GetIt
      await ServiceLocator.reset();
      
      // 注册模拟对象
      sl.registerSingleton<UserService>(mockUserService);
      sl.registerSingleton<ApiClient>(mockApiClient);
    });

    test('should create order successfully', () async {
      // 测试逻辑
      final orderService = OrderService();
      final result = await orderService.createOrder(testData);
      
      expect(result.isRight(), isTrue);
    });
  });
}
```

### 2. Widget 测试

```dart
testWidgets('ProfilePage should display user name', (tester) async {
  // 设置模拟依赖
  await ServiceLocator.reset();
  sl.registerSingleton<UserService>(mockUserService);
  
  when(mockUserService.getCurrentUser())
    .thenAnswer((_) async => Right(testUser));

  // 测试 Widget
  await tester.pumpWidget(
    MaterialApp(home: ProfilePage()),
  );
  
  await tester.pumpAndSettle();
  expect(find.text('用户: ${testUser.name}'), findsOneWidget);
});
```

## ⚠️ 常见陷阱

### 1. 避免循环依赖

```dart
// ❌ 错误：A 依赖 B，B 依赖 A
class ServiceA {
  ServiceA() : _serviceB = getIt<ServiceB>();
}

class ServiceB {
  ServiceB() : _serviceA = getIt<ServiceA>(); // 循环依赖！
}

// ✅ 正确：引入中间层或事件系统
class ServiceA {
  ServiceA() : _eventBus = getIt<EventBus>();
}

class ServiceB {
  ServiceB() : _eventBus = getIt<EventBus>();
}
```

### 2. 避免在 Provider build 中获取服务

```dart
// ❌ 错误：每次 rebuild 都会获取新的服务实例
@riverpod
class Auth extends _$Auth {
  @override
  AuthState build() {
    final userService = getIt<UserService>(); // 不要这样做
    return AuthState.initial();
  }
}

// ✅ 正确：通过桥接 Provider 获取
@riverpod
class Auth extends _$Auth {
  @override
  AuthState build() {
    final userService = ref.watch(AppProviders.userServiceProvider);
    return AuthState.initial();
  }
}
```

### 3. 测试后清理

```dart
// ✅ 确保测试后清理 GetIt
tearDown(() async {
  await ServiceLocator.reset();
});
```

## 📊 性能优化

### 1. 懒加载 vs 预加载

```dart
// 懒加载：首次使用时创建
@lazySingleton
class ExpensiveService {
  ExpensiveService() {
    // 昂贵的初始化操作
  }
}

// 预加载：应用启动时创建
@preResolve
@singleton
Future<DatabaseService> get databaseService async {
  final service = DatabaseService();
  await service.initialize();
  return service;
}
```

### 2. 工厂模式 vs 单例模式

```dart
// 单例：整个应用生命周期只有一个实例
@singleton
class ApiClient {}

// 工厂：每次获取都创建新实例
@factory
class TemporaryService {}
```

## 📝 总结

1. **GetIt 负责依赖注入**：服务、仓库、客户端等业务对象
2. **Riverpod 负责状态管理**：UI 状态、用户交互状态等
3. **使用 `getIt<T>()` 作为主要获取方式**：简洁、一致、易读
4. **通过桥接 Provider 连接两个系统**：保持架构清晰
5. **测试时使用模拟对象**：确保单元测试的隔离性

这种混合架构既保持了 GetIt 在依赖注入方面的优势，又充分利用了 Riverpod 在状态管理方面的强大功能。
