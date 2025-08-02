# nest_core

Core dependency injection and module system for Nest Dart - a NestJS-inspired framework for Dart applications.

## Features

- 🏗️ **Modular Architecture** - Organize code into reusable, self-contained modules
- 💉 **Dependency Injection** - Type-safe service resolution with access control
- 🔄 **Lifecycle Management** - Module initialization and cleanup hooks
- 🔒 **Export Control** - Services are private by default, must be explicitly exported
- ⚡ **Performance** - Minimal overhead with compile-time safety

## Installation

Add `nest_core` to your `pubspec.yaml`:

```yaml
dependencies:
  nest_core: ^0.1.0
```

## Quick Start

### 1. Create a Service

```dart
class LoggerService {
  void log(String message) {
    print('[LOG] ${DateTime.now()}: $message');
  }
}
```

### 2. Create a Module

```dart
import 'package:nest_core/nest_core.dart';

class CoreModule extends Module {
  @override
  void providers(Locator locator) {
    locator.registerSingleton<LoggerService>(LoggerService());
  }
  
  @override
  List<Type> get exports => [LoggerService];
}
```

### 3. Initialize Application

```dart
void main() async {
  final container = ApplicationContainer();
  await container.registerModule(CoreModule());
  
  final logger = container.get<LoggerService>();
  logger.log('Application started!');
}
```

## Core Concepts

### ApplicationContainer

The central container that manages modules and services:

```dart
final container = ApplicationContainer();
await container.registerModule(AppModule());

// Get services
final userService = container.get<UserService>();

// Check if ready
if (container.isReady) {
  print('Container initialized');
}
```

### Module System

Modules group related services and define dependencies:

```dart
class UserModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];
  
  @override
  void providers(Locator locator) {
    locator.registerSingleton<UserService>(
      UserService(locator.get<LoggerService>()),
    );
  }
  
  @override
  List<Type> get exports => [UserService];
}
```

### Service Registration

Multiple registration patterns:

```dart
// Singleton (created once)
locator.registerSingleton<UserService>(UserService());

// Factory (new instance each time)
locator.registerFactory<UserService>(() => UserService());

// Lazy Singleton (created on first access)
locator.registerLazySingleton<UserService>(() => UserService());
```

### Lifecycle Hooks

Initialize and cleanup resources:

```dart
class DatabaseModule extends Module {
  @override
  Future<void> onModuleInit(Locator locator, ModuleContext context) async {
    final db = locator.get<DatabaseService>();
    await db.connect();
  }
  
  @override
  Future<void> onModuleDestroy(Locator locator, ModuleContext context) async {
    final db = locator.get<DatabaseService>();
    await db.disconnect();
  }
}
```

## Platform Integrations

- **[nest_flutter](https://pub.dev/packages/nest_flutter)** - Flutter integration with widget support
- **[nest_frog](https://pub.dev/packages/nest_frog)** - Dart Frog backend integration

## Documentation

- [Getting Started Guide](https://chornthorn.github.io/nest-dart/getting-started)
- [API Reference](https://chornthorn.github.io/nest-dart/api-reference)
- [Examples](https://chornthorn.github.io/nest-dart/examples)

## Contributing

We welcome contributions! Please see our [Contributing Guide](https://github.com/chornthorn/nest-dart/blob/main/CONTRIBUTING.md) for details.

## License

This project is licensed under the BSD 3-Clause License - see the [LICENSE](LICENSE) file for details.