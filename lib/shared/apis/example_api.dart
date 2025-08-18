import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:zjs_flutter_template/core/errors/failures.dart';
import 'package:zjs_flutter_template/core/network/api_response_handler.dart';
import 'package:zjs_flutter_template/core/network/base_api.dart';

/// 示例API类，展示如何使用统一的API响应处理
///
/// 这是一个模板类，展示了各种常见的API调用场景
@Injectable()
class ExampleAPI extends BaseAPI {
  ExampleAPI(super.apiClient);

  /// 示例1: 获取单个对象
  Future<Either<Failure, ExampleModel>> getExample(String id) async {
    return handleApiCall(
      apiClient.get('/examples/$id'),
      ExampleModel.fromJson,
      logTag: 'ExampleAPI.getExample',
    );
  }

  /// 示例2: 获取对象列表
  Future<Either<Failure, List<ExampleModel>>> getExampleList() async {
    return handleApiListCall(
      apiClient.get('/examples'),
      ExampleModel.fromJson,
      logTag: 'ExampleAPI.getExampleList',
    );
  }

  /// 示例3: 获取分页数据
  Future<Either<Failure, PaginatedResponse<ExampleModel>>> getExamplesPaginated({
    int page = 1,
    int pageSize = 10,
  }) async {
    return handlePaginatedApiCall(
      apiClient.get(
        '/examples/paginated',
        queryParameters: {
          'page': page,
          'page_size': pageSize,
        },
      ),
      ExampleModel.fromJson,
      logTag: 'ExampleAPI.getExamplesPaginated',
    );
  }

  /// 示例4: 创建对象
  Future<Either<Failure, ExampleModel>> createExample(CreateExampleRequest request) async {
    return handleApiCall(
      apiClient.post('/examples', data: request.toJson()),
      ExampleModel.fromJson,
      logTag: 'ExampleAPI.createExample',
    );
  }

  /// 示例5: 更新对象
  Future<Either<Failure, ExampleModel>> updateExample(
    String id,
    UpdateExampleRequest request,
  ) async {
    return handleApiCall(
      apiClient.put('/examples/$id', data: request.toJson()),
      ExampleModel.fromJson,
      logTag: 'ExampleAPI.updateExample',
    );
  }

  /// 示例6: 删除对象（无返回数据）
  Future<Either<Failure, void>> deleteExample(String id) async {
    return handleApiVoidCall(
      apiClient.delete('/examples/$id'),
      logTag: 'ExampleAPI.deleteExample',
    );
  }

  /// 示例7: 批量操作
  Future<Either<Failure, List<Either<Failure, ExampleModel>>>> batchCreateExamples(
    List<CreateExampleRequest> requests,
  ) async {
    final response = await apiClient.post(
      '/examples/batch',
      data: {'items': requests.map((r) => r.toJson()).toList()},
    );

    return ApiResponseHandler.handleBatchResponse<ExampleModel>(
      response,
      ExampleModel.fromJson,
    );
  }

  /// 示例8: 文件上传
  Future<Either<Failure, FileUploadResult>> uploadExampleFile(
    String filePath, {
    String? fileName,
  }) async {
    final response = await apiClient.uploadFile(
      '/examples/upload',
      filePath,
      fileName: fileName,
    );

    return ApiResponseHandler.handleFileUploadResponse(response);
  }

  /// 示例9: 获取简单的字符串响应
  Future<Either<Failure, String>> getExampleToken() async {
    final response = await apiClient.get('/examples/token');
    return ApiResponseHandler.handleStringResponse(response, dataKey: 'token');
  }

  /// 示例10: 获取数字响应
  Future<Either<Failure, int>> getExampleCount() async {
    final response = await apiClient.get('/examples/count');
    return ApiResponseHandler.handleIntResponse(response, dataKey: 'count');
  }

  /// 示例11: 布尔响应
  Future<Either<Failure, bool>> checkExampleExists(String id) async {
    final response = await apiClient.get('/examples/$id/exists');
    return ApiResponseHandler.handleBooleanResponse(response);
  }

  /// 示例12: 处理原始响应（不使用ApiResponse包装）
  Future<Either<Failure, Map<String, dynamic>>> getRawData() async {
    final response = await apiClient.get('/examples/raw');
    return ApiResponseHandler.handleRawResponse<Map<String, dynamic>>(
      response,
      (data) => data as Map<String, dynamic>,
    );
  }
}

/// 示例模型类
class ExampleModel {
  const ExampleModel({
    required this.id,
    required this.name,
    required this.description,
    this.createdAt,
  });

  factory ExampleModel.fromJson(Map<String, dynamic> json) {
    return ExampleModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  final String id;
  final String name;
  final String description;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }
}

/// 创建请求模型
class CreateExampleRequest {
  const CreateExampleRequest({
    required this.name,
    required this.description,
  });

  final String name;
  final String description;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
    };
  }
}

/// 更新请求模型
class UpdateExampleRequest {
  const UpdateExampleRequest({
    this.name,
    this.description,
  });

  final String? name;
  final String? description;

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (description != null) 'description': description,
    };
  }
}
