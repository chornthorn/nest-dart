part of 'core.dart';

/// Exception thrown when trying to access a non-exported service
class ServiceNotExportedException implements Exception {
  final Type serviceType;
  final Type fromModule;
  final Type toModule;

  const ServiceNotExportedException(
    this.serviceType,
    this.fromModule,
    this.toModule,
  );

  @override
  String toString() {
    return 'ServiceNotExportedException: Service $serviceType is not exported by module $fromModule and cannot be accessed by module $toModule';
  }
}

/// Context for tracking module dependencies and exports
class ModuleContext {
  final Map<Type, Set<Type>> _moduleExports = {};
  final Map<Type, Set<Type>> _moduleImports = {};
  final Map<Type, Type> _serviceToModule = {};
  final Set<Type> _globalServices = {};

  /// Register a module's exports
  void registerModuleExports(Type moduleType, List<Type> exports) {
    _moduleExports[moduleType] = exports.toSet();
  }

  /// Register a module's imports
  void registerModuleImports(Type moduleType, List<Type> imports) {
    _moduleImports[moduleType] = imports.toSet();
  }

  /// Register which module provides a service
  void registerServiceProvider(Type serviceType, Type moduleType) {
    _serviceToModule[serviceType] = moduleType;
  }

  /// Mark a service as globally available (for root module)
  void markAsGlobal(Type serviceType) {
    _globalServices.add(serviceType);
  }

  /// Check if a module can access a service
  bool canAccess(Type requestingModule, Type serviceType) {
    // Global services are always accessible
    if (_globalServices.contains(serviceType)) {
      return true;
    }

    // Find the module that provides this service
    final providerModule = _serviceToModule[serviceType];
    if (providerModule == null) {
      return false;
    }

    // If the requesting module is the same as the provider, allow access
    if (requestingModule == providerModule) {
      return true;
    }

    // Check if the requesting module imports the provider module
    final imports = _moduleImports[requestingModule] ?? <Type>{};
    if (!imports.contains(providerModule)) {
      return false;
    }

    // Check if the provider module exports this service
    final exports = _moduleExports[providerModule] ?? <Type>{};
    return exports.contains(serviceType);
  }

  /// Get available services for a module
  Set<Type> getAvailableServices(Type moduleType) {
    final available = <Type>{};

    // Add global services
    available.addAll(_globalServices);

    // Add services from imported modules that are exported
    final imports = _moduleImports[moduleType] ?? <Type>{};
    for (final importedModule in imports) {
      final exports = _moduleExports[importedModule] ?? <Type>{};
      available.addAll(exports);
    }

    // Add services from this module itself
    for (final entry in _serviceToModule.entries) {
      if (entry.value == moduleType) {
        available.add(entry.key);
      }
    }

    return available;
  }

  // Getters for accessing private fields from ApplicationContainer
  Map<Type, Set<Type>> get moduleExports => _moduleExports;
  Map<Type, Set<Type>> get moduleImports => _moduleImports;
  Map<Type, Type> get serviceToModule => _serviceToModule;
  Set<Type> get globalServices => _globalServices;
}

/// Abstract base class for all modules in the framework
/// Provides modular dependency injection with controlled service access
abstract class Module {
  /// List of modules that this module depends on
  /// Services from imported modules are accessible if they are exported
  List<Module> get imports => [];

  /// Configure providers/services for dependency injection
  /// This method should register all services this module provides
  void providers(Locator locator);

  /// List of provider types that this module exports to other modules
  /// Only exported services can be accessed by modules that import this module
  List<Type> get exports => [];

  /// Internal method to register this module and its dependencies
  void _register(
    GetIt getIt,
    Set<Type> registeredModules,
    ModuleContext context,
  ) {
    final moduleType = runtimeType;

    // Prevent circular dependencies and duplicate registrations
    if (registeredModules.contains(moduleType)) {
      return;
    }

    registeredModules.add(moduleType);

    // Register this module's dependencies and exported services with the context
    context.registerModuleImports(
      moduleType,
      imports.map((m) => m.runtimeType).toList(),
    );
    context.registerModuleExports(moduleType, exports);

    // Register all imported modules first to establish dependency chain
    for (final importedModule in imports) {
      importedModule._register(getIt, registeredModules, context);
    }

    // Create a scoped container that enforces access restrictions for this module
    final scopedGetIt = _ScopedGetIt(getIt, context, moduleType);

    // Register this module's services using the scoped container
    providers(scopedGetIt);
  }

  /// Public method to register this module
  void register(GetIt getIt, ModuleContext context) {
    _register(getIt, <Type>{}, context);
  }

  /// Called after module registration and dependency resolution
  /// Use this for initialization logic like:
  /// - Database connections and migrations
  /// - Service warm-up and configuration
  /// - Data seeding
  /// - Health checks
  Future<void> onModuleInit(Locator locator, ModuleContext context) async {
    // Default implementation does nothing
    // Override in your modules for custom initialization
  }

  /// Called when the module is being destroyed/reset
  /// Use this for cleanup logic like:
  /// - Closing database connections
  /// - Saving state
  /// - Releasing resources
  /// - Cleanup operations
  Future<void> onModuleDestroy(Locator locator, ModuleContext context) async {
    // Default implementation does nothing
    // Override in your modules for custom cleanup
  }
}

/// Scoped dependency injection container that enforces module access restrictions
class _ScopedGetIt implements Locator {
  final GetIt _delegate;
  final ModuleContext _context;
  final Type _moduleType;

  _ScopedGetIt(this._delegate, this._context, this._moduleType);

  @override
  T get<T extends Object>({
    String? instanceName,
    dynamic param1,
    dynamic param2,
  }) {
    // Verify this module has permission to access the requested service
    if (!_context.canAccess(_moduleType, T)) {
      final providerModule = _context.serviceToModule[T];
      throw ServiceNotExportedException(
        T,
        providerModule ?? Object,
        _moduleType,
      );
    }

    return _delegate.get<T>(
      instanceName: instanceName,
      param1: param1,
      param2: param2,
    );
  }

  @override
  void registerSingleton<T extends Object>(
    T instance, {
    String? instanceName,
    bool? signalsReady,
    DisposingFunc<T>? dispose,
  }) {
    _context.registerServiceProvider(T, _moduleType);
    _delegate.registerSingleton<T>(
      instance,
      instanceName: instanceName,
      signalsReady: signalsReady,
      dispose: dispose,
    );
  }

  @override
  void registerFactory<T extends Object>(
    FactoryFunc<T> factoryFunc, {
    String? instanceName,
  }) {
    _context.registerServiceProvider(T, _moduleType);
    _delegate.registerFactory<T>(factoryFunc, instanceName: instanceName);
  }

  @override
  void registerLazySingleton<T extends Object>(
    FactoryFunc<T> factoryFunc, {
    String? instanceName,
    DisposingFunc<T>? dispose,
  }) {
    _context.registerServiceProvider(T, _moduleType);
    _delegate.registerLazySingleton<T>(
      factoryFunc,
      instanceName: instanceName,
      dispose: dispose,
    );
  }

  @override
  T call<T extends Object>({
    String? instanceName,
    dynamic param1,
    dynamic param2,
  }) => get<T>(instanceName: instanceName, param1: param1, param2: param2);

  @override
  bool isRegistered<T extends Object>({
    Object? instance,
    String? instanceName,
  }) =>
      _delegate.isRegistered<T>(instance: instance, instanceName: instanceName);

  @override
  Future<void> reset({bool dispose = true}) =>
      _delegate.reset(dispose: dispose);

  @override
  Future<void> allReady({
    Duration? timeout,
    bool ignorePendingAsyncCreation = false,
  }) => _delegate.allReady(
    timeout: timeout,
    ignorePendingAsyncCreation: ignorePendingAsyncCreation,
  );
}
