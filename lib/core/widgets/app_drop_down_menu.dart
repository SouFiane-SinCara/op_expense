import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:op_expense/core/theme/app_colors.dart';
import 'package:op_expense/core/theme/text_styles.dart';

class AppDropDownMenu extends StatefulWidget {
  final Function(dynamic)? onSelected;
  final List<DropdownMenuEntry<Object>> dropdownMenuEntries;
  final Object selectedType;

  final String? hintText;

  const AppDropDownMenu({
    super.key,
    required this.onSelected,
    this.hintText,
    required this.selectedType,
    required this.dropdownMenuEntries,
  });

  @override
  State<AppDropDownMenu> createState() => _AppDropDownMenuState();
}

class _AppDropDownMenuState extends State<AppDropDownMenu> {
  bool itemSelected = false;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyles.w500Light20.copyWith(
            fontSize: 18.sp,
            color: AppColors.light20, // Color of the hint text
          ),
        ),
      ),
      child: DropdownMenu(
        
        menuHeight: 200.h,
        selectedTrailingIcon: SvgPicture.asset(
          'lib/core/assets/icons/Magicons/Glyph/Arrow/arrow-up.svg',
          colorFilter: ColorFilter.mode(
              itemSelected ? AppColors.dark : AppColors.light20,
              BlendMode.srcIn),
        ),
        width: double.infinity,
        trailingIcon: SvgPicture.asset(
          'lib/core/assets/icons/Magicons/Glyph/Arrow/arrow-down-2.svg',
          colorFilter: ColorFilter.mode(
              itemSelected ? AppColors.dark : AppColors.light20,
              BlendMode.srcIn),
        ),
        hintText: widget.hintText ?? 'Select',
        menuStyle: const MenuStyle(
          backgroundColor: WidgetStatePropertyAll(
            AppColors.violet20,
          ),
        ),
        textStyle: TextStyles.w500Dark
            .copyWith(fontSize: 18.sp, overflow: TextOverflow.clip),
        inputDecorationTheme: InputDecorationTheme(
          outlineBorder: const BorderSide(
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
        dropdownMenuEntries: widget.dropdownMenuEntries,
        onSelected: (value) {
          widget.onSelected!(value);
          itemSelected = true;
          setState(() {});
        },
      ),
    );
  }
}
