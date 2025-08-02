part of 'core.dart';

/// Interface for dependency injection container
/// Provides type-safe access to services with export restrictions
abstract class Locator {
  /// Get a service instance
  T get<T extends Object>({
    String? instanceName,
    dynamic param1,
    dynamic param2,
  });

  /// Get a service instance asynchronously
  Future<T> getAsync<T extends Object>({
    String? instanceName,
    dynamic param1,
    dynamic param2,
  });

  /// Call method for syntactic sugar (same as get)
  T call<T extends Object>({
    String? instanceName,
    dynamic param1,
    dynamic param2,
  });

  /// Register a singleton instance
  void registerSingleton<T extends Object>(
    T instance, {
    String? instanceName,
    bool? signalsReady,
    DisposingFunc<T>? dispose,
  });

  /// Register a factory function
  void registerFactory<T extends Object>(
    FactoryFunc<T> factoryFunc, {
    String? instanceName,
  });

  /// Register a lazy singleton
  void registerLazySingleton<T extends Object>(
    FactoryFunc<T> factoryFunc, {
    String? instanceName,
    DisposingFunc<T>? dispose,
  });

  /// Check if a service is registered
  bool isRegistered<T extends Object>({Object? instance, String? instanceName});

  /// Reset the container
  Future<void> reset({bool dispose = true});

  /// Wait for all services to be ready
  Future<void> allReady({
    Duration? timeout,
    bool ignorePendingAsyncCreation = false,
  });
}
