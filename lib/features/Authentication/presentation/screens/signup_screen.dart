// ignore_for_file: use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:op_expense/core/constants/app_constants.dart';
import 'package:op_expense/core/helpers/sized_boxes.dart';
import 'package:op_expense/core/router/routes_name.dart';
import 'package:op_expense/core/services/dependency_injection.dart';
import 'package:op_expense/core/theme/app_colors.dart';
import 'package:op_expense/core/theme/text_styles.dart';
import 'package:op_expense/core/widgets/app_loading.dart';
import 'package:op_expense/core/widgets/app_text_form_field.dart';
import 'package:op_expense/core/widgets/my_app_bar.dart';
import 'package:op_expense/core/widgets/primary_button.dart';
import 'package:op_expense/core/widgets/snack_bars.dart';
import 'package:op_expense/features/Authentication/presentation/cubits/sign_up_cubit/sign_up_cubit.dart';
import 'package:op_expense/features/Authentication/presentation/widgets/auth_error_widget.dart';
import 'package:op_expense/features/main/domain/entities/payment_source.dart';
import 'package:op_expense/features/main/presentation/cubits/payment_sources_cubit/payment_sources_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late TextEditingController _nameTextEditingController;

  late TextEditingController _emailTextEditingController;

  late TextEditingController _passwordTextEditingController;
  @override
  void initState() {
    super.initState();
    _nameTextEditingController = TextEditingController();
    _emailTextEditingController = TextEditingController();
    _passwordTextEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _nameTextEditingController.dispose();
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool termsAccepted = false;
    return BlocProvider(
      create: (context) => sl<SignUpCubit>(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.light,
          appBar: myAppBar(
            title: "Sign Up",
            context: context,
          ),
          body: BlocConsumer<SignUpCubit, SignUpState>(
            listener: (context, state) async {
              print('fError: ${state}');

              if (state is SignUpWithEmailPasswordSuccessState) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RoutesName.verificationScreenName,
                  (route) => false,
                );
              } else if (state is SignUpWithGoogleSuccessState) {
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
              }
            },
            builder: (context, state) {
              switch (state) {
                case SignUpLoadingState():
                  return const AppLoading();
                default:
                  return SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      height: ScreenUtil().screenHeight,
                      width: ScreenUtil().screenWidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          heightSizedBox(40),
                          if (state is SignUpFailureState)
                            Column(
                              children: [
                                AuthErrorWidget(
                                  message: state.message,
                                ),
                                heightSizedBox(10),
                              ],
                            ),

                          //!---------- Name text form field-------------
                          AppTextFormField(
                            hintText: 'Name',
                            controller: _nameTextEditingController,
                            textInputAction: TextInputAction.next,
                          ),
                          heightSizedBox(24),
                          //!---------- Email text form field-------------

                          AppTextFormField(
                            hintText: 'Email',
                            controller: _emailTextEditingController,
                            textInputAction: TextInputAction.next,
                          ),
                          heightSizedBox(24),
                          //!---------- Password text form field-------------

                          AppTextFormField(
                            hintText: 'Password',
                            controller: _passwordTextEditingController,
                            secureTextFormField: true,
                          ),
                          //!----------- Terms and condition checkbox-----------
                          heightSizedBox(17),
                          Row(
                            children: [
                              StatefulBuilder(
                                builder: (BuildContext context, setTermsState) {
                                  return Checkbox(
                                    activeColor: AppColors.violet100,
                                    checkColor: AppColors.light,
                                    side: const BorderSide(
                                        color: AppColors.violet100, width: 2),
                                    value: termsAccepted,
                                    onChanged: (value) {
                                      setTermsState(
                                        () {
                                          termsAccepted = value!;
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                              RichText(
                                text: TextSpan(
                                  text: 'By signing up, you agree to the ',
                                  style: TextStyles.w500Dark
                                      .copyWith(fontSize: 14.sp),
                                  children: [
                                    TextSpan(
                                      text:
                                          'Terms of \nService and Privacy Policy',
                                      style: TextStyles.w500Violet100.copyWith(
                                        fontSize: 14.sp,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          _launchURL(
                                              AppConstants
                                                  .termsAndConditionsWebSiteLink,
                                              context);
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          //!-------- sign up button---------
                          heightSizedBox(27),
                          PrimaryButton(
                            text: "Sign Up",
                            onPressed: () async {
                              BlocProvider.of<SignUpCubit>(context)
                                  .signUpWithEmailPassword(
                                email: _emailTextEditingController.text.trim(),
                                password: _passwordTextEditingController.text,
                                name: _nameTextEditingController.text.trim(),
                                isAcceptedTerms: termsAccepted,
                              );
                            },
                          ),
                          //!-------------- or  with Text-----------
                          heightSizedBox(20),
                          Text(
                            'Or with',
                            style: TextStyles.w700Light20
                                .copyWith(fontSize: 18.sp),
                          ),
                          heightSizedBox(29),
                          //!---------- sign up with google------------
                          GestureDetector(
                            onTap: () {
                              BlocProvider.of<SignUpCubit>(context)
                                  .signUpWithGoogle();
                            },
                            child: SizedBox(
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'lib/core/assets/icons/google_icon.png',
                                    width: 32.w,
                                    height: 32.h,
                                  ),
                                  Text(
                                    "Sign Up with Google",
                                    style: TextStyles.w600Dark50.copyWith(
                                      fontSize: 18.sp,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          //!------------ Already have an account? Login ------------------
                          heightSizedBox(40),
                          RichText(
                            text: TextSpan(
                              text: 'Already have an account? ',
                              style: TextStyles.w500Light20
                                  .copyWith(fontSize: 16.sp),
                              children: [
                                TextSpan(
                                    text: 'Login',
                                    style: TextStyles.w500Violet100.copyWith(
                                      fontSize: 16.sp,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushReplacementNamed(context,
                                            RoutesName.loginScreenName);
                                      }),
                              ],
                            ),
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

  Future<void> _launchURL(String url, BuildContext context) async {
    try {
      final uri = Uri.parse(url);
      await launchUrl(
        uri,
        mode: LaunchMode.platformDefault,
      );
    } catch (e) {
      showErrorSnackBar(context, 'an error occurred');
    }
  }
}
