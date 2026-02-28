import 'package:flutter/material.dart';
import '../views/home/home_screen.dart';

class AppRoutes extends StatelessWidget {
  const AppRoutes({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: '/home',

      routes: {
        '/home': (_) => const HomeScreen(),
      },
    );
  }
}