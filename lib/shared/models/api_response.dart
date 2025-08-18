import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response.freezed.dart';
part 'api_response.g.dart';

/// API统一响应模型
@Freezed(genericArgumentFactories: true)
abstract class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse({
    required String message,
    T? data,
    int? code,
    String? timestamp,
  }) = _ApiResponse<T>;

  const ApiResponse._();

  /// 从JSON创建ApiResponse对象
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);

  /// 创建成功响应
  factory ApiResponse.success({
    required T data,
    String message = '操作成功',
    int? code,
    String? timestamp,
  }) {
    return ApiResponse<T>(
      message: message,
      data: data,
      code: code ?? 200,
      timestamp: timestamp ?? DateTime.now().toIso8601String(),
    );
  }

  /// 创建失败响应
  factory ApiResponse.failure({
    required String message,
    int? code,
    String? timestamp,
    T? data,
  }) {
    return ApiResponse<T>(
      message: message,
      data: data,
      code: code ?? 400,
      timestamp: timestamp ?? DateTime.now().toIso8601String(),
    );
  }

  /// 是否成功
  bool get isSuccess => code == 200 || code == 0;

  /// 是否失败
  bool get isFailure => code != 200 && code != 0;

  /// 是否有数据
  bool get hasData => data != null;
}

/// 分页数据模型
@Freezed(genericArgumentFactories: true)
abstract class PageData<T> with _$PageData<T> {
  const factory PageData({
    required List<T> items,
    required int total,
    required int page,
    required int pageSize,
    required int totalPages,
    required bool hasNextPage,
    required bool hasPreviousPage,
  }) = _PageData<T>;

  const PageData._();

  /// 从JSON创建PageData对象
  factory PageData.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$PageDataFromJson(json, fromJsonT);

  /// 创建空的分页数据
  factory PageData.empty({
    int page = 1,
    int pageSize = 20,
  }) {
    return PageData<T>(
      items: const [],
      total: 0,
      page: page,
      pageSize: pageSize,
      totalPages: 0,
      hasNextPage: false,
      hasPreviousPage: false,
    );
  }

  /// 是否为空
  bool get isEmpty => items.isEmpty;

  /// 是否不为空
  bool get isNotEmpty => items.isNotEmpty;

  /// 当前页开始索引
  int get startIndex => (page - 1) * pageSize + 1;

  /// 当前页结束索引
  int get endIndex => startIndex + items.length - 1;
}
