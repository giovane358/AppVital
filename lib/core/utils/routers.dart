import 'package:flutter/material.dart';
import 'package:vital_application/features/auth/auth_page.dart';
import 'package:vital_application/features/home/home_page.dart';
import 'package:vital_application/features/recp/recover_page.dart';
import 'package:vital_application/features/splash/splash_page.dart';

abstract class AppRoutes {
  static const String home = '/home';
  static const String splash = '/splash';
  static const String login = '/login';
  static const String recp = '/recp';
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case AppRoutes.recp:
        return MaterialPageRoute(builder: (_) => RecoverPage());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(body: Center(child: Text('Erro'))),
        );
    }
  }
}
