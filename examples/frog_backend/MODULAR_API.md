# Unified Modular API for Dart Frog

## Overview

We've successfully consolidated the `FrogContainer` and `Modular` classes into a single, unified `Modular` class that provides both container management and context-based service access.

## API Usage

### 1. Container Management

```dart
// Initialize the application container
Modular.initialize();

// Direct service access (anywhere in the app)
final userService = Modular.get<UserService>();
final config = Modular.get<ConfigService>();

// Check if initialized
if (Modular.isInitialized) {
  // Container is ready
}

// Reset for testing
Modular.reset();
```

### 2. Context-Based Access (Dart Frog Routes)

```dart
Response onRequest(RequestContext context) {
  // Flutter-style API with context
  final modular = Modular.of(context);
  final userService = modular.get<UserService>();
  final logger = modular.get<LoggerService>();
  
  // Use services...
  logger.log('Route accessed');
  final users = userService.getAllUsers();
  
  return Response.json(body: users);
}
```

### 3. Available Methods

#### Static Methods (Container Management)
- `Modular.initialize()` - Initialize the container with modules
- `Modular.get<T>()` - Get service directly from container
- `Modular.container` - Get the ApplicationContainer instance
- `Modular.isInitialized` - Check if container is initialized
- `Modular.reset()` - Reset container (useful for testing)

#### Context Methods (Request-Scoped)
- `Modular.of(context)` - Get ModularContext from RequestContext
- `modular.get<T>()` - Get service from request context (with fallback)
- `modular.has<T>()` - Check if service is available in context
- `modular.context` - Get the underlying RequestContext

## Benefits

✅ **Single Class**: No more confusion between `FrogContainer` and `Modular`
✅ **Consistent API**: Same naming conventions throughout
✅ **Flutter-Style**: Familiar `Modular.of(context)` pattern
✅ **Fallback Support**: Context access falls back to container if needed
✅ **Testing Support**: Easy reset functionality
✅ **Type Safety**: Full type safety with generics

## Usage Examples

### In Routes
```dart
// Before
final userService = context.read<UserService>();

// After (Option 1: Context-based)
final userService = Modular.of(context).get<UserService>();

// After (Option 2: Direct)
final userService = Modular.get<UserService>();
```

### In Middleware
```dart
Handler middleware(Handler handler) {
  // Initialize once
  Modular.initialize();
  
  return handler
    .use(provider<UserService>((context) => Modular.get<UserService>()))
    .use(provider<String>((context) => 'Welcome!'));
}
```

### In Tests/Scripts
```dart
void main() {
  // Initialize
  Modular.initialize();
  
  // Use services
  final config = Modular.get<ConfigService>();
  final userService = Modular.get<UserService>();
  
  // Test functionality...
}
```

## Migration Guide

1. Replace `FrogContainer.initialize()` with `Modular.initialize()`
2. Replace `FrogContainer.get<T>()` with `Modular.get<T>()`
3. Replace `FrogContainer.container` with `Modular.container`
4. Use `Modular.of(context).get<T>()` for request-scoped access

The unified `Modular` class provides a clean, consistent API that combines the best of both worlds: direct container access when needed, and Flutter-style context-based access for request handling.