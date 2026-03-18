import 'package:flutter/material.dart';
import 'package:vital_application/core/utils/routers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //tirar o banner de debug
      initialRoute: AppRoutes.splash,

      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
