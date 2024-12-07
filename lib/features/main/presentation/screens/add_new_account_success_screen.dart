import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:op_expense/core/router/routes_name.dart';
import 'package:op_expense/core/theme/app_colors.dart';
import 'package:op_expense/core/theme/text_styles.dart';

class AddNewAccountSuccessScreen extends StatefulWidget {
  const AddNewAccountSuccessScreen({super.key});

  @override
  State<AddNewAccountSuccessScreen> createState() =>
      _AddNewAccountSuccessScreenState();
}

class _AddNewAccountSuccessScreenState
    extends State<AddNewAccountSuccessScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context, RoutesName.homeScreenName, (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.light,
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'lib/core/assets/icons/Magicons/Glyph/User Interface/success.svg',
                colorFilter:
                    const ColorFilter.mode(AppColors.green80, BlendMode.srcIn),
                width: 128.w,
                height: 128.h,
              ),
              Text(
                'You are Set!',
                style: TextStyles.w500Dark50.copyWith(
                  fontSize: 24.sp,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
