import 'package:flutter/material.dart';
import 'package:op_expense/core/services/dependency_injection.dart';
import 'package:op_expense/core/widgets/my_app_bar.dart';
import 'package:op_expense/features/Authentication/presentation/cubits/sign_out_cubit/sign_out_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
