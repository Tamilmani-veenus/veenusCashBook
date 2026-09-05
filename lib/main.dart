import 'package:flutter/material.dart';
import 'package:veenuscashbook/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Veenus Cash Book',
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

