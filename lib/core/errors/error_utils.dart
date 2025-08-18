import 'package:sky_eldercare_family/core/errors/exceptions.dart';
import 'package:sky_eldercare_family/core/errors/failures.dart';

/// 将异常映射为失败
Failure mapExceptionToFailure(AppException exception) {
  if (exception is NetworkException) {
    return NetworkFailure(
      message: exception.message,
      code: exception.code ?? -1,
    );
  } else if (exception is ServerException) {
    return ServerFailure(
      message: exception.message,
      code: exception.code ?? 500,
    );
  } else if (exception is AuthException) {
    return AuthFailure(
      message: exception.message,
      code: exception.code ?? 401,
    );
  } else if (exception is ValidationException) {
    return ValidationFailure(
      message: exception.message,
      code: exception.code ?? 400,
    );
  } else {
    return UnknownFailure(
      message: exception.message,
      code: exception.code ?? -999,
    );
  }
}
