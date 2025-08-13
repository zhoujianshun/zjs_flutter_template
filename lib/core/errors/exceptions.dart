/// 抽象异常类
abstract class AppException implements Exception {
  final String message;
  final int? code;
  
  const AppException({
    required this.message,
    this.code,
  });
  
  @override
  String toString() => 'AppException(message: $message, code: $code)';
}

/// 服务器异常
class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.code,
  });
}

/// 网络异常
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
  });
}

/// 缓存异常
class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.code,
  });
}

/// 验证异常
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code,
  });
}

/// 权限异常  
class PermissionException extends AppException {
  const PermissionException({
    required super.message,
    super.code,
  });
}

/// 认证异常
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code,
  });
}

/// 解析异常
class ParsingException extends AppException {
  const ParsingException({
    required super.message,
    super.code,
  });
}
