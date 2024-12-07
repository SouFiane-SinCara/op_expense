import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:op_expense/core/services/dependency_injection.dart';
import 'package:op_expense/core/widgets/my_app_bar.dart';
import 'package:op_expense/features/Authentication/domain/entities/account.dart';
import 'package:op_expense/features/Authentication/presentation/cubits/authentication_cubit/authentication_cubit.dart';
import 'package:op_expense/features/Authentication/presentation/cubits/sign_out_cubit/sign_out_cubit.dart';
import 'package:op_expense/features/main/presentation/cubits/payment_sources_cubit/payment_sources_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Account account =
        BlocProvider.of<AuthenticationCubit>(context).getAuthenticatedAccount();

    return BlocProvider(
      create: (context) =>
          sl<PaymentSourcesCubit>()..getPaymentSources(account: account),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.red,
          appBar: myAppBar(title: 'Home Screen', context: context),
          body: Center(
            child: GestureDetector(
              onTap: () {
                sl<SignOutCubit>().signOut();
              },
              child: const Text(
                'Home Screen',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
