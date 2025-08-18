import 'package:flutter_test/flutter_test.dart';
import 'package:sky_eldercare_family/core/network/api_client.dart';
import 'package:sky_eldercare_family/core/network/network_info.dart';
import 'package:sky_eldercare_family/di/service_locator.dart';
import 'package:sky_eldercare_family/shared/repositories/auth_repository.dart';
import 'package:sky_eldercare_family/shared/services/user_service.dart';

void main() {
  group('GetIt Service Locator Tests', () {
    setUpAll(() async {
      // 初始化GetIt容器
      await ServiceLocator.initialize();
    });

    tearDownAll(() async {
      // 清理GetIt容器
      await ServiceLocator.reset();
    });

    test('should register and resolve ApiClient', () {
      // 验证ApiClient是否正确注册
      expect(ServiceLocator.isRegistered<ApiClient>(), isTrue);

      // 获取实例
      final apiClient = ServiceLocator.get<ApiClient>();
      expect(apiClient, isNotNull);
      expect(apiClient, isA<ApiClient>());

      // 验证单例模式
      final apiClient2 = ServiceLocator.get<ApiClient>();
      expect(identical(apiClient, apiClient2), isTrue);
    });

    test('should register and resolve NetworkInfo', () {
      // 验证NetworkInfo是否正确注册
      expect(ServiceLocator.isRegistered<NetworkInfo>(), isTrue);

      // 获取实例
      final networkInfo = ServiceLocator.get<NetworkInfo>();
      expect(networkInfo, isNotNull);
      expect(networkInfo, isA<NetworkInfo>());
    });

    test('should register and resolve UserService', () {
      // 验证UserService是否正确注册
      expect(ServiceLocator.isRegistered<UserService>(), isTrue);

      // 获取实例
      final userService = ServiceLocator.get<UserService>();
      expect(userService, isNotNull);
      expect(userService, isA<UserService>());
    });

    test('should register and resolve AuthRepository', () {
      // 验证AuthRepository是否正确注册
      expect(ServiceLocator.isRegistered<AuthRepository>(), isTrue);

      // 获取实例
      final authRepository = ServiceLocator.get<AuthRepository>();
      expect(authRepository, isNotNull);
      expect(authRepository, isA<AuthRepository>());
    });

    test('should handle dependency injection correctly', () {
      // 获取UserService，它依赖于ApiClient
      final userService = ServiceLocator.get<UserService>();
      expect(userService, isNotNull);

      // 获取AuthRepository，它依赖于UserService和StorageService
      final authRepository = ServiceLocator.get<AuthRepository>();
      expect(authRepository, isNotNull);

      // 验证依赖注入正常工作
      expect(userService, isA<UserService>());
      expect(authRepository, isA<AuthRepository>());
    });

    test('should return null for unregistered services', () {
      // 测试未注册的服务
      final unregisteredService = ServiceLocator.getOrNull<String>();
      expect(unregisteredService, isNull);
      expect(ServiceLocator.isRegistered<String>(), isFalse);
    });

    test('should use extension methods correctly', () {
      // 测试扩展方法
      expect(sl.apiClient, isNotNull);
      expect(sl.userService, isNotNull);
      expect(sl.authRepository, isNotNull);
      expect(sl.networkInfo, isNotNull);
    });
  });
}

