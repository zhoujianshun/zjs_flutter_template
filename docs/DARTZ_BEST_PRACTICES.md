# Dartz 最佳实践指南

## 📋 目录

- [设计原则](#设计原则)
- [错误处理策略](#错误处理策略)
- [API 设计规范](#api-设计规范)
- [性能优化](#性能优化)
- [测试策略](#测试策略)
- [常见陷阱](#常见陷阱)
- [代码风格](#代码风格)

## 🎯 设计原则

### 1. 一致性原则

在整个应用中保持一致的错误处理方式：

```dart
// ✅ 好的做法 - 统一使用 Either
abstract class UserRepository {
  Future<Either<Failure, User>> getUser(String id);
  Future<Either<Failure, List<User>>> getUsers();
  Future<Either<Failure, void>> deleteUser(String id);
}

// ❌ 不好的做法 - 混合使用异常和 Either
abstract class UserRepository {
  Future<Either<Failure, User>> getUser(String id);
  Future<List<User>> getUsers(); // 抛出异常
  Future<void> deleteUser(String id); // 抛出异常
}
```

### 2. 类型安全原则

使用具体的 Failure 类型而不是通用的 String：

```dart
// ✅ 好的做法 - 使用具体的 Failure 类型
Future<Either<UserNotFoundFailure, User>> findUser(String id) async {
  // 实现逻辑
}

// ❌ 不好的做法 - 使用通用的 String
Future<Either<String, User>> findUser(String id) async {
  // 实现逻辑
}
```

### 3. 最小化原则

只在真正需要的地方使用 Either，避免过度设计：

```dart
// ✅ 好的做法 - 简单的计算不需要 Either
int calculateAge(DateTime birthDate) {
  return DateTime.now().year - birthDate.year;
}

// ❌ 不好的做法 - 过度使用 Either
Either<ValidationFailure, int> calculateAge(DateTime birthDate) {
  return Right(DateTime.now().year - birthDate.year);
}
```

## 🚨 错误处理策略

### 1. 错误分层

建立清晰的错误处理层次：

```dart
// 基础错误类型
abstract class Failure extends Equatable {
  final String message;
  final int? code;
  final DateTime timestamp;
  
  const Failure({
    required this.message,
    this.code,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

// 业务层错误
abstract class BusinessFailure extends Failure {
  const BusinessFailure({
    required super.message,
    super.code,
    super.timestamp,
  });
}

// 基础设施层错误
abstract class InfrastructureFailure extends Failure {
  const InfrastructureFailure({
    required super.message,
    super.code,
    super.timestamp,
  });
}

// 具体的业务错误
class UserNotFoundFailure extends BusinessFailure {
  final String userId;
  
  const UserNotFoundFailure({
    required this.userId,
    super.code,
  }) : super(message: '用户不存在: $userId');
}

// 具体的基础设施错误
class DatabaseConnectionFailure extends InfrastructureFailure {
  const DatabaseConnectionFailure({
    super.code,
  }) : super(message: '数据库连接失败');
}
```

### 2. 错误恢复策略

实现智能的错误恢复机制：

```dart
class UserService {
  Future<Either<Failure, User>> getUser(String id) async {
    // 首先尝试从远程获取
    final remoteResult = await _getRemoteUser(id);
    
    return remoteResult.fold(
      (failure) async {
        // 如果是网络错误，尝试从缓存获取
        if (failure is NetworkFailure) {
          final cacheResult = await _getCachedUser(id);
          
          return cacheResult.fold(
            (cacheFailure) => Left(failure), // 返回原始网络错误
            (cachedUser) => Right(cachedUser),
          );
        }
        
        // 其他错误直接返回
        return Left(failure);
      },
      (user) => Right(user),
    );
  }
}
```

### 3. 错误上下文

提供丰富的错误上下文信息：

```dart
class DetailedFailure extends Failure {
  final String operation;
  final Map<String, dynamic> context;
  final Failure? cause;
  
  const DetailedFailure({
    required super.message,
    required this.operation,
    this.context = const {},
    this.cause,
    super.code,
  });
  
  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('Operation: $operation');
    buffer.writeln('Message: $message');
    if (context.isNotEmpty) {
      buffer.writeln('Context: $context');
    }
    if (cause != null) {
      buffer.writeln('Caused by: $cause');
    }
    return buffer.toString();
  }
}
```

## 🔌 API 设计规范

### 1. 命名约定

使用清晰且一致的命名：

```dart
// ✅ 好的做法 - 清晰的方法命名
abstract class UserService {
  Future<Either<Failure, User>> getUserById(String id);
  Future<Either<Failure, User>> createUser(CreateUserRequest request);
  Future<Either<Failure, User>> updateUser(String id, UpdateUserRequest request);
  Future<Either<Failure, void>> deleteUser(String id);
}

// ❌ 不好的做法 - 模糊的方法命名
abstract class UserService {
  Future<Either<Failure, User>> get(String id);
  Future<Either<Failure, User>> save(User user);
  Future<Either<Failure, void>> remove(String id);
}
```

### 2. 参数验证

在服务层进行参数验证：

```dart
class UserServiceImpl implements UserService {
  @override
  Future<Either<Failure, User>> getUserById(String id) async {
    // 参数验证
    if (id.isEmpty) {
      return const Left(ValidationFailure(message: '用户ID不能为空'));
    }
    
    if (!_isValidUserId(id)) {
      return const Left(ValidationFailure(message: '用户ID格式不正确'));
    }
    
    try {
      final user = await _repository.findById(id);
      return Right(user);
    } on RepositoryException catch (e) {
      return Left(_mapRepositoryException(e));
    }
  }
  
  bool _isValidUserId(String id) {
    return RegExp(r'^[a-zA-Z0-9]{8,}$').hasMatch(id);
  }
}
```

### 3. 异常映射

建立清晰的异常到 Failure 的映射：

```dart
class ExceptionMapper {
  static Failure mapException(Exception exception) {
    return switch (exception) {
      NetworkException e => NetworkFailure(
          message: e.message,
          code: e.statusCode,
        ),
      DatabaseException e => ServerFailure(
          message: '数据库操作失败: ${e.message}',
          code: e.code,
        ),
      ValidationException e => ValidationFailure(
          message: e.message,
          code: e.code,
        ),
      TimeoutException e => NetworkFailure(
          message: '请求超时',
          code: 408,
        ),
      _ => UnknownFailure(
          message: '未知错误: ${exception.toString()}',
        ),
    };
  }
}
```

## ⚡ 性能优化

### 1. 避免不必要的对象创建

缓存常用的 Failure 实例：

```dart
class CommonFailures {
  static const networkUnavailable = NetworkFailure(
    message: '网络不可用',
    code: -1,
  );
  
  static const unauthorized = AuthFailure(
    message: '未授权访问',
    code: 401,
  );
  
  static const serverError = ServerFailure(
    message: '服务器内部错误',
    code: 500,
  );
}

// 使用预定义的失败实例
Future<Either<Failure, User>> login() async {
  if (!await _networkInfo.isConnected) {
    return const Left(CommonFailures.networkUnavailable);
  }
  
  // 其他逻辑...
}
```

### 2. 延迟错误处理

只在真正需要时才处理错误：

```dart
// ✅ 好的做法 - 延迟处理
Future<Either<Failure, String>> processUserData(String userId) async {
  return (await getUserById(userId))
      .map((user) => user.name)
      .map((name) => name.toUpperCase());
}

// ❌ 不好的做法 - 过早处理
Future<Either<Failure, String>> processUserData(String userId) async {
  final userResult = await getUserById(userId);
  
  if (userResult.isLeft()) {
    return userResult.fold(
      (failure) => Left(failure),
      (_) => throw StateError('不可能'),
    );
  }
  
  final user = userResult.fold(
    (_) => throw StateError('不可能'),
    (user) => user,
  );
  
  return Right(user.name.toUpperCase());
}
```

## 🧪 测试策略

### 1. 单元测试

测试所有可能的路径：

```dart
group('UserService', () {
  late UserService userService;
  late MockUserRepository mockRepository;
  
  setUp(() {
    mockRepository = MockUserRepository();
    userService = UserServiceImpl(mockRepository);
  });
  
  group('getUserById', () {
    test('should return Right when user exists', () async {
      // Arrange
      const userId = 'user123';
      final user = User(id: userId, name: '测试用户');
      when(() => mockRepository.findById(userId))
          .thenAnswer((_) async => user);
      
      // Act
      final result = await userService.getUserById(userId);
      
      // Assert
      expect(result.isRight, true);
      expect(result.rightOrNull, equals(user));
    });
    
    test('should return Left when user not found', () async {
      // Arrange
      const userId = 'nonexistent';
      when(() => mockRepository.findById(userId))
          .thenThrow(const UserNotFoundException('用户不存在'));
      
      // Act
      final result = await userService.getUserById(userId);
      
      // Assert
      expect(result.isLeft, true);
      expect(result.leftOrNull, isA<UserNotFoundFailure>());
    });
    
    test('should return Left when userId is empty', () async {
      // Act
      final result = await userService.getUserById('');
      
      // Assert
      expect(result.isLeft, true);
      expect(result.leftOrNull, isA<ValidationFailure>());
      expect(result.leftOrNull!.message, contains('用户ID不能为空'));
    });
  });
});
```

### 2. 集成测试

测试完整的错误处理流程：

```dart
group('User Login Flow', () {
  testWidgets('should show error message when login fails', (tester) async {
    // Arrange
    final mockUserService = MockUserService();
    when(() => mockUserService.login(any(), any()))
        .thenAnswer((_) async => const Left(
          AuthFailure(message: '用户名或密码错误'),
        ));
    
    // Act
    await tester.pumpWidget(MyApp(userService: mockUserService));
    await tester.enterText(find.byKey(const Key('email_field')), 'test@example.com');
    await tester.enterText(find.byKey(const Key('password_field')), 'wrong_password');
    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pump();
    
    // Assert
    expect(find.text('用户名或密码错误'), findsOneWidget);
  });
});
```

### 3. 测试工具

创建测试辅助工具：

```dart
class EitherMatchers {
  static Matcher isRight<L, R>(R expected) {
    return _IsRight<L, R>(expected);
  }
  
  static Matcher isLeft<L, R>(L expected) {
    return _IsLeft<L, R>(expected);
  }
}

class _IsRight<L, R> extends Matcher {
  final R expected;
  
  const _IsRight(this.expected);
  
  @override
  bool matches(item, Map matchState) {
    if (item is! Either<L, R>) return false;
    return item.fold(
      (_) => false,
      (value) => value == expected,
    );
  }
  
  @override
  Description describe(Description description) {
    return description.add('is Right($expected)');
  }
}

// 使用示例
test('should return right value', () {
  final result = divide(10, 2);
  expect(result, EitherMatchers.isRight<String, int>(5));
});
```

## ⚠️ 常见陷阱

### 1. 忘记处理错误

```dart
// ❌ 不好的做法 - 忘记处理左侧值
final result = await getUserById('123');
final user = result.fold(
  (_) => null, // 忽略错误
  (user) => user,
);
// user 可能为 null，但没有适当处理

// ✅ 好的做法 - 正确处理所有情况
final result = await getUserById('123');
result.fold(
  (failure) {
    // 正确处理错误
    _showErrorMessage(failure.message);
    return;
  },
  (user) {
    // 处理成功情况
    _displayUser(user);
  },
);
```

### 2. 过度嵌套

```dart
// ❌ 不好的做法 - 过度嵌套
Future<Either<Failure, String>> processUser(String id) async {
  final userResult = await getUserById(id);
  return userResult.fold(
    (failure) => Left(failure),
    (user) async {
      final profileResult = await getProfile(user.id);
      return profileResult.fold(
        (failure) => Left(failure),
        (profile) async {
          final settingsResult = await getSettings(profile.id);
          return settingsResult.fold(
            (failure) => Left(failure),
            (settings) => Right(settings.theme),
          );
        },
      );
    },
  );
}

// ✅ 好的做法 - 使用扩展方法简化
Future<Either<Failure, String>> processUser(String id) async {
  return (await getUserById(id))
      .flatMapAsync((user) => getProfile(user.id))
      .flatMapAsync((profile) => getSettings(profile.id))
      .map((settings) => settings.theme);
}
```

### 3. 不一致的错误类型

```dart
// ❌ 不好的做法 - 不一致的错误类型
Future<Either<String, User>> getUser(String id) async { /* ... */ }
Future<Either<Failure, User>> createUser(User user) async { /* ... */ }

// ✅ 好的做法 - 一致的错误类型
Future<Either<Failure, User>> getUser(String id) async { /* ... */ }
Future<Either<Failure, User>> createUser(User user) async { /* ... */ }
```

## 🎨 代码风格

### 1. 格式化

使用一致的格式化风格：

```dart
// ✅ 好的做法 - 清晰的格式化
final result = await userService
    .getUserById(userId)
    .then((either) => either.map((user) => user.name))
    .then((either) => either.map((name) => name.toUpperCase()));

result.fold(
  (failure) => _handleError(failure),
  (name) => _displayName(name),
);
```

### 2. 注释

为复杂的错误处理逻辑添加注释：

```dart
Future<Either<Failure, User>> authenticateUser(
  String email,
  String password,
) async {
  // 首先验证输入参数
  final validationResult = _validateCredentials(email, password);
  if (validationResult.isLeft) {
    return validationResult;
  }
  
  // 尝试本地认证（如生物识别）
  final localAuthResult = await _tryLocalAuth();
  if (localAuthResult.isRight) {
    return localAuthResult;
  }
  
  // 回退到远程认证
  return _remoteAuth(email, password);
}
```

### 3. 文档化

为公共 API 提供完整的文档：

```dart
/// 根据用户ID获取用户信息
/// 
/// 参数:
/// - [id]: 用户唯一标识符，不能为空
/// 
/// 返回:
/// - [Right<User>]: 成功获取用户信息
/// - [Left<ValidationFailure>]: 输入参数无效
/// - [Left<NetworkFailure>]: 网络连接失败
/// - [Left<UserNotFoundFailure>]: 用户不存在
/// - [Left<ServerFailure>]: 服务器错误
/// 
/// 示例:
/// ```dart
/// final result = await userService.getUserById('user123');
/// result.fold(
///   (failure) => print('获取失败: ${failure.message}'),
///   (user) => print('用户: ${user.name}'),
/// );
/// ```
Future<Either<Failure, User>> getUserById(String id);
```

## 📚 总结

遵循这些最佳实践可以帮助您：

1. **提高代码质量** - 通过类型安全和强制错误处理
2. **增强可维护性** - 通过一致的错误处理模式
3. **改善用户体验** - 通过优雅的错误恢复机制
4. **简化测试** - 通过可预测的错误行为
5. **提升团队效率** - 通过标准化的开发模式

记住，dartz 是一个工具，应该服务于您的业务需求。不要为了使用函数式编程而过度复杂化简单的逻辑，始终保持代码的可读性和可维护性。
