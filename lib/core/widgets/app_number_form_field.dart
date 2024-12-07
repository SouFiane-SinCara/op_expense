import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:op_expense/core/theme/app_colors.dart';
import 'package:op_expense/core/theme/text_styles.dart';

class AppNumberFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? prefixText;
  const AppNumberFormField(
      {super.key, required this.controller, this.hintText, this.prefixText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // keyboardType of the balance text form field is number without space just numbers and max one dot,
      style: TextStyles.w600Light80.copyWith(fontSize: 64.sp),

      controller: controller,
      textInputAction: TextInputAction.done,
      onChanged: (value) {},
      keyboardType:
          const TextInputType.numberWithOptions(decimal: true, signed: true),
      cursorColor: AppColors.light,

      inputFormatters: [
        // Allow only numbers, one dot, negative numbers, up to 13 digits before the dot, and up to 2 digits after the dot.
        FilteringTextInputFormatter.allow(
            RegExp(r'^-?[0-9]{1,13}(\.[0-9]{0,2})?$')),
      ],

      decoration: InputDecoration(
        isDense: true,
        prefixText: prefixText,
        hintText: hintText,
        hintStyle: TextStyles.w600Light80.copyWith(fontSize: 64.sp),
        prefixStyle: TextStyles.w600Light80.copyWith(fontSize: 64.sp),
        border: InputBorder.none,
      ),
    );
  }
}
