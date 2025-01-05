import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:op_expense/core/helpers/app_extensions.dart';
import 'package:op_expense/core/helpers/sized_boxes.dart';
import 'package:op_expense/core/theme/app_colors.dart';
import 'package:op_expense/core/theme/text_styles.dart';
import 'package:op_expense/core/widgets/my_app_bar.dart';
import 'package:op_expense/core/widgets/show_success_dialog.dart';
import 'package:op_expense/core/widgets/snack_bars.dart';
import 'package:op_expense/features/Authentication/domain/entities/account.dart';
import 'package:op_expense/features/Authentication/presentation/cubits/authentication_cubit/authentication_cubit.dart';
import 'package:op_expense/features/main/domain/entities/transaction.dart';
import 'package:op_expense/features/main/presentation/cubits/payment_sources_cubit/payment_sources_cubit.dart';
import 'package:op_expense/features/main/presentation/cubits/transaction_cubit/transaction_cubit.dart';

class TransactionDetailsScreen extends StatefulWidget {
  final Transaction transaction;
  const TransactionDetailsScreen({super.key, required this.transaction});

  @override
  State<TransactionDetailsScreen> createState() =>
      _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  Account? account;

  @override
  Widget build(BuildContext context) {
    Color color = widget.transaction.type == TransactionType.expense
        ? Colors.red
        : Colors.green;
    account = context.read<AuthenticationCubit>().getAuthenticatedAccount();
    return BlocListener<TransactionCubit, TransactionState>(
      listener: (context, state) async {
        if (state is TransactionFailure) {
          showErrorSnackBar(context, state.message);
        } else if (state is TransactionSuccess) {
          Navigator.pop(context);
          await context
              .read<PaymentSourcesCubit>()
              .getPaymentSources(account: account!);
          showSuccessDialog(context, 'Transaction deleted successfully');
        }
      },
      child: SafeArea(
        child: ScaffoldMessenger(
          child: Scaffold(
            backgroundColor: AppColors.light,
            //!---------- App Bar ------------
            appBar: myAppBar(
              title: 'Detail Transaction',
              context: context,
              backgroundColor: color,
              iconColor: AppColors.light,
              actions: [
                GestureDetector(
                  onTap: () {
                    context.read<TransactionCubit>().deleteTransaction(
                        transaction: widget.transaction, account: account!);
                  },
                  child: SvgPicture.asset(
                    'lib/core/assets/icons/Magicons/Glyph/Communication/trash.svg',
                    colorFilter: const ColorFilter.mode(
                      AppColors.light,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                widthSizedBox(16),
              ],
              titleStyle: TextStyles.w600Light80.copyWith(
                fontSize: 18.sp,
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  //!----------- top red or green section------------
                  Container(
                    height: 325.h,
                    color: AppColors.light,
                    child: Stack(
                      children: [
                        Container(
                          height: 285.h,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30.r),
                              bottomRight: Radius.circular(30.r),
                            ),
                          ),
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '\$${widget.transaction.amount.formatNumber().replaceAll('-', '')}',
                                style: TextStyles.w700Light80
                                    .copyWith(fontSize: 48.sp),
                              ),
                              heightSizedBox(16),
                              // Saturday 4 June 2021
                              Text(
                                DateFormat('EEEE d MMMM y')
                                    .format(widget.transaction.createAt),
                                style: TextStyles.w600Light80.copyWith(
                                  fontSize: 16.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        //!--------- type category wallet -------------
                        Positioned(
                          bottom: 10.h,
                          left: 0,
                          right: 0,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 16.w,
                            ),
                            height: 70.h,
                            decoration: BoxDecoration(
                              color: AppColors.light,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Type',
                                        style: TextStyles.w500Light20.copyWith(
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      Text(
                                        widget.transaction.type ==
                                                TransactionType.expense
                                            ? 'Expense'
                                            : 'Income',
                                        style: TextStyles.w600Dark.copyWith(
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Category',
                                        style: TextStyles.w500Light20.copyWith(
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      Text(
                                        widget.transaction.category.name,
                                        style: TextStyles.w600Dark.copyWith(
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Account',
                                        style: TextStyles.w500Light20.copyWith(
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      Text(
                                        widget.transaction.paymentSource
                                                ?.name ??
                                            '',
                                        style: TextStyles.w600Dark.copyWith(
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //!---------- Description-------------
                  if (widget.transaction.description.isNotEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Description',
                            style: TextStyles.w600Light20.copyWith(
                              fontSize: 16.sp,
                            ),
                          ),
                          heightSizedBox(15),
                          Text(
                            widget.transaction.description,
                            style:
                                TextStyles.darkW500.copyWith(fontSize: 16.sp),
                          ),
                        ],
                      ),
                    ),
                  //!--------------- Attachment-----------
                  if (widget.transaction.attachment?.url != null)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Attachment',
                            style: TextStyles.w600Light20.copyWith(
                              fontSize: 16.sp,
                            ),
                          ),
                          heightSizedBox(16),
                          SizedBox(
                            height: 200.h,
                            child: Image.network(
                                fit: BoxFit.contain,
                                widget.transaction.attachment!.url!),
                          )
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
