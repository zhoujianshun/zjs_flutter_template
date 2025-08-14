import 'package:dio/dio.dart';
import 'package:sky_eldercare_family/core/errors/exceptions.dart';
import 'package:sky_eldercare_family/core/network/network_service.dart';
import 'package:sky_eldercare_family/core/utils/logger.dart';

/// Connectivity interceptor to check network status before requests
class ConnectivityInterceptor extends Interceptor {
  final NetworkService _networkService = NetworkService();

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final isConnected = await _networkService.isConnected();

      if (!isConnected) {
        AppLogger.warning('No network connection available for: ${options.uri}');
        throw const NetworkException(
          message: '网络连接不可用，请检查网络设置',
        );
      }

      handler.next(options);
    } catch (e) {
      if (e is NetworkException) {
        handler.reject(
          DioException(
            requestOptions: options,
            error: e,
            type: DioExceptionType.connectionError,
            message: e.message,
          ),
        );
      } else {
        AppLogger.error('Connectivity check failed: $e');
        handler.next(options);
      }
    }
  }
}
