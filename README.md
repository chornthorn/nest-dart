# Nest Dart

A NestJS-inspired dependency injection framework for Dart, bringing modular architecture and type-safe service management to Dart applications.

## Features

- 🏗️ **Modular Architecture** - Organize code into reusable modules
- 💉 **Dependency Injection** - Type-safe service resolution with GetIt
- 🔒 **Access Control** - Services are private by default, must be explicitly exported
- 🔧 **Multi-Platform** - Works with Flutter, Dart Frog, and pure Dart applications

## Packages

- **nest_core** - Core dependency injection and module system
- **nest_flutter** - Flutter integration with provider support
- **nest_frog** - Dart Frog backend integration

## Quick Start

```dart
import 'package:nest_core/nest_core.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [CoreModule(), UserModule()];
  
  @override
  void providers(Locator locator) {
    // Register your services here
  }
  
  @override
  List<Type> get exports => []; // Export services to other modules
}

// Initialize the application
final container = ApplicationContainer(AppModule());
await container.initialize();
```

## Examples

- **Flutter App** - Mobile app with modular architecture
- **Frog Backend** - REST API server with dependency injection

## Development

```bash
# Install dependencies
dart pub get

# Run tests
melos run test

# Format code
melos run format
```