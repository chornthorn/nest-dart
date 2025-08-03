part of 'core.dart';

/// Mixin that adds route support to nest_core Module
mixin RouteMixin on nest_core.Module {
  /// List of routes provided by this module
  /// These routes will be automatically collected and registered with go_router
  List<RouteBase> get routes => [];

  /// Optional route prefix for this module's routes
  /// Useful for organizing routes under a common path segment
  String? get routePrefix => null;

  /// Collect all routes from this module and its imports recursively
  /// Prevents duplicate processing of the same module types
  List<RouteBase> collectAllRoutes([Set<Type>? processedModuleTypes]) {
    processedModuleTypes ??= <Type>{};
    final allRoutes = <RouteBase>[];

    // Skip if this module type has already been processed
    if (processedModuleTypes.contains(runtimeType)) {
      return allRoutes; // Return empty list for duplicate module types
    }

    // Mark this module type as processed
    processedModuleTypes.add(runtimeType);

    // First, collect routes from imported modules
    for (final importedModule in imports) {
      if (importedModule is Module) {
        allRoutes.addAll(importedModule.collectAllRoutes(processedModuleTypes));
      }
    }

    // Then add this module's routes, applying prefix if specified
    for (final route in routes) {
      // Apply route prefix if specified
      final processedRoute = (routePrefix != null && routePrefix!.isNotEmpty)
          ? _applyRoutePrefix(route, routePrefix!)
          : route;

      allRoutes.add(processedRoute);
    }

    return allRoutes;
  }

  /// Apply route prefix to a route
  RouteBase _applyRoutePrefix(RouteBase route, String prefix) {
    if (route is GoRoute) {
      // Ensure prefix starts with / and doesn't end with /
      final cleanPrefix = prefix.startsWith('/') ? prefix : '/$prefix';
      final finalPrefix = cleanPrefix.endsWith('/')
          ? cleanPrefix.substring(0, cleanPrefix.length - 1)
          : cleanPrefix;

      // Ensure route path starts with /
      final routePath = route.path.startsWith('/')
          ? route.path
          : '/${route.path}';

      // Combine prefix and path, avoiding double slashes
      final newPath = routePath == '/' ? finalPrefix : '$finalPrefix$routePath';

      return GoRoute(
        path: newPath,
        name: route.name,
        builder: route.builder,
        pageBuilder: route.pageBuilder,
        redirect: route.redirect,
        routes: route.routes,
      );
    }

    // For other route types, return as-is
    return route;
  }
}

/// The Module class that extends nest_core Module with route support
abstract class Module extends nest_core.Module with RouteMixin {}
