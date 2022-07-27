import 'package:advanced_app/app/di.dart';
import 'package:flutter/material.dart';

import '../forget_password/view/forget_password_view.dart';
import '../login/view/login_view.dart';
import '../main/main_view.dart';
import '../onboarding/view/onboarding_view.dart';
import '../register/view/register_view.dart';
import '../splash/splash_view.dart';
import '../store_details/store_details_view.dart';
import 'strings_manager.dart';

class Routes {
  static const String splashRoute = "/";
  static const String loginRoute = "/login";
  static const String onBoardingRoute = "/onBoarding";
  static const String registerRoute = "/register";
  static const String forgetPasswordRoute = "/forgetPassword";
  static const String mainRoute = "/main";
  static const String storeDetailsRoute = "/storeDetails";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(
            settings: settings, builder: ((_) => const SplashView()));
      case Routes.loginRoute:
        initLoginModule();
        return MaterialPageRoute(
            settings: settings, builder: ((_) => const LoginView()));
      case Routes.onBoardingRoute:
        return MaterialPageRoute(
            settings: settings, builder: ((_) => const OnBoardingView()));
      case Routes.registerRoute:
        initRegisterModule();
        return MaterialPageRoute(
            settings: settings, builder: ((_) => const RegisterView()));
      case Routes.forgetPasswordRoute:
        initForgetPasswordModule();
        return MaterialPageRoute(
            settings: settings, builder: ((_) => const ForgetPasswordView()));
      case Routes.mainRoute:
        initHomeModule();
        return MaterialPageRoute(
            settings: settings, builder: ((_) => const MainView()));
      case Routes.storeDetailsRoute:
        return MaterialPageRoute(
            settings: settings, builder: ((_) => const StoreDetailsView()));
      default:
        return undefinedRoute();
    }
  }

  static Route<dynamic> undefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text(AppStrings.noRouteFound), // appBar
              ),
              body: const Center(
                child: Text(AppStrings.noRouteFound),
              ),
            ));
  }
}
