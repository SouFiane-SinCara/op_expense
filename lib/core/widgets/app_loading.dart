import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:op_expense/core/theme/app_colors.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: ScreenUtil().screenWidth,
      height: ScreenUtil().screenHeight,
      color: AppColors.light,
      child: const CircularProgressIndicator(
        color: AppColors.dark,
      ),
    );
  }
}
