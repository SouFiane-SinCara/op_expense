import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:op_expense/core/theme/app_colors.dart';

class TextStyles {
  static const String fontFamily = 'Inter';

  // Title 1 - Large headings
  static const TextStyle w700Dark50 = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.dark50,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle w500Light20 = TextStyle(
      fontFamily: fontFamily,
      color: AppColors.light20,
      fontWeight: FontWeight.w500);
  static const TextStyle w600Light80 = TextStyle(
      fontFamily: fontFamily,
      color: AppColors.light80,
      fontWeight: FontWeight.w600);
      static const TextStyle w600Violet20 = TextStyle(
      fontFamily: fontFamily,
      color: AppColors.violet100,
      fontWeight: FontWeight.w600); 
}
