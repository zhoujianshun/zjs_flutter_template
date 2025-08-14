import 'package:dio/dio.dart';
import 'package:sky_eldercare_family/config/env/app_config.dart';
import 'package:sky_eldercare_family/core/utils/logger.dart';

/// Logging interceptor for development and debugging
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (AppConfig.isDebug) {
      AppLogger.debug('''
🚀 REQUEST
   URL: ${options.uri}
   Method: ${options.method}
   Headers: ${_formatHeaders(options.headers)}
   Query Parameters: ${options.queryParameters}
   Data: ${_formatData(options.data)}
      ''');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    if (AppConfig.isDebug) {
      AppLogger.debug('''
✅ RESPONSE
   URL: ${response.requestOptions.uri}
   Status Code: ${response.statusCode}
   Status Message: ${response.statusMessage}
   Headers: ${_formatHeaders(response.headers.map)}
   Data: ${_formatData(response.data)}
      ''');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (AppConfig.isDebug) {
      AppLogger.error('''
❌ ERROR
   URL: ${err.requestOptions.uri}
   Method: ${err.requestOptions.method}
   Status Code: ${err.response?.statusCode}
   Error Type: ${err.type}
   Error Message: ${err.message}
   Response Data: ${_formatData(err.response?.data)}
      ''');
    }
    handler.next(err);
  }

  String _formatHeaders(Map<String, dynamic> headers) {
    if (headers.isEmpty) return '{}';

    final formatted = StringBuffer('{\n');
    headers.forEach((key, value) {
      // Hide sensitive headers in logs
      if (_isSensitiveHeader(key)) {
        formatted.writeln('    $key: [HIDDEN]');
      } else {
        formatted.writeln('    $key: $value');
      }
    });
    formatted.write('  }');
    return formatted.toString();
  }

  String _formatData(dynamic data) {
    if (data == null) return 'null';

    if (data is Map || data is List) {
      // Limit data output to prevent extremely long logs
      final dataString = data.toString();
      if (dataString.length > 1000) {
        return '${dataString.substring(0, 1000)}... [TRUNCATED]';
      }
      return dataString;
    }

    return data.toString();
  }

  bool _isSensitiveHeader(String key) {
    const sensitiveHeaders = [
      'authorization',
      'cookie',
      'set-cookie',
      'x-api-key',
      'x-auth-token',
    ];

    return sensitiveHeaders.contains(key.toLowerCase());
  }
}
