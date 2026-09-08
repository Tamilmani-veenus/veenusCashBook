import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:veenuscashbook/splash.dart';
import 'package:veenuscashbook/utilities/apiconstant.dart';
import 'package:upgrader/upgrader.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiConfig.initializeUrl();
  await Upgrader.clearSavedSettings();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp],);

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

