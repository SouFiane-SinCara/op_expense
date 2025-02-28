import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:op_expense/core/router/app_router.dart';
import 'package:op_expense/core/services/dependency_injection.dart';
import 'package:op_expense/features/AiGuide/presentation/cubits/ai_guide_cubit/ai_guide_cubit.dart';
import 'package:op_expense/features/Authentication/presentation/cubits/authentication_cubit/authentication_cubit.dart';
import 'package:op_expense/features/main/presentation/cubits/payment_sources_cubit/payment_sources_cubit.dart';
import 'package:op_expense/features/main/presentation/cubits/transaction_cubit/transaction_cubit.dart';

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
  runApp(DevicePreview(
      enabled: false, builder: (context) => const OpExpenseApp()));
}

class OpExpenseApp extends StatelessWidget {
  const OpExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    // general providers for the app
    return MultiBlocProvider(
      // authentication cubit provider have signed or logged user account details
      providers: [
        BlocProvider(
          create: (context) => sl<AuthenticationCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<PaymentSourcesCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<TransactionCubit>(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(410, 850),
        minTextAdapt: true,
        child: MaterialApp(
          onGenerateRoute: RouterApp().onGenerateRoute,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
