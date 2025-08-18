import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:zjs_flutter_template/core/network/api_client.dart';
import 'package:zjs_flutter_template/core/network/network_info.dart';

void main() {
  group('GetIt Service Locator Simple Tests', () {
    late GetIt testLocator;

    setUp(() {
      // 为每个测试创建独立的GetIt实例
      testLocator = GetIt.instance;
      testLocator.reset();

      // 手动注册简单的服务（不依赖Flutter插件）
      testLocator.registerSingleton<NetworkInfo>(NetworkInfo());
      testLocator.registerSingleton<ApiClient>(
        ApiClient(BaseOptions(baseUrl: 'https://test.com')),
      );
    });

    tearDown(() {
      testLocator.reset();
    });

    test('should register and resolve NetworkInfo', () {
      // 验证NetworkInfo是否正确注册
      expect(testLocator.isRegistered<NetworkInfo>(), isTrue);

      // 获取实例
      final networkInfo = testLocator.get<NetworkInfo>();
      expect(networkInfo, isNotNull);
      expect(networkInfo, isA<NetworkInfo>());

      // 验证单例模式
      final networkInfo2 = testLocator.get<NetworkInfo>();
      expect(identical(networkInfo, networkInfo2), isTrue);
    });

    test('should register and resolve ApiClient', () {
      // 验证ApiClient是否正确注册
      expect(testLocator.isRegistered<ApiClient>(), isTrue);

      // 获取实例
      final apiClient = testLocator.get<ApiClient>();
      expect(apiClient, isNotNull);
      expect(apiClient, isA<ApiClient>());

      // 验证单例模式
      final apiClient2 = testLocator.get<ApiClient>();
      expect(identical(apiClient, apiClient2), isTrue);
    });

    test('should handle unregistered services correctly', () {
      // 测试未注册的服务
      expect(testLocator.isRegistered<String>(), isFalse);

      // 应该抛出异常
      expect(() => testLocator.get<String>(), throwsA(isA<StateError>()));
    });

    test('should support factory registration', () {
      // 注册工厂（每次创建新实例）
      testLocator.registerFactory<DateTime>(DateTime.now);

      expect(testLocator.isRegistered<DateTime>(), isTrue);

      // 获取两个实例，应该不同
      final time1 = testLocator.get<DateTime>();
      final time2 = testLocator.get<DateTime>();

      expect(time1, isNotNull);
      expect(time2, isNotNull);
      expect(identical(time1, time2), isFalse);
    });

    test('should support lazy singleton registration', () {
      var creationCount = 0;

      // 注册懒加载单例
      testLocator.registerLazySingleton<String>(() {
        creationCount++;
        return 'lazy_instance';
      });

      expect(testLocator.isRegistered<String>(), isTrue);
      expect(creationCount, equals(0)); // 还没有创建

      // 首次获取时创建
      final instance1 = testLocator.get<String>();
      expect(creationCount, equals(1));
      expect(instance1, equals('lazy_instance'));

      // 再次获取，不会重新创建
      final instance2 = testLocator.get<String>();
      expect(creationCount, equals(1)); // 仍然是1
      expect(identical(instance1, instance2), isTrue);
    });

    test('should support dependency injection', () {
      // 获取已注册的服务
      final apiClient = testLocator.get<ApiClient>();
      final networkInfo = testLocator.get<NetworkInfo>();

      expect(apiClient, isNotNull);
      expect(networkInfo, isNotNull);

      // 验证依赖是单例
      final apiClient2 = testLocator.get<ApiClient>();
      final networkInfo2 = testLocator.get<NetworkInfo>();

      expect(identical(apiClient, apiClient2), isTrue);
      expect(identical(networkInfo, networkInfo2), isTrue);
    });

    test('should support named instances', () {
      // 注册命名实例
      testLocator.registerSingleton<String>('dev_config', instanceName: 'dev');
      testLocator.registerSingleton<String>('prod_config', instanceName: 'prod');

      // 获取命名实例
      final devConfig = testLocator.get<String>(instanceName: 'dev');
      final prodConfig = testLocator.get<String>(instanceName: 'prod');

      expect(devConfig, equals('dev_config'));
      expect(prodConfig, equals('prod_config'));
      expect(devConfig != prodConfig, isTrue);
    });
  });
}
