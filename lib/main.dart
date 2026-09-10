import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:veenuscashbook/splash.dart';
import 'package:veenuscashbook/utilities/apiconstant.dart';
import 'package:upgrader/upgrader.dart';

import 'app_theme/app_theme.dart';
import 'app_theme/theme_bloc/theme_bloc.dart';
import 'app_theme/theme_bloc/theme_state.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiConfig.initializeUrl();
  await Upgrader.clearSavedSettings();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp],);

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeBloc(ThemeState(themeData: appThemeData[AppTheme.DeepPurpleAccent])),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: _buildWithTheme,
      ),
    );
  }

  Widget _buildWithTheme(BuildContext context, ThemeState state) {
    return GetMaterialApp(
      title: "Veenus cash book",
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child!,
        );
      },
      theme: state.themeData,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

