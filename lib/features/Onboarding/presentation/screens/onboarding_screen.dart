import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:op_expense/core/helpers/sized_boxes.dart';
import 'package:op_expense/core/theme/app_colors.dart';
import 'package:op_expense/core/theme/text_styles.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});
  // controller to track which page we are on
  PageController _controller = PageController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.light,
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  child: PageView(
                    controller: _controller,
                    children: [
                      onboardingPictureTitleDescription(
                        imageName: 'onboarding1.png',
                        title: 'Gain total control of your money',
                        description:
                            'Become your own money manager and make every cent count',
                      ),
                      onboardingPictureTitleDescription(
                        imageName: 'onboarding2.png',
                        title: 'Know where your money goes',
                        description:
                            'Track your transaction easily, with categories and financial report ',
                      ),
                      onboardingPictureTitleDescription(
                        imageName: 'onboarding3.png',
                        title: 'Planning ahead',
                        description:
                            'Setup your budget for each category so you in control',
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 10.h,
                child: SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: WormEffect(
                    dotColor: AppColors.violet20,
                    activeDotColor: AppColors.violet100,
                    dotHeight: 10.h,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    heightSizedBox(25),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 65.h,
                            decoration: BoxDecoration(
                              color: AppColors.violet100,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            alignment: Alignment.center,
                            child: FittedBox(
                              child: Text(
                                'Sign Up',
                                style: TextStyles.w600Light80
                                    .copyWith(fontSize: 16.sp),
                              ),
                            ),
                          ),
                          heightSizedBox(16),
                          Container(
                            width: double.infinity,
                            height: 65.h,
                            decoration: BoxDecoration(
                              color: AppColors.violet20,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            alignment: Alignment.center,
                            child: FittedBox(
                              child: Text(
                                'Login',
                                style: TextStyles.w600Violet20
                                    .copyWith(fontSize: 16.sp),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget onboardingPictureTitleDescription(
      {required String imageName,
      required String title,
      required String description}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: 300.w,
              child: Image.asset(
                'lib/core/assets/images/onboarding/$imageName',
                fit: BoxFit.contain,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: AutoSizeText(
                title,
                style: TextStyles.w700Dark50.copyWith(fontSize: 29.sp),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 35.w),
              alignment: Alignment.topCenter,
              child: AutoSizeText(
                description,
                style: TextStyles.w500Light20.copyWith(fontSize: 16.sp),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
