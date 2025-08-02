import 'package:nest_core/nest_core.dart';

class ConfigService {
  final Map<String, dynamic> _config = {
    'database_type': 'in-memory',
    'port': 8080,
    'environment': 'development',
    'jwt_secret': 'your-secret-key',
    'app_name': 'Dart Frog Demo API',
    'version': '1.0.0',
  };

  T get<T>(String key) {
    return _config[key] as T;
  }

  String get databaseType => get<String>('database_type');
  int get port => get<int>('port');
  String get environment => get<String>('environment');
  String get jwtSecret => get<String>('jwt_secret');
  String get appName => get<String>('app_name');
  String get version => get<String>('version');
}

class LoggerService {
  void log(String message) {
    print('[LOG] ${DateTime.now()}: $message');
  }

  void error(String message) {
    print('[ERROR] ${DateTime.now()}: $message');
  }
}

class CoreModule extends Module {
  @override
  Future<void> providers(Locator locator) async {
    locator.registerSingleton<ConfigService>(ConfigService());
    locator.registerSingleton<LoggerService>(LoggerService());
  }

  @override
  List<Type> get exports => [ConfigService, LoggerService];
}
