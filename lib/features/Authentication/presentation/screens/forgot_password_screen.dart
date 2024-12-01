import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:op_expense/core/helpers/sized_boxes.dart';
import 'package:op_expense/core/theme/app_colors.dart';
import 'package:op_expense/core/theme/text_styles.dart';
import 'package:op_expense/core/widgets/app_text_form_field.dart';
import 'package:op_expense/core/widgets/my_app_bar.dart';
import 'package:op_expense/core/widgets/primary_button.dart';
import 'package:op_expense/features/Authentication/presentation/cubits/forgot_password_cubit/forgot_password_cubit.dart';
import 'package:op_expense/features/Authentication/presentation/widgets/auth_error_widget.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.light,
          //!--------- app bar ------------
          appBar: myAppBar(title: 'Forgot Password', context: context),
          //!--------- body ------------
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                heightSizedBox(70),
                //!--------- title ------------
                Text(
                  '''Don’t worry.
Enter your email and we’ll send you a link to reset your password.''',
                  style: TextStyles.w600Dark.copyWith(fontSize: 24.sp),
                ),
                heightSizedBox(46),
                if (state is ForgotPasswordFailure)
                  Column(
                    children: [
                      //!--------- error message ------------
                      AuthErrorWidget(message: state.message),
                      heightSizedBox(16),
                    ],
                  ),
                //!--------- email text field ------------
                AppTextFormField(
                    hintText: 'Email', controller: _emailTextEditingController),

                heightSizedBox(32),
                //!--------- continue button ------------
                PrimaryButton(
                  text: 'Continue',
                  onPressed: () {
                    // send reset password
                    BlocProvider.of<ForgotPasswordCubit>(context)
                        .sendResetPassword(
                            _emailTextEditingController.text.trim());
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
