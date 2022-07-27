import 'package:advanced_app/app/di.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initAppModule(); // this function for call dependency injection
  runApp(MyApp());
}
