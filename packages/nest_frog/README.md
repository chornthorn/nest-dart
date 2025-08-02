# nest_frog

Dart Frog integration for Nest Dart - bringing dependency injection and modular architecture to Dart Frog backend applications.

## Features

- 🐸 **Dart Frog Integration** - Seamless middleware integration
- 🔄 **Request Context** - Service resolution from request context
- 🎯 **Unified API** - Clean Modular API for backend services
- ⚡ **Performance** - Minimal overhead with efficient service resolution
- 🧪 **Testing Support** - Easy mocking and testing utilities

## Installation

Add `nest_frog` to your `pubspec.yaml`:

```yaml
dependencies:
  nest_frog: ^0.1.2
  dart_frog: ^1.1.0
```

## Quick Start

### 1. Create Your Modules

```dart
import 'package:nest_frog/nest_frog.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [CoreModule(), UserModule()];
  
  @override
  void providers(Locator locator) {
    // App-level services
  }
}
```

### 2. Set Up Middleware

```dart
// routes/_middleware.dart
import 'package:dart_frog/dart_frog.dart';
import 'package:nest_frog/nest_frog.dart';
import 'package:your_app/app_module.dart';

Handler middleware(Handler handler) {
  return handler.use(nestFrogMiddleware(AppModule()));
}
```

### 3. Use Services in Routes

```dart
// routes/users/index.dart
import 'package:dart_frog/dart_frog.dart';
import 'package:nest_frog/nest_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  final userService = Modular.of(context).get<UserService>();
  
  switch (context.request.method) {
    case HttpMethod.get:
      final users = userService.getAllUsers();
      return Response.json(body: {
        'users': users.map((u) => u.toJson()).toList(),
      });
    case HttpMethod.post:
      final body = await context.request.json();
      final user = userService.createUser(body['name'], body['email']);
      return Response.json(statusCode: 201, body: user.toJson());
    default:
      return Response(statusCode: 405);
  }
}
```

## Service Access Patterns

### Context-Based Access (Recommended)

```dart
Future<Response> onRequest(RequestContext context) async {
  final modular = Modular.of(context);
  final userService = modular.get<UserService>();
  final logger = modular.get<LoggerService>();
  
  logger.log('Processing request');
  // Handle request...
}
```

### Direct Access

```dart
Future<Response> onRequest(RequestContext context) async {
  final configService = Modular.get<ConfigService>();
  final apiKey = configService.apiKey;
  
  // Use global configuration...
}
```

## Complete Example

### Services

```dart
class UserService {
  final UserRepository _repository;
  final LoggerService _logger;
  
  UserService(this._repository, this._logger);
  
  List<User> getAllUsers() {
    _logger.log('Getting all users');
    return _repository.findAll();
  }
  
  User createUser(String name, String email) {
    _logger.log('Creating user: $name');
    return _repository.create(name, email);
  }
}
```

### Module Configuration

```dart
class UserModule extends Module {
  @override
  List<Module> get imports => [CoreModule(), DatabaseModule()];
  
  @override
  void providers(Locator locator) {
    locator.registerSingleton<UserRepository>(
      UserRepository(locator.get<DatabaseService>()),
    );
    
    locator.registerSingleton<UserService>(
      UserService(
        locator.get<UserRepository>(),
        locator.get<LoggerService>(),
      ),
    );
  }
  
  @override
  List<Type> get exports => [UserService];
}
```

### Route Handlers

```dart
Future<Response> onRequest(RequestContext context) async {
  final userService = Modular.of(context).get<UserService>();
  
  try {
    switch (context.request.method) {
      case HttpMethod.get:
        return _getUsers(userService);
      case HttpMethod.post:
        return await _createUser(context, userService);
      default:
        return Response(statusCode: 405);
    }
  } catch (e) {
    return Response.json(
      statusCode: 500,
      body: {'error': 'Internal server error'},
    );
  }
}

Response _getUsers(UserService userService) {
  final users = userService.getAllUsers();
  return Response.json(body: {
    'users': users.map((u) => u.toJson()).toList(),
    'count': users.length,
  });
}
```

## Advanced Features

### Middleware Integration

```dart
Middleware authMiddleware() {
  return (handler) {
    return (context) async {
      final authService = Modular.get<AuthService>();
      final token = context.request.headers['authorization'];
      
      if (!authService.validateToken(token)) {
        return Response.json(
          statusCode: 401,
          body: {'error': 'Unauthorized'},
        );
      }
      
      return handler(context);
    };
  };
}
```

### Error Handling

```dart
class ApiResponse {
  static Response success(Map<String, dynamic> data) {
    return Response.json(body: {
      'success': true,
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  static Response error(String message, {int statusCode = 400}) {
    return Response.json(
      statusCode: statusCode,
      body: {
        'success': false,
        'error': message,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }
}
```

## Testing

Test your routes with mock services:

```dart
import 'package:test/test.dart';
import 'package:dart_frog/dart_frog.dart';

void main() {
  group('User API', () {
    test('GET /users returns users', () async {
      // Initialize with test module
      await Modular.initialize(TestModule());
      
      final request = Request.get(Uri.parse('/users'));
      final context = RequestContext(request: request);
      
      final response = await onRequest(context);
      
      expect(response.statusCode, equals(200));
      // Additional assertions...
    });
  });
}

class TestModule extends Module {
  @override
  void providers(Locator locator) {
    locator.registerSingleton<UserService>(MockUserService());
  }
}
```

## Performance Tips

- Use lazy singletons for expensive services
- Implement proper service disposal
- Cache frequently accessed services
- Use request-scoped services when appropriate

## Documentation

- [Dart Frog Integration Guide](https://chornthorn.github.io/nest-dart/frog-guide)
- [API Reference](https://chornthorn.github.io/nest-dart/api-reference)
- [Examples](https://chornthorn.github.io/nest-dart/examples)

## Related Packages

- **[nest_core](https://pub.dev/packages/nest_core)** - Core dependency injection system
- **[nest_flutter](https://pub.dev/packages/nest_flutter)** - Flutter integration
- **[dart_frog](https://pub.dev/packages/dart_frog)** - Fast, minimalistic backend framework

## Contributing

We welcome contributions! Please see our [Contributing Guide](https://github.com/chornthorn/nest-dart/blob/main/CONTRIBUTING.md) for details.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.