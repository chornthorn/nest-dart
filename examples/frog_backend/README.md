# Dart Frog + NestJS-like Module System

This project demonstrates how to integrate a NestJS-like module system with Dart Frog for building scalable backend applications.

## Features

- 🏗️ **Modular Architecture**: Organize code into reusable modules
- 💉 **Dependency Injection**: Type-safe service resolution
- 🔧 **Configuration Management**: Centralized app configuration
- 📝 **Logging**: Built-in logging service
- 🗄️ **Database Integration**: Database service with connection management
- 🔒 **Encapsulation**: Services are private by default, must be explicitly exported

## Project Structure

```
my_project/
├── lib/
│   └── app_module.dart          # Main module definitions and DI container
├── routes/
│   ├── _middleware.dart         # Global middleware setup
│   ├── index.dart              # Root endpoint
│   └── users/
│       ├── index.dart          # GET /users
│       └── [id].dart           # GET /users/:id
└── test_container.dart         # Test script
```

## Module System

### Core Services

- **ConfigService**: Application configuration management
- **LoggerService**: Logging functionality
- **DatabaseService**: Database connection and query execution

### Domain Services

- **UserRepository**: Data access layer for users
- **UserService**: Business logic for user operations

### Module Hierarchy

```
AppModule
├── CoreModule (exports: ConfigService, LoggerService, DatabaseService)
└── UserModule (exports: UserService, UserRepository)
    └── imports: CoreModule
```

## Usage

### 1. Running the Test

```bash
dart my_project/test_container.dart
```

### 2. Starting the Server

```bash
cd my_project
dart_frog dev
```

### 3. API Endpoints

- `GET /` - Welcome message with app info
- `GET /users` - List all users
- `GET /users/:id` - Get user by ID

### 4. Example Responses

**GET /**
```json
{
  "message": "Welcome to Dart Frog with NestJS-like Modules!",
  "environment": "development",
  "port": 8080,
  "timestamp": "2024-01-01T12:00:00.000Z"
}
```

**GET /users**
```json
{
  "users": [
    {
      "id": 1,
      "name": "Sample Data",
      "email": "Sample Data@example.com"
    }
  ],
  "count": 1,
  "timestamp": "2024-01-01T12:00:00.000Z"
}
```

## How It Works

### 1. Module Definition

```dart
class UserModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];
  
  @override
  void providers(Locator locator) {
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

### 2. Dart Frog Integration

```dart
Handler middleware(Handler handler) {
  return handler.use(appMiddleware);
}
```

### 3. Service Resolution in Routes

```dart
Response onRequest(RequestContext context) {
  final userService = context.read<UserService>();
  final logger = context.read<LoggerService>();
  
  // Use services...
}
```

## Benefits

1. **Modularity**: Code is organized into logical modules
2. **Testability**: Easy to mock dependencies for testing
3. **Scalability**: Add new modules without affecting existing code
4. **Type Safety**: Full compile-time type checking
5. **Encapsulation**: Services are only accessible where explicitly imported
6. **Dart Frog Integration**: Seamless integration with Dart Frog's middleware system

## Architecture Principles

- **Single Responsibility**: Each service has a single, well-defined purpose
- **Dependency Inversion**: Depend on abstractions, not concretions
- **Explicit Dependencies**: All dependencies are explicitly declared
- **Module Boundaries**: Clear separation between different domains
- **Export Control**: Only explicitly exported services are accessible

This system provides the structure and benefits of NestJS modules while remaining lightweight and Dart-native.