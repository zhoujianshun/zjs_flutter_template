import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sky_eldercare_family/core/constants/app_constants.dart';
import 'package:sky_eldercare_family/core/errors/exceptions.dart';
import 'package:sky_eldercare_family/core/storage/storage_service.dart';

/// API客户端 - 统一网络请求管理
class ApiClient {
  ApiClient() {
    _dio = Dio();
    _setupDio();
  }

  late final Dio _dio;

  /// 配置Dio实例
  void _setupDio() {
    // 基础配置
    _dio.options = BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: AppConstants.connectionTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
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
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // 添加认证token
          final token = await StorageService.getUserToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          handler.next(options);
        },
        onError: (error, handler) async {
          // 处理401未授权错误
          if (error.response?.statusCode == 401) {
            await _handleUnauthorized();
          }

          handler.next(error);
        },
      ),
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
  }

  /// 处理未授权错误
  Future<void> _handleUnauthorized() async {
    await StorageService.removeUserToken();
    await StorageService.clearUserData();
    // 这里可以添加跳转到登录页面的逻辑
  }

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
      throw _handleDioError(e);
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
      throw _handleDioError(e);
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
      throw _handleDioError(e);
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
      throw _handleDioError(e);
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
      throw _handleDioError(e);
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
      throw _handleDioError(e);
    }
  }

  /// 处理Dio错误
  AppException _handleDioError(DioException error) {
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
      default:
        return NetworkException(
          message: '未知网络错误: ${error.message}',
          code: error.response?.statusCode,
        );
    }
  }

  /// 处理响应错误
  AppException _handleResponseError(DioException error) {
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
  String? _getErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message']?.toString() ?? data['error']?.toString() ?? data['msg']?.toString();
    }
    return data?.toString();
  }
}
