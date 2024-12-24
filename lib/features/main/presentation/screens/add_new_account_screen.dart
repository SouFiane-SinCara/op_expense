import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:op_expense/core/helpers/sized_boxes.dart';
import 'package:op_expense/core/router/routes_name.dart';
import 'package:op_expense/core/theme/app_colors.dart';
import 'package:op_expense/core/theme/text_styles.dart';
import 'package:op_expense/core/widgets/app_drop_down_menu.dart';
import 'package:op_expense/core/widgets/app_number_form_field.dart';
import 'package:op_expense/core/widgets/app_text_form_field.dart';
import 'package:op_expense/core/widgets/my_app_bar.dart';
import 'package:op_expense/core/widgets/primary_button.dart';
import 'package:op_expense/core/widgets/snack_bars.dart';
import 'package:op_expense/features/Authentication/domain/entities/account.dart';
import 'package:op_expense/features/Authentication/presentation/cubits/authentication_cubit/authentication_cubit.dart';
import 'package:op_expense/features/main/domain/entities/payment_source.dart';
import 'package:op_expense/features/main/domain/entities/payments_source_types.dart';
import 'package:op_expense/features/main/presentation/cubits/payment_sources_cubit/payment_sources_cubit.dart';

class AddNewAccountScreen extends StatefulWidget {
  const AddNewAccountScreen({super.key});

  @override
  State<AddNewAccountScreen> createState() => _AddNewAccountScreenState();
}

class _AddNewAccountScreenState extends State<AddNewAccountScreen> {
  late TextEditingController nameController;

  late TextEditingController balanceController;

  PaymentsSourceTypes? chosenPaymentType;

  String? selectedProviderLogo;

  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    balanceController = TextEditingController();
    scrollController = ScrollController(initialScrollOffset: 10000);
  }

  @override
  void dispose() {
    nameController.dispose();
    balanceController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Account account =
        BlocProvider.of<AuthenticationCubit>(context).getAuthenticatedAccount();
    return BlocListener<PaymentSourcesCubit, PaymentSourcesState>(
      listener: (context, state) {
        if (state is PaymentSourcesError) {
          showErrorSnackBar(context, state.message);
        } else if (state is PaymentSourcesLoaded) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.addNewAccountSuccessScreenName,
            (route) => false,
          );
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.violet100,
          appBar: myAppBar(
              title: 'Add new account',
              context: context,
              titleStyle: TextStyles.w600Light80.copyWith(fontSize: 18.sp),
              backgroundColor: AppColors.violet100,
              iconColor: AppColors.light),
          body: SingleChildScrollView(
            controller: scrollController,
            child: Container(
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
                          'Balance',
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
                    decoration: BoxDecoration(
                      color: AppColors.light,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        topRight: Radius.circular(16.r),
                      ),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    child: Column(
                      children: [
                        AppTextFormField(
                            hintText: 'Name', controller: nameController),
                        heightSizedBox(16),
                        StatefulBuilder(
                          builder:
                              (BuildContext context, setDropDownMenuState) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //!----------- Account type dropdown --------------
                                AppDropDownMenu(
                                  hintText: 'Select account type',
                                  onSelected: (value) {
                                    if (chosenPaymentType == null ||
                                        chosenPaymentType ==
                                            PaymentsSourceTypes.cash) {
                                      //scroll to the bottom of the screen
                                      setState(() {
                                        scrollController.animateTo(
                                          1000,
                                          duration: const Duration(seconds: 1),
                                          curve: Curves.easeInCubic,
                                        );
                                      });
                                    }

                                    setDropDownMenuState(() {
                                      chosenPaymentType = value;
                                    });
                                  },
                                  selectedType: PaymentsSourceTypes,
                                  dropdownMenuEntries: <DropdownMenuEntry<
                                      PaymentsSourceTypes>>[
                                    ...PaymentsSourceTypes.values.map(
                                      (element) => DropdownMenuEntry(
                                        value: element,
                                        label: element.toShortString,
                                      ),
                                    ),
                                  ],
                                 
                                ),
                                //!-------------- after selecting account type show providers of that type of payment source ------------
                                // check if selectedType is not null then show the providers of chosen payment type
                                if (chosenPaymentType != null &&
                                    chosenPaymentType!
                                        .providersLogos.isNotEmpty)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      heightSizedBox(16),
                                      //!--------- chosen payment type  text ------------
                                      Text(
                                        chosenPaymentType!.toShortString,
                                        style: TextStyles.w600Dark.copyWith(
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      //!----------- check if the chosen payment type has providers logos then show them like cash don't have providers ------------
                                      // chosenPaymentType!.providersLogos (.providersLogos) is a extension in PaymentSourceTypes file that returns the providers logos of the chosen payment type

                                      SizedBox(
                                        width: double.infinity,
                                        // fixed size of the grid view to make it scrollable
                                        height: 150.h,
                                        child: GridView.builder(
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 4,
                                          ),
                                          itemCount: chosenPaymentType!
                                              .providersLogos.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            var providersLogos =
                                                chosenPaymentType!
                                                    .providersLogos;
                                            return GestureDetector(
                                              onTap: () {
                                                setDropDownMenuState(() {
                                                  selectedProviderLogo =
                                                      providersLogos[index];
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.r),
                                                    color:
                                                        selectedProviderLogo ==
                                                                providersLogos[
                                                                    index]
                                                            ? AppColors.violet40
                                                            : AppColors
                                                                .light60),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 5.w,
                                                  vertical: 2.h,
                                                ),
                                                margin: EdgeInsets.symmetric(
                                                  horizontal: 8.w,
                                                  vertical: 18.h,
                                                ),
                                                child: Image.asset(
                                                  providersLogos[index],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  //!----------- Continue button --------------
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    color: AppColors.light,
                    child: Column(
                      children: [
                        PrimaryButton(
                            text: 'Continue',
                            onPressed: () {
                              // add the account to the database
                              BlocProvider.of<PaymentSourcesCubit>(context)
                                  .addNewPaymentSource(
                                account: account,
                                paymentSource: PaymentSource(
                                  // if the chosen payment type is cash then set the provider logo to the cash logo
                                  providerLogo: chosenPaymentType ==
                                          PaymentsSourceTypes.cash
                                      ? 'lib/core/assets/images/setup_wallet/cash.png'
                                      : selectedProviderLogo,
                                  balance: balanceController.text.isEmpty
                                      ? 0.0
                                      : double.parse(balanceController.text),
                                  name: nameController.text.trim(),
                                  type: chosenPaymentType,
                                ),
                              );
                            }),
                        heightSizedBox(32),
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
