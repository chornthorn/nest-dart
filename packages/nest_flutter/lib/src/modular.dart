part of 'core.dart';

/// Global instance for accessing the current container
ApplicationContainerNotifier? _globalContainer;

/// Modular class providing a clean API similar to Flutter Modular
class Modular {
  /// Get a service instance from the global container
  /// Usage: Modular.get&lt;UserService&gt;()
  static T get<T extends Object>({String? instanceName}) {
    if (_globalContainer == null) {
      throw FlutterError(
        'Modular.get<$T>() called before ModularApp was initialized.\n'
        'Make sure your app is wrapped with ModularApp widget.',
      );
    }
    return _globalContainer!.get<T>(instanceName: instanceName);
  }

  /// Get a service instance with parameters
  static T getWithParams<T extends Object>(dynamic param1, [dynamic param2]) {
    if (_globalContainer == null) {
      throw FlutterError(
        'Modular.getWithParams<$T>() called before ModularApp was initialized.\n'
        'Make sure your app is wrapped with ModularApp widget.',
      );
    }
    return _globalContainer!.getWithParams<T>(param1, param2);
  }

  /// Get async service instance
  static Future<T> getAsync<T extends Object>({String? instanceName}) {
    if (_globalContainer == null) {
      throw FlutterError(
        'Modular.getAsync<$T>() called before ModularApp was initialized.\n'
        'Make sure your app is wrapped with ModularApp widget.',
      );
    }
    return _globalContainer!.getAsync<T>(instanceName: instanceName);
  }

  /// Check if a service is registered
  static bool isRegistered<T extends Object>({String? instanceName}) {
    if (_globalContainer == null) return false;
    return _globalContainer!.isRegistered<T>(instanceName: instanceName);
  }

  /// Get the container notifier from context (alternative to static methods)
  static ApplicationContainerNotifier of(BuildContext context) {
    return ApplicationContainerProvider.of(context);
  }

  /// Get the container from context
  static nest_core.ApplicationContainer containerOf(BuildContext context) {
    return ApplicationContainerProvider.containerOf(context);
  }

  /// Get all available services
  static Set<Type> getAvailableServices() {
    if (_globalContainer == null) return <Type>{};
    return _globalContainer!.getAvailableServices();
  }

  /// Internal method to set the global container
  static void _setGlobalContainer(ApplicationContainerNotifier container) {
    _globalContainer = container;
  }

  /// Internal method to clear the global container
  static void _clearGlobalContainer() {
    _globalContainer = null;
    _cachedRouter = null; // Clear router cache when container is cleared
  }

  /// Clear the cached router (useful for testing or when routes need to be refreshed)
  /// Call this method if you need to force router recreation after module changes
  static void clearRouterCache() {
    _cachedRouter = null;
  }

  /// Get the cached router instance (for debugging purposes)
  static GoRouter? get cachedRouter => _cachedRouter;

  /// Check if router is currently cached
  static bool get isRouterCached => _cachedRouter != null;

  /// Create a GoRouter configuration from the root module
  /// Allows customization through a configurator callback
  /// Caches the router to prevent recreation during hot reloads
  static GoRouter router(
    GoRouter Function(GoRouter router) configurator, {
    Module? rootModule,
    bool forceRecreate = false,
  }) {
    // Return cached router if available and not forcing recreation
    if (_cachedRouter != null && !forceRecreate) {
      return _cachedRouter!;
    }

    // Get the root module from stored reference or use provided one
    final module = rootModule ?? _rootModule;

    if (module == null) {
      throw FlutterError(
        'Modular.router() called but no root module found.\n'
        'Either provide a rootModule parameter or ensure ModularApp is initialized.',
      );
    }

    // Collect all routes from the module hierarchy if it has route support
    final routes = module.collectAllRoutes();

    // Create the base router with collected routes
    final baseRouter = GoRouter(
      routes: routes,
      initialLocation: '/',
      debugLogDiagnostics: false,
    );

    // Apply custom configuration through the configurator
    final configuredRouter = configurator(baseRouter);

    // Cache the router to prevent recreation on hot reload
    _cachedRouter = configuredRouter;

    return configuredRouter;
  }

  /// Internal storage for the root module
  static Module? _rootModule;

  /// Internal storage for the cached router to prevent recreation on hot reload
  static GoRouter? _cachedRouter;

  /// Internal method to set the root module
  static void _setRootModule(Module module) {
    _rootModule = module;
    // Clear cached router when root module changes
    _cachedRouter = null;
  }

  /// Get the current root module
  static Module? get rootModule => _rootModule;
}

/// ModularApp widget that initializes the module system
/// Usage: ModularApp(module: AppModule(), child: MyApp())
class ModularApp extends StatefulWidget {
  final Module module;
  final Widget child;
  final nest_core.ApplicationContainer? container;
  final Widget? loading;

  const ModularApp({
    super.key,
    required this.module,
    required this.child,
    this.container,
    this.loading,
  });

  @override
  State<ModularApp> createState() => _ModularAppState();
}

class _ModularAppState extends State<ModularApp> {
  ApplicationContainerNotifier? _containerNotifier;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeContainer();
  }

  Future<void> _initializeContainer() async {
    // Create container
    final container = widget.container ?? nest_core.ApplicationContainer();

    // Store the root module for router configuration
    Modular._setRootModule(widget.module);

    // Register module asynchronously
    await container.registerModule(widget.module);

    // Create notifier with the initialized container
    _containerNotifier = ApplicationContainerNotifier(container);

    // Set as global container
    Modular._setGlobalContainer(_containerNotifier!);

    // Mark as initialized and rebuild
    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    // Clear global container when app is disposed
    Modular._clearGlobalContainer();
    _containerNotifier?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_containerNotifier != null) {
      Modular._setGlobalContainer(_containerNotifier!);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _containerNotifier == null) {
      return widget.loading ??
          const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
    }

    return ApplicationContainerProvider(
      notifier: _containerNotifier!,
      child: widget.child,
    );
  }
}
