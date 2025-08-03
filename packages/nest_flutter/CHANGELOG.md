# Changelog

All notable changes to the `nest_flutter` package will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.3] - 2025-08-03

### Added
- **🚦 GoRouter Integration** - Full integration with go_router for modern Flutter navigation
- **📍 Module-based Routing** - Define routes directly in modules using the `routes` getter
- **🔗 Route Prefixes** - Organize routes with automatic path prefixing using `routePrefix`
- **🔄 Automatic Route Collection** - Routes from imported modules are automatically collected
- **🎯 Modular.router()** - New static method to create configured GoRouter instances

### Router API
- `Modular.router(configurator)` - Create configured router from modules

### Integration
- **go_router dependency** - Added go_router as a direct dependency
- **MaterialApp.router support** - Full integration with MaterialApp.router

## [0.1.2] - 2025-08-02

### Added
- **Loading widget support** for ModularApp widget

### Fixed
- **Module registration** - Fixed async provider registration to properly await service initialization

### Changed
- **nest_core** dependency updated to 0.1.1

## [0.1.1] - 2025-08-02

### Added
- **Re-exports nest_core** for convenience - no need to add nest_core separately to your pubspec.yaml

## [0.1.0] - 2025-08-02

### Added
- **ModularApp widget** for easy Flutter app initialization
- **ApplicationContainerProvider** for widget tree integration
- **ApplicationContainerNotifier** with ChangeNotifier support
- **Static Modular API** for global service access
- **Context-based service resolution** with BuildContext integration
- **Reactive service support** with ChangeNotifier integration
- **Widget testing utilities** for testing with dependency injection
- **Multi-platform support** for all Flutter platforms

### Features
- ModularApp widget wraps your app with dependency injection
- ApplicationContainerProvider provides container to widget tree
- Modular class with static methods for service access
- Support for both static and context-based service resolution
- Integration with Flutter's reactive system via ChangeNotifier
- Proper disposal and cleanup of services
- Testing support with mock modules

### Widget Integration
- Easy service access from any widget
- Automatic container initialization
- Proper lifecycle management
- Memory leak prevention with proper disposal

### Documentation
- Complete Flutter integration guide
- Widget usage examples
- Testing patterns and examples
- Performance optimization tips

This is the initial release of nest_flutter, providing seamless integration between Nest Dart's dependency injection system and Flutter's widget architecture.