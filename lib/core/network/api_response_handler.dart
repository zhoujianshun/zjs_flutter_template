import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sky_eldercare_family/core/errors/failures.dart';
import 'package:sky_eldercare_family/core/utils/logger.dart';
import 'package:sky_eldercare_family/shared/models/api_response.dart';

/// API响应处理工具类
class ApiResponseHandler {
  /// 处理简单的布尔响应（如成功/失败操作）
  static Either<Failure, bool> handleBooleanResponse(Response<dynamic> response) {
    try {
      if (response.data == null) {
        // 如果没有响应体，根据状态码判断
        if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
          return const Right(true);
        }
        return const Left(ServerFailure(message: '请求失败'));
      }

      final apiResponse = ApiResponse<bool>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => json as bool? ?? true,
      );

      if (apiResponse.isSuccess) {
        return Right(apiResponse.data ?? true);
      } else {
        return Left(
          ServerFailure(
            message: apiResponse.message,
            code: apiResponse.code ?? 500,
          ),
        );
      }
    } catch (e) {
      AppLogger.error('布尔响应处理失败', error: e);
      return Left(ServerFailure(message: '响应处理失败: $e'));
    }
  }

  /// 处理字符串响应（如token、消息等）
  static Either<Failure, String> handleStringResponse(
    Response<dynamic> response, {
    String dataKey = 'data',
  }) {
    try {
      if (response.data == null) {
        return const Left(ServerFailure(message: '响应数据为空'));
      }

      final apiResponse = ApiResponse<dynamic>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => json,
      );

      if (apiResponse.isSuccess && apiResponse.hasData) {
        String result;
        if (apiResponse.data is String) {
          result = apiResponse.data as String;
        } else if (apiResponse.data is Map<String, dynamic>) {
          final data = apiResponse.data as Map<String, dynamic>;
          result = data[dataKey]?.toString() ?? '';
        } else {
          result = apiResponse.data.toString();
        }

        return Right(result);
      } else {
        return Left(
          ServerFailure(
            message: apiResponse.message,
            code: apiResponse.code ?? 500,
          ),
        );
      }
    } catch (e) {
      AppLogger.error('字符串响应处理失败', error: e);
      return Left(ServerFailure(message: '响应处理失败: $e'));
    }
  }

  /// 处理数字响应（如ID、计数等）
  static Either<Failure, int> handleIntResponse(
    Response<dynamic> response, {
    String dataKey = 'data',
  }) {
    try {
      if (response.data == null) {
        return const Left(ServerFailure(message: '响应数据为空'));
      }

      final apiResponse = ApiResponse<dynamic>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => json,
      );

      if (apiResponse.isSuccess && apiResponse.hasData) {
        int result;
        if (apiResponse.data is int) {
          result = apiResponse.data as int;
        } else if (apiResponse.data is Map<String, dynamic>) {
          final data = apiResponse.data as Map<String, dynamic>;
          final value = data[dataKey];
          if (value is int) {
            result = value;
          } else if (value is String) {
            result = int.tryParse(value) ?? 0;
          } else {
            result = 0;
          }
        } else if (apiResponse.data is String) {
          result = int.tryParse(apiResponse.data as String) ?? 0;
        } else {
          result = 0;
        }

        return Right(result);
      } else {
        return Left(
          ServerFailure(
            message: apiResponse.message,
            code: apiResponse.code ?? 500,
          ),
        );
      }
    } catch (e) {
      AppLogger.error('数字响应处理失败', error: e);
      return Left(ServerFailure(message: '响应处理失败: $e'));
    }
  }

  /// 处理原始数据响应（不进行ApiResponse包装解析）
  static Either<Failure, T> handleRawResponse<T>(
    Response<dynamic> response,
    T Function(dynamic) fromJson,
  ) {
    try {
      if (response.data == null) {
        return const Left(ServerFailure(message: '响应数据为空'));
      }

      // 检查HTTP状态码
      if (response.statusCode == null || response.statusCode! < 200 || response.statusCode! >= 300) {
        return Left(
          ServerFailure(
            message: '请求失败',
            code: response.statusCode ?? 500,
          ),
        );
      }

      final data = fromJson(response.data);
      return Right(data);
    } catch (e) {
      AppLogger.error('原始响应处理失败', error: e);
      return Left(ServerFailure(message: '响应处理失败: $e'));
    }
  }

  /// 处理文件上传响应
  static Either<Failure, FileUploadResult> handleFileUploadResponse(Response<dynamic> response) {
    try {
      if (response.data == null) {
        return const Left(ServerFailure(message: '文件上传响应为空'));
      }

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => json! as Map<String, dynamic>,
      );

      if (apiResponse.isSuccess && apiResponse.hasData) {
        final data = apiResponse.data!;
        final result = FileUploadResult(
          url: data['url'] as String? ?? '',
          fileName: data['file_name'] as String? ?? '',
          size: data['size'] as int? ?? 0,
          mimeType: data['mime_type'] as String? ?? '',
        );
        return Right(result);
      } else {
        return Left(
          ServerFailure(
            message: apiResponse.message,
            code: apiResponse.code ?? 500,
          ),
        );
      }
    } catch (e) {
      AppLogger.error('文件上传响应处理失败', error: e);
      return Left(ServerFailure(message: '文件上传响应处理失败: $e'));
    }
  }

  /// 批量处理响应结果
  static Either<Failure, List<Either<Failure, T>>> handleBatchResponse<T>(
    Response<dynamic> response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    try {
      if (response.data == null) {
        return const Left(ServerFailure(message: '批量响应数据为空'));
      }

      final apiResponse = ApiResponse<List<dynamic>>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => json! as List<dynamic>,
      );

      if (apiResponse.isSuccess && apiResponse.hasData) {
        final results = <Either<Failure, T>>[];

        for (final item in apiResponse.data!) {
          try {
            if (item is Map<String, dynamic>) {
              final data = fromJson(item);
              results.add(Right(data));
            } else {
              results.add(const Left(ServerFailure(message: '无效的数据格式')));
            }
          } catch (e) {
            results.add(Left(ServerFailure(message: '数据解析失败: $e')));
          }
        }

        return Right(results);
      } else {
        return Left(
          ServerFailure(
            message: apiResponse.message,
            code: apiResponse.code ?? 500,
          ),
        );
      }
    } catch (e) {
      AppLogger.error('批量响应处理失败', error: e);
      return Left(ServerFailure(message: '批量响应处理失败: $e'));
    }
  }
}

/// 文件上传结果模型
class FileUploadResult {
  const FileUploadResult({
    required this.url,
    required this.fileName,
    required this.size,
    required this.mimeType,
  });

  final String url;
  final String fileName;
  final int size;
  final String mimeType;

  @override
  String toString() {
    return 'FileUploadResult(url: $url, fileName: $fileName, size: $size, mimeType: $mimeType)';
  }
}
