import 'package:dart_frog/dart_frog.dart';
import 'package:nest_core/nest_core.dart';
import 'dart:developer' as dev;

/// Unified Modular class for Dart Frog integration
/// Combines container management with context-based service access
class Modular {
  static ApplicationContainer? _container;

  /// Initialize the application container with modules
  static Future<void> initialize(Module appModule) async {
    _container = ApplicationContainer();
    await _container!.registerModule(appModule);

    // Wait for container to be ready
    await _container!.waitUntilReady();

    dev.log('Application container initialized and ready');
  }

  /// Get a service from the request context
  /// Usage: final userService = Modular.of(context).get<UserService>();
  static ModularContext of(RequestContext context) {
    return ModularContext._(context);
  }

  /// Static get method (direct container access)
  /// Usage: final userService = Modular.get<UserService>();
  static T get<T extends Object>() {
    if (_container == null) {
      throw Exception(
        'Modular not initialized. Call Modular.initialize() first.',
      );
    }
    return _container!.get<T>();
  }

  /// Get the application container instance
  static ApplicationContainer get container {
    if (_container == null) {
      throw Exception(
        'Modular not initialized. Call Modular.initialize() first.',
      );
    }
    return _container!;
  }

  /// Check if the container is initialized
  static bool get isInitialized => _container != null;

  /// Reset the container (useful for testing)
  static Future<void> reset() async {
    if (_container != null) {
      await _container!.reset();
    }
    _container = null;
  }
}

/// Context wrapper that provides service access
class ModularContext {
  final RequestContext _context;

  ModularContext._(this._context);

  /// Get a service from the request context
  T get<T extends Object>() {
    try {
      return _context.read<T>();
    } catch (e) {
      // Fallback to container if not in context
      return Modular.get<T>();
    }
  }

  /// Check if a service is available in the context
  bool has<T extends Object>() {
    try {
      _context.read<T>();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get the underlying request context
  RequestContext get context => _context;
}
