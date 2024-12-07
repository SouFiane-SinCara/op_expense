import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:op_expense/core/router/routes_name.dart';
import 'package:op_expense/core/services/dependency_injection.dart';
import 'package:op_expense/features/Authentication/presentation/cubits/check_email_verification_cubit/check_email_verification_cubit.dart';
import 'package:op_expense/features/Authentication/presentation/cubits/forgot_password_cubit/forgot_password_cubit.dart';
import 'package:op_expense/features/Authentication/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:op_expense/features/Authentication/presentation/cubits/send_email_verification_cubit/send_email_verification_cubit.dart';
import 'package:op_expense/features/Authentication/presentation/cubits/sign_out_cubit/sign_out_cubit.dart';
import 'package:op_expense/features/Authentication/presentation/screens/forgot_password_screen.dart';
import 'package:op_expense/features/Authentication/presentation/screens/forgot_password_sent_screen.dart';
import 'package:op_expense/features/Authentication/presentation/screens/login_screen.dart';
import 'package:op_expense/core/widgets/onboarding_screen.dart';
import 'package:op_expense/features/Authentication/presentation/screens/signup_screen.dart';
import 'package:op_expense/features/Authentication/presentation/screens/verification_screen.dart';
import 'package:op_expense/features/main/presentation/cubits/payment_sources_cubit/payment_sources_cubit.dart';
import 'package:op_expense/features/main/presentation/screens/add_new_account_screen.dart';
import 'package:op_expense/features/main/presentation/screens/add_new_account_success_screen.dart';
import 'package:op_expense/features/main/presentation/screens/home_screen.dart';
import 'package:op_expense/features/main/presentation/screens/setup_wallet_screen.dart';

class RouterApp {
  Route<dynamic>? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case RoutesName.onboardingScreenName:
        return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => sl<PaymentSourcesCubit>(),
                    ),
                    BlocProvider(
                      create: (context) =>
                          sl<LoginCubit>()..getLoggedInAccount(),
                    ),
                  ],
                  child: const OnboardingScreen(),
                ));
      case RoutesName.signUpScreenName:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => sl<PaymentSourcesCubit>(),
            child: const SignupScreen(),
          ),
        );
      case RoutesName.loginScreenName:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => sl<PaymentSourcesCubit>(),
            child: const LoginScreen(),
          ),
        );
      case RoutesName.verificationScreenName:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => sl<SignOutCubit>(),
              ),
              BlocProvider(
                create: (context) => sl<CheckEmailVerificationCubit>(),
              ),
              BlocProvider(
                create: (context) =>
                    sl<SendEmailVerificationCubit>()..sendEmailVerification(),
              ),
            ],
            child: const VerificationScreen(),
          ),
        );
      case RoutesName.homeScreenName:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
      case RoutesName.forgotPasswordScreenName:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => sl<ForgotPasswordCubit>(),
            child: ForgotPasswordScreen(),
          ),
        );
      case RoutesName.forgetPasswordSentScreenName:
        return MaterialPageRoute(
          builder: (context) => ForgotPasswordSentScreen(
            email: routeSettings.arguments as String,
          ),
        );
      case RoutesName.setupWalletScreenName:
        return MaterialPageRoute(
            builder: (context) => const SetupWalletScreen());
      case RoutesName.addNewAccountScreenName:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => sl<PaymentSourcesCubit>(),
                  child: const AddNewAccountScreen(),
                ));
      case RoutesName.addNewAccountSuccessScreenName:
        return MaterialPageRoute(
          builder: (context) => const AddNewAccountSuccessScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(),
        );
    }
  }
}
