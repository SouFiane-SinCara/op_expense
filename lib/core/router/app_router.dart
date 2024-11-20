import 'package:flutter/material.dart';
import 'package:op_expense/core/router/routes_name.dart';
import 'package:op_expense/features/Login/presentation/screens/login_screen.dart';
import 'package:op_expense/features/Onboarding/presentation/screens/onboarding_screen.dart';
import 'package:op_expense/features/SignUp/presentation/screens/signup_screen.dart';
import 'package:op_expense/features/SignUp/presentation/screens/verification_screen.dart';

class RouterApp {
  Route<dynamic>? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case RoutesName.onboardingScreenName:
        return MaterialPageRoute(
          builder: (context) => OnboardingScreen(),
        );
      case RoutesName.signUpScreenName:
        return MaterialPageRoute(
          builder: (context) => const SignupScreen(),
        );
      case RoutesName.loginScreenName:
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );
      case RoutesName.verificationScreenName:
        return MaterialPageRoute(
          builder: (context) => const VerificationScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(),
        );
    }
  }
}
