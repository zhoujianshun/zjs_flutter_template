import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zjs_flutter_template/core/network/api_client.dart';
import 'package:zjs_flutter_template/core/network/network_info.dart';
import 'package:zjs_flutter_template/core/storage/storage_service.dart';
import 'package:zjs_flutter_template/core/utils/logger.dart';
import 'package:zjs_flutter_template/di/service_locator.dart';

/// Core providers for dependency injection
/// 基础服务提供者 - 桥接 GetIt 和 Riverpod
/// GetIt 负责依赖注入，Riverpod 负责状态管理
class AppProviders {
  /// 网络服务提供者
  static final networkInfoProvider = Provider<NetworkInfo>((ref) {
    return getIt<NetworkInfo>();
  });

  /// 网络状态提供者
  static final networkStatusProvider = StreamProvider<NetworkStatus>((ref) {
    final networkService = ref.watch(networkInfoProvider);
    return networkService.networkStatusStream;
  });

  /// 网络连接状态提供者 (简单布尔值)
  static final isConnectedProvider = StreamProvider<bool>((ref) {
    final networkService = ref.watch(networkInfoProvider);
    return networkService.networkStatusStream.map(
      (status) => status == NetworkStatus.connected,
    );
  });

  /// API客户端提供者
  static final apiClientProvider = Provider<ApiClient>((ref) {
    AppLogger.info('Creating ApiClient instance');
    return getIt<ApiClient>();
  });

  /// 存储服务提供者
  static final storageServiceProvider = Provider<StorageService>((ref) {
    return getIt<StorageService>();
  });

  // /// Authentication related providers
  // static final authServiceProvider = Provider<AuthService>((ref) {
  //   final dioClient = ref.watch(dioClientProvider);
  //   return AuthService(dioClient);
  // });

  // static final authRepositoryProvider = Provider<AuthRepository>((ref) {
  //   final authService = ref.watch(authServiceProvider);
  //   final storageService = ref.watch(storageServiceProvider);
  //   return AuthRepositoryImpl(
  //     authService: authService,
  //     storageService: storageService,
  //   );
  // });
}

/// Initialize all providers
// Future<void> initializeProviders() async {
//   try {
//     // Initialize logger
//     AppLogger.initialize();

//     AppLogger.info('Initializing application providers...');

//     // Initialize storage service
//     await StorageService.instance.initialize();

//     AppLogger.info('All providers initialized successfully');
//   } catch (e) {
//     AppLogger.error('Failed to initialize providers', error: e);
//     rethrow;
//   }
// }
