import 'package:nest_core/nest_core.dart';

import 'database/database_module.dart';
import 'modules/core_module.dart';
import 'modules/user_module.dart';

// Main application module
class AppModule extends Module {
  @override
  List<Module> get imports => [DatabaseModule(), CoreModule(), UserModule()];

  @override
  Future<void> providers(Locator locator) async {}
}
