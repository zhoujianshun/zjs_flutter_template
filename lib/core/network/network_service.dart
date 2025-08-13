import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 网络状态枚举
enum NetworkStatus {
  connected,
  disconnected,
}

/// 网络服务 - 管理网络连接状态
class NetworkService {
  final Connectivity _connectivity = Connectivity();

  /// 检查当前网络连接状态
  Future<bool> isConnected() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  /// 监听网络连接状态变化
  Stream<NetworkStatus> get networkStatusStream {
    return _connectivity.onConnectivityChanged.map((result) {
      return result != ConnectivityResult.none ? NetworkStatus.connected : NetworkStatus.disconnected;
    });
  }

  /// 获取连接类型
  Future<ConnectivityResult> getConnectionType() async {
    return _connectivity.checkConnectivity();
  }

  /// 判断是否为WiFi连接
  Future<bool> isWiFiConnected() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult == ConnectivityResult.wifi;
  }

  /// 判断是否为移动网络连接
  Future<bool> isMobileConnected() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult == ConnectivityResult.mobile;
  }
}

/// 网络服务提供者
final networkServiceProvider = Provider<NetworkService>((ref) {
  return NetworkService();
});

/// 网络状态提供者
final networkStatusProvider = StreamProvider<NetworkStatus>((ref) {
  final networkService = ref.watch(networkServiceProvider);
  return networkService.networkStatusStream;
});

/// 网络连接状态提供者 (简单布尔值)
final isConnectedProvider = StreamProvider<bool>((ref) {
  final networkService = ref.watch(networkServiceProvider);
  return networkService.networkStatusStream.map(
    (status) => status == NetworkStatus.connected,
  );
});
