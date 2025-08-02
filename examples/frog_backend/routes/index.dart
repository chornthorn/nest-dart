import 'package:dart_frog/dart_frog.dart';
import 'package:my_project/modules/core_module.dart';
import 'package:nest_frog/nest_frog.dart';

Response onRequest(RequestContext context) {
  // Using the new Modular.of(context) API
  final modular = Modular.of(context);
  final welcomeMessage = modular.get<String>();
  final logger = modular.get<LoggerService>();
  final config = modular.get<ConfigService>();

  logger.log('Index route accessed');

  final response = {
    'message': welcomeMessage,
    'app_name': config.appName,
    'version': config.version,
    'environment': config.environment,
    'database_type': config.databaseType,
    'port': config.port,
    'timestamp': DateTime.now().toIso8601String(),
  };

  return Response.json(body: response);
}
