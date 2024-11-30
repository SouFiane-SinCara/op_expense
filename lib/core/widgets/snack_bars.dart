import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:op_expense/core/theme/app_colors.dart';
import 'package:op_expense/core/theme/text_styles.dart';

void showSuccessSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    margin: EdgeInsets.only(bottom: 16.h, left: 16.w, right: 16.w),
    content: Text(
      message,
      style: TextStyles.w600Dark50.copyWith(fontSize: 16.sp),
    ),
    backgroundColor: AppColors.green20,
    duration: const Duration(seconds: 3),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    behavior: SnackBarBehavior.floating,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showWarningSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    margin: EdgeInsets.only(bottom: 16.h, left: 16.w, right: 16.w),
    content: Text(
      message,
      style: TextStyles.w600Dark50.copyWith(fontSize: 16.sp),
    ),
    backgroundColor: AppColors.yellow20,
    duration: const Duration(seconds: 3),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    behavior: SnackBarBehavior.floating,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showErrorSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    margin: EdgeInsets.only(bottom: 16.h, left: 16.w, right: 16.w),
    content: Text(
      message,
      style: TextStyles.w600Dark50.copyWith(fontSize: 16.sp),
    ),
    backgroundColor: AppColors.red20,
    duration: const Duration(seconds: 3),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    behavior: SnackBarBehavior.floating,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
