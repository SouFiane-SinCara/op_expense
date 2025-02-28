import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:op_expense/core/theme/app_colors.dart';
import 'package:op_expense/core/theme/text_styles.dart';

class AuthErrorWidget extends StatelessWidget {
  final String message;
  const AuthErrorWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.red20,
        borderRadius: BorderRadius.circular(10.r),
      ),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: AutoSizeText(
        message,
        style: TextStyles.w700red100,
      ),
    );
  }
}
