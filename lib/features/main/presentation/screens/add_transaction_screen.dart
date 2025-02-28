// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:op_expense/core/helpers/sized_boxes.dart';
import 'package:op_expense/core/theme/app_colors.dart';
import 'package:op_expense/core/theme/text_styles.dart';
import 'package:op_expense/core/widgets/app_drop_down_menu.dart';
import 'package:op_expense/core/widgets/app_loading.dart';
import 'package:op_expense/core/widgets/app_number_form_field.dart';
import 'package:op_expense/core/widgets/app_switch.dart';
import 'package:op_expense/core/widgets/app_text_form_field.dart';
import 'package:op_expense/core/widgets/my_app_bar.dart';
import 'package:op_expense/core/widgets/primary_button.dart';
import 'package:op_expense/core/widgets/show_success_dialog.dart';
import 'package:op_expense/core/widgets/snack_bars.dart';
import 'package:op_expense/features/Authentication/domain/entities/account.dart';
import 'package:op_expense/features/Authentication/presentation/cubits/authentication_cubit/authentication_cubit.dart';
import 'package:op_expense/features/main/domain/entities/payment_source.dart';
import 'package:op_expense/features/main/domain/entities/transaction.dart';
import 'package:op_expense/features/main/presentation/cubits/payment_sources_cubit/payment_sources_cubit.dart';
import 'package:op_expense/features/main/presentation/cubits/transaction_cubit/transaction_cubit.dart';

// Main screen widget for adding a transaction
class AddTransactionScreen extends StatefulWidget {
  final TransactionType transactionType;
  const AddTransactionScreen({super.key, required this.transactionType});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

// State class for AddTransactionScreen
class _AddTransactionScreenState extends State<AddTransactionScreen> {
  late ImagePicker imagePicker;
  XFile? imageFile;
  late TextEditingController balanceController;
  Category? chosenCategory;
  late TextEditingController descriptionController;
  PaymentSource? chosenPaymentSource;
  bool repeated = false;
  late ScrollController scrollController;
  Frequency? chosenFrequency;
  DateTime? endFrequency;
  bool errorShowed = false;
  String? frequencyChosenMonth;
  String? frequencyChosenDay;
  // Check if the frequency selection is valid
  bool isFrequencyValid() {
    if (chosenFrequency == Frequency.daily && endFrequency != null) {
      return true;
    } else if (chosenFrequency == Frequency.monthly &&
        endFrequency != null &&
        frequencyChosenDay != null) {
      return true;
    } else if (chosenFrequency == Frequency.yearly &&
        endFrequency != null &&
        frequencyChosenMonth != null &&
        frequencyChosenDay != null) {
      return true;
    }
    return false;
  }

  // Initialize controllers and other state variables
  @override
  void initState() {
    super.initState();
    balanceController = TextEditingController();
    descriptionController = TextEditingController();
    scrollController = ScrollController(initialScrollOffset: 250);
    imagePicker = ImagePicker();
  }

  // Dispose controllers to free up resources
  @override
  void dispose() {
    balanceController.dispose();
    descriptionController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  // months short names
  List<String> months = List.generate(12, (index) {
    DateTime date = DateTime(2024, index + 1, 1); // Month starts from 1
    return DateFormat.MMM().format(date);
  });
  // days list as a list of strings
  List<String> days = List.generate(31, (index) {
    return (index + 1).toString();
  });

  DateTime currentDate = DateTime.now();

  // Main build method for the screen
  @override
  Widget build(BuildContext context) {
    List<PaymentSource> paymentSources =
        BlocProvider.of<PaymentSourcesCubit>(context).paymentSources;
    Account account = BlocProvider.of<AuthenticationCubit>(context)
        .authenticatedAccount!; //* color depends on the transaction type (income or expense)
    Color color = widget.transactionType == TransactionType.income
        ? AppColors.green100
        : AppColors.red100;

    return SafeArea(
      child: ScaffoldMessenger(
        child: Scaffold(
          //!------- AppBar-----------
          appBar: myAppBar(
            title: widget.transactionType.name,
            context: context,
            titleStyle: TextStyles.w600Light80,
            iconColor: AppColors.light,
            backgroundColor: color,
          ),
          backgroundColor: color,
          resizeToAvoidBottomInset: true,
          body: BlocConsumer<TransactionCubit, TransactionState>(
            listener: (context, state) {
              if (state is TransactionFailure) {
                showErrorSnackBar(context, state.message);
              } else if (state is TransactionSuccess) {
                Navigator.pop(context);
                context.read<PaymentSourcesCubit>().updatePaymentSourceBalance(
                    chosenPaymentSource!.balance +
                        (balanceController.text == ''
                            ? 0
                            : double.parse(balanceController.text) *
                                (widget.transactionType ==
                                        TransactionType.expense
                                    ? (-1)
                                    : (1))),
                    chosenPaymentSource!);
                showTransactionAddedSuccessfully(context);
              }
            },
            builder: (context, state) => state is TransactionLoading
                ? AppLoading(
                    backgroundColor: color,
                    circularProgressColor: AppColors.light,
                  )
                : SingleChildScrollView(
                    controller: scrollController,
                    child: SizedBox(
                      height: ScreenUtil().screenHeight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          //!------- Amount Input Section -----------
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
                                    color: AppColors.light80.withAlpha(163),
                                  ),
                                ),
                                heightSizedBox(13),
                                AppNumberFormField(
                                  controller: balanceController,
                                  hintText: '00.0',
                                  prefixText: '\$',
                                ),
                                heightSizedBox(8),
                              ],
                            ),
                          ),
                          //!------- Transaction Details Section -----------
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
                                //!------- Category Dropdown -----------
                                AppDropDownMenu(
                                  hintText: 'Select Category',
                                  onSelected: (value) {
                                    chosenCategory = value;
                                  },
                                  selectedType: Category,
                                  dropdownMenuEntries: Category.values
                                      .map(
                                        (e) => DropdownMenuEntry(
                                            value: e, label: e.name),
                                      )
                                      .toList(),
                                ),
                                heightSizedBox(16),
                                //!------- Description Input -----------
                                AppTextFormField(
                                    hintText: 'Description',
                                    controller: descriptionController),
                                heightSizedBox(16),
                                //!------- Payment Source Dropdown -----------
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
                                ),
                                heightSizedBox(16),
                                //!------- Attachment Section -----------
                                StatefulBuilder(
                                  builder: (BuildContext context,
                                      setAttachmentState) {
                                    return GestureDetector(
                                      onTap: () {
                                        displayAttachmentSourceOptions(
                                            context, setAttachmentState);
                                      },
                                      child: imageFile != null
                                          ? Align(
                                              alignment: Alignment.centerLeft,
                                              child: Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 16.h),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16.r),
                                                ),
                                                child: Stack(
                                                  children: [
                                                    Image.file(
                                                      File(imageFile!.path),
                                                      fit: BoxFit.fill,
                                                      width: 110.w,
                                                      height: 110.h,
                                                    ),
                                                    Positioned(
                                                      top: 0,
                                                      right: 0,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          imageFile = null;
                                                          setAttachmentState(
                                                              () {});
                                                        },
                                                        child: Container(
                                                          width: 24.w,
                                                          height: 24.h,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: AppColors
                                                                .light20
                                                                .withAlpha((0.8 *
                                                                        255)
                                                                    .toInt()),
                                                          ),
                                                          //lib\core\assets\icons\Magicons\Glyph\User Interface\close.svg
                                                          child:
                                                              SvgPicture.asset(
                                                            'lib/core/assets/icons/Magicons/Glyph/User Interface/close.svg',
                                                            width: 16.w,
                                                            height: 16.h,
                                                            colorFilter:
                                                                const ColorFilter
                                                                    .mode(
                                                                    AppColors
                                                                        .light,
                                                                    BlendMode
                                                                        .srcIn),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  'lib/core/assets/icons/Magicons/Glyph/User Interface/attachment.svg',
                                                  width: 32.w,
                                                  height: 32.h,
                                                  colorFilter:
                                                      const ColorFilter.mode(
                                                    AppColors.light20,
                                                    BlendMode.srcIn,
                                                  ),
                                                ),
                                                widthSizedBox(10),
                                                Text(
                                                  'Add attachment',
                                                  style: TextStyles.w500Light20
                                                      .copyWith(
                                                          fontSize: 16.sp),
                                                ),
                                              ],
                                            ),
                                    );
                                  },
                                ),
                                //!------- Repeat Transaction Section -----------
                                StatefulBuilder(
                                  builder: (BuildContext context, updateState) {
                                    return Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Repeat",
                                                  style: TextStyles.w500Dark25
                                                      .copyWith(
                                                    fontSize: 16.sp,
                                                  ),
                                                ),
                                                Text('Repeat transaction',
                                                    style: TextStyles
                                                        .w500Light20
                                                        .copyWith(
                                                      fontSize: 16.sp,
                                                    )),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                AppSwitch(
                                                  value: repeated,
                                                  onChanged: (value) async {
                                                    chosenFrequency = null;
                                                    endFrequency = null;
                                                    errorShowed = false;
                                                    if (repeated == true) {
                                                      updateState(() {
                                                        repeated = false;
                                                      });
                                                      return;
                                                    }
                                                    displayFrequencyOptions(
                                                        context, updateState);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        //!----------- frequency information if repeated -----------
                                        if (repeated)
                                          Container(
                                            margin: EdgeInsets.only(top: 8.h),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Frequency',
                                                      style: TextStyles
                                                          .w500Dark25
                                                          .copyWith(
                                                        fontSize: 16.sp,
                                                      ),
                                                    ),
                                                    Text(
                                                      chosenFrequency ==
                                                              Frequency.monthly
                                                          ? '${chosenFrequency!.name} - ${frequencyChosenDay ?? ''}'
                                                          : '${chosenFrequency!.name} - ${frequencyChosenMonth ?? ''} ${frequencyChosenDay ?? ''}',
                                                      style: TextStyles
                                                          .w500Light20
                                                          .copyWith(
                                                        fontSize: 16.sp,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'End After',
                                                      style: TextStyles
                                                          .w500Dark25
                                                          .copyWith(
                                                        fontSize: 16.sp,
                                                      ),
                                                    ),
                                                    //show end date like 12 Jan 2024
                                                    Text(
                                                      DateFormat('dd MMM yyyy')
                                                          .format(
                                                              endFrequency!),
                                                      style: TextStyles
                                                          .w500Light20
                                                          .copyWith(
                                                        fontSize: 16.sp,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    displayFrequencyOptions(
                                                        context, updateState);
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: AppColors.violet20,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.r),
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 16.w,
                                                      vertical: 7.h,
                                                    ),
                                                    child: Text(
                                                      'Edit',
                                                      style: TextStyles
                                                          .w500Violet100
                                                          .copyWith(
                                                        fontSize: 14.sp,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                      ],
                                    );
                                  },
                                ),
                                heightSizedBox(40),
                                //!------- Continue Button -----------
                                PrimaryButton(
                                    text: 'continue',
                                    onPressed: () {
                                      BlocProvider.of<TransactionCubit>(context)
                                          .addTransaction(
                                              transaction: Transaction(
                                                type: widget.transactionType,
                                                description:
                                                    descriptionController.text
                                                        .trim(),
                                                amount: balanceController
                                                            .text ==
                                                        ''
                                                    ? 0
                                                    : double.parse(
                                                            balanceController
                                                                .text) *
                                                        (widget.transactionType ==
                                                                TransactionType
                                                                    .expense
                                                            ? (-1)
                                                            : (1)),
                                                createAt: currentDate,
                                                paymentSource:
                                                    chosenPaymentSource,
                                                category: chosenCategory,
                                                frequency: chosenFrequency,
                                                frequencyEndDate: endFrequency,
                                                attachment: Attachment(
                                                  file: imageFile,
                                                ),
                                                repeat: repeated,
                                                frequencyDay:
                                                    frequencyChosenDay == null
                                                        ? null
                                                        : int.parse(
                                                            frequencyChosenDay!),
                                                frequencyMonth:
                                                    frequencyChosenMonth == null
                                                        ? null
                                                        : months.indexOf(
                                                                frequencyChosenMonth!) +
                                                            1,
                                              ),
                                              account: account);
                                    }),
                                heightSizedBox(16),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  //!----------------- Show transaction added successfully -------------------
  Future<dynamic> showTransactionAddedSuccessfully(BuildContext context) {
    return showSuccessDialog(
        context, 'Transaction has been successfully added');
  }

  //!----------------- Display frequency options -------------------
  Future<dynamic> displayFrequencyOptions(
      BuildContext context, StateSetter updateState) {
    errorShowed = false;
    return showDialog(
      context: context,
      builder: (context) => SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
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
                  vertical: 16.h,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Material(
                        child: StatefulBuilder(
                          builder: (BuildContext context, setFrequencyState) {
                            return Column(
                              children: [
                                if (errorShowed)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 16.h,
                                    ),
                                    child:
                                        Text('Complete frequency information',
                                            style: TextStyles.w600Red.copyWith(
                                              fontSize: 16.sp,
                                            )),
                                  ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: AppDropDownMenu(
                                        onSelected: (value) {
                                          setFrequencyState(() {
                                            chosenFrequency = value;
                                          });
                                        },
                                        hintText: 'Frequency',
                                        selectedType: String,
                                        dropdownMenuEntries: Frequency.values
                                            .map(
                                              (e) => DropdownMenuEntry(
                                                value: e,
                                                label: e.name,
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                    chosenFrequency != null &&
                                            chosenFrequency != Frequency.daily
                                        ? Expanded(
                                            flex: chosenFrequency !=
                                                    Frequency.monthly
                                                ? 2
                                                : 1,
                                            child: Row(
                                              children: [
                                                if (chosenFrequency !=
                                                    Frequency.monthly)
                                                  Expanded(
                                                    child: AppDropDownMenu(
                                                      onSelected: (value) {
                                                        frequencyChosenMonth =
                                                            value;
                                                      },
                                                      selectedType: String,
                                                      dropdownMenuEntries:
                                                          months
                                                              .map(
                                                                (e) =>
                                                                    DropdownMenuEntry(
                                                                        value:
                                                                            e,
                                                                        label:
                                                                            e),
                                                              )
                                                              .toList(),
                                                      hintText: 'month',
                                                    ),
                                                  ),
                                                Expanded(
                                                  child: AppDropDownMenu(
                                                    onSelected: (value) {
                                                      frequencyChosenDay =
                                                          value;
                                                    },
                                                    hintText: 'day',
                                                    selectedType: String,
                                                    dropdownMenuEntries: days
                                                        .map(
                                                          (e) =>
                                                              DropdownMenuEntry(
                                                                  value: e,
                                                                  label: e),
                                                        )
                                                        .toList(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : const Expanded(
                                            flex: 0,
                                            child: SizedBox(),
                                          ),
                                  ],
                                ),
                                heightSizedBox(16),
                                GestureDetector(
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: currentDate,
                                      firstDate: currentDate,
                                      lastDate: DateTime(
                                        2050,
                                      ),
                                    ).then((value) {
                                      if (value != null) {
                                        setFrequencyState(() {
                                          endFrequency = value;
                                        });
                                      }
                                    });
                                  },
                                  child: Container(
                                    height: 56.h,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 16.h,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          endFrequency == null
                                              ? 'End After'
                                              : DateFormat.yMMMd()
                                                  .format(endFrequency!),
                                          style: endFrequency == null
                                              ? TextStyles.w500Light20.copyWith(
                                                  fontSize: 16.sp,
                                                )
                                              : TextStyles.w500Dark25.copyWith(
                                                  fontSize: 16.sp,
                                                ),
                                        ),
                                        Icon(
                                          Icons.calendar_month,
                                          color: endFrequency == null
                                              ? AppColors.light20
                                              : AppColors.dark,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                heightSizedBox(24),
                                PrimaryButton(
                                    text: 'next',
                                    onPressed: () {
                                      if (isFrequencyValid()) {
                                        Navigator.pop(context);
                                        updateState(() {
                                          repeated = true;
                                        });
                                      } else {
                                        setFrequencyState(() {
                                          errorShowed = true;
                                        });
                                      }
                                    }),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

//!----------------- Display attachment source options -------------------
  Future<dynamic> displayAttachmentSourceOptions(
      BuildContext context, StateSetter setAttachmentState) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () async {
                XFile? oldImageFile = imageFile;
                imageFile =
                    await imagePicker.pickImage(source: ImageSource.gallery);

                if (imageFile != oldImageFile) {
                  Navigator.of(context).pop();
                  setAttachmentState(() {});
                }
              },
              child: SvgPicture.asset(
                'lib/core/assets/icons/Magicons/Glyph/Communication/gallery.svg',
                width: 32.w,
                height: 32.h,
                colorFilter: const ColorFilter.mode(
                  AppColors.light20,
                  BlendMode.srcIn,
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                XFile? oldImageFile = imageFile;
                imageFile =
                    await imagePicker.pickImage(source: ImageSource.camera);

                if (imageFile != oldImageFile) {
                  Navigator.of(context).pop();
                  setAttachmentState(() {});
                }
              },
              child: SvgPicture.asset(
                'lib/core/assets/icons/Magicons/Glyph/User Interface/camera.svg',
                width: 32.w,
                height: 32.h,
                colorFilter: const ColorFilter.mode(
                  AppColors.light20,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
