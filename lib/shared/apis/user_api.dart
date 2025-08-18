import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:zjs_flutter_template/core/errors/failures.dart';
import 'package:zjs_flutter_template/core/network/api_response_handler.dart';
import 'package:zjs_flutter_template/core/network/base_api.dart';
import 'package:zjs_flutter_template/shared/models/auth_models.dart';
import 'package:zjs_flutter_template/shared/models/user.dart';

/// 用户API服务
@Injectable()
class UserAPI extends BaseAPI {
  UserAPI(super.apiClient);

  Future<Either<Failure, UserLoginResult>> login({
    required String email,
    required String password,
  }) async {
    return handleApiCall(
      apiClient.post(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
      ),
      UserLoginResult.fromJson,
      // (json) {
      //   final user = User.fromJson(json['user'] as Map<String, dynamic>);
      //   final token = json['token'] as String;
      //   return UserLoginResult(user: user, token: token);
      // },
      logTag: 'UserAPI.login',
    );
  }

  Future<Either<Failure, UserLoginResult>> register({
    required String email,
    required String password,
    String? name,
    String? phone,
  }) async {
    return handleApiCall(
      apiClient.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          if (name != null) 'name': name,
          if (phone != null) 'phone': phone,
        },
      ),
      (json) {
        final user = User.fromJson(json['user'] as Map<String, dynamic>);
        final token = json['token'] as String;
        return UserLoginResult(user: user, token: token);
      },
      logTag: 'UserAPI.register',
    );
  }

  Future<Either<Failure, User>> getCurrentUser() async {
    return handleApiCall(
      apiClient.get('/user/profile'),
      User.fromJson,
      logTag: 'UserAPI.getCurrentUser',
    );
  }

  Future<Either<Failure, User>> updateUser({
    String? name,
    String? phone,
    String? avatar,
    DateTime? birthday,
    String? gender,
  }) async {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (phone != null) data['phone'] = phone;
    if (avatar != null) data['avatar'] = avatar;
    if (birthday != null) data['birthday'] = birthday.toIso8601String();
    if (gender != null) data['gender'] = gender;

    return handleApiCall(
      apiClient.put('/user/profile', data: data),
      User.fromJson,
      logTag: 'UserAPI.updateUser',
    );
  }

  Future<Either<Failure, bool>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      '/user/change-password',
      data: {
        'old_password': oldPassword,
        'new_password': newPassword,
      },
    );

    return ApiResponseHandler.handleBooleanResponse(response);
  }

  Future<Either<Failure, bool>> logout() async {
    return handleApiVoidCall(
      apiClient.post('/auth/logout'),
      logTag: 'UserAPI.logout',
    ).then(
      (result) => result.fold(
        Left.new,
        (_) => const Right(true),
      ),
    );
  }

  Future<Either<Failure, String>> refreshToken() async {
    final response = await apiClient.post<Map<String, dynamic>>('/auth/refresh');
    return ApiResponseHandler.handleStringResponse(response, dataKey: 'token');
  }

  Future<Either<Failure, UserLoginResult>> phoneLogin({
    required String phone,
    required String code,
  }) async {
    return handleApiCall(
      apiClient.post(
        '/auth/phone-login',
        data: {
          'phone': phone,
          'code': code,
        },
      ),
      (json) {
        final user = User.fromJson(json['user'] as Map<String, dynamic>);
        final token = json['token'] as String;
        return UserLoginResult(user: user, token: token);
      },
      logTag: 'UserAPI.phoneLogin',
    );
  }
}
