import 'package:flutter/material.dart';
import 'package:flutter_app/modules/splash_module.dart';
import 'package:flutter_app/modules/todo_module.dart';
import 'package:nest_flutter/nest_flutter.dart';
import 'package:provider/provider.dart' hide Locator;
import 'package:go_router/go_router.dart';
import 'providers/todo_provider.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [
    SplashModule(),
    TodoModule(),
    ModuleA(),
    ModuleB(),
  ];

  @override
  Future<void> providers(Locator _) async {}
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ModularApp(module: AppModule(), child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Modular.get<TodoProvider>(),
      child: MaterialApp.router(
        routerConfig: Modular.router((router) {
          return GoRouter(
            routes: router.configuration.routes,
            initialLocation: '/todos',
            debugLogDiagnostics: true,
          );
        }),
      ),
    );
  }
}
