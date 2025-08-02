import 'package:flutter/material.dart';
import 'package:nest_core/nest_core.dart';
import 'package:nest_flutter/nest_flutter.dart';

// Simple data service
class UserService {
  final List<String> _users = ['Alice', 'Bob', 'Charlie', 'Diana'];

  List<String> getAllUsers() => List.from(_users);

  void addUser(String name) {
    _users.add(name);
  }
}

// Simple counter service
class CounterService {
  int _count = 0;

  int get count => _count;

  void increment() => _count++;
  void decrement() => _count--;
  void reset() => _count = 0;
}

// App configuration
class AppConfig {
  final String appName;
  final String version;

  const AppConfig({required this.appName, required this.version});
}

// Services module
class ServicesModule extends Module {
  @override
  void providers(Locator locator) {
    locator.registerSingleton<UserService>(UserService());
    locator.registerSingleton<CounterService>(CounterService());
  }

  @override
  List<Type> get exports => [CounterService];
}

// Config module
class ConfigModule extends Module {
  @override
  void providers(Locator locator) {
    locator.registerSingleton<AppConfig>(
      const AppConfig(appName: 'My App', version: '1.0.0'),
    );
  }

  @override
  List<Type> get exports => [AppConfig];
}

class FeatureAService {
  final String message;
  final CounterService counterService;
  final AppConfig appConfig;

  FeatureAService({
    required this.message,
    required this.counterService,
    required this.appConfig,
  });

  int get count => counterService.count;

  void increment() {
    counterService.increment();
  }

  void decrement() {
    counterService.decrement();
  }

  void reset() {
    counterService.reset();
  }

  String get appName => appConfig.appName;
}

class FeatureAModule extends Module {
  @override
  List<Module> get imports => [ServicesModule(), ConfigModule()];

  @override
  void providers(Locator locator) {
    locator.registerSingleton<FeatureAService>(
      FeatureAService(
        message: 'Feature A',
        counterService: locator.get<CounterService>(),
        appConfig: locator.get<AppConfig>(),
      ),
    );
  }
}

// Main app module
class AppModule extends Module {
  @override
  List<Module> get imports => [
    ServicesModule(),
    ConfigModule(),
    FeatureAModule(),
  ];

  @override
  void providers(Locator _) {}
}

void main() {
  runApp(ModularApp(module: AppModule(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final config = Modular.get<AppConfig>();
    return MaterialApp(
      title: config.appName,
      theme: ThemeData(primarySwatch: Colors.blue),
      // home: const HomePage(),
      home: const FeatureAWidget(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();

  // Get services using the clean Modular API
  UserService get _userService => Modular.get<UserService>();
  CounterService get _counterService => Modular.get<CounterService>();
  AppConfig get _config => Modular.get<AppConfig>();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_config.appName} v${_config.version}'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Counter Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Counter Service Demo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Count: ${_counterService.count}',
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _counterService.decrement();
                            });
                          },
                          child: const Text('-'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _counterService.reset();
                            });
                          },
                          child: const Text('Reset'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _counterService.increment();
                            });
                          },
                          child: const Text('+'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // User Service Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'User Service Demo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Enter name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            if (_nameController.text.isNotEmpty) {
                              setState(() {
                                _userService.addUser(_nameController.text);
                                _nameController.clear();
                              });
                            }
                          },
                          child: const Text('Add'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Users:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

            // Users List
            Expanded(
              child: Card(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _userService.getAllUsers().length,
                  itemBuilder: (context, index) {
                    final users = _userService.getAllUsers();
                    return ListTile(
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text(users[index]),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureAWidget extends StatefulWidget {
  const FeatureAWidget({super.key});

  @override
  State<FeatureAWidget> createState() => _FeatureAWidgetState();
}

class _FeatureAWidgetState extends State<FeatureAWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Modular.get<FeatureAService>().appName)),
      body: Center(
        child: Column(
          children: [
            Text('Message: ${Modular.get<FeatureAService>().message}'),

            Text('Count: ${Modular.get<FeatureAService>().count}'),
          ],
        ),
      ),
      floatingActionButton: Row(
        children: [
          FloatingActionButton(
            onPressed: () {
              Modular.get<FeatureAService>().increment();
              setState(() {});
            },
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: () {
              Modular.get<FeatureAService>().decrement();
              setState(() {});
            },
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
