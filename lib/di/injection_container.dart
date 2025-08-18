import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sky_eldercare_family/config/env/app_config.dart';
import 'package:sky_eldercare_family/core/utils/logger.dart';

/// Dependency Injection Container for the application
class InjectionContainer {
  static ProviderContainer? _container;

  /// Get the provider container instance
  static ProviderContainer get container {
    if (_container == null) {
      throw Exception(
        'InjectionContainer has not been initialized. '
        'Call InjectionContainer.initialize() first.',
      );
    }
    return _container!;
  }

  /// Initialize the dependency injection container
  static Future<void> initialize() async {
    try {
      AppLogger.info('Initializing Dependency Injection Container...');
      AppLogger.info('AppConfig isDebug: ${AppConfig.isDebug}');

      // Create provider container
      _container = ProviderContainer(
        observers: [
          if (AppConfig.isDebug) ProviderLogger(),
        ],
      );

      // Initialize core providers
      // await initializeProviders();

      AppLogger.info('Dependency Injection Container initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize DI container', error: e);
      rethrow;
    }
  }

  /// Dispose the container
  static void dispose() {
    _container?.dispose();
    _container = null;
    AppLogger.info('Dependency Injection Container disposed');
  }

  /// Get a provider value
  static T read<T>(ProviderBase<T> provider) {
    return container.read(provider);
  }

  /// Listen to a provider
  static void listen<T>(
    ProviderListenable<T> provider,
    void Function(T? previous, T next) listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
  }) {
    container.listen<T>(provider, listener, onError: onError);
  }

  /// Refresh a provider
  static T refresh<T>(ProviderBase<T> provider) {
    return container.refresh(provider);
  }
}

/// Provider observer for debugging
class ProviderLogger extends ProviderObserver {
  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    AppLogger.debug('Provider added: ${provider.runtimeType}');
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    AppLogger.debug('Provider disposed: ${provider.runtimeType}');
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    AppLogger.debug('Provider updated: ${provider.runtimeType}');
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    AppLogger.error(
      'Provider failed: ${provider.runtimeType}',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
