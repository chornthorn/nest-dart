import 'package:flutter/widgets.dart';
import 'package:flutter_app/modules/core_module.dart';
import 'package:flutter_app/services/todo_service.dart';
import 'package:flutter_app/providers/todo_provider.dart';
import 'package:flutter_app/utils/config_preference.dart';
import 'package:flutter_app/views/todo_list_view.dart';
import 'package:flutter_app/views/todo_detail_view.dart';
import 'package:nest_flutter/nest_flutter.dart';
import 'package:http/http.dart';

class ModuleB extends Module {
  @override
  String? get routePrefix => '/module-b';

  @override
  List<RouteBase> get routes => [
    GoRoute(
      path: '/',
      builder: (context, state) => const Placeholder(),
      routes: [
        GoRoute(
          path: 'second',
          builder: (context, state) => const Placeholder(),
        ),
      ],
    ),
  ];
}

class ModuleA extends Module {
  @override
  String? get routePrefix => '/module-a';

  @override
  List<RouteBase> get routes => [
    GoRoute(path: '/', builder: (context, state) => const Placeholder()),
  ];
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
  }

  @override
  List<Type> get exports => [TodoService, TodoProvider];

  @override
  String? get routePrefix => '/todos';

  @override
  List<RouteBase> get routes => [
    GoRoute(path: '/', builder: (context, state) => const TodoListView()),
    GoRoute(
      path: '/:id',
      builder: (context, state) => TodoDetailView(
        todoId: int.tryParse(state.pathParameters['id'] ?? '0') ?? 0,
      ),
    ),
    GoRoute(path: '/second', builder: (context, state) => Placeholder()),
  ];
}
