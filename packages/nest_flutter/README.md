# nest_flutter

Flutter integration for Nest Dart - bringing dependency injection and modular architecture to Flutter applications.

## Features

- 🎯 **ModularApp Widget** - Easy Flutter app initialization
- 🔄 **Provider Integration** - Works with Flutter's widget tree
- 📱 **Reactive Services** - ChangeNotifier support for state management
- 🎨 **Context Access** - Get services from BuildContext
- ⚡ **Static API** - Global service access with Modular class

## Installation

Add `nest_flutter` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  nest_core: ^0.1.0
  nest_flutter: ^0.1.0
```

## Quick Start

### 1. Create Your Module

```dart
import 'package:nest_core/nest_core.dart';

class AppModule extends Module {
  @override
  void providers(Locator locator) {
    locator.registerSingleton<UserService>(UserService());
  }
  
  @override
  List<Type> get exports => [UserService];
}
```

### 2. Wrap Your App

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
    return MaterialApp(
      title: 'Nest Flutter Demo',
      home: HomePage(),
    );
  }
}
```

### 3. Use Services in Widgets

```dart
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final UserService _userService;
  
  @override
  void initState() {
    super.initState();
    _userService = Modular.get<UserService>();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users')),
      body: FutureBuilder<List<User>>(
        future: _userService.getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data!
                  .map((user) => ListTile(title: Text(user.name)))
                  .toList(),
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
```

## Service Access Patterns

### Static Access (Recommended)

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userService = Modular.get<UserService>();
    // Use service...
  }
}
```

### Context-Based Access

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final container = Modular.containerOf(context);
    final userService = container.get<UserService>();
    // Use service...
  }
}
```

### Reactive Services

Create services that work with Flutter's reactive system:

```dart
class CounterService extends ChangeNotifier {
  int _count = 0;
  
  int get count => _count;
  
  void increment() {
    _count++;
    notifyListeners();
  }
}

// In your module
locator.registerSingleton<CounterService>(CounterService());

// In your widget
class CounterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counterService = Modular.get<CounterService>();
    
    return ListenableBuilder(
      listenable: counterService,
      builder: (context, child) {
        return Text('Count: ${counterService.count}');
      },
    );
  }
}
```

## Advanced Usage

### Custom Container Provider

```dart
ApplicationContainerProvider.withModules(
  modules: [AppModule(), UserModule()],
  child: MyApp(),
)
```

### Service-Aware Base Widget

```dart
abstract class ServiceAwareWidget<T extends StatefulWidget> extends State<T> {
  late final ApplicationContainer _container;
  
  @override
  void initState() {
    super.initState();
    _container = Modular.containerOf(context);
    onServicesReady();
  }
  
  void onServicesReady() {}
  
  S getService<S extends Object>() => _container.get<S>();
}
```

## Testing

Test widgets with mock services:

```dart
testWidgets('should display users', (tester) async {
  await tester.pumpWidget(
    ModularApp(
      module: TestModule(),
      child: MaterialApp(home: UserListWidget()),
    ),
  );
  
  expect(find.text('Test User'), findsOneWidget);
});

class TestModule extends Module {
  @override
  void providers(Locator locator) {
    locator.registerSingleton<UserService>(MockUserService());
  }
}
```

## Platform Support

- ✅ **Android** - Full support
- ✅ **iOS** - Full support  
- ✅ **Web** - Full support
- ✅ **macOS** - Full support
- ✅ **Windows** - Full support
- ✅ **Linux** - Full support

## Documentation

- [Flutter Integration Guide](https://chornthorn.github.io/nest-dart/flutter-guide)
- [API Reference](https://chornthorn.github.io/nest-dart/api-reference)
- [Examples](https://chornthorn.github.io/nest-dart/examples)

## Related Packages

- **[nest_core](https://pub.dev/packages/nest_core)** - Core dependency injection system
- **[nest_frog](https://pub.dev/packages/nest_frog)** - Dart Frog backend integration

## Contributing

We welcome contributions! Please see our [Contributing Guide](https://github.com/chornthorn/nest-dart/blob/main/CONTRIBUTING.md) for details.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.