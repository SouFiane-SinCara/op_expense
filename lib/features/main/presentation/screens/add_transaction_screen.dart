import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:op_expense/core/helpers/sized_boxes.dart';
import 'package:op_expense/core/theme/app_colors.dart';
import 'package:op_expense/core/theme/text_styles.dart';
import 'package:op_expense/core/widgets/app_drop_down_menu.dart';
import 'package:op_expense/core/widgets/app_number_form_field.dart';
import 'package:op_expense/core/widgets/app_switch.dart';
import 'package:op_expense/core/widgets/app_text_form_field.dart';
import 'package:op_expense/core/widgets/my_app_bar.dart';
import 'package:op_expense/core/widgets/primary_button.dart';
import 'package:op_expense/features/main/domain/entities/payment_source.dart';
import 'package:op_expense/features/main/domain/entities/transaction.dart';
import 'package:op_expense/features/main/presentation/cubits/payment_sources_cubit/payment_sources_cubit.dart';

class AddTransactionScreen extends StatefulWidget {
  final TransactionType transactionType;
  const AddTransactionScreen({super.key, required this.transactionType});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  late TextEditingController balanceController;
  Category? chosenCategory;
  late TextEditingController descriptionController;
  PaymentSource? chosenPaymentSource;
  bool repeated = false;
  late ScrollController scrollController;
  @override
  void initState() {
    super.initState();
    balanceController = TextEditingController();
    descriptionController = TextEditingController();
    scrollController = ScrollController(initialScrollOffset: 250);
  }
  
  @override
  void dispose() {
    balanceController.dispose();
    descriptionController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(scrollController.toString());
    List<PaymentSource> paymentSources =
        BlocProvider.of<PaymentSourcesCubit>(context).paymentSources;
    //* color depends on the transaction type (income or expense)
    Color color = widget.transactionType == TransactionType.income
        ? AppColors.green100
        : AppColors.red100;
    return Scaffold(
      //!------- AppBar-----------
      appBar: myAppBar(
        title: widget.transactionType.name,
        context: context,
        titleStyle: TextStyles.w600Light80,
        iconColor: AppColors.light,
        backgroundColor: color,
      ),
      backgroundColor: color,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        controller: scrollController,
        child: SizedBox(
          height: ScreenUtil().screenHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: ScreenUtil().screenWidth,
                    ),
                    Text(
                      'How much?',
                      style: TextStyles.w600Light80.copyWith(
                        fontSize: 18.sp,
                        color: AppColors.light80.withOpacity(0.64),
                      ),
                    ),
                    heightSizedBox(13),
                    AppNumberFormField(
                      controller: balanceController,
                      hintText: '\$00.0',
                    ),
                    heightSizedBox(8),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.light,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                ),
                child: Column(
                  children: [
                    heightSizedBox(16),
                    AppDropDownMenu(
                        hintText: 'Select Category',
                        onSelected: (value) {
                          chosenCategory = value;
                        },
                        selectedType: Category,
                        dropdownMenuEntries: Category.values
                            .map(
                              (e) => DropdownMenuEntry(value: e, label: e.name),
                            )
                            .toList(),
                        trailingIconColor: chosenCategory == null
                            ? AppColors.light20
                            : AppColors.dark),
                    heightSizedBox(16),
                    AppTextFormField(
                        hintText: 'Description',
                        controller: descriptionController),
                    heightSizedBox(16),
                    AppDropDownMenu(
                        hintText: 'Select account',
                        onSelected: (value) {
                          chosenPaymentSource = value;
                        },
                        selectedType: PaymentSource,
                        dropdownMenuEntries: paymentSources
                            .map(
                              (e) => DropdownMenuEntry(
                                value: e,
                                label: e.name,
                              ),
                            )
                            .toList(),
                        trailingIconColor: chosenPaymentSource == null
                            ? AppColors.light20
                            : AppColors.dark),
                    heightSizedBox(16),
                    SizedBox(
                      height: 56.h,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'lib/core/assets/icons/Magicons/Glyph/User Interface/attachment.svg',
                            width: 32.w,
                            height: 32.h,
                            colorFilter: const ColorFilter.mode(
                              AppColors.light20,
                              BlendMode.srcIn,
                            ),
                          ),
                          widthSizedBox(10),
                          Text(
                            'Add attachment',
                            style: TextStyles.w500Light20
                                .copyWith(fontSize: 16.sp),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Repeat",
                              style: TextStyles.w500Dark25.copyWith(
                                fontSize: 16.sp,
                              ),
                            ),
                            Text('Repeat transaction',
                                style: TextStyles.w500Light20.copyWith(
                                  fontSize: 16.sp,
                                )),
                          ],
                        ),
                        StatefulBuilder(
                          builder: (BuildContext context, setState) {
                            return AppSwitch(
                              value: repeated,
                              onChanged: (value) {
                                setState(() {
                                  repeated = value;
                                });
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    heightSizedBox(40),
                    PrimaryButton(text: 'continue', onPressed: () {}),
                    heightSizedBox(16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
