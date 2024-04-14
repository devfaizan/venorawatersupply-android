import 'package:flutter/material.dart';
import 'package:venorawatersupply/screens/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 46, 49, 146),
      ),
      title: "Venora Water Supply",
      home: SplashScreen(),
    );
  }
}
