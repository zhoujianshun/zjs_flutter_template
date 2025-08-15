// Riverpod 使用示例
// 这个文件包含了各种Riverpod的使用案例，供学习参考
//
// 【重要】避免 "ref after widget disposed" 错误的最佳实践：
// 1. 在异步回调中使用 ref 之前，始终检查 context.mounted
// 2. 在 StatefulWidget 中，可以在 dispose() 方法中取消异步操作
// 3. 避免在 Future.delayed 等异步回调中直接使用 ref
// 4. 使用 ref.listen 时要注意回调中的异步操作

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ========== 1. 简单状态管理 ==========

/// 计数器Provider - 最基础的状态管理
final counterProvider = StateProvider<int>((ref) => 0);

/// 计数器Widget示例
class CounterExample extends ConsumerWidget {
  const CounterExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 监听计数器变化，当值改变时Widget会重新构建
    final count = ref.watch(counterProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('简单计数器示例', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('当前计数: $count', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // 使用ref.read()来修改状态，不会触发当前Widget重建
                    ref.read(counterProvider.notifier).state--;
                  },
                  child: const Text('-'),
                ),
                ElevatedButton(
                  onPressed: () {
                    ref.read(counterProvider.notifier).state++;
                  },
                  child: const Text('+'),
                ),
                ElevatedButton(
                  onPressed: () {
                    ref.read(counterProvider.notifier).state = 0;
                  },
                  child: const Text('重置'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ========== 2. 复杂状态管理 ==========

/// 购物车商品
class CartItem {
  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });
  final String id;
  final String name;
  final double price;
  final int quantity;

  CartItem copyWith({
    String? id,
    String? name,
    double? price,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }
}

/// 购物车状态
class CartState {
  CartState({
    required this.items,
    this.isLoading = false,
  });
  final List<CartItem> items;
  final bool isLoading;

  CartState copyWith({
    List<CartItem>? items,
    bool? isLoading,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  /// 计算总价
  double get totalPrice {
    return items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  /// 计算商品总数
  int get totalItems {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }
}

/// 购物车状态管理器
class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState(items: []));

  /// 添加商品到购物车
  void addItem(CartItem item) {
    final existingIndex = state.items.indexWhere((i) => i.id == item.id);

    if (existingIndex >= 0) {
      // 如果商品已存在，增加数量
      final updatedItems = [...state.items];
      updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
        quantity: updatedItems[existingIndex].quantity + 1,
      );
      state = state.copyWith(items: updatedItems);
    } else {
      // 如果是新商品，添加到列表
      state = state.copyWith(items: [...state.items, item]);
    }
  }

  /// 移除商品
  void removeItem(String itemId) {
    state = state.copyWith(
      items: state.items.where((item) => item.id != itemId).toList(),
    );
  }

  /// 更新商品数量
  void updateQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      removeItem(itemId);
      return;
    }

    final updatedItems = state.items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();

    state = state.copyWith(items: updatedItems);
  }

  /// 清空购物车
  void clearCart() {
    state = CartState(items: []);
  }

  /// 模拟异步结账
  Future<void> checkout() async {
    state = state.copyWith(isLoading: true);

    try {
      // 模拟网络请求
      await Future<void>.delayed(const Duration(seconds: 2));

      // 结账成功，清空购物车
      state = CartState(items: []);
    } catch (e) {
      // 结账失败，恢复状态
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }
}

/// 购物车Provider
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});

/// 购物车Widget示例
class CartExample extends ConsumerWidget {
  const CartExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('购物车示例', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // 购物车统计信息
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('商品数量: ${cartState.totalItems}'),
                Text('总价: ¥${cartState.totalPrice.toStringAsFixed(2)}'),
              ],
            ),
            const SizedBox(height: 16),

            // 添加商品按钮
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    ref.read(cartProvider.notifier).addItem(
                          CartItem(
                            id: 'item_${DateTime.now().millisecondsSinceEpoch}',
                            name: '商品${cartState.items.length + 1}',
                            price: 99.99,
                            quantity: 1,
                          ),
                        );
                  },
                  child: const Text('添加商品'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: cartState.items.isEmpty
                      ? null
                      : () {
                          ref.read(cartProvider.notifier).clearCart();
                        },
                  child: const Text('清空购物车'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: cartState.items.isEmpty || cartState.isLoading
                      ? null
                      : () async {
                          try {
                            await ref.read(cartProvider.notifier).checkout();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('结账成功！')),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('结账失败: $e')),
                              );
                            }
                          }
                        },
                  child: cartState.isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('结账'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 商品列表
            if (cartState.items.isEmpty)
              const Text('购物车为空')
            else
              ...cartState.items.map(
                (item) => ListTile(
                  title: Text(item.name),
                  subtitle: Text('¥${item.price.toStringAsFixed(2)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          ref.read(cartProvider.notifier).updateQuantity(
                                item.id,
                                item.quantity - 1,
                              );
                        },
                        icon: const Icon(Icons.remove),
                      ),
                      Text('${item.quantity}'),
                      IconButton(
                        onPressed: () {
                          ref.read(cartProvider.notifier).updateQuantity(
                                item.id,
                                item.quantity + 1,
                              );
                        },
                        icon: const Icon(Icons.add),
                      ),
                      IconButton(
                        onPressed: () {
                          ref.read(cartProvider.notifier).removeItem(item.id);
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ========== 3. 异步数据处理 ==========

/// 模拟用户数据
class User {
  User({required this.id, required this.name, required this.email});
  final String id;
  final String name;
  final String email;
}

/// 模拟API服务
class UserApiService {
  static Future<List<User>> getUsers() async {
    // 模拟网络延迟
    await Future<void>.delayed(const Duration(seconds: 1));

    // 模拟可能的错误
    if (DateTime.now().millisecond % 3 == 0) {
      throw Exception('网络错误');
    }

    return [
      User(id: '1', name: '张三', email: 'zhangsan@example.com'),
      User(id: '2', name: '李四', email: 'lisi@example.com'),
      User(id: '3', name: '王五', email: 'wangwu@example.com'),
    ];
  }
}

/// 用户列表Provider - 处理异步数据
final usersProvider = FutureProvider<List<User>>((ref) async {
  return UserApiService.getUsers();
});

/// 异步数据Widget示例
class AsyncDataExample extends ConsumerWidget {
  const AsyncDataExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('异步数据示例', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ElevatedButton(
                  onPressed: () {
                    // 刷新数据
                    ref.invalidate(usersProvider);
                  },
                  child: const Text('刷新'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 使用when方法处理不同状态
            usersAsync.when(
              // 数据加载成功
              data: (users) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('用户列表 (${users.length}个用户):'),
                  const SizedBox(height: 8),
                  ...users.map(
                    (user) => ListTile(
                      leading: CircleAvatar(child: Text(user.name[0])),
                      title: Text(user.name),
                      subtitle: Text(user.email),
                    ),
                  ),
                ],
              ),

              // 数据加载中
              loading: () => const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 8),
                    Text('加载用户数据中...'),
                  ],
                ),
              ),

              // 数据加载失败
              error: (error, stackTrace) => Column(
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 48),
                  const SizedBox(height: 8),
                  Text('加载失败: $error'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      ref.invalidate(usersProvider);
                    },
                    child: const Text('重试'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ========== 4. Provider组合使用 ==========

/// 搜索关键词Provider
final searchQueryProvider = StateProvider<String>((ref) => '');

/// 过滤后的用户列表Provider - 依赖其他Provider
final filteredUsersProvider = Provider<AsyncValue<List<User>>>((ref) {
  final usersAsync = ref.watch(usersProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

  return usersAsync.whenData((users) {
    if (searchQuery.isEmpty) {
      return users;
    }
    return users
        .where(
          (user) => user.name.toLowerCase().contains(searchQuery) || user.email.toLowerCase().contains(searchQuery),
        )
        .toList();
  });
});

/// Provider组合示例Widget
class ProviderCombinationExample extends ConsumerWidget {
  const ProviderCombinationExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider);
    final filteredUsersAsync = ref.watch(filteredUsersProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Provider组合示例', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // 搜索框
            TextField(
              decoration: const InputDecoration(
                labelText: '搜索用户',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
              },
            ),
            const SizedBox(height: 16),

            // 过滤后的用户列表
            filteredUsersAsync.when(
              data: (users) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('搜索结果: ${users.length}个用户'),
                  if (searchQuery.isNotEmpty) Text('关键词: "$searchQuery"', style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  if (users.isEmpty && searchQuery.isNotEmpty)
                    const Text('没有找到匹配的用户')
                  else
                    ...users.map(
                      (user) => ListTile(
                        leading: CircleAvatar(child: Text(user.name[0])),
                        title: Text(user.name),
                        subtitle: Text(user.email),
                      ),
                    ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Text('错误: $error'),
            ),
          ],
        ),
      ),
    );
  }
}

// ========== 5. 监听器示例 ==========

/// 通知Provider
final notificationProvider = StateProvider<String?>((ref) => null);

/// 监听器示例Widget
class ListenerExample extends ConsumerWidget {
  const ListenerExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);

    // 监听计数器变化，执行副作用（不重建Widget）
    ref.listen<int>(counterProvider, (previous, next) {
      if (next != 0 && next % 5 == 0) {
        // 当计数器是5的倍数时显示通知
        ref.read(notificationProvider.notifier).state = '计数器达到了 $next！';

        // 3秒后清除通知 - 检查Widget是否仍然存在
        Future<void>.delayed(const Duration(seconds: 3), () {
          // 检查Widget是否仍然挂载，避免"ref after widget disposed"错误
          if (context.mounted) {
            ref.read(notificationProvider.notifier).state = null;
          }
        });
      }
    });

    final notification = ref.watch(notificationProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('监听器示例', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('当计数器是5的倍数时会显示通知'),
            const SizedBox(height: 16),
            Text('当前计数: $counter', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 16),

            // 通知显示区域
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: notification != null ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                border: Border.all(
                  color: notification != null ? Colors.green : Colors.grey,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: notification != null
                    ? Text(notification, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
                    : const Text('等待通知...', style: TextStyle(color: Colors.grey)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ========== 6. 正确的异步处理示例 ==========

/// 演示如何正确处理异步操作，避免"ref after widget disposed"错误
class SafeAsyncExample extends ConsumerStatefulWidget {
  const SafeAsyncExample({super.key});

  @override
  ConsumerState<SafeAsyncExample> createState() => _SafeAsyncExampleState();
}

class _SafeAsyncExampleState extends ConsumerState<SafeAsyncExample> {
  bool _isLoading = false;
  String _message = '';

  /// 安全的异步操作示例
  Future<void> _performSafeAsyncOperation() async {
    if (!mounted) return; // 检查Widget是否仍然挂载

    setState(() {
      _isLoading = true;
      _message = '';
    });

    try {
      // 模拟异步操作
      await Future<void>.delayed(const Duration(seconds: 2));

      // 在使用ref之前检查Widget是否仍然挂载
      if (!mounted) return;

      // 安全地使用ref更新状态
      ref.read(notificationProvider.notifier).state = '异步操作完成！';

      setState(() {
        _isLoading = false;
        _message = '操作成功完成';
      });

      // 延迟清除通知 - 正确的做法
      Future<void>.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          // 再次检查
          ref.read(notificationProvider.notifier).state = null;
        }
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _message = '操作失败: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('安全异步操作示例', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('演示如何避免 "ref after widget disposed" 错误'),
            const SizedBox(height: 16),
            if (_message.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _message.contains('失败') ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                  border: Border.all(
                    color: _message.contains('失败') ? Colors.red : Colors.green,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_message),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _performSafeAsyncOperation,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('执行安全异步操作'),
            ),
          ],
        ),
      ),
    );
  }
}

// ========== 示例页面 ==========

/// Riverpod示例页面
class RiverpodExamplesPage extends ConsumerWidget {
  const RiverpodExamplesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod 使用示例'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CounterExample(),
            SizedBox(height: 16),
            ListenerExample(),
            SizedBox(height: 16),
            CartExample(),
            SizedBox(height: 16),
            AsyncDataExample(),
            SizedBox(height: 16),
            ProviderCombinationExample(),
            SizedBox(height: 16),
            SafeAsyncExample(),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
