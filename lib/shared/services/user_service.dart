import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sky_eldercare_family/core/errors/exceptions.dart';
import 'package:sky_eldercare_family/core/errors/failures.dart';
import 'package:sky_eldercare_family/core/network/api_client.dart';
import 'package:sky_eldercare_family/core/network/api_providers.dart';
import 'package:sky_eldercare_family/core/storage/storage_service.dart';
import 'package:sky_eldercare_family/shared/models/api_response.dart';
import 'package:sky_eldercare_family/shared/models/user.dart';

/// 用户服务接口
abstract class UserService {
  /// 登录
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  /// 注册
  Future<Either<Failure, User>> register({
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
  Future<Either<Failure, User>> login({
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

        // 保存用户token和信息
        await StorageService.setUserToken(token);
        await StorageService.setUserData('user_info', user.toJson());

        return Right(user);
      } else {
        return Left(AuthFailure(message: apiResponse.message));
      }
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register({
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

        // 保存用户token和信息
        await StorageService.setUserToken(token);
        await StorageService.setUserData('user_info', user.toJson());

        return Right(user);
      } else {
        return Left(AuthFailure(message: apiResponse.message));
      }
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      // 先从本地缓存获取
      final cachedUserData = StorageService.getUserData<Map<String, dynamic>>('user_info');
      if (cachedUserData != null) {
        final user = User.fromJson(cachedUserData);
        return Right(user);
      }

      // 如果本地没有，从服务器获取
      final response = await _apiClient.get('/user/profile');

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => json! as Map<String, dynamic>,
      );

      if (apiResponse.isSuccess && apiResponse.hasData) {
        final user = User.fromJson(apiResponse.data!);

        // 缓存用户信息
        await StorageService.setUserData('user_info', user.toJson());

        return Right(user);
      } else {
        return Left(ServerFailure(message: apiResponse.message));
      }
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
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

        // 更新本地缓存
        await StorageService.setUserData('user_info', user.toJson());

        return Right(user);
      } else {
        return Left(ServerFailure(message: apiResponse.message));
      }
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
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
      return Left(_mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await _apiClient.post('/auth/logout');

      // 清除本地数据
      await StorageService.removeUserToken();
      await StorageService.clearUserData();

      return const Right(true);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
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

        // 保存新token
        await StorageService.setUserToken(token);

        return Right(token);
      } else {
        return Left(AuthFailure(message: apiResponse.message));
      }
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  /// 将异常映射为失败
  Failure _mapExceptionToFailure(AppException exception) {
    if (exception is NetworkException) {
      return NetworkFailure(
        message: exception.message,
        code: exception.code,
      );
    } else if (exception is ServerException) {
      return ServerFailure(
        message: exception.message,
        code: exception.code,
      );
    } else if (exception is AuthException) {
      return AuthFailure(
        message: exception.message,
        code: exception.code,
      );
    } else if (exception is ValidationException) {
      return ValidationFailure(
        message: exception.message,
        code: exception.code,
      );
    } else {
      return UnknownFailure(
        message: exception.message,
        code: exception.code,
      );
    }
  }
}

/// 用户服务提供者
final userServiceProvider = Provider<UserService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
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
