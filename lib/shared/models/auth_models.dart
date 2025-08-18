import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zjs_flutter_template/shared/models/user.dart';

part 'auth_models.freezed.dart';
part 'auth_models.g.dart';

/// 登录请求模型
@freezed
abstract class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String email,
    required String password,
    @Default(false) bool rememberMe,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);
}

/// 手机号登录请求模型
@freezed
abstract class PhoneLoginRequest with _$PhoneLoginRequest {
  const factory PhoneLoginRequest({
    required String phone,
    required String code,
    @Default(false) bool rememberMe,
  }) = _PhoneLoginRequest;

  factory PhoneLoginRequest.fromJson(Map<String, dynamic> json) => _$PhoneLoginRequestFromJson(json);
}

/// 注册请求模型
@freezed
abstract class RegisterRequest with _$RegisterRequest {
  const factory RegisterRequest({
    required String email,
    required String password,
    required String confirmPassword,
    String? name,
    String? phone,
  }) = _RegisterRequest;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) => _$RegisterRequestFromJson(json);
}

/// 重置密码请求模型
@freezed
abstract class ResetPasswordRequest with _$ResetPasswordRequest {
  const factory ResetPasswordRequest({
    required String email,
  }) = _ResetPasswordRequest;

  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) => _$ResetPasswordRequestFromJson(json);
}

/// 修改密码请求模型
@freezed
abstract class ChangePasswordRequest with _$ChangePasswordRequest {
  const factory ChangePasswordRequest({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) = _ChangePasswordRequest;

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) => _$ChangePasswordRequestFromJson(json);
}

/// 认证响应模型
@freezed
abstract class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    required String accessToken,
    required String refreshToken,
    required User user,
    required DateTime expiresAt,
    String? tokenType,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) => _$AuthResponseFromJson(json);
}

/// 用户登录结果模型（Service层返回）
@freezed
abstract class UserLoginResult with _$UserLoginResult {
  const factory UserLoginResult({
    required User user,
    required String token,
  }) = _UserLoginResult;

  factory UserLoginResult.fromJson(Map<String, dynamic> json) => _$UserLoginResultFromJson(json);
}

/// 刷新token请求模型
@freezed
abstract class RefreshTokenRequest with _$RefreshTokenRequest {
  const factory RefreshTokenRequest({
    required String refreshToken,
  }) = _RefreshTokenRequest;

  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) => _$RefreshTokenRequestFromJson(json);
}

/// 验证码请求模型
@freezed
abstract class VerificationCodeRequest with _$VerificationCodeRequest {
  const factory VerificationCodeRequest({
    required String email,
    required VerificationCodeType type,
  }) = _VerificationCodeRequest;

  factory VerificationCodeRequest.fromJson(Map<String, dynamic> json) => _$VerificationCodeRequestFromJson(json);
}

/// 验证码验证模型
@freezed
abstract class VerifyCodeRequest with _$VerifyCodeRequest {
  const factory VerifyCodeRequest({
    required String email,
    required String code,
    required VerificationCodeType type,
  }) = _VerifyCodeRequest;

  factory VerifyCodeRequest.fromJson(Map<String, dynamic> json) => _$VerifyCodeRequestFromJson(json);
}

/// 验证码类型枚举
enum VerificationCodeType {
  @JsonValue('login')
  login,
  @JsonValue('register')
  register,
  @JsonValue('reset_password')
  resetPassword,
  @JsonValue('change_email')
  changeEmail,
  @JsonValue('change_phone')
  changePhone,
}

/// 验证码类型扩展
extension VerificationCodeTypeExtension on VerificationCodeType {
  /// 获取显示名称
  String get displayName {
    switch (this) {
      case VerificationCodeType.login:
        return '登录验证';
      case VerificationCodeType.register:
        return '注册验证';
      case VerificationCodeType.resetPassword:
        return '重置密码';
      case VerificationCodeType.changeEmail:
        return '更换邮箱';
      case VerificationCodeType.changePhone:
        return '更换手机';
    }
  }

  /// 获取验证码用途描述
  String get description {
    switch (this) {
      case VerificationCodeType.login:
        return '请输入登录验证码';
      case VerificationCodeType.register:
        return '请输入注册验证码';
      case VerificationCodeType.resetPassword:
        return '请输入重置密码验证码';
      case VerificationCodeType.changeEmail:
        return '请输入邮箱验证码';
      case VerificationCodeType.changePhone:
        return '请输入手机验证码';
    }
  }
}
