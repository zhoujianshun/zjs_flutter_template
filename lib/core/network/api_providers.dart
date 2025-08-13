import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_client.dart';

/// API客户端提供者
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});
