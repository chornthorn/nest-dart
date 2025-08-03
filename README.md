# Nest Dart

A NestJS-inspired dependency injection framework for Dart, bringing modular architecture and type-safe service management to Dart applications.

## Features

- 🏗️ **Modular Architecture** - Organize code into reusable modules
- 💉 **Dependency Injection** - Type-safe service resolution with GetIt
- 🔒 **Access Control** - Services are private by default, must be explicitly exported
- 🔧 **Multi-Platform** - Works with Flutter, Dart Frog, and pure Dart applications
- 🚦 **Module-Based Routing** - GoRouter integration with automatic route collection

## Packages

| Package | Version | Description |
|---------|---------|-------------|
| **[nest_core](packages/nest_core)** | ![pub version](https://img.shields.io/pub/v/nest_core.svg) | Core dependency injection and module system |
| **[nest_flutter](packages/nest_flutter)** | ![pub version](https://img.shields.io/pub/v/nest_flutter.svg) | Flutter integration with GoRouter and provider support |
| **[nest_frog](packages/nest_frog)** | ![pub version](https://img.shields.io/pub/v/nest_frog.svg) | Dart Frog backend integration with middleware support |

## Quick Start

### Core Application

```dart
import 'package:nest_core/nest_core.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [CoreModule(), UserModule()];
  
  @override
  void providers(Locator locator) {
    locator.registerSingleton<UserService>(UserService());
  }
  
  @override
  List<Type> get exports => [UserService];
}

// Initialize the application
final container = ApplicationContainer();
await container.registerModule(AppModule());
```

### Flutter Integration

```dart
import 'package:flutter/material.dart';
import 'package:nest_flutter/nest_flutter.dart';

void main() {
  runApp(
    ModularApp(
      module: AppModule(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: Modular.router((router) {
        return GoRouter(
          routes: router.configuration.routes,
          initialLocation: '/',
        );
      }),
    );
  }
}
```

### Module with Routes

```dart
class UserModule extends Module {
  @override
  List<RouteBase> get routes => [
    GoRoute(
      path: '/users',
      builder: (context, state) => UserListPage(),
    ),
  ];

  @override
  void providers(Locator locator) {
    locator.registerSingleton<UserService>(UserService());
  }
}
```

## Examples

- **[Flutter App](examples/flutter_app)** - Mobile app with modular architecture and GoRouter integration
- **[Frog Backend](examples/frog_backend)** - REST API server with dependency injection and middleware

## Documentation

- 📖 **[Getting Started](https://khode-io.github.io/nest-dart/getting-started)** - Quick introduction to Nest Dart
- 🎯 **[Core Guide](https://khode-io.github.io/nest-dart/core-guide)** - Dependency injection fundamentals
- 📱 **[Flutter Guide](https://khode-io.github.io/nest-dart/flutter-guide)** - Flutter integration and routing
- 🐸 **[Frog Guide](https://khode-io.github.io/nest-dart/frog-guide)** - Dart Frog backend development
- 🔧 **[API Reference](https://khode-io.github.io/nest-dart/api-reference)** - Complete API documentation

## Development

```bash
# Install dependencies
dart pub get

# Run tests
melos run test

# Format code
melos run format
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.