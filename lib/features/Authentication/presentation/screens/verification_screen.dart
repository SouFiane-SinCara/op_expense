import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:op_expense/core/helpers/sized_boxes.dart';
import 'package:op_expense/core/router/routes_name.dart';
import 'package:op_expense/core/theme/app_colors.dart';
import 'package:op_expense/core/theme/text_styles.dart';
import 'package:op_expense/core/widgets/my_app_bar.dart';
import 'package:op_expense/core/widgets/primary_button.dart';
import 'package:op_expense/core/widgets/secondary_button.dart';
import 'package:op_expense/core/widgets/snack_bars.dart';
import 'package:op_expense/features/Authentication/domain/entities/account.dart';
import 'package:op_expense/features/Authentication/presentation/cubits/authentication_cubit/authentication_cubit.dart';
import 'package:op_expense/features/Authentication/presentation/cubits/check_email_verification_cubit/check_email_verification_cubit.dart';
import 'package:op_expense/features/Authentication/presentation/cubits/send_email_verification_cubit/send_email_verification_cubit.dart';
import 'package:op_expense/features/Authentication/presentation/cubits/sign_out_cubit/sign_out_cubit.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Account account =
        BlocProvider.of<AuthenticationCubit>(context).getAuthenticatedAccount();

    return MultiBlocListener(
      listeners: [
        //!------------ check email verification listener ------------
        BlocListener<CheckEmailVerificationCubit, CheckEmailVerificationState>(
          listener: (context, state) {
            if (state is CheckEmailVerificationSuccess) {
              // if email is verified navigate to home screen
              if (state.isVerified) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RoutesName.homeScreenName,
                  (route) => false,
                );
              } else {
                // show warning snackbar if email is not verified
                showWarningSnackBar(context, 'Email not verified !');
              }
              // show error snackbar if email verification check fails
            } else if (state is CheckEmailVerificationFailure) {
              showErrorSnackBar(context, state.message);
            }
          },
        ),
        //!------------ sign out listener ------------
        BlocListener<SignOutCubit, SignOutState>(listener: (context, state) {
          // if sign out is successful navigate to onboarding screen
          if (state is SignOutSuccess) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              RoutesName.onboardingScreenName,
              (route) => false,
            );
            // show error snackbar if sign out fails
          } else if (state is SignOutFailure) {
            showErrorSnackBar(context, state.message);
          }
        }),
        //!------------ send email verification listener ------------
        BlocListener<SendEmailVerificationCubit, SendEmailVerificationState>(
          listener: (context, state) {
            // show success snackbar if send email verification is sent successfully
            if (state is SendEmailVerificationSuccess) {
              showSuccessSnackBar(context, 'Email verification sent !');
              // show error snackbar if send email verification fails
            } else if (state is SendEmailVerificationFailure) {
              showErrorSnackBar(context, state.message);
            }
          },
        )
      ],
      child: Scaffold(
        backgroundColor: AppColors.light,
        //!------------ app bar ------------
        appBar: myAppBar(
          title: 'Verification',
          context: context,
          actions: [
            IconButton(
              onPressed: () {
                BlocProvider.of<SignOutCubit>(context).signOut();
              },
              icon: SizedBox(
                width: 24.w,
                child: SvgPicture.asset(
                  'lib/core/assets/icons/Magicons/Glyph/User Interface/logout.svg',
                  colorFilter: const ColorFilter.mode(
                    AppColors.red60,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            widthSizedBox(5),
          ],
        ),

        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //!------------ email verification image ------------
              SizedBox(
                width: 300.w,
                height: 400.h,
                child: ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                    AppColors.violet40,
                    BlendMode.modulate,
                  ),
                  child: Image.asset(
                      'lib/core/assets/images/verification_screen/confirm-email.png'),
                ),
              ),
              //!------------ verify your email text ------------
              Text(
                'Verify your email',
                style: TextStyles.w700Dark50.copyWith(fontSize: 30.sp),
              ),
              heightSizedBox(20),
              //!------------ sub title text ------------
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyles.w500Dark.copyWith(fontSize: 12.sp),
                  children: [
                    const TextSpan(
                        text:
                            'We have sent a verification link to your email address '),
                    TextSpan(
                      text: account.email,
                      style: TextStyles.w600Violet100.copyWith(fontSize: 12.sp),
                    ),
                    const TextSpan(
                        text:
                            '. Please click on the link to verify your email address.'),
                  ],
                ),
              ),
              heightSizedBox(20),
              //!------------ resend email verification button ------------
              PrimaryButton(
                text: 'Resend Email Verification',
                onPressed: () {
                  BlocProvider.of<SendEmailVerificationCubit>(context)
                      .sendEmailVerification();
                },
              ),
              heightSizedBox(20),
              //!------------ check email verification button ------------
              SecondaryButton(
                text: 'check email verification',
                onPressed: () {
                  BlocProvider.of<CheckEmailVerificationCubit>(context)
                      .checkEmailVerification();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}