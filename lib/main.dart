import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:op_expense/core/router/app_router.dart';
import 'package:op_expense/core/services/dependency_injection.dart';
import 'package:op_expense/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setup();
  runApp(const OpExpenseApp());
}

class OpExpenseApp extends StatelessWidget {
  const OpExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      child: MaterialApp(
        onGenerateRoute: RouterApp().onGenerateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
