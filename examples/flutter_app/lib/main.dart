import 'package:flutter/material.dart';
import 'package:nest_flutter/nest_flutter.dart';
import 'package:provider/provider.dart' hide Locator;
import 'package:shared_preferences/shared_preferences.dart';
import 'services/todo_service.dart';
import 'providers/todo_provider.dart';
import 'views/todo_list_view.dart';
import 'utils/config_preference.dart';
import 'package:http/http.dart' show Client;

class CoreModule extends Module {
  @override
  Future<void> providers(Locator locator) async {
    locator.registerSingleton<Client>(Client());
    final prefs = await SharedPreferences.getInstance();
    locator.registerSingleton<SharedPreferences>(prefs);
    locator.registerSingleton<ConfigPreference>(ConfigPreference(prefs));
  }

  @override
  List<Type> get exports => [Client, SharedPreferences, ConfigPreference];
}

class TodoModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  Future<void> providers(Locator locator) async {
    locator.registerSingleton<TodoService>(
      JsonPlaceholderTodoService(client: locator.get<Client>()),
    );
    locator.registerSingleton<TodoProvider>(
      TodoProvider(locator.get<TodoService>(), locator.get<ConfigPreference>()),
    );

    locator.registerSingleton<ServiceDemo>(
      ServiceDemo(locator.get<SharedPreferences>()),
    );
  }

  @override
  List<Type> get exports => [TodoService, TodoProvider];
}

class ServiceDemo {
  final SharedPreferences prefs;

  ServiceDemo(this.prefs);
}

class AppModule extends Module {
  @override
  List<Module> get imports => [CoreModule(), TodoModule()];

  @override
  Future<void> providers(Locator _) async {}
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ModularApp(
      module: AppModule(),
      loading: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Modular.get<TodoProvider>(),
      child: MaterialApp(
        title: 'Todo App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const TodoListView(),
      ),
    );
  }
}
