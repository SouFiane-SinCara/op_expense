import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:op_expense/core/router/app_router.dart';

void main() {
  runApp(const OpExpenseApp());
}

class OpExpenseApp extends StatelessWidget {
  const OpExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        onGenerateRoute: RouterApp().onGenerateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
