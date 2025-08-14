import 'package:dio/dio.dart';
import 'package:sky_eldercare_family/core/utils/logger.dart';

/// Retry interceptor for handling network failures with automatic retry
class RetryInterceptor extends Interceptor {
  const RetryInterceptor({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });
  final int maxRetries;
  final Duration retryDelay;

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      final requestOptions = err.requestOptions;
      final currentRetryCount = requestOptions.extra['retry_count'] as int? ?? 0;

      if (currentRetryCount < maxRetries) {
        requestOptions.extra['retry_count'] = currentRetryCount + 1;

        AppLogger.warning(
          'Retrying request (${currentRetryCount + 1}/$maxRetries): ${requestOptions.uri}',
        );

        // Wait before retrying with exponential backoff
        final delay = Duration(
          milliseconds: retryDelay.inMilliseconds * (currentRetryCount + 1),
        );
        await Future<void>.delayed(delay);

        try {
          final dio = Dio();
          final originalInterceptors = err.requestOptions.extra['original_interceptors'] ?? <Interceptor>[];
          // Copy interceptors except retry to avoid infinite loop
          for (final interceptor in (originalInterceptors as List<Interceptor>)) {
            if (interceptor is! RetryInterceptor) {
              dio.interceptors.add(interceptor);
            }
          }

          final response = await dio.fetch<dynamic>(requestOptions);
          return handler.resolve(response);
        } catch (e) {
          // Continue with original error if retry also fails
          AppLogger.error('Retry failed: $e');
        }
      } else {
        AppLogger.error('Max retry attempts reached for: ${requestOptions.uri}');
      }
    }

    handler.next(err);
  }

  /// Determine if the request should be retried
  bool _shouldRetry(DioException err) {
    // Only retry on specific error types
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return true;

      case DioExceptionType.badResponse:
        // Retry on server errors (5xx) but not client errors (4xx)
        final statusCode = err.response?.statusCode;
        return statusCode != null && statusCode >= 500;

      case DioExceptionType.unknown:
        // Retry on network connection errors
        final containsNetwork = err.message?.contains('network') ?? false;
        final containsConnection = err.message?.contains('connection') ?? false;
        return containsNetwork || containsConnection;
      // ignore: no_default_cases
      default:
        return false;
    }
  }
}
