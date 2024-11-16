import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart'; 
import 'package:op_expense/core/theme/app_colors.dart';
import 'package:op_expense/core/theme/text_styles.dart';

// MyAppBar widget is used to display the title and navigation icon at the top of the screen. The MyAppBar
AppBar myAppBar({
  required String title,
  void Function()? onPressedLeading,
  Color? backgroundColor,
  Color? iconColor,
  required BuildContext context,
}) {
  return AppBar(
    backgroundColor: backgroundColor ?? AppColors.light,
    leadingWidth: 48.w,
    leading: Container(
      margin: EdgeInsets.only(left: 16.w),
      child: GestureDetector(
        onTap: onPressedLeading ??
            () {
              Navigator.pop(context);
            },
        child: SvgPicture.asset(
          'lib/core/assets/icons/Magicons/Glyph/Arrow/arrow-left.svg',
          colorFilter: ColorFilter.mode(
            iconColor ?? AppColors.dark50,
            BlendMode.srcIn,
          ),
          fit: BoxFit.contain,
        ),
      ),
    ),
    centerTitle: true,
    title: Text(
      title,
      style: TextStyles.w600Dark50.copyWith(fontSize: 18.sp),
    ),
  );
}
