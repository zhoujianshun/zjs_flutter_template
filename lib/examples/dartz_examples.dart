// ignore_for_file: unused_local_variable, avoid_print

import 'package:dartz/dartz.dart';
import 'package:zjs_flutter_template/core/errors/failures.dart';
import 'package:zjs_flutter_template/shared/models/user.dart';

/// Dartz 使用示例
///
/// 这个文件展示了在我们的项目中如何使用 dartz 包
/// 包含了常见的使用场景和最佳实践
class DartzExamples {
  /// 示例 1: 基本的 Either 使用
  ///
  /// Either<L, R> 表示一个值要么是左边的类型 L（错误），要么是右边的类型 R（成功）
  static Either<String, int> divide(int a, int b) {
    if (b == 0) {
      return const Left('除数不能为零');
    }
    return Right(a ~/ b);
  }

  /// 示例 2: 使用 fold 方法处理 Either
  static void handleDivisionResult() {
    final result = divide(10, 2);

    // fold 方法接受两个函数，分别处理左边（错误）和右边（成功）的情况
    final message = result.fold(
      (error) => '计算失败: $error',
      (value) => '计算结果: $value',
    );

    print(message);
  }

  /// 示例 3: 模拟网络请求的错误处理
  static Future<Either<Failure, User>> fetchUser(String userId) async {
    try {
      // 模拟网络延迟
      await Future<void>.delayed(const Duration(seconds: 1));

      // 模拟不同的错误情况
      if (userId.isEmpty) {
        return const Left(ValidationFailure(message: '用户ID不能为空'));
      }

      if (userId == 'network_error') {
        return const Left(NetworkFailure(message: '网络连接失败'));
      }

      if (userId == 'server_error') {
        return const Left(ServerFailure(message: '服务器内部错误'));
      }

      // 模拟成功获取用户信息
      final user = User(
        id: userId,
        name: '用户$userId',
        email: 'user$userId@example.com',
        phone: '1234567890',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      return Right(user);
    } catch (e) {
      return Left(UnknownFailure(message: '未知错误: $e'));
    }
  }

  /// 示例 4: 处理异步 Either 结果
  static Future<void> handleAsyncEither() async {
    final result = await fetchUser('123');

    result.fold(
      (failure) {
        print('获取用户失败: ${failure.message}');

        // 根据不同的失败类型进行不同的处理
        if (failure is NetworkFailure) {
          print('请检查网络连接');
        } else if (failure is ServerFailure) {
          print('服务器错误，请稍后重试');
        } else if (failure is ValidationFailure) {
          print('请检查输入参数');
        }
      },
      (user) {
        print('获取用户成功: ${user.name}');
      },
    );
  }

  /// 示例 5: 链式操作 - map
  ///
  /// map 方法可以转换成功的值，而不影响错误的值
  static Future<Either<Failure, String>> getUserDisplayName(String userId) async {
    final userResult = await fetchUser(userId);

    // 使用 map 转换成功的结果
    return userResult.map((user) {
      return user.displayName;
    });
  }

  /// 示例 6: 链式操作 - flatMap
  ///
  /// flatMap 用于链接多个可能失败的操作
  static Future<Either<Failure, String>> getUserEmailDomain(String userId) async {
    final userResult = await fetchUser(userId);

    return userResult.fold(
      Left.new,
      (user) async {
        final email = user.email;
        if (email.isEmpty) {
          return const Left(ValidationFailure(message: '用户邮箱为空'));
        }

        final emailParts = email.split('@');
        if (emailParts.length != 2) {
          return const Left(ValidationFailure(message: '邮箱格式不正确'));
        }

        return Right(emailParts[1]);
      },
    );
  }

  /// 示例 7: Option 类型的使用
  ///
  /// Option 用于处理可能为空的值
  static Option<String> findUserNameById(String userId, List<User> users) {
    try {
      final user = users.firstWhere((u) => u.id == userId);
      return Some(user.displayName);
    } catch (e) {
      return const None();
    }
  }

  /// 示例 8: 处理 Option 类型
  static void handleOptionResult() {
    final users = <User>[
      User(
        id: '1',
        name: '张三',
        email: 'zhangsan@example.com',
        phone: '1234567890',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      User(
        id: '2',
        name: '李四',
        email: 'lisi@example.com',
        phone: '0987654321',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    final nameOption = findUserNameById('1', users);

    nameOption.fold(
      () => print('用户不存在'),
      (name) => print('找到用户: $name'),
    );
  }

  /// 示例 9: 批量操作处理
  ///
  /// 处理多个异步操作，只有全部成功才返回成功
  static Future<Either<Failure, List<User>>> fetchMultipleUsers(
    List<String> userIds,
  ) async {
    final users = <User>[];

    for (final userId in userIds) {
      final result = await fetchUser(userId);

      // 如果任何一个请求失败，立即返回失败
      if (result.isLeft()) {
        return result.fold(
          Left.new,
          (_) => throw StateError('不可能的情况'),
        );
      }

      // 添加成功获取的用户
      result.fold(
        (_) => throw StateError('不可能的情况'),
        users.add,
      );
    }

    return Right(users);
  }

  /// 示例 10: 错误恢复
  ///
  /// 当操作失败时，提供默认值或执行替代操作
  static Future<Either<Failure, User>> fetchUserWithFallback(
    String userId,
  ) async {
    final result = await fetchUser(userId);

    return result.fold(
      (failure) async {
        // 如果是网络错误，尝试从缓存获取
        if (failure is NetworkFailure) {
          print('网络错误，尝试从缓存获取用户信息');
          // 这里可以从本地存储获取用户信息
          return Right(
            User(
              id: userId,
              name: '缓存用户',
              email: 'cache@example.com',
              phone: '0000000000',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );
        }

        // 其他错误直接返回
        return Left(failure);
      },
      Right.new,
    );
  }

  /// 示例 11: 条件操作
  ///
  /// 根据条件执行不同的操作
  static Future<Either<Failure, String>> processUser(
    String userId,
    bool shouldUpdateProfile,
  ) async {
    final userResult = await fetchUser(userId);

    return userResult.fold(
      Left.new,
      (user) async {
        if (shouldUpdateProfile) {
          // 模拟更新用户资料
          print('更新用户资料: ${user.name}');
          await Future<void>.delayed(const Duration(milliseconds: 500));
          return Right('用户资料已更新: ${user.name}');
        } else {
          return Right('用户信息: ${user.name}');
        }
      },
    );
  }

  /// 示例 12: 组合多个操作
  ///
  /// 将多个可能失败的操作组合在一起
  static Future<Either<Failure, Map<String, dynamic>>> getUserProfile(
    String userId,
  ) async {
    // 获取用户基本信息
    final userResult = await fetchUser(userId);
    if (userResult.isLeft()) {
      return userResult.fold(
        Left.new,
        (_) => throw StateError('不可能的情况'),
      );
    }

    // 获取用户邮箱域名
    final domainResult = await getUserEmailDomain(userId);
    if (domainResult.isLeft()) {
      return domainResult.fold(
        Left.new,
        (_) => throw StateError('不可能的情况'),
      );
    }

    // 组合结果
    final user = userResult.fold(
      (_) => throw StateError('不可能的情况'),
      (user) => user,
    );

    final domain = domainResult.fold(
      (_) => throw StateError('不可能的情况'),
      (domain) => domain,
    );

    return Right({
      'user': user.toJson(),
      'emailDomain': domain,
      'profileComplete': user.displayName.isNotEmpty,
    });
  }

  /// 运行所有示例
  static Future<void> runAllExamples() async {
    print('=== Dartz 使用示例 ===\n');

    print('1. 基本 Either 使用:');
    handleDivisionResult();
    print('');

    print('2. 异步 Either 处理:');
    await handleAsyncEither();
    print('');

    print('3. 链式操作 - 获取用户显示名称:');
    final displayNameResult = await getUserDisplayName('123');
    displayNameResult.fold(
      (failure) => print('失败: ${failure.message}'),
      (name) => print('显示名称: $name'),
    );
    print('');

    print('4. 链式操作 - 获取邮箱域名:');
    final domainResult = await getUserEmailDomain('123');
    domainResult.fold(
      (failure) => print('失败: ${failure.message}'),
      (domain) => print('邮箱域名: $domain'),
    );
    print('');

    print('5. Option 类型处理:');
    handleOptionResult();
    print('');

    print('6. 批量操作:');
    final batchResult = await fetchMultipleUsers(['123', '456']);
    batchResult.fold(
      (failure) => print('批量获取失败: ${failure.message}'),
      (users) => print('成功获取 ${users.length} 个用户'),
    );
    print('');

    print('7. 错误恢复:');
    final fallbackResult = await fetchUserWithFallback('network_error');
    fallbackResult.fold(
      (failure) => print('恢复失败: ${failure.message}'),
      (user) => print('恢复成功: ${user.name}'),
    );
    print('');

    print('8. 组合操作:');
    final profileResult = await getUserProfile('123');
    profileResult.fold(
      (failure) => print('获取用户档案失败: ${failure.message}'),
      (profile) => print('用户档案: $profile'),
    );
  }
}

/// Either 扩展方法示例
extension EitherExtensionsExample<L, R> on Either<L, R> {
  /// 获取右侧值，如果是左侧则返回 null
  R? get rightOrNull => fold((_) => null, (r) => r);

  /// 获取左侧值，如果是右侧则返回 null
  L? get leftOrNull => fold((l) => l, (_) => null);

  /// 是否是成功结果
  bool get isRight => fold((_) => false, (_) => true);

  /// 是否是失败结果
  bool get isLeft => fold((_) => true, (_) => false);

  /// 当是右侧值时执行操作
  Either<L, R> onRight(void Function(R) action) {
    return fold(
      Left.new,
      (r) {
        action(r);
        return Right(r);
      },
    );
  }

  /// 当是左侧值时执行操作
  Either<L, R> onLeft(void Function(L) action) {
    return fold(
      (l) {
        action(l);
        return Left(l);
      },
      Right.new,
    );
  }
}

/// Future Either 扩展方法示例
extension FutureEitherExtensionsExample<L, R> on Future<Either<L, R>> {
  /// 异步 map 操作
  Future<Either<L, T>> mapAsync<T>(Future<T> Function(R) mapper) async {
    final result = await this;
    return result.fold(
      Left.new,
      (r) async => Right(await mapper(r)),
    );
  }

  /// 异步 flatMap 操作
  Future<Either<L, T>> flatMapAsync<T>(
    Future<Either<L, T>> Function(R) mapper,
  ) async {
    final result = await this;
    return result.fold(
      Left.new,
      (r) => mapper(r),
    );
  }
}
