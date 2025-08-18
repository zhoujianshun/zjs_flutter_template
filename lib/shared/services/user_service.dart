import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sky_eldercare_family/core/errors/error_utils.dart';
import 'package:sky_eldercare_family/core/errors/exceptions.dart';
import 'package:sky_eldercare_family/core/errors/failures.dart';
import 'package:sky_eldercare_family/core/network/api_client.dart';
import 'package:sky_eldercare_family/di/providers.dart';
import 'package:sky_eldercare_family/shared/models/api_response.dart';
import 'package:sky_eldercare_family/shared/models/auth_models.dart';
import 'package:sky_eldercare_family/shared/models/user.dart';

/// 用户服务接口
abstract class UserService {
  /// 手机号登录
  Future<Either<Failure, UserLoginResult>> phoneLogin({
    required String phone,
    required String code,
  });

  /// 登录
  Future<Either<Failure, UserLoginResult>> login({
    required String email,
    required String password,
  });

  /// 注册
  Future<Either<Failure, UserLoginResult>> register({
    required String email,
    required String password,
    String? name,
    String? phone,
  });

  /// 获取当前用户信息
  Future<Either<Failure, User>> getCurrentUser();

  /// 更新用户信息
  Future<Either<Failure, User>> updateUser({
    String? name,
    String? phone,
    String? avatar,
    DateTime? birthday,
    String? gender,
  });

  /// 修改密码
  Future<Either<Failure, bool>> changePassword({
    required String oldPassword,
    required String newPassword,
  });

  /// 退出登录
  Future<Either<Failure, bool>> logout();

  /// 刷新token
  Future<Either<Failure, String>> refreshToken();
}

/// 用户服务实现
class UserServiceImpl implements UserService {
  UserServiceImpl(this._apiClient);
  final ApiClient _apiClient;

  @override
  Future<Either<Failure, UserLoginResult>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => json! as Map<String, dynamic>,
      );

      if (apiResponse.isSuccess && apiResponse.hasData) {
        final userData = apiResponse.data!;
        final user = User.fromJson(userData['user'] as Map<String, dynamic>);
        final token = userData['token'] as String;

        // 返回用户和token信息，让Repository层决定如何存储
        return Right(UserLoginResult(user: user, token: token));
      } else {
        return Left(AuthFailure(message: apiResponse.message));
      }
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserLoginResult>> register({
    required String email,
    required String password,
    String? name,
    String? phone,
  }) async {
    try {
      final response = await _apiClient.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          if (name != null) 'name': name,
          if (phone != null) 'phone': phone,
        },
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => json! as Map<String, dynamic>,
      );

      if (apiResponse.isSuccess && apiResponse.hasData) {
        final userData = apiResponse.data!;
        final user = User.fromJson(userData['user'] as Map<String, dynamic>);
        final token = userData['token'] as String;

        // 返回用户和token信息，让Repository层决定如何存储
        return Right(UserLoginResult(user: user, token: token));
      } else {
        return Left(AuthFailure(message: apiResponse.message));
      }
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      // 直接从服务器获取，缓存逻辑由Repository层处理
      final response = await _apiClient.get('/user/profile');

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => json! as Map<String, dynamic>,
      );

      if (apiResponse.isSuccess && apiResponse.hasData) {
        final user = User.fromJson(apiResponse.data!);
        return Right(user);
      } else {
        return Left(ServerFailure(message: apiResponse.message));
      }
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updateUser({
    String? name,
    String? phone,
    String? avatar,
    DateTime? birthday,
    String? gender,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (phone != null) data['phone'] = phone;
      if (avatar != null) data['avatar'] = avatar;
      if (birthday != null) data['birthday'] = birthday.toIso8601String();
      if (gender != null) data['gender'] = gender;

      final response = await _apiClient.put(
        '/user/profile',
        data: data,
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => json! as Map<String, dynamic>,
      );

      if (apiResponse.isSuccess && apiResponse.hasData) {
        final user = User.fromJson(apiResponse.data!);

        // 只返回更新后的用户信息，缓存更新由Repository层处理
        return Right(user);
      } else {
        return Left(ServerFailure(message: apiResponse.message));
      }
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _apiClient.post(
        '/user/change-password',
        data: {
          'old_password': oldPassword,
          'new_password': newPassword,
        },
      );

      final apiResponse = ApiResponse<bool>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => json! as bool,
      );

      if (apiResponse.isSuccess) {
        return const Right(true);
      } else {
        return Left(ServerFailure(message: apiResponse.message));
      }
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await _apiClient.post('/auth/logout');

      // 只负责API调用，数据清理由Repository层处理
      return const Right(true);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> refreshToken() async {
    try {
      final response = await _apiClient.post('/auth/refresh');

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => json! as Map<String, dynamic>,
      );

      if (apiResponse.isSuccess && apiResponse.hasData) {
        final token = apiResponse.data!['token'] as String;

        // 只返回新token，存储由Repository层处理
        return Right(token);
      } else {
        return Left(AuthFailure(message: apiResponse.message));
      }
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserLoginResult>> phoneLogin({required String phone, required String code}) async {
    try {
      final response = await _apiClient.post(
        '/auth/phone-login',
        data: {
          'phone': phone,
          'code': code,
        },
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => json! as Map<String, dynamic>,
      );

      if (apiResponse.isSuccess && apiResponse.hasData) {
        final userData = apiResponse.data!;
        final user = User.fromJson(userData['user'] as Map<String, dynamic>);
        final token = userData['token'] as String;

        // 返回用户和token信息，让Repository层决定如何存储
        return Right(UserLoginResult(user: user, token: token));
      } else {
        return Left(AuthFailure(message: apiResponse.message));
      }
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}

/// 用户服务提供者
final userServiceProvider = Provider<UserService>((ref) {
  final apiClient = ref.watch(AppProviders.apiClientProvider);
  return UserServiceImpl(apiClient);
});

/// 当前用户提供者
final currentUserProvider = FutureProvider<User?>((ref) async {
  final userService = ref.watch(userServiceProvider);
  final result = await userService.getCurrentUser();

  return result.fold(
    (failure) => null,
    (user) => user,
  );
});
