part of 'core.dart';

/// Application container that manages modules and dependency injection
/// Provides centralized service resolution with module-based encapsulation
class ApplicationContainer {
  final GetIt _getIt;
  final ModuleContext _context;
  final List<Module> _modules = [];
  final List<Module> _initializedModules = [];
  final Type _rootModuleType = ApplicationContainer;
  bool _isReady = false;

  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      noBoxingByDefault: true,
      printEmojis: false,
      dateTimeFormat: DateTimeFormat.none,
    ),
  );

  // total time to initialize the container
  Duration _totalTime = Duration.zero;

  ApplicationContainer([GetIt? getIt])
    : _getIt = getIt ?? GetIt.instance,
      _context = ModuleContext();

  /// Register a module with the container
  /// Makes the module's exported services available to the application
  Future<void> registerModule(Module module) async {
    if (!_modules.contains(module)) {
      _modules.add(module);
      module.register(_getIt, _context);

      // Register this module as an import of the root application container
      _context.registerModuleImports(_rootModuleType, [module.runtimeType]);

      // Auto-export: Make all services from directly imported modules globally available
      _autoExportFromRootModule(module);

      // Initialize the module and its dependencies
      await _initializeModule(module);

      // Mark container as ready after all modules are initialized
      _isReady = true;

      _logger.log(
        Level.info,
        '[NestCore] Container initialized in ${_totalTime.inMilliseconds}ms',
      );
    }
  }

  /// Initialize a module and all its dependencies
  Future<void> _initializeModule(Module module) async {
    final startTime = DateTime.now();
    final visited = <Type>{};
    await _initializeModuleRecursive(module, visited);
    _totalTime += DateTime.now().difference(startTime);
  }

  /// Recursively initialize modules, ensuring dependencies are initialized first
  Future<void> _initializeModuleRecursive(
    Module module,
    Set<Type> visited,
  ) async {
    final moduleType = module.runtimeType;

    // Skip if already visited or initialized
    if (visited.contains(moduleType) || _initializedModules.contains(module)) {
      return;
    }

    visited.add(moduleType);

    // Initialize all imported modules first (dependency-first order)
    for (final importedModule in module.imports) {
      await _initializeModuleRecursive(importedModule, visited);
    }

    // Initialize this module
    if (!_initializedModules.contains(module)) {
      final startTime = DateTime.now();
      // Create a scoped locator for this module
      final scopedLocator = _ScopedGetIt(_getIt, _context, moduleType);

      try {
        await module.onModuleInit(scopedLocator, _context);
        _initializedModules.add(module);
        _totalTime += DateTime.now().difference(startTime);
        _logger.log(
          Level.info,
          '[NestCore] Module initialized successfully: $moduleType',
        );
      } catch (e) {
        _logger.log(
          Level.error,
          '[NestCore] Error initializing module $moduleType: $e',
        );
        rethrow;
      }
    }
  }

  /// Automatically make services available from registered modules and their direct imports
  void _autoExportFromRootModule(Module rootModule) {
    final visitedModules = <Type>{};

    // Make the root module's own exported services globally available
    for (final exportType in rootModule.exports) {
      _context.markAsGlobal(exportType);
    }

    // Make services from directly imported modules globally available
    // This does not include transitive imports to maintain proper encapsulation
    for (final importedModule in rootModule.imports) {
      _collectDirectExports(importedModule, visitedModules);
    }
  }

  /// Make all services from a directly imported module globally available
  /// Only processes direct imports, not transitive dependencies
  void _collectDirectExports(Module module, Set<Type> visitedModules) {
    final moduleType = module.runtimeType;

    // Prevent infinite recursion in case of circular module references
    if (visitedModules.contains(moduleType)) {
      return;
    }
    visitedModules.add(moduleType);

    // Make ALL services from this module globally available to the root container
    // This allows the application container to access any service from directly
    // imported modules, providing convenience while maintaining encapsulation
    for (final serviceEntry in _context.serviceToModule.entries) {
      if (serviceEntry.value == moduleType) {
        _context.markAsGlobal(serviceEntry.key);
      }
    }
  }

  /// Register multiple modules at once
  Future<void> registerModules(List<Module> modules) async {
    for (final module in modules) {
      await registerModule(module);
    }
  }

  /// Get a service instance from the container
  /// Services are accessible if they are available from registered modules
  T get<T extends Object>({String? instanceName}) {
    // Verify the service is accessible from the application container
    if (!_context.canAccess(_rootModuleType, T)) {
      final providerModule = _context.serviceToModule[T];
      throw ServiceNotExportedException(
        T,
        providerModule ?? Object,
        _rootModuleType,
      );
    }

    return _getIt.get<T>(instanceName: instanceName);
  }

  /// Get a service instance with parameters
  T getWithParams<T extends Object>(dynamic param1, [dynamic param2]) {
    if (!_context.canAccess(_rootModuleType, T)) {
      final providerModule = _context.serviceToModule[T];
      throw ServiceNotExportedException(
        T,
        providerModule ?? Object,
        _rootModuleType,
      );
    }

    return _getIt.get<T>(param1: param1, param2: param2);
  }

  /// Get async service instance
  Future<T> getAsync<T extends Object>({String? instanceName}) {
    if (!_context.canAccess(_rootModuleType, T)) {
      final providerModule = _context.serviceToModule[T];
      throw ServiceNotExportedException(
        T,
        providerModule ?? Object,
        _rootModuleType,
      );
    }

    return _getIt.getAsync<T>(instanceName: instanceName);
  }

  /// Check if a service is registered and accessible
  bool isRegistered<T extends Object>({String? instanceName}) {
    return _getIt.isRegistered<T>(instanceName: instanceName) &&
        _context.canAccess(_rootModuleType, T);
  }

  /// Check if a service is registered in the underlying container (ignoring exports)
  bool isRegisteredInContainer<T extends Object>({String? instanceName}) {
    return _getIt.isRegistered<T>(instanceName: instanceName);
  }

  /// Get all services available to the root container
  Set<Type> getAvailableServices() {
    return _context.getAvailableServices(_rootModuleType);
  }

  /// Check if the container is ready (all modules initialized)
  bool get isReady => _isReady;

  /// Wait for the container to be ready
  Future<void> waitUntilReady({Duration? timeout}) async {
    if (_isReady) return;

    final completer = Completer<void>();
    Timer? timeoutTimer;

    // Set up timeout if provided
    if (timeout != null) {
      timeoutTimer = Timer(timeout, () {
        if (!completer.isCompleted) {
          completer.completeError(
            TimeoutException(
              'Container initialization timed out after ${timeout.inMilliseconds}ms',
              timeout,
            ),
          );
        }
      });
    }

    // Poll for readiness (simple implementation)
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      if (_isReady) {
        timer.cancel();
        timeoutTimer?.cancel();
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
    });

    return completer.future;
  }

  /// Wait for all services to be ready (delegates to GetIt)
  Future<void> allReady({
    Duration? timeout,
    bool ignorePendingAsyncCreation = false,
  }) async {
    await _getIt.allReady(
      timeout: timeout,
      ignorePendingAsyncCreation: ignorePendingAsyncCreation,
    );
  }

  /// Reset the container (useful for testing)
  Future<void> reset() async {
    // Destroy modules in reverse order of initialization
    final modulesToDestroy = List<Module>.from(_initializedModules.reversed);

    for (final module in modulesToDestroy) {
      try {
        print('Destroying module: ${module.runtimeType}');
        final scopedLocator = _ScopedGetIt(
          _getIt,
          _context,
          module.runtimeType,
        );
        await module.onModuleDestroy(scopedLocator, _context);
        print('Module destroyed successfully: ${module.runtimeType}');
      } catch (e) {
        print('Error destroying module ${module.runtimeType}: $e');
      }
    }

    _getIt.reset();
    _modules.clear();
    _initializedModules.clear();
    _context.moduleExports.clear();
    _context.moduleImports.clear();
    _context.serviceToModule.clear();
    _context.globalServices.clear();
    _isReady = false;
  }

  /// Get the underlying GetIt instance (use with caution - bypasses module restrictions)
  GetIt get getIt => _getIt;

  /// Get the module context (useful for testing and debugging)
  ModuleContext get context => _context;

  /// Get all registered modules
  List<Module> get modules => List.unmodifiable(_modules);
}
