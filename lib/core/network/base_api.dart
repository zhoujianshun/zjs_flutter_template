import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sky_eldercare_family/core/errors/error_utils.dart';
import 'package:sky_eldercare_family/core/errors/exceptions.dart';
import 'package:sky_eldercare_family/core/errors/failures.dart';
import 'package:sky_eldercare_family/core/network/api_client.dart';
import 'package:sky_eldercare_family/core/utils/logger.dart';
import 'package:sky_eldercare_family/shared/models/api_response.dart';

/// 基础API类，提供统一的API响应处理
abstract class BaseAPI {
  BaseAPI(this.apiClient);

  final ApiClient apiClient;

  /// 处理标准API调用，返回单个数据对象
  Future<Either<Failure, T>> handleApiCall<T>(
    Future<Response<dynamic>> apiCall,
    T Function(Map<String, dynamic>) fromJson, {
    String? logTag,
  }) async {
    try {
      AppLogger.info('${logTag ?? runtimeType.toString()}: API call started');

      final response = await apiCall;

      AppLogger.info(
        '${logTag ?? runtimeType.toString()}: API call completed with status ${response.statusCode}',
      );

      return _handleApiResponse<T>(response, fromJson);
    } on AppException catch (e) {
      AppLogger.error('${logTag ?? runtimeType.toString()}: AppException caught', error: e);
      return Left(mapExceptionToFailure(e));
    } catch (e, stackTrace) {
      AppLogger.error(
        '${logTag ?? runtimeType.toString()}: Unexpected error',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  /// 处理返回列表数据的API调用
  Future<Either<Failure, List<T>>> handleApiListCall<T>(
    Future<Response<dynamic>> apiCall,
    T Function(Map<String, dynamic>) fromJson, {
    String? logTag,
  }) async {
    try {
      AppLogger.info('${logTag ?? runtimeType.toString()}: API list call started');

      final response = await apiCall;

      AppLogger.info(
        '${logTag ?? runtimeType.toString()}: API list call completed with status ${response.statusCode}',
      );

      return _handleApiListResponse<T>(response, fromJson);
    } on AppException catch (e) {
      AppLogger.error('${logTag ?? runtimeType.toString()}: AppException caught', error: e);
      return Left(mapExceptionToFailure(e));
    } catch (e, stackTrace) {
      AppLogger.error(
        '${logTag ?? runtimeType.toString()}: Unexpected error',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  /// 处理无返回数据的API调用（如删除操作）
  Future<Either<Failure, void>> handleApiVoidCall(
    Future<Response<dynamic>> apiCall, {
    String? logTag,
  }) async {
    try {
      AppLogger.info('${logTag ?? runtimeType.toString()}: API void call started');

      final response = await apiCall;

      AppLogger.info(
        '${logTag ?? runtimeType.toString()}: API void call completed with status ${response.statusCode}',
      );

      return _handleApiVoidResponse(response);
    } on AppException catch (e) {
      AppLogger.error('${logTag ?? runtimeType.toString()}: AppException caught', error: e);
      return Left(mapExceptionToFailure(e));
    } catch (e, stackTrace) {
      AppLogger.error(
        '${logTag ?? runtimeType.toString()}: Unexpected error',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  /// 处理分页API调用
  Future<Either<Failure, PaginatedResponse<T>>> handlePaginatedApiCall<T>(
    Future<Response<dynamic>> apiCall,
    T Function(Map<String, dynamic>) fromJson, {
    String? logTag,
  }) async {
    try {
      AppLogger.info('${logTag ?? runtimeType.toString()}: Paginated API call started');

      final response = await apiCall;

      AppLogger.info(
        '${logTag ?? runtimeType.toString()}: Paginated API call completed with status ${response.statusCode}',
      );

      return _handlePaginatedApiResponse<T>(response, fromJson);
    } on AppException catch (e) {
      AppLogger.error('${logTag ?? runtimeType.toString()}: AppException caught', error: e);
      return Left(mapExceptionToFailure(e));
    } catch (e, stackTrace) {
      AppLogger.error(
        '${logTag ?? runtimeType.toString()}: Unexpected error',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  /// 处理单个对象的API响应
  Either<Failure, T> _handleApiResponse<T>(
    Response<dynamic> response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (response.data == null) {
      return const Left(ServerFailure(message: '响应数据为空'));
    }

    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json! as Map<String, dynamic>,
    );

    if (apiResponse.isSuccess && apiResponse.hasData) {
      try {
        final data = fromJson(apiResponse.data!);
        return Right(data);
      } catch (e) {
        AppLogger.error('数据解析失败', error: e);
        return Left(ServerFailure(message: '数据解析失败: $e'));
      }
    } else {
      return Left(
        ServerFailure(
          message: apiResponse.message,
          code: apiResponse.code ?? 500,
        ),
      );
    }
  }

  /// 处理列表数据的API响应
  Either<Failure, List<T>> _handleApiListResponse<T>(
    Response<dynamic> response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (response.data == null) {
      return const Left(ServerFailure(message: '响应数据为空'));
    }

    final apiResponse = ApiResponse<List<dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json! as List<dynamic>,
    );

    if (apiResponse.isSuccess && apiResponse.hasData) {
      try {
        final dataList = apiResponse.data!.cast<Map<String, dynamic>>().map((json) => fromJson(json)).toList();
        return Right(dataList);
      } catch (e) {
        AppLogger.error('列表数据解析失败', error: e);
        return Left(ServerFailure(message: '列表数据解析失败: $e'));
      }
    } else {
      return Left(
        ServerFailure(
          message: apiResponse.message,
          code: apiResponse.code ?? 500,
        ),
      );
    }
  }

  /// 处理无返回数据的API响应
  Either<Failure, void> _handleApiVoidResponse(Response<dynamic> response) {
    if (response.data == null) {
      // 对于void调用，如果状态码是成功的，即使没有数据也认为成功
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        return const Right(null);
      }
      return const Left(ServerFailure(message: '请求失败'));
    }

    final apiResponse = ApiResponse<dynamic>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json,
    );

    if (apiResponse.isSuccess) {
      return const Right(null);
    } else {
      return Left(
        ServerFailure(
          message: apiResponse.message,
          code: apiResponse.code ?? 500,
        ),
      );
    }
  }

  /// 处理分页API响应
  Either<Failure, PaginatedResponse<T>> _handlePaginatedApiResponse<T>(
    Response<dynamic> response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (response.data == null) {
      return const Left(ServerFailure(message: '响应数据为空'));
    }

    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json! as Map<String, dynamic>,
    );

    if (apiResponse.isSuccess && apiResponse.hasData) {
      try {
        final responseData = apiResponse.data!;
        final itemsData = responseData['items'] as List<dynamic>? ?? [];
        final items = itemsData.cast<Map<String, dynamic>>().map((json) => fromJson(json)).toList();

        final paginatedResponse = PaginatedResponse<T>(
          items: items,
          total: responseData['total'] as int? ?? 0,
          page: responseData['page'] as int? ?? 1,
          pageSize: responseData['page_size'] as int? ?? 10,
          hasMore: responseData['has_more'] as bool? ?? false,
        );

        return Right(paginatedResponse);
      } catch (e) {
        AppLogger.error('分页数据解析失败', error: e);
        return Left(ServerFailure(message: '分页数据解析失败: $e'));
      }
    } else {
      return Left(
        ServerFailure(
          message: apiResponse.message,
          code: apiResponse.code ?? 500,
        ),
      );
    }
  }
}

/// 分页响应模型
class PaginatedResponse<T> {
  const PaginatedResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.hasMore,
  });

  final List<T> items;
  final int total;
  final int page;
  final int pageSize;
  final bool hasMore;

  @override
  String toString() {
    return 'PaginatedResponse(items: ${items.length}, total: $total, page: $page, pageSize: $pageSize, hasMore: $hasMore)';
  }
}
