import 'package:dart_frog/dart_frog.dart';
import 'package:my_project/app_module.dart';
import 'package:nest_frog/nest_frog.dart';

final message = 'Welcome to Dart Frog with NestJS-like Modules!';

Handler middleware(Handler handler) {
  if (!Modular.isInitialized) {
    Modular.initialize(AppModule());
  }

  return handler
      .use(nestFrogMiddleware(AppModule()))
      .use(provider<String>((context) => message));
}
