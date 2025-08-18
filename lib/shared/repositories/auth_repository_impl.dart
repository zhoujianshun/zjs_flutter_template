import 'package:dartz/dartz.dart';
import 'package:sky_eldercare_family/core/constants/storage_keys.dart';
import 'package:sky_eldercare_family/core/errors/failures.dart';
import 'package:sky_eldercare_family/core/storage/storage_service.dart';
import 'package:sky_eldercare_family/shared/models/auth_models.dart';
import 'package:sky_eldercare_family/shared/models/user.dart';
import 'package:sky_eldercare_family/shared/repositories/auth_repository.dart';
import 'package:sky_eldercare_family/shared/services/user_service.dart';

/// 认证仓库实现
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required UserService userService,
    required StorageService storageService,
  })  : _userService = userService,
        _storageService = storageService;

  final UserService _userService;
  final StorageService _storageService;

  @override
  Future<Either<Failure, AuthResponse>> login(LoginRequest request) async {
    try {
      // 使用 UserService 进行登录
      final result = await _userService.login(
        email: request.email,
        password: request.password,
      );

      return result.fold(
        Left.new,
        (loginResult) async {
          // Repository层负责数据存储
          await _storageService.setUserToken(loginResult.token);
          await _storageService.setUserData('user_info', loginResult.user.toJson());

          final authResponse = AuthResponse(
            accessToken: loginResult.token,
            refreshToken: 'refresh_token_${DateTime.now().millisecondsSinceEpoch}',
            user: loginResult.user,
            expiresAt: DateTime.now().add(const Duration(hours: 24)),
            tokenType: 'Bearer',
          );

          // 如果选择记住我，保存完整的认证信息到本地存储
          if (request.rememberMe) {
            await saveAuthInfo(authResponse);
          }

          return Right(authResponse);
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: '登录失败: $e'));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> phoneLogin(PhoneLoginRequest request) async {
    try {
      // 使用 UserService 进行手机号登录
      final result = await _userService.phoneLogin(
        phone: request.phone,
        code: request.code,
      );

      return result.fold(
        Left.new,
        (loginResult) async {
          // Repository层负责数据存储
          await _storageService.setUserToken(loginResult.token);
          await _storageService.setUserData('user_info', loginResult.user.toJson());

          final authResponse = AuthResponse(
            accessToken: loginResult.token,
            refreshToken: 'refresh_token_${DateTime.now().millisecondsSinceEpoch}',
            user: loginResult.user,
            expiresAt: DateTime.now().add(const Duration(hours: 24)),
            tokenType: 'Bearer',
          );

          // 如果选择记住我，保存完整的认证信息到本地存储
          if (request.rememberMe) {
            await saveAuthInfo(authResponse);
          }

          return Right(authResponse);
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: '手机号登录失败: $e'));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> register(RegisterRequest request) async {
    try {
      // 使用 UserService 进行注册
      final result = await _userService.register(
        email: request.email,
        password: request.password,
        name: request.name,
        phone: request.phone,
      );

      return result.fold(
        Left.new,
        (loginResult) async {
          // Repository层负责数据存储
          await _storageService.setUserToken(loginResult.token);
          await _storageService.setUserData('user_info', loginResult.user.toJson());

          final authResponse = AuthResponse(
            accessToken: loginResult.token,
            refreshToken: 'refresh_token_${DateTime.now().millisecondsSinceEpoch}',
            user: loginResult.user,
            expiresAt: DateTime.now().add(const Duration(hours: 24)),
            tokenType: 'Bearer',
          );

          return Right(authResponse);
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: '注册失败: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // 使用 UserService 进行登出
      final result = await _userService.logout();

      return result.fold(
        Left.new,
        (_) async {
          // Repository层负责清理所有本地数据
          await _storageService.removeUserToken();
          await _storageService.clearUserData();
          await clearLocalAuthInfo();
          return const Right(null);
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: '登出失败: $e'));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> refreshToken(RefreshTokenRequest request) async {
    try {
      // 使用 UserService 刷新Token
      final result = await _userService.refreshToken();

      return result.fold(
        Left.new,
        (newToken) async {
          // Repository层负责存储新token
          await _storageService.setUserToken(newToken);

          // 获取当前用户信息
          final userResult = await _userService.getCurrentUser();

          return userResult.fold(
            Left.new,
            (user) async {
              // Repository层负责更新用户信息缓存
              await _storageService.setUserData('user_info', user.toJson());

              final authResponse = AuthResponse(
                accessToken: newToken,
                refreshToken: request.refreshToken,
                user: user,
                expiresAt: DateTime.now().add(const Duration(hours: 24)),
                tokenType: 'Bearer',
              );

              await saveAuthInfo(authResponse);
              return Right(authResponse);
            },
          );
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: '刷新Token失败: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(ResetPasswordRequest request) async {
    try {
      // 模拟API调用
      await Future<void>.delayed(const Duration(seconds: 1));
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: '重置密码失败: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword(ChangePasswordRequest request) async {
    try {
      // 使用 UserService 修改密码
      final result = await _userService.changePassword(
        oldPassword: request.oldPassword,
        newPassword: request.newPassword,
      );

      return result.fold(
        Left.new,
        (_) => const Right(null),
      );
    } catch (e) {
      return Left(ServerFailure(message: '修改密码失败: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> sendVerificationCode(VerificationCodeRequest request) async {
    try {
      // 模拟API调用
      await Future<void>.delayed(const Duration(seconds: 1));
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: '发送验证码失败: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> verifyCode(VerifyCodeRequest request) async {
    try {
      // 模拟API调用
      await Future<void>.delayed(const Duration(seconds: 1));
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: '验证码验证失败: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      // Repository层先从缓存获取
      final cachedUserData = _storageService.getUserData<Map<String, dynamic>>('user_info');
      if (cachedUserData != null) {
        final user = User.fromJson(cachedUserData);
        return Right(user);
      }

      // 如果缓存没有，使用 UserService 从服务器获取
      final result = await _userService.getCurrentUser();

      return result.fold(
        Left.new,
        (user) async {
          // Repository层负责缓存用户信息
          await _storageService.setUserData('user_info', user.toJson());
          return Right(user);
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: '获取用户信息失败: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> updateUser(User user) async {
    try {
      // 使用 UserService 更新用户信息
      final result = await _userService.updateUser(
        name: user.name,
        phone: user.phone,
        avatar: user.avatar,
        birthday: user.birthday,
        gender: user.gender,
      );

      return result.fold(
        Left.new,
        (updatedUser) async {
          // 更新本地存储的认证信息中的用户信息
          final localAuth = await getLocalAuthInfo();
          await localAuth.fold(
            (failure) => Future<void>.value(),
            (authResponse) async {
              if (authResponse != null) {
                final newAuthResponse = AuthResponse(
                  accessToken: authResponse.accessToken,
                  refreshToken: authResponse.refreshToken,
                  user: updatedUser,
                  expiresAt: authResponse.expiresAt,
                  tokenType: authResponse.tokenType,
                );
                await saveAuthInfo(newAuthResponse);
              }
            },
          );

          return Right(updatedUser);
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: '更新用户信息失败: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> validateToken(String token) async {
    try {
      // 模拟API调用
      await Future<void>.delayed(const Duration(milliseconds: 500));

      // 简单的Token验证逻辑
      final isValid = token.isNotEmpty && !token.contains('expired');
      return Right(isValid);
    } catch (e) {
      return Left(ServerFailure(message: '验证Token失败: $e'));
    }
  }

  @override
  Future<Either<Failure, AuthResponse?>> getLocalAuthInfo() async {
    try {
      final authData = _storageService.getUserData<Map<String, dynamic>>(StorageKeys.authInfo);
      if (authData != null) {
        final authResponse = AuthResponse.fromJson(authData);
        return Right(authResponse);
      }
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: '获取本地认证信息失败: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveAuthInfo(AuthResponse authResponse) async {
    try {
      await _storageService.setUserData(
        StorageKeys.authInfo,
        authResponse.toJson(),
      );
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: '保存认证信息失败: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearLocalAuthInfo() async {
    try {
      await _storageService.removeUserData(StorageKeys.authInfo);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: '清除认证信息失败: $e'));
    }
  }
}
