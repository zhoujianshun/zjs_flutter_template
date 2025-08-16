# Dartz + Riverpod 集成指南

## 📖 概述

本指南展示如何在使用 Riverpod 状态管理的 Flutter 应用中有效集成 dartz 进行错误处理。我们将探讨各种集成模式、最佳实践和实际应用场景。

## 🎯 核心集成模式

### 1. Provider 中的 Either 处理

#### 基础 FutureProvider 集成

```dart
import 'package:dartz/dartz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_providers.g.dart';

/// 获取用户信息的 Provider
@riverpod
Future<Either<Failure, User>> user(UserRef ref, String userId) async {
  final userService = ref.read(userServiceProvider);
  return await userService.getUserById(userId);
}

/// 在 UI 中使用
class UserProfilePage extends ConsumerWidget {
  final String userId;
  
  const UserProfilePage({required this.userId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider(userId));
    
    return Scaffold(
      body: userAsync.when(
        data: (either) => either.fold(
          (failure) => ErrorWidget(failure.message),
          (user) => UserProfileWidget(user: user),
        ),
        loading: () => const CircularProgressIndicator(),
        error: (error, stack) => ErrorWidget(error.toString()),
      ),
    );
  }
}
```

#### 使用 AsyncValue 包装 Either

```dart
/// 将 Either 转换为 AsyncValue 的扩展
extension EitherToAsync<L, R> on Either<L, R> {
  AsyncValue<R> toAsyncValue() {
    return fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (value) => AsyncValue.data(value),
    );
  }
}

/// 直接返回 AsyncValue 的 Provider
@riverpod
Future<User> userDirect(UserDirectRef ref, String userId) async {
  final userService = ref.read(userServiceProvider);
  final result = await userService.getUserById(userId);
  
  return result.fold(
    (failure) => throw failure,
    (user) => user,
  );
}
```

### 2. StateNotifier 中的 Either 处理

```dart
/// 认证状态
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(User user) = _Authenticated;
  const factory AuthState.unauthenticated(String? errorMessage) = _Unauthenticated;
}

/// 认证状态管理
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    return const AuthState.initial();
  }

  /// 登录方法
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();
    
    final userService = ref.read(userServiceProvider);
    final result = await userService.login(
      email: email,
      password: password,
    );
    
    result.fold(
      (failure) {
        state = AuthState.unauthenticated(failure.message);
      },
      (user) {
        state = AuthState.authenticated(user);
        // 保存用户信息到本地存储
        ref.read(storageServiceProvider).saveUser(user);
      },
    );
  }

  /// 注册方法
  Future<void> register({
    required String email,
    required String password,
    String? name,
  }) async {
    state = const AuthState.loading();
    
    final userService = ref.read(userServiceProvider);
    final result = await userService.register(
      email: email,
      password: password,
      name: name,
    );
    
    result.fold(
      (failure) => state = AuthState.unauthenticated(failure.message),
      (user) => state = AuthState.authenticated(user),
    );
  }

  /// 登出方法
  Future<void> logout() async {
    final userService = ref.read(userServiceProvider);
    final result = await userService.logout();
    
    result.fold(
      (failure) {
        // 即使登出失败，也清除本地状态
        state = AuthState.unauthenticated(failure.message);
      },
      (_) {
        state = const AuthState.unauthenticated(null);
      },
    );
    
    // 清除本地存储
    ref.read(storageServiceProvider).clearUser();
  }
}
```

### 3. 复杂状态管理

```dart
/// 用户列表状态
@freezed
class UserListState with _$UserListState {
  const factory UserListState({
    @Default([]) List<User> users,
    @Default(false) bool isLoading,
    @Default(false) bool hasMore,
    String? errorMessage,
    @Default(1) int currentPage,
  }) = _UserListState;
}

/// 用户列表管理
@riverpod
class UserListNotifier extends _$UserListNotifier {
  @override
  UserListState build() {
    loadUsers();
    return const UserListState();
  }

  /// 加载用户列表
  Future<void> loadUsers({bool refresh = false}) async {
    if (refresh) {
      state = state.copyWith(
        users: [],
        currentPage: 1,
        hasMore: true,
        errorMessage: null,
      );
    }
    
    if (state.isLoading || !state.hasMore) return;
    
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    final userService = ref.read(userServiceProvider);
    final result = await userService.getUsers(
      page: state.currentPage,
      limit: 20,
    );
    
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (newUsers) {
        state = state.copyWith(
          users: [...state.users, ...newUsers],
          isLoading: false,
          hasMore: newUsers.length == 20,
          currentPage: state.currentPage + 1,
        );
      },
    );
  }

  /// 删除用户
  Future<void> deleteUser(String userId) async {
    final userService = ref.read(userServiceProvider);
    final result = await userService.deleteUser(userId);
    
    result.fold(
      (failure) {
        // 显示错误消息
        ref.read(snackbarServiceProvider).showError(failure.message);
      },
      (_) {
        // 从列表中移除用户
        state = state.copyWith(
          users: state.users.where((user) => user.id != userId).toList(),
        );
        ref.read(snackbarServiceProvider).showSuccess('用户已删除');
      },
    );
  }

  /// 更新用户
  Future<void> updateUser(User updatedUser) async {
    final userService = ref.read(userServiceProvider);
    final result = await userService.updateUser(
      id: updatedUser.id,
      name: updatedUser.name,
      email: updatedUser.email,
    );
    
    result.fold(
      (failure) {
        ref.read(snackbarServiceProvider).showError(failure.message);
      },
      (user) {
        // 更新列表中的用户
        final updatedUsers = state.users.map((u) {
          return u.id == user.id ? user : u;
        }).toList();
        
        state = state.copyWith(users: updatedUsers);
        ref.read(snackbarServiceProvider).showSuccess('用户已更新');
      },
    );
  }
}
```

## 🔄 异步操作链

### 1. 连续异步操作

```dart
/// 用户档案 Provider
@riverpod
Future<Either<Failure, UserProfile>> userProfile(
  UserProfileRef ref,
  String userId,
) async {
  final userService = ref.read(userServiceProvider);
  
  // 获取用户基本信息
  final userResult = await userService.getUserById(userId);
  if (userResult.isLeft()) {
    return userResult.fold(
      (failure) => Left(failure),
      (_) => throw StateError('不可能的情况'),
    );
  }
  
  final user = userResult.fold(
    (_) => throw StateError('不可能的情况'),
    (user) => user,
  );
  
  // 获取用户设置
  final settingsResult = await userService.getUserSettings(userId);
  if (settingsResult.isLeft()) {
    return settingsResult.fold(
      (failure) => Left(failure),
      (_) => throw StateError('不可能的情况'),
    );
  }
  
  final settings = settingsResult.fold(
    (_) => throw StateError('不可能的情况'),
    (settings) => settings,
  );
  
  // 组合结果
  final profile = UserProfile(
    user: user,
    settings: settings,
  );
  
  return Right(profile);
}

/// 使用扩展方法简化
@riverpod
Future<Either<Failure, UserProfile>> userProfileSimplified(
  UserProfileSimplifiedRef ref,
  String userId,
) async {
  final userService = ref.read(userServiceProvider);
  
  return (await userService.getUserById(userId))
      .flatMapAsync((user) async {
        final settingsResult = await userService.getUserSettings(userId);
        return settingsResult.map((settings) => UserProfile(
          user: user,
          settings: settings,
        ));
      });
}
```

### 2. 并行异步操作

```dart
/// 用户仪表板数据
@riverpod
Future<Either<Failure, DashboardData>> dashboardData(
  DashboardDataRef ref,
  String userId,
) async {
  final userService = ref.read(userServiceProvider);
  final orderService = ref.read(orderServiceProvider);
  final notificationService = ref.read(notificationServiceProvider);
  
  // 并行获取多个数据
  final results = await Future.wait([
    userService.getUserById(userId),
    orderService.getRecentOrders(userId),
    notificationService.getUnreadNotifications(userId),
  ]);
  
  // 检查是否有任何失败
  for (final result in results) {
    if (result.isLeft()) {
      return result.fold(
        (failure) => Left(failure),
        (_) => throw StateError('不可能的情况'),
      );
    }
  }
  
  // 提取所有成功的结果
  final user = results[0].fold(
    (_) => throw StateError('不可能的情况'),
    (user) => user as User,
  );
  
  final orders = results[1].fold(
    (_) => throw StateError('不可能的情况'),
    (orders) => orders as List<Order>,
  );
  
  final notifications = results[2].fold(
    (_) => throw StateError('不可能的情况'),
    (notifications) => notifications as List<Notification>,
  );
  
  return Right(DashboardData(
    user: user,
    recentOrders: orders,
    unreadNotifications: notifications,
  ));
}
```

## 🎨 UI 集成模式

### 1. 错误处理 Widget

```dart
/// 通用错误处理 Widget
class EitherBuilder<T> extends StatelessWidget {
  final Either<Failure, T> either;
  final Widget Function(T data) onSuccess;
  final Widget Function(Failure failure)? onError;
  final Widget? loadingWidget;

  const EitherBuilder({
    required this.either,
    required this.onSuccess,
    this.onError,
    this.loadingWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return either.fold(
      (failure) => onError?.call(failure) ?? DefaultErrorWidget(failure),
      (data) => onSuccess(data),
    );
  }
}

/// 默认错误 Widget
class DefaultErrorWidget extends StatelessWidget {
  final Failure failure;

  const DefaultErrorWidget(this.failure, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getErrorIcon(failure),
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            failure.message,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // 重试逻辑
            },
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }

  IconData _getErrorIcon(Failure failure) {
    return switch (failure.runtimeType) {
      NetworkFailure => Icons.wifi_off,
      ServerFailure => Icons.server_error,
      AuthFailure => Icons.lock,
      ValidationFailure => Icons.warning,
      _ => Icons.error,
    };
  }
}
```

### 2. 表单处理

```dart
/// 登录表单状态
@freezed
class LoginFormState with _$LoginFormState {
  const factory LoginFormState({
    @Default('') String email,
    @Default('') String password,
    @Default(false) bool isLoading,
    String? errorMessage,
    @Default({}) Map<String, String> fieldErrors,
  }) = _LoginFormState;
}

/// 登录表单管理
@riverpod
class LoginFormNotifier extends _$LoginFormNotifier {
  @override
  LoginFormState build() {
    return const LoginFormState();
  }

  void updateEmail(String email) {
    state = state.copyWith(
      email: email,
      fieldErrors: {...state.fieldErrors}..remove('email'),
    );
  }

  void updatePassword(String password) {
    state = state.copyWith(
      password: password,
      fieldErrors: {...state.fieldErrors}..remove('password'),
    );
  }

  Future<void> submit() async {
    // 客户端验证
    final fieldErrors = <String, String>{};
    
    if (state.email.isEmpty) {
      fieldErrors['email'] = '请输入邮箱';
    } else if (!_isValidEmail(state.email)) {
      fieldErrors['email'] = '邮箱格式不正确';
    }
    
    if (state.password.isEmpty) {
      fieldErrors['password'] = '请输入密码';
    } else if (state.password.length < 6) {
      fieldErrors['password'] = '密码至少6位';
    }
    
    if (fieldErrors.isNotEmpty) {
      state = state.copyWith(fieldErrors: fieldErrors);
      return;
    }
    
    // 提交登录
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    final authNotifier = ref.read(authNotifierProvider.notifier);
    await authNotifier.login(
      email: state.email,
      password: state.password,
    );
    
    // 检查登录结果
    final authState = ref.read(authNotifierProvider);
    authState.when(
      initial: () {},
      loading: () {},
      authenticated: (_) {
        state = state.copyWith(isLoading: false);
        // 导航到主页
      },
      unauthenticated: (errorMessage) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: errorMessage,
        );
      },
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

/// 登录页面
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(loginFormNotifierProvider);
    final formNotifier = ref.read(loginFormNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('登录')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 错误消息
            if (formState.errorMessage != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  formState.errorMessage!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
              ),
            
            // 邮箱输入框
            TextFormField(
              onChanged: formNotifier.updateEmail,
              decoration: InputDecoration(
                labelText: '邮箱',
                errorText: formState.fieldErrors['email'],
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            
            // 密码输入框
            TextFormField(
              onChanged: formNotifier.updatePassword,
              decoration: InputDecoration(
                labelText: '密码',
                errorText: formState.fieldErrors['password'],
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            
            // 登录按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: formState.isLoading ? null : formNotifier.submit,
                child: formState.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('登录'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 🔧 实用扩展

### 1. Either 扩展方法

```dart
/// Future Either 扩展
extension FutureEitherExtensions<L, R> on Future<Either<L, R>> {
  /// 转换为 AsyncValue
  Future<AsyncValue<R>> toAsyncValue() async {
    try {
      final result = await this;
      return result.fold(
        (failure) => AsyncValue.error(failure, StackTrace.current),
        (value) => AsyncValue.data(value),
      );
    } catch (error, stackTrace) {
      return AsyncValue.error(error, stackTrace);
    }
  }

  /// 异步 flatMap
  Future<Either<L, T>> flatMapAsync<T>(
    Future<Either<L, T>> Function(R) mapper,
  ) async {
    final result = await this;
    return result.fold(
      (failure) => Left(failure),
      (value) => mapper(value),
    );
  }
}
```

### 2. Riverpod 特定扩展

```dart
/// Ref 扩展，用于处理 Either
extension RefEitherExtensions on Ref {
  /// 监听 Either Provider 并处理错误
  void listenEither<T>(
    ProviderListenable<AsyncValue<Either<Failure, T>>> provider,
    void Function(T data) onData, {
    void Function(Failure failure)? onError,
  }) {
    listen(provider, (previous, next) {
      next.when(
        data: (either) => either.fold(
          (failure) => onError?.call(failure),
          (data) => onData(data),
        ),
        loading: () {},
        error: (error, stack) {},
      );
    });
  }
}
```

## 📱 完整示例：用户管理应用

```dart
/// 主应用
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Dartz Riverpod Demo',
      routerConfig: ref.watch(routerProvider),
    );
  }
}

/// 用户列表页面
class UserListPage extends ConsumerWidget {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userListState = ref.watch(userListNotifierProvider);
    final userListNotifier = ref.read(userListNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('用户列表'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => userListNotifier.loadUsers(refresh: true),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => userListNotifier.loadUsers(refresh: true),
        child: Column(
          children: [
            // 错误消息
            if (userListState.errorMessage != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Theme.of(context).colorScheme.errorContainer,
                child: Text(
                  userListState.errorMessage!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
              ),
            
            // 用户列表
            Expanded(
              child: ListView.builder(
                itemCount: userListState.users.length + 
                    (userListState.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == userListState.users.length) {
                    // 加载更多指示器
                    if (userListState.isLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      return TextButton(
                        onPressed: () => userListNotifier.loadUsers(),
                        child: const Text('加载更多'),
                      );
                    }
                  }
                  
                  final user = userListState.users[index];
                  return UserListItem(
                    user: user,
                    onDelete: () => userListNotifier.deleteUser(user.id),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 导航到创建用户页面
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

## 📚 总结

通过将 dartz 与 Riverpod 结合使用，我们可以：

1. **类型安全的错误处理** - 在编译时就能发现错误处理问题
2. **一致的状态管理** - 统一的错误处理模式
3. **优雅的异步操作** - 链式操作和组合
4. **可测试的代码** - 清晰的依赖注入和状态管理
5. **更好的用户体验** - 智能的错误恢复和状态管理

这种组合为 Flutter 应用提供了强大而灵活的架构基础，既保证了代码质量，又提升了开发效率。
