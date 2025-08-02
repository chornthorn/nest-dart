# Changelog

All notable changes to the `nest_core` package will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.1] - 2025-08-02

### Added
- **Async providers support** - The `providers` method now supports async/await for services requiring async initialization (e.g., SharedPreferences)

### Fixed
- **Module registration** - Fixed async provider registration to properly await service initialization

## [0.1.0] - 2025-08-02

### Added
- **Core dependency injection system** with ApplicationContainer
- **Module-based architecture** with import/export mechanism
- **Service registration** support for singletons, factories, and lazy singletons
- **Lifecycle hooks** with onModuleInit and onModuleDestroy
- **Access control** with service export restrictions
- **Error handling** with ServiceNotExportedException
- **Circular dependency detection** during module registration
- **Type-safe service resolution** with compile-time checks
- **Named instance support** for service registration
- **Service disposal** with cleanup functions
- **Module context** for debugging and testing
- **Container monitoring** with readiness checks and service availability

### Features
- ApplicationContainer for centralized service management
- Abstract Module base class for organizing services
- Locator interface for type-safe dependency injection
- ModuleContext for tracking module relationships
- Scoped service access with export validation
- Automatic dependency resolution with proper initialization order

### Documentation
- Complete API documentation
- Getting started guide with examples
- Module lifecycle documentation
- Service registration patterns
- Testing guidelines and examples

This is the initial release of nest_core, providing the foundation for building modular Dart applications with dependency injection.