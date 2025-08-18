# Auth 系统使用指南

本文档介绍如何使用基于 Freezed 和 Riverpod 构建的用户认证系统，该系统采用分层架构设计，AuthRepository 使用 UserService 进行 API 访问。

## 目录结构

```
lib/
├── features/providers/
│   └── auth.dart                    # Auth Provider (Riverpod + Freezed)
├── shared/
│   ├── models/
│   │   ├── auth_models.dart         # 认证相关数据模型 (Freezed)
│   │   └── user.dart                # 用户数据模型
│   ├── repositories/
│   │   ├── auth_repository.dart     # 认证仓库接口
│   │   └── auth_repository_impl.dart # 认证仓库实现
│   └── services/
│       └── user_service.dart        # 用户服务 (API 访问层)
└── examples/
    ├── auth_examples.dart           # 基础使用示例
    └── auth_with_user_service_example.dart # 完整架构示例
```

## 架构设计

### 分层架构

```
UI Layer (Widgets)
    ↓
State Management (Auth Provider - Riverpod)
    ↓
Repository Layer (AuthRepository)
    ↓
Service Layer (UserService)
    ↓
Network Layer (ApiClient)
```

### 职责分工

- **Auth Provider**: 状态管理，业务逻辑协调
- **AuthRepository**: 认证业务逻辑，数据转换和缓存
- **UserService**: API 调用，网络请求处理
- **ApiClient**: 底层 HTTP 请求

## 核心组件

### 1. 认证状态模型 (AuthState)

使用 Freezed 定义的不可变状态模型：

```dart
@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(AuthStatus.initial) AuthStatus status,
    User? user,
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
    String? errorMessage,
    @Default(false) bool isLoading,
    @Default(false) bool rememberMe,
  }) = _AuthState;
}
```

### 2. 认证请求模型

所有认证相关的请求都使用 Freezed 定义：

- `LoginRequest` - 登录请求
- `PhoneLoginRequest` - 手机号登录请求
- `RegisterRequest` - 注册请求
- `ResetPasswordRequest` - 重置密码请求
- `ChangePasswordRequest` - 修改密码请求
- `RefreshTokenRequest` - 刷新Token请求
- `VerificationCodeRequest` - 验证码请求
- `VerifyCodeRequest` - 验证码验证请求

### 3. Auth Provider

使用 Riverpod 的 `@riverpod` 注解创建的状态管理器：

```dart
@riverpod
class Auth extends _$Auth {
  @override
  AuthState build() {
    _initializeAuth();
    return const AuthState();
  }
  
  // 登录、注册、登出等方法...
}
```

## 使用方法

### 1. 基本设置

在 `main.dart` 中设置 Riverpod：

```dart
void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}
```

### 2. 在页面中使用

```dart
class LoginPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  Future<void> _handleLogin() async {
    final request = LoginRequest(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      rememberMe: _rememberMe,
    );

    await ref.read(authProvider.notifier).login(request);
    
    final authState = ref.read(authProvider);
    if (authState.isAuthenticated) {
      // 登录成功，导航到主页
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    
    return Scaffold(
      body: Column(
        children: [
          // 登录表单...
          
          ElevatedButton(
            onPressed: authState.isLoading ? null : _handleLogin,
            child: authState.isLoading 
              ? CircularProgressIndicator()
              : Text('登录'),
          ),
          
          // 错误信息显示
          if (authState.hasError)
            Text(
              authState.errorMessage!,
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }
}
```

### 3. 监听认证状态变化

```dart
class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    return MaterialApp.router(
      routerConfig: GoRouter(
        initialLocation: authState.isAuthenticated ? '/home' : '/login',
        routes: [
          GoRoute(
            path: '/login',
            builder: (context, state) => LoginPage(),
          ),
          GoRoute(
            path: '/home',
            builder: (context, state) => HomePage(),
            redirect: (context, state) {
              return authState.isAuthenticated ? null : '/login';
            },
          ),
        ],
      ),
    );
  }
}
```

### 4. 用户操作

```dart
// 邮箱登录
final loginRequest = LoginRequest(
  email: 'user@example.com',
  password: 'password123',
  rememberMe: true,
);
await ref.read(authProvider.notifier).login(loginRequest);

// 手机号登录
final phoneLoginRequest = PhoneLoginRequest(
  phone: '13800138000',
  code: '123456',
  rememberMe: true,
);
await ref.read(authProvider.notifier).phoneLogin(phoneLoginRequest);

// 注册
final registerRequest = RegisterRequest(
  email: 'user@example.com',
  password: 'password123',
  confirmPassword: 'password123',
  name: '用户名',
);
await ref.read(authProvider.notifier).register(registerRequest);

// 登出
await ref.read(authProvider.notifier).logout();

// 刷新Token
await ref.read(authProvider.notifier).refreshToken();

// 重置密码
final resetRequest = ResetPasswordRequest(email: 'user@example.com');
await ref.read(authProvider.notifier).resetPassword(resetRequest);

// 发送验证码
final codeRequest = VerificationCodeRequest(
  email: 'user@example.com',
  type: VerificationCodeType.login,
);
await ref.read(authProvider.notifier).sendVerificationCode(codeRequest);

// 更新用户信息
final updatedUser = currentUser.copyWith(name: '新名称');
await ref.read(authProvider.notifier).updateUser(updatedUser);
```

## 状态管理

### 认证状态

- `AuthStatus.initial` - 初始状态
- `AuthStatus.loading` - 加载中
- `AuthStatus.authenticated` - 已认证
- `AuthStatus.unauthenticated` - 未认证
- `AuthStatus.error` - 错误状态

### 便利方法

AuthState 提供了一些便利的扩展方法：

```dart
final authState = ref.watch(authProvider);

// 检查认证状态
if (authState.isAuthenticated) {
  // 用户已登录
}

if (authState.isUnauthenticated) {
  // 用户未登录
}

if (authState.hasError) {
  // 显示错误信息
  print(authState.errorMessage);
}

// 检查Token状态
if (authState.isTokenExpired) {
  // Token已过期
}

if (authState.needsTokenRefresh) {
  // 需要刷新Token
}
```

## 本地存储

系统会自动处理认证信息的本地存储：

- 选择"记住我"时，认证信息会保存到本地
- 应用启动时会自动尝试从本地恢复认证状态
- Token过期时会自动尝试刷新
- 登出时会自动清除本地认证信息

## 错误处理

所有的认证操作都使用 `Either<Failure, T>` 模式进行错误处理：

- `ServerFailure` - 服务器错误
- `NetworkFailure` - 网络错误
- `CacheFailure` - 缓存错误
- `ValidationFailure` - 验证错误

错误信息会自动设置到 `AuthState.errorMessage` 中，可以通过 UI 显示给用户。

## 示例代码

查看示例文件获取完整的使用示例：

- `lib/examples/auth_examples.dart` - 基础功能示例
- `lib/examples/auth_with_user_service_example.dart` - 完整架构示例，展示 AuthRepository + UserService 集成使用

示例包括：

- 登录表单
- 注册表单
- 用户信息显示
- 各种认证操作
- 错误处理

## 扩展

### 添加新的认证方法

1. 在 `auth_models.dart` 中添加新的请求模型
2. 在 `AuthRepository` 接口中添加新方法
3. 在 `AuthRepositoryImpl` 中实现该方法
4. 在 `Auth` Provider 中添加对应的状态管理方法

### 自定义认证流程

可以通过继承或包装现有的 `AuthRepository` 来实现自定义的认证流程，例如：

- 社交登录（微信、支付宝等）
- 生物识别登录
- 多因素认证
- 单点登录（SSO）

## 最佳实践

1. **状态监听**：使用 `ref.watch(authProvider)` 监听认证状态变化
2. **错误处理**：始终检查 `authState.hasError` 并显示错误信息
3. **加载状态**：使用 `authState.isLoading` 显示加载指示器
4. **路由保护**：根据认证状态控制页面访问权限
5. **Token刷新**：定期检查 `authState.needsTokenRefresh` 并自动刷新
6. **安全存储**：敏感信息（如Token）使用安全存储

## 注意事项

1. 本示例使用模拟数据，实际使用时需要连接真实的API
2. Token刷新逻辑需要根据实际的API规范进行调整
3. 错误处理需要根据实际的错误码进行细化
4. 生产环境中需要添加更多的安全措施（如Token加密、请求签名等）
