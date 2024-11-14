import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:op_expense/core/theme/app_colors.dart';
import 'package:op_expense/core/theme/text_styles.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final double? width;
  final double? height;
  final void Function()? onPressed;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 65.h,
        decoration: BoxDecoration(
          color: AppColors.violet100,
          borderRadius: BorderRadius.circular(16.r),
        ),
        alignment: Alignment.center,
        child: FittedBox(
          child: Text(
            text,
            style: TextStyles.w600Light80.copyWith(fontSize: 16.sp),
          ),
        ),
      ),
    );
  }
}
