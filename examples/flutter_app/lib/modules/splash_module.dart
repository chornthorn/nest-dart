import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nest_flutter/nest_flutter.dart';

class SplashModule extends Module {
  @override
  List<RouteBase> get routes => [
    GoRoute(path: '/', builder: (context, state) => const SplashView()),
  ];
}

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
