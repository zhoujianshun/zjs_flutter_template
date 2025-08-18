import 'package:flutter/material.dart';
import 'package:sky_eldercare_family/di/service_locator.dart';
import 'package:sky_eldercare_family/shared/services/user_service.dart';

/// GetIt使用示例
class GetItUsageExamples {
  /// 示例1: 在Service中使用GetIt
  static void serviceExample() {
    // 直接获取依赖，无需context或ref
    final userService = sl<UserService>();

    // 使用服务
    userService.getCurrentUser().then(
          (result) => result.fold(
            (failure) => null,
            (user) => user,
          ),
        );
  }

  /// 示例2: 在Widget中使用GetIt
  static Widget widgetExample() {
    return Builder(
      builder: (context) {
        // 在Widget中直接获取服务
        final userService = sl<UserService>();

        return FutureBuilder(
          future: userService.getCurrentUser().then(
                (result) => result.fold(
                  (failure) => null,
                  (user) => user,
                ),
              ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text('用户: ${snapshot.data?.name ?? '未知'}');
            }
            return const CircularProgressIndicator();
          },
        );
      },
    );
  }

  /// 示例3: 在业务逻辑类中使用GetIt
  static void businessLogicExample() {
    final orderService = OrderService();
    orderService.createOrder();
  }
}

/// 示例业务逻辑类
class OrderService {
  // 构造函数中获取依赖
  OrderService() : _userService = sl<UserService>();

  final UserService _userService;

  Future<void> createOrder() async {
    // 检查用户认证
    final authResult = await _userService.getLocalAuthInfo();

    authResult.fold(
      (failure) => throw Exception('用户未认证'),
      (authInfo) async {
        if (authInfo != null) {
          // 获取用户信息
          final userResult = await _userService.getCurrentUser();
          userResult.fold(
            (failure) => throw Exception('获取用户信息失败'),
            (user) {
              // 创建订单逻辑
              print('为用户 ${user.name} 创建订单');
            },
          );
        }
      },
    );
  }
}

/// GetIt vs Riverpod 性能对比示例
class PerformanceComparison {
  /// GetIt方式 - 直接访问
  static void getItPerformance() {
    final stopwatch = Stopwatch()..start();

    for (var i = 0; i < 10000; i++) {
      final userService = sl<UserService>(); // 直接获取，O(1)复杂度
      // 使用服务...
      userService.toString(); // 避免unused warning
    }

    stopwatch.stop();
    print('GetIt获取10000次服务耗时: ${stopwatch.elapsedMicroseconds}μs');
  }
}
