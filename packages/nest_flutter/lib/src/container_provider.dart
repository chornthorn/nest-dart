part of 'core.dart';

/// A ChangeNotifier wrapper for ApplicationContainer to enable reactive updates
class ApplicationContainerNotifier extends ChangeNotifier {
  final nest_core.ApplicationContainer _container;

  ApplicationContainerNotifier([nest_core.ApplicationContainer? container])
    : _container = container ?? nest_core.ApplicationContainer();

  /// Create with initial modules
  ApplicationContainerNotifier.withModules(
    List<nest_core.Module> modules, [
    nest_core.ApplicationContainer? container,
  ]) : _container = container ?? nest_core.ApplicationContainer() {
    for (final module in modules) {
      _container.registerModule(module);
    }
  }

  /// Get the underlying container
  nest_core.ApplicationContainer get container => _container;

  /// Register a module (typically done during initialization)
  void registerModule(nest_core.Module module) {
    _container.registerModule(module);
  }

  /// Register multiple modules (typically done during initialization)
  void registerModules(List<nest_core.Module> modules) {
    _container.registerModules(modules);
  }

  /// Register a module and notify listeners (use for dynamic module registration)
  void registerModuleWithNotification(nest_core.Module module) {
    _container.registerModule(module);
    notifyListeners();
  }

  /// Register multiple modules and notify listeners (use for dynamic module registration)
  void registerModulesWithNotification(List<nest_core.Module> modules) {
    _container.registerModules(modules);
    notifyListeners();
  }

  /// Get a service instance from the container
  T get<T extends Object>({String? instanceName}) {
    return _container.get<T>(instanceName: instanceName);
  }

  /// Get a service instance with parameters
  T getWithParams<T extends Object>(dynamic param1, [dynamic param2]) {
    return _container.getWithParams<T>(param1, param2);
  }

  /// Get async service instance
  Future<T> getAsync<T extends Object>({String? instanceName}) {
    return _container.getAsync<T>(instanceName: instanceName);
  }

  /// Check if a service is registered and accessible
  bool isRegistered<T extends Object>({String? instanceName}) {
    return _container.isRegistered<T>(instanceName: instanceName);
  }

  /// Get all services available to the root container
  Set<Type> getAvailableServices() {
    return _container.getAvailableServices();
  }

  /// Reset the container and notify listeners
  void reset() {
    _container.reset();
    notifyListeners();
  }

  /// Get all registered modules
  List<nest_core.Module> get modules => _container.modules;

  /// Get the underlying GetIt instance (use with caution)
  nest_core.GetIt get getIt => _container.getIt;

  /// Get the module context (useful for testing and debugging)
  nest_core.ModuleContext get context => _container.context;
}

/// InheritedNotifier that provides ApplicationContainer to the widget tree
class ApplicationContainerProvider
    extends InheritedNotifier<ApplicationContainerNotifier> {
  const ApplicationContainerProvider({
    super.key,
    required ApplicationContainerNotifier super.notifier,
    required super.child,
  });

  /// Create a provider with a new container
  ApplicationContainerProvider.create({
    super.key,
    nest_core.ApplicationContainer? container,
    required super.child,
  }) : super(notifier: ApplicationContainerNotifier(container));

  /// Create a provider with initial modules
  ApplicationContainerProvider.withModules({
    super.key,
    required List<nest_core.Module> modules,
    nest_core.ApplicationContainer? container,
    required super.child,
  }) : super(
         notifier: ApplicationContainerNotifier.withModules(modules, container),
       );

  /// Get the ApplicationContainerNotifier from the widget tree
  static ApplicationContainerNotifier of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<ApplicationContainerProvider>();
    if (provider == null) {
      throw FlutterError(
        'ApplicationContainerProvider.of() called with a context that does not contain '
        'an ApplicationContainerProvider.\n'
        'No ApplicationContainerProvider ancestor could be found starting from the context '
        'that was passed to ApplicationContainerProvider.of().\n'
        'This can happen if the context you used comes from a widget above the '
        'ApplicationContainerProvider.\n'
        'The context used was: $context',
      );
    }
    return provider.notifier!;
  }

  /// Get the ApplicationContainerNotifier from the widget tree, or null if not found
  static ApplicationContainerNotifier? maybeOf(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<ApplicationContainerProvider>();
    return provider?.notifier;
  }

  /// Get the ApplicationContainer from the widget tree
  static nest_core.ApplicationContainer containerOf(BuildContext context) {
    return of(context).container;
  }

  /// Get the ApplicationContainer from the widget tree, or null if not found
  static nest_core.ApplicationContainer? maybeContainerOf(
    BuildContext context,
  ) {
    return maybeOf(context)?.container;
  }
}
