import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:op_expense/core/theme/app_colors.dart';
import 'package:op_expense/core/theme/text_styles.dart';

// MyAppBar widget is used to display the title and navigation icon at the top of the screen. The MyAppBar
AppBar myAppBar({
  required String title,
  TextStyle? titleStyle,
  void Function()? onPressedLeading,
  Color? backgroundColor,
  Color? iconColor,
  required BuildContext context,
  List<Widget>? actions,
}) {
  return AppBar(
    actions: actions,
    elevation: 0,
    backgroundColor: backgroundColor ?? AppColors.light,
    leadingWidth: 48.w,
    leading: Navigator.of(context).canPop()
        ? Container(
            margin: EdgeInsets.only(left: 16.w),
            child: GestureDetector(
              onTap: onPressedLeading ??
                  () {
                    // navigate back to the previous screen if possible
                    Navigator.of(context).pop();
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
          )
        : const SizedBox(),
    centerTitle: true,
    title: Text(
      title,
      style: titleStyle ?? TextStyles.w600Dark50.copyWith(fontSize: 18.sp),
    ),
  );
}
