import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:op_expense/core/router/app_router.dart';
import 'package:op_expense/core/services/dependency_injection.dart';

Future<void> main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Initialize GetIt
  setup();
  // initialize hive for local storage
  await Hive.initFlutter();
  // open account box
  await Hive.openBox('account');
  // Run the app
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
