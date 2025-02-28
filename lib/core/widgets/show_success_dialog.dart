import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:op_expense/core/theme/text_styles.dart';

Future showSuccessDialog(BuildContext context, String message) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
        content: Container(
      padding: EdgeInsets.symmetric(
        vertical: 16.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'lib/core/assets/icons/Magicons/Glyph/User Interface/success.svg',
            width: 50.w,
            height: 50.h,
            colorFilter:
                const ColorFilter.mode(Color(0xFF5233FF), BlendMode.srcIn),
          ),
          FittedBox(
            child: Text(
              message,
              style: TextStyles.darkW500,
            ),
          ),
        ],
      ),
    )),
  );
}
