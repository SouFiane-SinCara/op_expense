// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:op_expense/core/helpers/sized_boxes.dart';
import 'package:op_expense/core/router/routes_name.dart';
import 'package:op_expense/core/services/dependency_injection.dart';
import 'package:op_expense/core/theme/app_colors.dart';
import 'package:op_expense/core/theme/text_styles.dart';
import 'package:op_expense/core/widgets/app_loading.dart';
import 'package:op_expense/core/widgets/app_text_form_field.dart';
import 'package:op_expense/core/widgets/my_app_bar.dart';
import 'package:op_expense/core/widgets/primary_button.dart';
import 'package:op_expense/features/Authentication/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:op_expense/features/Authentication/presentation/widgets/auth_error_widget.dart';
import 'package:op_expense/features/main/domain/entities/payment_source.dart';
import 'package:op_expense/features/main/presentation/cubits/payment_sources_cubit/payment_sources_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailTextEditingController;

  late TextEditingController _passwordTextEditingController;
  @override
  void initState() {
    super.initState();
    _emailTextEditingController = TextEditingController();
    _passwordTextEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LoginCubit>(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.light,
          appBar: myAppBar(
            title: 'Login',
            context: context,
          ),
          body: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) async {
              if (state is LoginSuccessState) {
                if (state.account.isVerified) {
                  List<PaymentSource> paymentSources =
                      await BlocProvider.of<PaymentSourcesCubit>(context)
                          .getPaymentSources(account: state.account);
                  if (paymentSources.isEmpty) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      RoutesName.setupWalletScreenName,
                      (route) => false, 
                    );
                  } else {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      RoutesName.homeScreenName,
                      (route) => false,
                    );
                  }
                } else {
                  Navigator.pushReplacementNamed(
                    context,
                    RoutesName.verificationScreenName,
                  );
                }
              }
            },
            builder: (context, state) {
              switch (state) {
                case LoginLoadingState():
                  return const AppLoading();
                default:
                  return SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      height: ScreenUtil().screenHeight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          heightSizedBox(140),
                          //!-------- error message ------------
                          if (state is LoginFailureState)
                            Column(
                              children: [
                                AuthErrorWidget(
                                  message: state.message,
                                ),
                                heightSizedBox(30),
                              ],
                            ),
                          //!--------- Login Form ------------
                          AppTextFormField(
                              textInputAction: TextInputAction.next,
                              hintText: 'Email',
                              controller: _emailTextEditingController),
                          heightSizedBox(24),
                          //!--------- Password Form ------------
                          AppTextFormField(
                              secureTextFormField: true,
                              textInputAction: TextInputAction.done,
                              hintText: 'Password',
                              controller: _passwordTextEditingController),
                          heightSizedBox(40),
                          //!--------- Login Button ------------
                          PrimaryButton(
                            text: 'Login',
                            onPressed: () {
                              BlocProvider.of<LoginCubit>(context).login(
                                email: _emailTextEditingController.text,
                                password: _passwordTextEditingController.text,
                              );
                            },
                          ),
                          heightSizedBox(33),
                          //!--------- Forgot Password ------------
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, RoutesName.forgotPasswordScreenName);
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyles.w600Violet100.copyWith(
                                fontSize: 18.sp,
                              ),
                            ),
                          ),
                          //!--------- Don't have an account yet? Sign up------------
                          heightSizedBox(40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don\'t have an account yet? ',
                                style: TextStyles.w500Light20
                                    .copyWith(fontSize: 16.sp),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                      context, RoutesName.signUpScreenName);
                                },
                                child: Text(
                                  'Sign up',
                                  style: TextStyles.w500Violet100.copyWith(
                                      fontSize: 16.sp,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}
