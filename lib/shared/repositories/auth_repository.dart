import 'package:dartz/dartz.dart';
import 'package:sky_eldercare_family/core/errors/failures.dart';
import 'package:sky_eldercare_family/shared/models/auth_models.dart';
import 'package:sky_eldercare_family/shared/models/user.dart';

/// 认证仓库接口
abstract class AuthRepository {
  /// 登录
  Future<Either<Failure, AuthResponse>> login(LoginRequest request);

  /// 手机号登录
  Future<Either<Failure, AuthResponse>> phoneLogin(PhoneLoginRequest request);

  /// 注册
  Future<Either<Failure, AuthResponse>> register(RegisterRequest request);

  /// 登出
  Future<Either<Failure, void>> logout();

  /// 刷新Token
  Future<Either<Failure, AuthResponse>> refreshToken(RefreshTokenRequest request);

  /// 重置密码
  Future<Either<Failure, void>> resetPassword(ResetPasswordRequest request);

  /// 修改密码
  Future<Either<Failure, void>> changePassword(ChangePasswordRequest request);

  /// 发送验证码
  Future<Either<Failure, void>> sendVerificationCode(VerificationCodeRequest request);

  /// 验证验证码
  Future<Either<Failure, void>> verifyCode(VerifyCodeRequest request);

  /// 获取当前用户信息
  Future<Either<Failure, User>> getCurrentUser();

  /// 更新用户信息
  Future<Either<Failure, User>> updateUser(User user);

  /// 检查Token有效性
  Future<Either<Failure, bool>> validateToken(String token);

  /// 获取本地存储的认证信息
  Future<Either<Failure, AuthResponse?>> getLocalAuthInfo();

  /// 保存认证信息到本地
  Future<Either<Failure, void>> saveAuthInfo(AuthResponse authResponse);

  /// 清除本地认证信息
  Future<Either<Failure, void>> clearLocalAuthInfo();
}
