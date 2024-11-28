import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:op_expense/core/router/routes_name.dart';
import 'package:op_expense/core/services/dependency_injection.dart';
import 'package:op_expense/features/Authentication/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:op_expense/features/Authentication/presentation/screens/login_screen.dart';
import 'package:op_expense/core/widgets/onboarding_screen.dart';
import 'package:op_expense/features/Authentication/presentation/screens/signup_screen.dart';
import 'package:op_expense/features/Authentication/presentation/screens/verification_screen.dart';
import 'package:op_expense/features/main/presentation/screens/home_screen.dart';

class RouterApp {
  Route<dynamic>? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case RoutesName.onboardingScreenName:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => sl<LoginCubit>()..getLoggedInAccount(),
            child: OnboardingScreen(),
          ),
        );
      case RoutesName.signUpScreenName:
        return MaterialPageRoute(
          builder: (context) => const SignupScreen(),
        );
      case RoutesName.loginScreenName:
        return MaterialPageRoute(
          builder: (context) => LoginScreen(),
        );
      case RoutesName.verificationScreenName:
        return MaterialPageRoute(
          builder: (context) => const VerificationScreen(),
        );
      case RoutesName.homeScreenName:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(),
        );
    }
  }
}
