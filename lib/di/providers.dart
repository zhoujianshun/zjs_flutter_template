import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sky_eldercare_family/core/network/api_client.dart';
import 'package:sky_eldercare_family/core/network/network_info.dart';
import 'package:sky_eldercare_family/core/storage/storage_service.dart';
import 'package:sky_eldercare_family/core/utils/logger.dart';

/// Core providers for dependency injection
/// 基础服务提供者
class AppProviders {
  /// 网络服务提供者
  static final networkInfoProvider = Provider<NetworkInfo>((ref) {
    return NetworkInfo();
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

  static final apiClientProvider = Provider<ApiClient>((ref) {
    AppLogger.info('Creating ApiClient instance');
    return ApiClient();
  });

  /// Storage related providers
  static final storageServiceProvider = Provider<StorageService>((ref) {
    return StorageService.instance;
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
Future<void> initializeProviders() async {
  try {
    // Initialize logger
    AppLogger.initialize();

    AppLogger.info('Initializing application providers...');

    // Initialize storage service
    await StorageService.instance.initialize();

    AppLogger.info('All providers initialized successfully');
  } catch (e) {
    AppLogger.error('Failed to initialize providers', error: e);
    rethrow;
  }
}
