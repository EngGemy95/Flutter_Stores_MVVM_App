import 'package:advanced_app/presentation/resources_data/routes_manager.dart';
import 'package:flutter/material.dart';

import '../presentation/resources_data/theme_manager.dart';

class MyApp extends StatefulWidget {
  //const MyApp({Key? key}) : super(key: key); // default constructor

  int appState = 0;

  //Named Constructor
  MyApp._internal();
  static final MyApp _instance =
      MyApp._internal(); // singelton or single instance

  factory MyApp() => _instance; // factory

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.splashRoute,
      onGenerateRoute: (settings) => RouteGenerator.getRoute(settings),
      theme: getApplicationTheme(),
    );
  }
}
