import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:zjs_flutter_template/config/env/app_config.dart';
import 'package:zjs_flutter_template/core/constants/app_constants.dart';
import 'package:zjs_flutter_template/core/network/api_client.dart';
import 'package:zjs_flutter_template/core/network/network_info.dart';
import 'package:zjs_flutter_template/core/storage/storage_service.dart';
import 'package:zjs_flutter_template/core/utils/logger.dart';
import 'package:zjs_flutter_template/di/service_locator.config.dart';
import 'package:zjs_flutter_template/shared/services/user_service.dart';

/// 全局服务定位器实例
final GetIt sl = GetIt.instance;

/// 依赖注入配置
@InjectableInit()
Future<void> configureDependencies() async => sl.init();

/// 手动注册依赖（用于不使用injectable注解的类）
@module
abstract class RegisterModule {
  /// 注册存储服务 - 单例
  @preResolve
  @singleton
  Future<StorageService> get storageService async {
    final service = StorageService.instance;
    await service.initialize();
    AppLogger.info('StorageService实例化成功');
    return service;
  }

  @singleton
  ApiClient get apiClient => ApiClient(
        BaseOptions(
          baseUrl: AppConfig.baseUrl,
          connectTimeout: AppConstants.connectionTimeout,
          receiveTimeout: AppConstants.receiveTimeout,
        ),
      );
}

/// 服务定位器工具类
class ServiceLocator {
  /// 初始化所有依赖
  static Future<void> initialize() async {
    try {
      AppLogger.info('正在初始化GetIt依赖注入容器...');

      // 配置injectable生成的依赖
      await configureDependencies();

      AppLogger.info('GetIt依赖注入容器初始化成功');
    } catch (e) {
      AppLogger.error('GetIt依赖注入容器初始化失败', error: e);
      rethrow;
    }
  }

  /// 重置所有依赖（主要用于测试）
  static Future<void> reset() async {
    await sl.reset();
    AppLogger.info('GetIt依赖注入容器已重置');
  }

  /// 获取服务实例
  static T get<T extends Object>() => sl.get<T>();

  /// 获取服务实例（可选参数）
  static T? getOrNull<T extends Object>() => sl.isRegistered<T>() ? sl.get<T>() : null;

  /// 检查服务是否已注册
  static bool isRegistered<T extends Object>() => sl.isRegistered<T>();

  /// 等待异步依赖准备就绪
  static Future<T> getAsync<T extends Object>() => sl.getAsync<T>();
}

/// GetIt扩展方法，提供更便捷的访问方式
extension GetItExtensions on GetIt {
  /// 快速获取API客户端
  ApiClient get apiClient => get<ApiClient>();

  /// 快速获取存储服务
  StorageService get storageService => get<StorageService>();

  /// 快速获取网络信息服务
  NetworkInfo get networkInfo => get<NetworkInfo>();

  /// 快速获取用户服务
  UserService get userService => get<UserService>();
}

/// 全局快捷访问方式
/// 使用 sl<T>() 而不是 ServiceLocator.get<T>() 来简化调用
T getIt<T extends Object>() => sl.get<T>();
