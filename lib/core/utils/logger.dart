import 'package:logger/logger.dart';
import 'package:sky_eldercare_family/config/env/app_config.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Application logger with different output levels
class AppLogger {
  static late Logger _logger;
  static late Talker _talker;
  static bool _initialized = false;

  /// Initialize the logger
  static void initialize() {
    if (_initialized) return;

    _logger = Logger(
      filter: _getLogFilter(),
      printer: _getLogPrinter(),
      output: _getLogOutput(),
    );

    _talker = TalkerFlutter.init(
      settings: TalkerSettings(
        maxHistoryItems: 100,
      ),
    );

    _initialized = true;
  }

  /// Get Talker instance for advanced logging
  static Talker get talker {
    if (!_initialized) initialize();
    return _talker;
  }

  /// Debug level logging
  static void debug(String message, {Object? error, StackTrace? stackTrace}) {
    if (!_initialized) initialize();
    _logger.d(message, error: error, stackTrace: stackTrace);
    _talker.debug(message);
  }

  static void d(String message, {Object? error, StackTrace? stackTrace}) {
    debug(message, error: error, stackTrace: stackTrace);
  }

  /// Info level logging
  static void info(String message, {Object? error, StackTrace? stackTrace}) {
    if (!_initialized) initialize();
    _logger.i(message, error: error, stackTrace: stackTrace);
    _talker.info(message);
  }

  static void i(String message, {Object? error, StackTrace? stackTrace}) {
    info(message, error: error, stackTrace: stackTrace);
  }

  /// Warning level logging
  static void warning(String message, {Object? error, StackTrace? stackTrace}) {
    if (!_initialized) initialize();
    _logger.w(message, error: error, stackTrace: stackTrace);
    _talker.warning(message);
  }

  static void w(String message, {Object? error, StackTrace? stackTrace}) {
    warning(message, error: error, stackTrace: stackTrace);
  }

  /// Error level logging
  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    if (!_initialized) initialize();
    _logger.e(message, error: error, stackTrace: stackTrace);
    _talker.error(message, error, stackTrace);
  }

  static void e(String message, {Object? error, StackTrace? stackTrace}) {
    if (!_initialized) initialize();
    _logger.e(message, error: error, stackTrace: stackTrace);
    _talker.error(message, error, stackTrace);
  }

  /// Fatal level logging
  static void fatal(String message, {Object? error, StackTrace? stackTrace}) {
    if (!_initialized) initialize();
    _logger.f(message, error: error, stackTrace: stackTrace);
    _talker.critical(message, error, stackTrace);
  }

  static void f(String message, {Object? error, StackTrace? stackTrace}) {
    fatal(message, error: error, stackTrace: stackTrace);
  }

  /// Log HTTP requests/responses
  static void http(String message, {Map<String, dynamic>? data}) {
    if (!_initialized) initialize();
    _talker.logCustom(
      HttpTalkerLog(
        message: message,
        requestOptions: data?['request'],
        response: data?['response'],
        httpError: data?['error'],
      ),
    );
  }

  /// Log exceptions with context
  static void exception(
    Object exception,
    StackTrace stackTrace, {
    String? message,
    Map<String, dynamic>? context,
  }) {
    if (!_initialized) initialize();
    final logMessage = message != null ? '$message: $exception' : exception.toString();
    _logger.e(logMessage, error: exception, stackTrace: stackTrace);
    _talker.handle(exception, stackTrace, logMessage);
  }

  static LogFilter _getLogFilter() {
    switch (AppConfig.logLevel.toLowerCase()) {
      case 'debug':
        return DevelopmentFilter();
      case 'info':
        return ProductionFilter();
      case 'warning':
      case 'warn':
        return ProductionFilter();
      case 'error':
        return ProductionFilter();
      default:
        return AppConfig.isDebug ? DevelopmentFilter() : ProductionFilter();
    }
  }

  static LogPrinter _getLogPrinter() {
    if (AppConfig.isDebug) {
      return PrettyPrinter(
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      );
    } else {
      return SimplePrinter(colors: false);
    }
  }

  static LogOutput _getLogOutput() {
    if (AppConfig.isDebug) {
      return ConsoleOutput();
    } else {
      // In production, you might want to use FileOutput or remote logging
      return ConsoleOutput();
    }
  }
}

/// Custom Talker log for HTTP requests
class HttpTalkerLog extends TalkerLog {
  HttpTalkerLog({
    required String message,
    this.requestOptions,
    this.response,
    this.httpError,
  }) : super(message);
  final dynamic requestOptions;
  final dynamic response;
  final dynamic httpError;

  @override
  String get key => 'http';

  @override
  String get title => 'HTTP';
}
