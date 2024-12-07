import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:op_expense/core/helpers/sized_boxes.dart';
import 'package:op_expense/core/router/routes_name.dart';
import 'package:op_expense/core/services/dependency_injection.dart';
import 'package:op_expense/core/theme/app_colors.dart';
import 'package:op_expense/core/theme/text_styles.dart';
import 'package:op_expense/core/widgets/primary_button.dart';
import 'package:op_expense/features/Authentication/presentation/cubits/sign_out_cubit/sign_out_cubit.dart';

class SetupWalletScreen extends StatelessWidget {
  const SetupWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.light,
        body: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              heightSizedBox(67),
              Text(
                "Let's setup your\naccount!",
                style: TextStyles.w500Dark50.copyWith(fontSize: 36.sp),
              ),
              heightSizedBox(37),
              Text(
                "Account can be your bank, credit card or\nyour wallet.",
                style: TextStyles.w500Dark25.copyWith(fontSize: 14.sp),
              ),
              const Expanded(child: SizedBox.shrink()),
              GestureDetector(
                onLongPress: () {
                  sl<SignOutCubit>().signOut();
                },
                child: PrimaryButton(
                    text: "Let's start",
                    onPressed: () {
                      Navigator.pushNamed(
                          context, RoutesName.addNewAccountScreenName);
                    }),
              ),
              heightSizedBox(16),
            ],
          ),
        ),
      ),
    );
  }
}
