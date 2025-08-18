import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sky_eldercare_family/di/providers.dart';
import 'package:sky_eldercare_family/shared/models/auth_models.dart';
import 'package:sky_eldercare_family/shared/models/user.dart';
import 'package:sky_eldercare_family/shared/repositories/auth_repository.dart';
import 'package:sky_eldercare_family/shared/repositories/auth_repository_impl.dart';
import 'package:sky_eldercare_family/shared/services/user_service.dart';

part 'auth.freezed.dart';
part 'auth.g.dart';

/// 认证状态枚举
enum AuthStatus {
  initial, // 初始状态
  loading, // 加载中
  authenticated, // 已认证
  unauthenticated, // 未认证
  error, // 错误状态
}

/// 认证状态模型
@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(AuthStatus.initial) AuthStatus status,
    User? user,
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
    String? errorMessage,
    @Default(false) bool isLoading,
    @Default(false) bool rememberMe,
  }) = _AuthState;

  factory AuthState.fromJson(Map<String, dynamic> json) => _$AuthStateFromJson(json);
}

/// AuthState 扩展方法
extension AuthStateExtension on AuthState {
  /// 是否已认证
  bool get isAuthenticated => status == AuthStatus.authenticated && user != null;

  /// 是否未认证
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;

  /// 是否有错误
  bool get hasError => status == AuthStatus.error && errorMessage != null;

  /// Token是否过期
  bool get isTokenExpired {
    if (expiresAt == null) return true;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// 是否需要刷新Token
  bool get needsTokenRefresh {
    if (expiresAt == null) return false;
    // 提前5分钟刷新Token
    final refreshTime = expiresAt!.subtract(const Duration(minutes: 5));
    return DateTime.now().isAfter(refreshTime);
  }
}

@riverpod
class Auth extends _$Auth {
  @override
  AuthState build() {
    // 初始化时尝试从本地存储恢复认证状态
    _initializeAuth();
    return const AuthState();
  }

  /// 初始化认证状态
  Future<void> _initializeAuth() async {
    final authRepository = ref.read(authRepositoryProvider);

    final result = await authRepository.getLocalAuthInfo();
    result.fold(
      (failure) {
        // 获取本地认证信息失败，设置为未认证状态
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          isLoading: false,
        );
      },
      (authResponse) {
        if (authResponse != null) {
          // 检查Token是否过期
          if (DateTime.now().isBefore(authResponse.expiresAt)) {
            // Token有效，设置为已认证状态
            state = state.copyWith(
              status: AuthStatus.authenticated,
              user: authResponse.user,
              accessToken: authResponse.accessToken,
              refreshToken: authResponse.refreshToken,
              expiresAt: authResponse.expiresAt,
              isLoading: false,
            );
          } else {
            // Token过期，尝试刷新
            _refreshToken();
          }
        } else {
          // 没有本地认证信息，设置为未认证状态
          state = state.copyWith(
            status: AuthStatus.unauthenticated,
            isLoading: false,
          );
        }
      },
    );
  }

  /// 登录
  Future<void> login(LoginRequest request) async {
    state = state.copyWith(
      status: AuthStatus.loading,
      isLoading: true,
      errorMessage: null,
    );

    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.login(request);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (authResponse) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: authResponse.user,
          accessToken: authResponse.accessToken,
          refreshToken: authResponse.refreshToken,
          expiresAt: authResponse.expiresAt,
          rememberMe: request.rememberMe,
          isLoading: false,
          errorMessage: null,
        );
      },
    );
  }

  /// 手机号登录
  Future<void> phoneLogin(PhoneLoginRequest request) async {
    state = state.copyWith(
      status: AuthStatus.loading,
      isLoading: true,
      errorMessage: null,
    );

    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.phoneLogin(request);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (authResponse) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: authResponse.user,
          accessToken: authResponse.accessToken,
          refreshToken: authResponse.refreshToken,
          expiresAt: authResponse.expiresAt,
          rememberMe: request.rememberMe,
          isLoading: false,
          errorMessage: null,
        );
      },
    );
  }

  /// 注册
  Future<void> register(RegisterRequest request) async {
    state = state.copyWith(
      status: AuthStatus.loading,
      isLoading: true,
      errorMessage: null,
    );

    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.register(request);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (authResponse) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: authResponse.user,
          accessToken: authResponse.accessToken,
          refreshToken: authResponse.refreshToken,
          expiresAt: authResponse.expiresAt,
          isLoading: false,
          errorMessage: null,
        );
      },
    );
  }

  /// 登出
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    final authRepository = ref.read(authRepositoryProvider);
    await authRepository.logout();

    // 无论服务器登出是否成功，都要清除本地状态
    state = const AuthState(
      status: AuthStatus.unauthenticated,
    );
  }

  /// 刷新Token
  Future<void> _refreshToken() async {
    if (state.refreshToken == null) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        isLoading: false,
      );
      return;
    }

    final authRepository = ref.read(authRepositoryProvider);
    final request = RefreshTokenRequest(refreshToken: state.refreshToken!);
    final result = await authRepository.refreshToken(request);

    result.fold(
      (failure) {
        // 刷新失败，设置为未认证状态
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          user: null,
          accessToken: null,
          refreshToken: null,
          expiresAt: null,
          isLoading: false,
        );
      },
      (authResponse) {
        // 刷新成功，更新状态
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: authResponse.user,
          accessToken: authResponse.accessToken,
          refreshToken: authResponse.refreshToken,
          expiresAt: authResponse.expiresAt,
          isLoading: false,
        );
      },
    );
  }

  /// 更新用户信息
  Future<void> updateUser(User user) async {
    if (!state.isAuthenticated) return;

    state = state.copyWith(isLoading: true);

    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.updateUser(user);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (updatedUser) {
        state = state.copyWith(
          user: updatedUser,
          isLoading: false,
          errorMessage: null,
        );
      },
    );
  }

  /// 重置密码
  Future<void> resetPassword(ResetPasswordRequest request) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );

    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.resetPassword(request);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (_) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: null,
        );
      },
    );
  }

  /// 修改密码
  Future<void> changePassword(ChangePasswordRequest request) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );

    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.changePassword(request);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (_) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: null,
        );
      },
    );
  }

  /// 发送验证码
  Future<void> sendVerificationCode(VerificationCodeRequest request) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );

    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.sendVerificationCode(request);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (_) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: null,
        );
      },
    );
  }

  /// 验证验证码
  Future<void> verifyCode(VerifyCodeRequest request) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );

    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.verifyCode(request);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (_) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: null,
        );
      },
    );
  }

  /// 清除错误信息
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// 手动触发Token刷新
  Future<void> refreshToken() async {
    await _refreshToken();
  }
}

/// Auth Repository Provider
@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  final userService = ref.read(userServiceProvider);
  final storageService = ref.read(AppProviders.storageServiceProvider);

  return AuthRepositoryImpl(
    userService: userService,
    storageService: storageService,
  );
}
