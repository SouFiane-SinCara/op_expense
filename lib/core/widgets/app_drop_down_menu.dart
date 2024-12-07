import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:op_expense/core/theme/app_colors.dart';
import 'package:op_expense/core/theme/text_styles.dart';

class AppDropDownMenu extends StatelessWidget {
  final Function(dynamic)? onSelected;
  final List<DropdownMenuEntry<Object>> dropdownMenuEntries;
  final Object selectedType;
  final Color trailingIconColor;
  const AppDropDownMenu(
      {super.key,
      required this.onSelected,
      required this.selectedType,
      required this.dropdownMenuEntries,
      required this.trailingIconColor});

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      menuHeight: 200.h,
      width: double.infinity,
      trailingIcon: SvgPicture.asset(
        'lib/core/assets/icons/Magicons/Glyph/Arrow/arrow-down-2.svg',
        colorFilter: ColorFilter.mode(trailingIconColor, BlendMode.srcIn),
      ),
      hintText: 'Account type',
      menuStyle: const MenuStyle(
        backgroundColor: WidgetStatePropertyAll(
          AppColors.violet20,
        ),
      ),
      textStyle: TextStyles.w500Dark.copyWith(fontSize: 18.sp),
      inputDecorationTheme: InputDecorationTheme(
        // ignore: prefer_const_constructors
        outlineBorder: BorderSide(
          width: 1,
          color: AppColors.light60,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: const BorderSide(
            width: 1,
            color: AppColors.light60,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: const BorderSide(
            width: 1,
            color: AppColors.light60,
          ),
        ),
      ),
      dropdownMenuEntries: dropdownMenuEntries,
      onSelected: onSelected,
    );
  }
}
