import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:op_expense/core/theme/app_colors.dart';

class AppLoading extends StatelessWidget {
  final Color? backgroundColor;
  final Color? circularProgressColor;
  const AppLoading(
      {super.key, this.backgroundColor, this.circularProgressColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: ScreenUtil().screenWidth,
      height: ScreenUtil().screenHeight,
      color: backgroundColor ?? AppColors.light,
      child: CircularProgressIndicator(
        color: circularProgressColor ?? AppColors.dark,
      ),
    );
  }
}
