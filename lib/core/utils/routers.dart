import 'package:flutter/material.dart';
import 'package:vital_application/features/home/home_page.dart';
import 'package:vital_application/features/splash/splash_page.dart';

abstract class AppRoutes {
  static const String home = '/home';
  static const String splash = '/splash';
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(body: Center(child: Text('Erro'))),
        );
    }
  }
}
