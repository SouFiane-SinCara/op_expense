import 'package:flutter/material.dart';
import 'package:op_expense/core/widgets/my_app_bar.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        title: 'Login',
        context: context,
      ),
    );
  }
}
