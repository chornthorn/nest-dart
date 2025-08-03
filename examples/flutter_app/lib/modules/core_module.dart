import 'package:flutter_app/utils/config_preference.dart';
import 'package:nest_flutter/nest_flutter.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
