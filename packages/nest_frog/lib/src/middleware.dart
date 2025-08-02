import 'package:dart_frog/dart_frog.dart';
import 'package:nest_core/nest_core.dart';
import 'nest_frog.dart';

/// Create NestFrog middleware for Dart Frog
/// This middleware initializes the container and provides dependency injection
Middleware nestFrogMiddleware(Module appModule) {
  return (handler) {
    return (context) async {
      // Initialize container if not already done
      if (!Modular.isInitialized) {
        await Modular.initialize(appModule);
      }

      return handler(context);
    };
  };
}
