import 'package:dio/dio.dart';
import 'package:sky_eldercare_family/core/storage/storage_service.dart';
import 'package:sky_eldercare_family/core/utils/logger.dart';
import 'package:sky_eldercare_family/di/service_locator.dart';

/// Authentication interceptor for adding tokens to requests
class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      // Skip auth for login/register endpoints
      if (_shouldSkipAuth(options.path)) {
        return handler.next(options);
      }
      final storageService = ServiceLocator.get<StorageService>();
      final token = await storageService.getUserToken();

      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
        AppLogger.debug('Added auth token to request: ${options.path}');
      }

      handler.next(options);
    } catch (e) {
      AppLogger.error('Auth interceptor error: $e');
      handler.next(options);
    }
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle token refresh on 401 errors
    if (err.response?.statusCode == 401 && !_isRefreshRequest(err.requestOptions.path)) {
      // 这里可以添加跳转到登录页面的逻辑
      await _clearTokens();

      // 不需要刷新token
      // try {
      //   final refreshed = await _refreshToken();
      //   if (refreshed) {
      //     // Retry original request with new token
      //     final options = err.requestOptions;
      //     final token = await _secureStorage.getUserToken();
      //     if (token != null) {
      //       options.headers['Authorization'] = 'Bearer $token';

      //       // Use the original Dio instance for retry
      //       final originalDio = options.extra['dio_instance'] as Dio?;
      //       if (originalDio != null) {
      //         final response = await originalDio.fetch<dynamic>(options);
      //         return handler.resolve(response);
      //       }
      //     }
      //   }
      // } catch (e) {
      //   AppLogger.error('Token refresh failed: $e');
      //   await _clearTokens();
      // }
    }

    handler.next(err);
  }

  /// Check if auth should be skipped for this endpoint
  bool _shouldSkipAuth(String path) {
    const skipPaths = [
      '/auth/login',
      '/auth/register',
      '/auth/refresh',
      '/auth/forgot-password',
    ];

    return skipPaths.any((skipPath) => path.contains(skipPath));
  }

  /// Check if this is a token refresh request
  bool _isRefreshRequest(String path) {
    return path.contains('/auth/refresh');
  }

  /// Refresh access token using refresh token
  Future<bool> _refreshToken() async {
    try {
      final storageService = ServiceLocator.get<StorageService>();
      final refreshToken = await storageService.secure.read('refresh_token');

      if (refreshToken == null || refreshToken.isEmpty) {
        AppLogger.warning('No refresh token available');
        return false;
      }

      // Create a new Dio instance for refresh request to avoid interceptor loops
      final refreshDio = Dio();
      refreshDio.options.baseUrl = 'https://api.example.com'; // Use your actual base URL

      final response = await refreshDio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data!;
        final newAccessToken = data['access_token'] as String?;
        final newRefreshToken = data['refresh_token'] as String?;

        if (newAccessToken != null) {
          final storageService = ServiceLocator.get<StorageService>();
          await storageService.setUserToken(newAccessToken);
          AppLogger.info('Access token refreshed successfully');
        }

        if (newRefreshToken != null) {
          final storageService = ServiceLocator.get<StorageService>();
          await storageService.secure.write('refresh_token', newRefreshToken);
        }

        return true;
      }

      return false;
    } catch (e) {
      AppLogger.error('Token refresh error: $e');
      return false;
    }
  }

  /// Clear all stored tokens
  Future<void> _clearTokens() async {
    final storageService = ServiceLocator.get<StorageService>();
    await storageService.removeUserToken();
    await storageService.clearUserData();
    AppLogger.info('Cleared stored tokens');

    // 使用 go_router 跳转到登录页面
  }
}
