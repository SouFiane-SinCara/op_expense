import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:op_expense/core/theme/app_colors.dart';
import 'package:op_expense/core/theme/text_styles.dart';

class AppNumberFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? prefixText;
  final bool allowNegative;
  const AppNumberFormField(
      {super.key,
      required this.controller,
      this.hintText,
      this.prefixText,
      this.allowNegative = false});

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
        // Allow only numbers, one dot, negative numbers (allow adding - at start ) and positive, up to 13 digits before the dot, and up to 2 digits after the dot.
        allowNegative
            ? FilteringTextInputFormatter.allow(
                RegExp(r'^-?\d{0,13}(\.\d{0,2})?$'))
            : FilteringTextInputFormatter.allow(
                RegExp(r'^\d{0,13}(\.\d{0,2})?$'))
      ],

      decoration: InputDecoration(
        isDense: true,
        prefixIcon: prefixText != null
            ? Text(
                prefixText!,
                style: TextStyles.w600Light80.copyWith(fontSize: 64.sp),
              )
            : null,
        hintText: hintText,
        hintStyle: TextStyles.w600Light80.copyWith(fontSize: 64.sp),
        prefixStyle: TextStyles.w600Light80.copyWith(fontSize: 64.sp),
        border: InputBorder.none,
      ),
    );
  }
}
