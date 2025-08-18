import 'package:dartz/dartz.dart';
import 'package:sky_eldercare_family/core/constants/storage_keys.dart';
import 'package:sky_eldercare_family/core/errors/failures.dart';
import 'package:sky_eldercare_family/core/network/api_client.dart';
import 'package:sky_eldercare_family/core/storage/storage_service.dart';
import 'package:sky_eldercare_family/shared/models/auth_models.dart';
import 'package:sky_eldercare_family/shared/models/user.dart';
import 'package:sky_eldercare_family/shared/repositories/auth_repository.dart';

/// 认证仓库实现（简化版本，用于演示）
class AuthRepositoryImplSimple implements AuthRepository {
  AuthRepositoryImplSimple({
    required ApiClient apiClient,
    required StorageService storageService,
  })  : _apiClient = apiClient,
        _storageService = storageService;
  final ApiClient _apiClient;
  final StorageService _storageService;

  @override
  Future<Either<Failure, AuthResponse>> login(LoginRequest request) async {
    try {
      // 模拟API调用
      await Future.delayed(const Duration(seconds: 1));

      // 模拟成功响应
      final mockUser = User(
        id: 'user_123',
        email: request.email,
        name: '测试用户',
        createdAt: DateTime.now(),
      );

      final authResponse = AuthResponse(
        accessToken: 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
        refreshToken: 'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
        user: mockUser,
        expiresAt: DateTime.now().add(const Duration(hours: 24)),
        tokenType: 'Bearer',
      );

      // 如果选择记住我，保存到本地存储
      if (request.rememberMe) {
        await saveAuthInfo(authResponse);
      }

      return Right(authResponse);
    } catch (e) {
      return Left(ServerFailure(message: '登录失败: $e'));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> register(RegisterRequest request) async {
    try {
      // 模拟API调用
      await Future.delayed(const Duration(seconds: 1));

      // 模拟成功响应
      final mockUser = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: request.email,
        name: request.name ?? '新用户',
        phone: request.phone,
        createdAt: DateTime.now(),
      );

      final authResponse = AuthResponse(
        accessToken: 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
        refreshToken: 'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
        user: mockUser,
        expiresAt: DateTime.now().add(const Duration(hours: 24)),
        tokenType: 'Bearer',
      );

      return Right(authResponse);
    } catch (e) {
      return Left(ServerFailure(message: '注册失败: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await clearLocalAuthInfo();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: '登出失败: $e'));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> refreshToken(RefreshTokenRequest request) async {
    try {
      // 模拟API调用
      await Future.delayed(const Duration(milliseconds: 500));

      // 获取当前用户信息
      final localAuth = await getLocalAuthInfo();
      User? currentUser;
      localAuth.fold(
        (failure) => currentUser = null,
        (authResponse) => currentUser = authResponse?.user,
      );

      if (currentUser == null) {
        return const Left(ServerFailure(message: '用户信息不存在，请重新登录'));
      }

      final authResponse = AuthResponse(
        accessToken: 'refreshed_access_token_${DateTime.now().millisecondsSinceEpoch}',
        refreshToken: request.refreshToken,
        user: currentUser!,
        expiresAt: DateTime.now().add(const Duration(hours: 24)),
        tokenType: 'Bearer',
      );

      await saveAuthInfo(authResponse);
      return Right(authResponse);
    } catch (e) {
      return Left(ServerFailure(message: '刷新Token失败: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(ResetPasswordRequest request) async {
    try {
      // 模拟API调用
      await Future.delayed(const Duration(seconds: 1));
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: '重置密码失败: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword(ChangePasswordRequest request) async {
    try {
      // 模拟API调用
      await Future.delayed(const Duration(seconds: 1));
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: '修改密码失败: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> sendVerificationCode(VerificationCodeRequest request) async {
    try {
      // 模拟API调用
      await Future.delayed(const Duration(seconds: 1));
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: '发送验证码失败: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> verifyCode(VerifyCodeRequest request) async {
    try {
      // 模拟API调用
      await Future.delayed(const Duration(seconds: 1));
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: '验证码验证失败: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final localAuth = await getLocalAuthInfo();
      return localAuth.fold(
        Left.new,
        (authResponse) {
          if (authResponse?.user != null) {
            return Right(authResponse!.user);
          } else {
            return const Left(ServerFailure(message: '用户信息不存在'));
          }
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: '获取用户信息失败: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> updateUser(User user) async {
    try {
      // 模拟API调用
      await Future.delayed(const Duration(seconds: 1));

      final updatedUser = user.copyWith(
        updatedAt: DateTime.now(),
      );

      // 更新本地存储的用户信息
      final localAuth = await getLocalAuthInfo();
      await localAuth.fold(
        (failure) => Future.value(),
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
    } catch (e) {
      return Left(ServerFailure(message: '更新用户信息失败: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> validateToken(String token) async {
    try {
      // 模拟API调用
      await Future.delayed(const Duration(milliseconds: 500));

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

  @override
  Future<Either<Failure, AuthResponse>> phoneLogin(PhoneLoginRequest request) {
    // TODO: implement phoneLogin
    throw UnimplementedError();
  }
}
