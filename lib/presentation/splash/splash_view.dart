import 'dart:async';

import 'package:advanced_app/app/app_prefs.dart';
import 'package:advanced_app/app/di.dart';
import 'package:flutter/material.dart';

import '../resources_data/assets_manager.dart';
import '../resources_data/color_manager.dart';
import '../resources_data/constants_manager.dart';
import '../resources_data/routes_manager.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? _timer;
  final AppPreference _appPreference = instance<AppPreference>();

  _startDelay() {
    _timer = Timer(const Duration(seconds: AppConstants.splashDelay), _goNext);
  }

  _goNext() async {
    _appPreference.isUserLoggedIn().then((isUserLoggedIn) {
      if (isUserLoggedIn) {
        //Navigate to main screen
        Navigator.pushReplacementNamed(context, Routes.mainRoute);
      } else {
        _appPreference
            .isOnBoardingScreenViewed()
            .then((isOnBoardingScreenViewed) {
          if (isOnBoardingScreenViewed) {
            //Navigate to login screen
            Navigator.pushReplacementNamed(context, Routes.loginRoute);
          } else {
            //Navigate to Onboarding screen
            Navigator.pushReplacementNamed(context, Routes.onBoardingRoute);
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      body:
          const Center(child: Image(image: AssetImage(ImageAssets.splashLogo))),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
