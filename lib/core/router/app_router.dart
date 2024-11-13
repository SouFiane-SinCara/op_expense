import 'package:flutter/material.dart';
import 'package:op_expense/core/router/routes_name.dart';
import 'package:op_expense/features/Onboarding/presentation/screens/onboarding_screen.dart';

class RouterApp {
  Route<dynamic>? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case RoutesName.onboardingScreenName:
        return MaterialPageRoute(
          builder: (context) => OnboardingScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(),
        );
    }
  }
}
