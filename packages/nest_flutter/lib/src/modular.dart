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
  static ApplicationContainer containerOf(BuildContext context) {
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
  }
}

/// ModularApp widget that initializes the module system
/// Usage: ModularApp(module: AppModule(), child: MyApp())
class ModularApp extends StatefulWidget {
  final Module module;
  final Widget child;
  final ApplicationContainer? container;

  const ModularApp({
    super.key,
    required this.module,
    required this.child,
    this.container,
  });

  @override
  State<ModularApp> createState() => _ModularAppState();
}

class _ModularAppState extends State<ModularApp> {
  late ApplicationContainerNotifier _containerNotifier;

  @override
  void initState() {
    super.initState();

    // Determine which modules to use
    final List<Module> modulesToRegister;
    modulesToRegister = [widget.module];

    // Create container notifier with modules
    _containerNotifier = ApplicationContainerNotifier.withModules(
      modulesToRegister,
      widget.container,
    );

    // Set as global container
    Modular._setGlobalContainer(_containerNotifier);
  }

  @override
  void dispose() {
    // Clear global container when app is disposed
    Modular._clearGlobalContainer();
    _containerNotifier.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Modular._setGlobalContainer(_containerNotifier);
  }

  @override
  Widget build(BuildContext context) {
    return ApplicationContainerProvider(
      notifier: _containerNotifier,
      child: widget.child,
    );
  }
}
