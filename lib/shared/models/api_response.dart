import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

/// API统一响应模型
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> extends Equatable {
  final bool success;
  final String message;
  final T? data;
  final int? code;
  final String? timestamp;

  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.code,
    this.timestamp,
  });

  /// 从JSON创建ApiResponse对象
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);

  /// 转换为JSON
  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);

  /// 创建成功响应
  factory ApiResponse.success({
    required T data,
    String message = '操作成功',
    int? code,
    String? timestamp,
  }) {
    return ApiResponse<T>(
      success: true,
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
      success: false,
      message: message,
      data: data,
      code: code ?? 400,
      timestamp: timestamp ?? DateTime.now().toIso8601String(),
    );
  }

  /// 是否成功
  bool get isSuccess => success;

  /// 是否失败
  bool get isFailure => !success;

  /// 是否有数据
  bool get hasData => data != null;

  @override
  List<Object?> get props => [success, message, data, code, timestamp];

  @override
  String toString() {
    return 'ApiResponse(success: $success, message: $message, data: $data, code: $code)';
  }
}

/// 分页数据模型
@JsonSerializable(genericArgumentFactories: true)
class PageData<T> extends Equatable {
  final List<T> items;
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const PageData({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  /// 从JSON创建PageData对象
  factory PageData.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$PageDataFromJson(json, fromJsonT);

  /// 转换为JSON
  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$PageDataToJson(this, toJsonT);

  /// 创建空的分页数据
  factory PageData.empty({
    int page = 1,
    int pageSize = 20,
  }) {
    return PageData<T>(
      items: [],
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

  @override
  List<Object?> get props => [
        items,
        total,
        page,
        pageSize,
        totalPages,
        hasNextPage,
        hasPreviousPage,
      ];

  @override
  String toString() {
    return 'PageData(items: ${items.length}, total: $total, page: $page/$totalPages)';
  }
}
