import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:op_expense/core/theme/app_colors.dart';
import 'package:op_expense/core/theme/text_styles.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  const SecondaryButton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 65.h,
        decoration: BoxDecoration(
          color: AppColors.violet20,
          borderRadius: BorderRadius.circular(16.r),
        ),
        alignment: Alignment.center,
        child: FittedBox(
          child: Text(
            text,
            style: TextStyles.w600Violet20.copyWith(fontSize: 16.sp),
          ),
        ),
      ),
    );
  }
}
