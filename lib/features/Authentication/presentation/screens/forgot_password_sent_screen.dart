import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:op_expense/core/helpers/sized_boxes.dart';
import 'package:op_expense/core/router/routes_name.dart';
import 'package:op_expense/core/theme/app_colors.dart';
import 'package:op_expense/core/theme/text_styles.dart';
import 'package:op_expense/core/widgets/primary_button.dart';

class ForgotPasswordSentScreen extends StatelessWidget {
  final String email;
  const ForgotPasswordSentScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.light,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              heightSizedBox(32),
              SizedBox(
                height: 300.h,
                width: 300.w,
                child: Image.asset(
                    "lib/core/assets/images/forgot_password_sent_screen/sent.png"),
              ),
              heightSizedBox(16),
              Text(
                'Your email is on the way',
                style: TextStyles.w600Dark.copyWith(
                  fontSize: 24.sp,
                ),
              ),
              heightSizedBox(24),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyles.w500Dark25.copyWith(fontSize: 16.sp),
                  children: [
                    const TextSpan(
                      text: 'Check your email ',
                    ),
                    TextSpan(
                      text: email,
                      style: TextStyles.w600Violet100.copyWith(fontSize: 18.sp),
                    ),
                    TextSpan(
                      text:
                          ' and follow the instructions to reset your password',
                      style: TextStyles.w500Dark25.copyWith(fontSize: 16.sp),
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: SizedBox.shrink(),
              ),
              PrimaryButton(
                text: 'Back to Login',
                onPressed: () {
                  // push login screen with onboarding screen as second back screen and remove all the previous screens

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    RoutesName.onboardingScreenName,
                    (route) => false,
                  );
                  Navigator.pushNamed(context, RoutesName.loginScreenName);
                },
              ),
              heightSizedBox(16),
            ],
          ),
        ),
      ),
    );
  }
}
