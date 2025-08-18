import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:zjs_flutter_template/core/errors/exceptions.dart';
import 'package:zjs_flutter_template/core/network/interceptors/auth_interceptor.dart';
import 'package:zjs_flutter_template/core/utils/logger.dart';

/// API客户端 - 统一网络请求管理

class ApiClient {
  ApiClient(BaseOptions options) {
    _dio = Dio();
    _setupDio(options);
  }

  late final Dio _dio;

  Dio get dio => _dio;

  /// 配置Dio实例
  void _setupDio(BaseOptions options) {
    // 基础配置
    _dio.options = BaseOptions(
      baseUrl: options.baseUrl,
      connectTimeout: options.connectTimeout,
      receiveTimeout: options.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // 添加拦截器
    _setupInterceptors();
  }

  /// 设置拦截器
  void _setupInterceptors() {
    // 请求拦截器 - 添加认证token
    _dio.interceptors.add(
      AuthInterceptor(),
    );

    // 日志拦截器 - 仅在debug模式下使用
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
        ),
      );
    }

    // dio缓存
    // _setupCacheInterceptor();
    // _storeInterceptorsForRetry()
  }

  /// 存储拦截器引用供重试使用
  // void _storeInterceptorsForRetry() {
  //   // 为每个请求存储Dio实例引用，供重试时使用
  //   _dio.interceptors.add(
  //     InterceptorsWrapper(
  //       onRequest: (options, handler) {
  //         options.extra['dio_instance'] = _dio;
  //         options.extra['original_interceptors'] = _dio.interceptors;
  //         handler.next(options);
  //       },
  //     ),
  //   );
  // }

  // dio_cache_interceptor: ^3.5.0
  // dio_cache_interceptor_hive_store: ^3.2.2
  // Future<void> _setupCacheInterceptor() async {
  //   try {
  //     final cacheStore = HiveCacheStore(null);
  //     final cacheOptions = CacheOptions(
  //       store: cacheStore,
  //       policy: CachePolicy.request,
  //       hitCacheOnErrorExcept: [401, 403],
  //       maxStale: const Duration(days: 7),
  //       priority: CachePriority.normal,
  //       cipher: null,
  //       keyBuilder: CacheOptions.defaultCacheKeyBuilder,
  //       allowPostMethod: false,
  //     );

  //     _dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));
  //   } catch (e) {
  //     AppLogger.error('Failed to setup cache interceptor: $e');
  //   }
  // }

  /// Create a new instance with custom options
  // static ApiClient withOptions(BaseOptions options) {
  //   final client = ApiClient(options);
  //   // client._dio.options = client._dio.options.copyWith(
  //   //   baseUrl: options.baseUrl ?? client._dio.options.baseUrl,
  //   //   connectTimeout: options.connectTimeout ?? client._dio.options.connectTimeout,
  //   //   receiveTimeout: options.receiveTimeout ?? client._dio.options.receiveTimeout,
  //   //   sendTimeout: options.sendTimeout ?? client._dio.options.sendTimeout,
  //   //   headers: {...client._dio.options.headers, ...options.headers},
  //   // );
  //   return client;
  // }

  /// GET请求
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw DioErrorHandler.handleDioError(e);
    }
  }

  /// POST请求
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw DioErrorHandler.handleDioError(e);
    }
  }

  /// PUT请求
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw DioErrorHandler.handleDioError(e);
    }
  }

  /// DELETE请求
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw DioErrorHandler.handleDioError(e);
    }
  }

  /// 上传文件
  Future<Response<T>> uploadFile<T>(
    String path,
    String filePath, {
    String? fileName,
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: fileName,
        ),
        if (data != null) ...data,
      });

      final response = await _dio.post<T>(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );

      return response;
    } on DioException catch (e) {
      throw DioErrorHandler.handleDioError(e);
    }
  }

  /// 下载文件
  Future<Response<dynamic>> downloadFile(
    String urlPath,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw DioErrorHandler.handleDioError(e);
    }
  }
}

/// Dio错误处理
class DioErrorHandler {
  /// 处理Dio错误
  static AppException handleDioError(DioException error) {
    AppLogger.error('handleDioError错误: ${error.response?.data}');
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          message: '网络连接超时，请检查网络设置',
          code: error.response?.statusCode,
        );

      case DioExceptionType.badResponse:
        return _handleResponseError(error);

      case DioExceptionType.cancel:
        return NetworkException(
          message: '请求已取消',
          code: error.response?.statusCode,
        );

      case DioExceptionType.connectionError:
        return NetworkException(
          message: '网络连接失败，请检查网络设置',
          code: error.response?.statusCode,
        );

      case DioExceptionType.badCertificate:
        return NetworkException(
          message: '证书验证失败',
          code: error.response?.statusCode,
        );

      case DioExceptionType.unknown:
      // ignore: no_default_cases, unreachable_switch_default
      default:
        return NetworkException(
          message: '未知网络错误: ${error.message}',
          code: error.response?.statusCode,
        );
    }
  }

  /// 处理响应错误
  static AppException _handleResponseError(DioException error) {
    final statusCode = error.response?.statusCode;
    final message = _getErrorMessage(error.response?.data);

    switch (statusCode) {
      case 400:
        return ValidationException(
          message: message ?? '请求参数错误',
          code: statusCode,
        );

      case 401:
        return AuthException(
          message: message ?? '未授权访问，请重新登录',
          code: statusCode,
        );

      case 403:
        return PermissionException(
          message: message ?? '权限不足，无法访问',
          code: statusCode,
        );

      case 404:
        return ServerException(
          message: message ?? '请求的资源不存在',
          code: statusCode,
        );

      case 422:
        return ValidationException(
          message: message ?? '数据验证失败',
          code: statusCode,
        );

      case 500:
        return ServerException(
          message: message ?? '服务器内部错误',
          code: statusCode,
        );

      case 502:
      case 503:
      case 504:
        return ServerException(
          message: message ?? '服务器暂时不可用，请稍后重试',
          code: statusCode,
        );

      default:
        return ServerException(
          message: message ?? '服务器错误 ($statusCode)',
          code: statusCode,
        );
    }
  }

  /// 从响应数据中提取错误信息
  static String? _getErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message']?.toString() ?? data['error']?.toString() ?? data['msg']?.toString();
    }
    return data?.toString();
  }
}
