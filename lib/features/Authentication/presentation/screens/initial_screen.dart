import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:op_expense/core/router/routes_name.dart';
import 'package:op_expense/core/theme/app_colors.dart';
import 'package:op_expense/features/Authentication/presentation/cubits/login_cubit/login_cubit.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccessState) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              RoutesName.homeScreenName, (route) => false);
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
              RoutesName.onboardingScreenName, (route) => false);
        }
      },
      child: const SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.light,
        ),
      ),
    );
  }
}
