# Riverpod 使用指南

## 🎯 核心Provider类型

### 1. Provider - 只读数据

用于提供不变的数据或计算结果。

```dart
// 简单值
final nameProvider = Provider<String>((ref) => 'John Doe');

// 计算属性
final fullNameProvider = Provider<String>((ref) {
  final firstName = ref.watch(firstNameProvider);
  final lastName = ref.watch(lastNameProvider);
  return '$firstName $lastName';
});
```

### 2. StateProvider - 简单状态

用于管理简单的可变状态。

```dart
// 计数器示例
final counterProvider = StateProvider<int>((ref) => 0);

// 在Widget中使用
class CounterWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    
    return Column(
      children: [
        Text('计数: $count'),
        ElevatedButton(
          onPressed: () => ref.read(counterProvider.notifier).state++,
          child: Text('增加'),
        ),
      ],
    );
  }
}
```

### 3. StateNotifierProvider - 复杂状态

用于管理复杂的状态逻辑。

```dart
// 状态类
class CounterState {
  final int count;
  final bool isLoading;
  
  CounterState({required this.count, required this.isLoading});
  
  CounterState copyWith({int? count, bool? isLoading}) {
    return CounterState(
      count: count ?? this.count,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// StateNotifier
class CounterNotifier extends StateNotifier<CounterState> {
  CounterNotifier() : super(CounterState(count: 0, isLoading: false));
  
  void increment() {
    state = state.copyWith(count: state.count + 1);
  }
  
  Future<void> incrementAsync() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(Duration(seconds: 1));
    state = state.copyWith(
      count: state.count + 1,
      isLoading: false,
    );
  }
}

// Provider
final counterNotifierProvider = StateNotifierProvider<CounterNotifier, CounterState>(
  (ref) => CounterNotifier(),
);
```

### 4. FutureProvider - 异步数据

用于处理异步操作。

```dart
// API调用
final userProvider = FutureProvider<User>((ref) async {
  final response = await http.get(Uri.parse('/api/user'));
  return User.fromJson(json.decode(response.body));
});

// 在Widget中使用
class UserProfile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    
    return userAsync.when(
      data: (user) => Text('用户: ${user.name}'),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('错误: $error'),
    );
  }
}
```

### 5. StreamProvider - 流数据

用于处理数据流。

```dart
// WebSocket或实时数据
final messagesProvider = StreamProvider<List<Message>>((ref) {
  return FirebaseFirestore.instance
      .collection('messages')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Message.fromJson(doc.data()))
          .toList());
});
```

## 🔧 Consumer类型

### 1. ConsumerWidget

最常用的消费者Widget。

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return Text('$count');
  }
}
```

### 2. Consumer

在StatelessWidget中使用。

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final count = ref.watch(counterProvider);
        return Text('$count');
      },
    );
  }
}
```

### 3. ConsumerStatefulWidget

有状态Widget的消费者版本。

```dart
class MyWidget extends ConsumerStatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<MyWidget> {
  @override
  Widget build(BuildContext context) {
    final count = ref.watch(counterProvider);
    return Text('$count');
  }
}
```

## 📖 Ref对象方法

### ref.watch() - 监听变化

当Provider值改变时，Widget会重新构建。

```dart
final count = ref.watch(counterProvider);
```

### ref.read() - 一次性读取

读取当前值，不监听变化。通常用于事件处理。

```dart
onPressed: () {
  ref.read(counterProvider.notifier).state++;
}
```

### ref.listen() - 监听副作用

监听变化但不重新构建Widget，用于副作用。

```dart
ref.listen(counterProvider, (previous, next) {
  if (next == 10) {
    showDialog(/* ... */);
  }
});
```

## 🎯 实际项目示例

### 用户认证状态管理

```dart
// 用户状态
class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;
  
  AuthState({this.user, this.isLoading = false, this.error});
  
  AuthState copyWith({User? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// 认证逻辑
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());
  
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final user = await AuthService.login(email, password);
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
  
  void logout() {
    state = AuthState();
  }
}

// Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);

// 使用示例
class LoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    // 监听登录状态变化
    ref.listen(authProvider, (previous, next) {
      if (next.user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
    
    return Scaffold(
      body: Column(
        children: [
          if (authState.isLoading)
            CircularProgressIndicator(),
          if (authState.error != null)
            Text('错误: ${authState.error}'),
          ElevatedButton(
            onPressed: authState.isLoading ? null : () {
              ref.read(authProvider.notifier).login(email, password);
            },
            child: Text('登录'),
          ),
        ],
      ),
    );
  }
}
```

## 🔥 高级特性

### 1. 家族Provider (Family)

根据参数创建不同的Provider实例。

```dart
final userProvider = FutureProvider.family<User, String>((ref, userId) async {
  return UserService.getUser(userId);
});

// 使用
final user = ref.watch(userProvider('user123'));
```

### 2. 自动销毁Provider (AutoDispose)

当没有监听者时自动销毁。

```dart
final counterProvider = StateProvider.autoDispose<int>((ref) => 0);
```

### 3. Provider依赖

Provider可以依赖其他Provider。

```dart
final configProvider = Provider<Config>((ref) => Config());

final apiClientProvider = Provider<ApiClient>((ref) {
  final config = ref.watch(configProvider);
  return ApiClient(baseUrl: config.apiUrl);
});

final userServiceProvider = Provider<UserService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UserService(apiClient);
});
```

## 💡 最佳实践

### 1. Provider命名约定

```dart
// 好的命名
final userProvider = StateNotifierProvider<UserNotifier, User>(...);
final currentUserProvider = Provider<User?>(...);
final isLoggedInProvider = Provider<bool>(...);

// 避免的命名
final provider1 = StateProvider<int>(...);
final data = FutureProvider<String>(...);
```

### 2. 状态设计原则

- 保持状态扁平化
- 使用不可变对象
- 分离UI状态和业务状态

```dart
// 好的设计
class UserState {
  final User? user;
  final bool isLoading;
  final String? error;
}

// 避免嵌套过深
class BadState {
  final Map<String, Map<String, dynamic>> data;
}
```

### 3. 错误处理

```dart
class DataNotifier extends StateNotifier<AsyncValue<List<Data>>> {
  DataNotifier() : super(const AsyncValue.loading());
  
  Future<void> loadData() async {
    state = const AsyncValue.loading();
    
    try {
      final data = await DataService.loadData();
      state = AsyncValue.data(data);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
```

## 🎨 项目中的实际应用

在你的项目中，Riverpod已经被用于：

1. **主题管理** - `themeModeProvider`
2. **路由管理** - `appRouterProvider`  
3. **网络请求** - `apiClientProvider`
4. **用户服务** - `userServiceProvider`

这些都是很好的Riverpod使用示例，你可以参考学习！
