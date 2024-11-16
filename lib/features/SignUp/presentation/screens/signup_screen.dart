import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:op_expense/core/constants/app_constants.dart';
import 'package:op_expense/core/helpers/sized_boxes.dart';
import 'package:op_expense/core/router/routes_name.dart';
import 'package:op_expense/core/theme/app_colors.dart';
import 'package:op_expense/core/theme/text_styles.dart';
import 'package:op_expense/core/widgets/app_text_form_field.dart';
import 'package:op_expense/core/widgets/my_app_bar.dart';
import 'package:op_expense/core/widgets/primary_button.dart';
import 'package:op_expense/core/widgets/secondary_button.dart';
import 'package:url_launcher/url_launcher.dart';

class SignupScreen extends StatelessWidget {
  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  SignupScreen({super.key});
  bool _termsAccepted = false;
  @override
  Widget build(BuildContext context) {
    print("rebuild");
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.light,
        appBar: myAppBar(
          title: "Sign Up",
          context: context,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          height: ScreenUtil().screenHeight,
          width: ScreenUtil().screenWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                        value: _termsAccepted,
                        onChanged: (value) {
                          setTermsState(
                            () {
                              _termsAccepted = value!;
                            },
                          );
                        },
                      );
                    },
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'By signing up, you agree to the ',
                      style: TextStyles.w500Dark.copyWith(fontSize: 14.sp),
                      children: [
                        TextSpan(
                          text: 'Terms of \nService and Privacy Policy',
                          style: TextStyles.w500Violet100.copyWith(
                            fontSize: 14.sp,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _launchURL(
                                  AppConstants.termsAndConditionsWebSiteLink,
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
                onPressed: () {},
              ),
              //!-------------- or  with Text-----------
              heightSizedBox(20),
              Text(
                'Or with',
                style: TextStyles.w700Light20.copyWith(fontSize: 18.sp),
              ),
              heightSizedBox(29),
              //!---------- sign up with google------------
              Row(
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
              //!------------ Already have an account? Login ------------------
              heightSizedBox(40),
              RichText(
                text: TextSpan(
                  text: 'Already have an account? ',
                  style: TextStyles.w500Light20.copyWith(fontSize: 16.sp),
                  children: [
                    TextSpan(
                        text: 'Login',
                        style: TextStyles.w500Violet100.copyWith(
                          fontSize: 16.sp,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacementNamed(
                                context, RoutesName.loginScreenName);
                          }),
                  ],
                ),
              ),
            ],
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to launch URL: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
