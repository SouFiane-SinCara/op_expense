import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:op_expense/core/theme/app_colors.dart';
import 'package:op_expense/core/theme/text_styles.dart';

class AppTextFormField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputAction? textInputAction;
  final bool? secureTextFormField;

  const AppTextFormField({
    super.key,
    required this.hintText,
    required this.controller,
    this.secureTextFormField,
    this.textInputAction,
  });

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      textInputAction: widget.textInputAction ?? TextInputAction.done,
      //! don't show password if showPassword is false and the secureTextFormField is true
      obscureText: widget.secureTextFormField == true && showPassword == false,
      //! these next three lines for the multiline text field like the message field in the ai guide screen
      maxLines: widget.textInputAction == TextInputAction.newline ? null : 1,
      scrollPhysics: widget.textInputAction == TextInputAction.newline
          ? const BouncingScrollPhysics()
          : null,
      keyboardType: widget.textInputAction == TextInputAction.newline
          ? TextInputType.multiline
          : null,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
        hintText: widget.hintText,
        hintStyle: TextStyles.w400Light40,
        //! isDense make the textField smaller
        isDense: true,
        suffixIcon: widget.secureTextFormField == true
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 8.h),
                  height: 10.h,
                  width: 10.w,
                  child: SvgPicture.asset(
                    'lib/core/assets/icons/Magicons/Outline/User Interface/${showPassword ? "hide" : "show"}.svg',
                    colorFilter: const ColorFilter.mode(
                      AppColors.light20,
                      BlendMode.srcIn,
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
              )
            : null,
        //*style and color of the border
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(
            color: AppColors.light60,
            width: 1.0,
          ),
        ),
        //*style and color of the border when the field is focused
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: AppColors.violet20, // Border color when focused
            width: 2.0,
          ),
        ),

        border: InputBorder.none,
        //*background color of the text field
        fillColor: AppColors.light,
        filled: true,
      ),
    );
  }
}
