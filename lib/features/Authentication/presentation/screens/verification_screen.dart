import 'package:flutter/material.dart';
import 'package:op_expense/features/Authentication/data/data_sources/auth_local_data_source.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
            onTap: () {
              AuthLocalDataSourceImpl().deleteAccount();
            },
            child: Text('Verification Screen')),
      ),
    );
  }
}
