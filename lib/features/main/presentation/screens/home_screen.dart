import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:op_expense/core/errors/failures.dart';
import 'package:op_expense/core/helpers/app_extensions.dart';
import 'package:op_expense/core/helpers/sized_boxes.dart';
import 'package:op_expense/core/router/routes_name.dart';
import 'package:op_expense/core/theme/app_colors.dart';
import 'package:op_expense/core/theme/text_styles.dart';
import 'package:op_expense/core/widgets/secondary_button.dart';
import 'package:op_expense/features/AiGuide/presentation/screens/ai_guide_screen.dart';
import 'package:op_expense/features/Authentication/domain/entities/account.dart';
import 'package:op_expense/features/Authentication/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:op_expense/features/Authentication/presentation/cubits/sign_out_cubit/sign_out_cubit.dart';
import 'package:op_expense/features/main/presentation/cubits/payment_sources_cubit/payment_sources_cubit.dart';
import 'package:op_expense/features/main/domain/entities/transaction.dart';
import 'package:op_expense/features/main/presentation/cubits/transaction_cubit/transaction_cubit.dart';
import 'package:op_expense/features/main/presentation/screens/transactions_screen.dart';
import 'package:op_expense/features/main/presentation/widgets/transaction_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double? balance;
  double? income;
  double? expense;
  int navigationIndex = 0;
  String selectedDuration = 'Today';
  bool isDialogShown = false;
  Account? account = const Account.empty();
  @override
  Widget build(BuildContext context) {
    final DateTime currentTime = DateTime.now();

    return MultiBlocListener(
      listeners: [
        BlocListener<LoginCubit, LoginState>(
          listener: (context, loginState) async {
            if (loginState is LoginSuccessState) {
              account = loginState.account;
              if (loginState.account.isVerified) {
                await context
                    .read<PaymentSourcesCubit>()
                    .getPaymentSources(account: loginState.account);
                // ignore: use_build_context_synchronously
                await context.read<TransactionCubit>().getTransactions(
                      account: account!,
                    );
              } else {
                Navigator.pushReplacementNamed(
                    context, RoutesName.verificationScreenName);
              }
            } else if (loginState is LoginFailureState) {
              if (loginState.message != const NoInternetFailure().message) {
                Navigator.pushReplacementNamed(
                    context, RoutesName.onboardingScreenName);
              }
            }
          },
        ),
        BlocListener<PaymentSourcesCubit, PaymentSourcesState>(
          listener: (context, paymentSourcesState) {
            if (paymentSourcesState is PaymentSourcesLoaded) {
              if (paymentSourcesState.paymentSources.isEmpty) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RoutesName.setupWalletScreenName,
                  (route) => false,
                );
              }
            }
          },
        ),
        BlocListener<TransactionCubit, TransactionState>(
          listener: (context, transactionState) {
            if (transactionState is TransactionSuccess) {
              income = 0;
              expense = 0;
              for (var element in transactionState.transactions) {
                if (element.type == TransactionType.income) {
                  income = income == null
                      ? element.amount
                      : (element.amount + income!);
                } else {
                  expense = expense == null
                      ? element.amount
                      : (element.amount + expense!);
                }
              }
              income == null ? income = 0 : null;
              expense == null ? expense = 0 : null;
            }
          },
        )
      ],
      child: BlocBuilder<TransactionCubit, TransactionState>(
          builder: (context, state) {
        return BlocBuilder<LoginCubit, LoginState>(
          builder: (context, loginState) {
            if (loginState is LoginFailureState &&
                loginState.message == const NoInternetFailure().message) {
              return SafeArea(
                child: Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No Internet Connection',
                          style:
                              TextStyles.w700Dark50.copyWith(fontSize: 20.sp),
                        ),
                        heightSizedBox(16),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: SecondaryButton(
                            text: 'Retry',
                            onPressed: () {
                              BlocProvider.of<LoginCubit>(context)
                                  .getLoggedInAccount();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
            return SafeArea(
              child: ScaffoldMessenger(
                child: Scaffold(
                  backgroundColor: AppColors.light,
                  bottomNavigationBar: showBottomBar(),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerDocked,
                  floatingActionButton:
                      navigationIndex == 0 ? showFloatingPlusButton() : null,
                  resizeToAvoidBottomInset: true,
                  body: navigationIndex == 0
                      ? showBody(
                          state is TransactionSuccess
                              ? state.transactions
                              : state is TransactionLoading
                                  ? [Transaction.empty(), Transaction.empty()]
                                  : null,
                          currentTime,
                        )
                      : navigationIndex == 1
                          ? const TransactionsScreen()
                          : navigationIndex == 2
                              ? const AiGuideScreen()
                              : Container(),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  //!---------- bottom bar-----------
  StatefulBuilder showBottomBar() {
    return StatefulBuilder(
      builder: (BuildContext context, setNavigationState) {
        return BottomNavigationBar(
          currentIndex: navigationIndex,
          onTap: (index) {
            setState(() {
              navigationIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'lib/core/assets/icons/Magicons/Glyph/User Interface/home.svg',
                height: 32.h,
                width: 32.w,
                colorFilter: ColorFilter.mode(
                  navigationIndex != 0
                      ? AppColors.light20
                      : AppColors.violet100,
                  BlendMode.srcIn,
                ),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                height: 32.h,
                width: 32.w,
                'lib/core/assets/icons/Magicons/Glyph/Finance/transaction.svg',
                colorFilter: ColorFilter.mode(
                  navigationIndex != 1
                      ? AppColors.light20
                      : AppColors.violet100,
                  BlendMode.srcIn,
                ),
              ),
              label: 'Transaction',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'lib/core/assets/icons/Magicons/Glyph/User Interface/chat.svg',
                height: 32.h,
                width: 32.w,
                colorFilter: ColorFilter.mode(
                  navigationIndex != 2
                      ? AppColors.light20
                      : AppColors.violet100,
                  BlendMode.srcIn,
                ),
              ),
              label: 'AI Guide',
            ),
            BottomNavigationBarItem(
              icon: GestureDetector(
                onLongPress: () async {
                  await BlocProvider.of<SignOutCubit>(context).signOut();
                },
                child: SvgPicture.asset(
                  'lib/core/assets/icons/Magicons/Glyph/Ecommerce & Shopping/user.svg',
                  height: 32.h,
                  width: 32.w,
                  colorFilter: ColorFilter.mode(
                    navigationIndex != 3
                        ? AppColors.light20
                        : AppColors.violet100,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              label: 'Profile',
            ),
          ],
          selectedItemColor: AppColors.violet100,
          unselectedItemColor: AppColors.light20,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        );
      },
    );
  }

  //!---------- body-----------
  SingleChildScrollView showBody(
      List<Transaction>? transactions, DateTime staticNow) {
    return SingleChildScrollView(
      child: Column(
        children: [
          //!----------- balance income expense container -----------
          buildBalanceIncomeExpense(balance),

          //!----------------- spend frequency chart -----------------
          buildSpendFrequencyChartWithDurationControl(transactions, staticNow),
          //!----------------- recent transactions title && see all button -----------------
          Container(
            margin: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // recent transactions title
                Text(
                  'Recent Transactions',
                  style: TextStyles.w600Dark25.copyWith(fontSize: 24.sp),
                ),
                // see all button
                GestureDetector(
                  onTap: () {
                    navigationIndex = 1;
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.violet20,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 7.h,
                    ),
                    child: Text(
                      'See All',
                      style: TextStyles.w500Violet100.copyWith(
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          //!----------------- recent transactions -----------------
          transactions == null || transactions.isNotEmpty
              ? Skeletonizer(
                  enabled: transactions == null,
                  enableSwitchAnimation: true,
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: transactions == null
                            ? 3
                            : transactions.length > 3
                                ? 3
                                : transactions.length,
                        itemBuilder: (BuildContext context, int index) {
                          final transaction = transactions == null
                              ? Transaction.empty()
                              : transactions[index];
                          return GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  RoutesName.transactionDetailsScreenName,
                                  arguments: transaction,
                                );
                              },
                              child: TransactionCard(
                                transaction: transaction,
                              ));
                        },
                      ),
                      heightSizedBox(16),
                    ],
                  ),
                )
              : Container(
                  height: 200.h,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No transactions yet',
                        style: TextStyles.darkW500.copyWith(fontSize: 24.sp),
                      ),
                    ],
                  ),
                )
        ],
      ),
    );
  }

  //!---------- floating plus buttons-----------
  Stack showFloatingPlusButton() {
    return Stack(
      children: [
        Positioned(
          bottom: 40.h,
          left: 0,
          right: 0,
          child: StatefulBuilder(
            builder: (BuildContext context, setShowDialogState) {
              return GestureDetector(
                onTap: () {
                  isDialogShown = true;
                  setShowDialogState(() {});
                  showFloatingIncomeAndExpenseButtonsAfterPressingFloatedPlusButton(
                      context, setShowDialogState);
                },
                child: Container(
                  height: 56.h,
                  decoration: BoxDecoration(
                    color: AppColors.violet100,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color:
                            AppColors.violet100.withAlpha((0.5 * 255).toInt()),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  width: 56.w,
                  child: SvgPicture.asset(
                    // lib\core\assets\icons\Magicons\Glyph\User Interface\close.svg
                    isDialogShown
                        ? 'lib/core/assets/icons/Magicons/Glyph/User Interface/close.svg'
                        : 'lib/core/assets/icons/Magicons/Outline/User Interface/add.svg',
                    colorFilter: const ColorFilter.mode(
                      AppColors.light,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  //!---------- spend frequency chart inside body-----------
  StatefulBuilder buildSpendFrequencyChartWithDurationControl(
      List<Transaction>? transactions, DateTime staticNow) {
    return StatefulBuilder(
      builder: (BuildContext context, setSpendFrequencyDurationState) {
        List<FlSpot> spots = [];
        List<Transaction>? reversedTransactions =
            transactions?.reversed.toList();

        if (reversedTransactions != null) {
          for (var e in reversedTransactions) {
            if ((staticNow.subtract(
              Duration(
                days: selectedDuration.durationToNumber(),
              ),
            )).isBefore(e.createAt)) {
              spots.add(
                FlSpot(spots.length.toDouble(), e.amount),
              );
            }
          }
        }
        if (spots.isEmpty) {
          spots = [const FlSpot(0, 0), const FlSpot(1, 0)];
        } else if (spots.length == 1) {
          spots.add(const FlSpot(-1, 0));
        }
        return spots.isEmpty
            ? const SizedBox.shrink()
            : Column(
                children: [
                  //!--------------- spend frequency title ---------------
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    margin: EdgeInsets.symmetric(vertical: 16.h),
                    child: Text(
                      'Spend Frequency',
                      style: TextStyles.w600Dark.copyWith(
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                  Container(
                    color: AppColors.light,
                    height: 185.h,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: LineChart(
                      LineChartData(
                        titlesData: const FlTitlesData(
                          show: false,
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        gridData: const FlGridData(
                          show: false,
                        ),

                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                              return lineBarsSpot.map((lineBarSpot) {
                                return LineTooltipItem(
                                  lineBarSpot.y.toString(),
                                  const TextStyle(
                                    color: AppColors.light,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }).toList();
                            },
                            getTooltipColor: (touchedSpot) =>
                                AppColors.violet100,
                          ),
                        ),

                        // get the min and max amount from transactions
                        minY: spots
                            .map((e) => e.y)
                            .reduce((a, b) => a < b ? a : b),

                        maxY: spots
                            .map((e) => e.y)
                            .reduce((a, b) => a > b ? a : b),
                        lineBarsData: [
                          LineChartBarData(
                            color: AppColors.violet100,
                            barWidth: 6,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: AppColors.linear2,
                            ),
                            isCurved: true,
                            curveSmoothness: 0.4,
                            spots: spots,
                          )
                        ],
                      ),
                    ),
                  ),
                  //!----------------- duration filter (day , week , month and year)  -----------------
                  Container(
                    height: 34.h,
                    margin: EdgeInsets.symmetric(vertical: 8.h),
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setSpendFrequencyDurationState(() {
                              selectedDuration = 'Today';
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: selectedDuration == "Today"
                                  ? AppColors.yellow20
                                  : AppColors.light,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 8.h,
                            ),
                            child: Text(
                              'Today',
                              style: selectedDuration == "Today"
                                  ? TextStyles.w700Yellow100.copyWith(
                                      fontSize: 14.sp,
                                    )
                                  : TextStyles.w500Light20.copyWith(
                                      fontSize: 14.sp,
                                    ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setSpendFrequencyDurationState(() {
                              selectedDuration = 'Week';
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: selectedDuration == 'Week'
                                  ? AppColors.yellow20
                                  : AppColors.light,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 8.h,
                            ),
                            child: Text(
                              'Week',
                              style: selectedDuration == "Week"
                                  ? TextStyles.w700Yellow100.copyWith(
                                      fontSize: 14.sp,
                                    )
                                  : TextStyles.w500Light20.copyWith(
                                      fontSize: 14.sp,
                                    ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setSpendFrequencyDurationState(() {
                              selectedDuration = 'Month';
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: selectedDuration == 'Month'
                                  ? AppColors.yellow20
                                  : AppColors.light,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 8.h,
                            ),
                            child: Text(
                              'Month',
                              style: selectedDuration == "Month"
                                  ? TextStyles.w700Yellow100.copyWith(
                                      fontSize: 14.sp,
                                    )
                                  : TextStyles.w500Light20.copyWith(
                                      fontSize: 14.sp,
                                    ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setSpendFrequencyDurationState(() {
                              selectedDuration = 'Year';
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: selectedDuration == 'Year'
                                  ? AppColors.yellow20
                                  : AppColors.light,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 8.h,
                            ),
                            child: Text(
                              'Year',
                              style: selectedDuration == "Year"
                                  ? TextStyles.w700Yellow100.copyWith(
                                      fontSize: 14.sp,
                                    )
                                  : TextStyles.w500Light20.copyWith(
                                      fontSize: 14.sp,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
      },
    );
  }

  //!---------- show Income and expense buttons -----------
  void showFloatingIncomeAndExpenseButtonsAfterPressingFloatedPlusButton(
      BuildContext context, StateSetter setShowDialogState) {
    showDialog(
        barrierColor: AppColors.violet10.withAlpha((0.1 * 255).toInt()),
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return PopScope(
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) {
                isDialogShown = false;
                setShowDialogState(() {});
              }
            },
            child: GestureDetector(
              onTap: () {
                isDialogShown = false;
                setShowDialogState(() {});
                Navigator.of(context).pop();
              },
              child: Stack(
                children: [
                  Positioned(
                    right: 115.w,
                    bottom: 100.h,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed(
                            RoutesName.addTransactionScreenName,
                            arguments: TransactionType.expense);
                      },
                      child: Container(
                        width: 56.w,
                        height: 56.h,
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 10.h,
                        ),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.red100,
                        ),
                        child: SvgPicture.asset(
                          'lib/core/assets/icons/Magicons/Glyph/Finance/expense.svg',
                          colorFilter: const ColorFilter.mode(
                            AppColors.light,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 115.w,
                    bottom: 100.h,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed(
                          RoutesName.addTransactionScreenName,
                          arguments: TransactionType.income,
                        );
                      },
                      child: Container(
                        width: 56.w,
                        height: 56.h,
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 10.h,
                        ),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.green100,
                        ),
                        child: SvgPicture.asset(
                          'lib/core/assets/icons/Magicons/Glyph/Finance/income.svg',
                          colorFilter: const ColorFilter.mode(
                            AppColors.light,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Container buildBalanceIncomeExpense(double? balance) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.linear1,
      ),
      height: 216.h,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          heightSizedBox(20),
          Text(
            'Balance',
            style: TextStyles.w500Light20.copyWith(fontSize: 16.sp),
          ),
          heightSizedBox(9),
          // if for ex 200.0 type just number without '.0' like this 200
          BlocBuilder<PaymentSourcesCubit, PaymentSourcesState>(
            builder: (context, paymentSourcesState) {
              if (paymentSourcesState is PaymentSourcesLoaded) {
                balance = paymentSourcesState.paymentSources
                    .map((e) => e.balance)
                    .reduce((a, b) => a + b);
              }
              return Skeletonizer(
                enabled: balance == null,
                enableSwitchAnimation: true,
                child: Text(
                  balance == null ? '' : '\$${balance!.formatNumber()}',
                  style: TextStyles.w600Dark75.copyWith(
                    fontSize: 39.sp,
                  ),
                ),
              );
            },
          ),
          heightSizedBox(27),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 164.w,
                height: 80.h,
                decoration: BoxDecoration(
                  color: AppColors.green100,
                  borderRadius: BorderRadius.circular(28.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 48.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: AppColors.light80,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 4.h,
                      ),
                      child: SvgPicture.asset(
                        'lib/core/assets/icons/Magicons/Glyph/Finance/income.svg',
                        colorFilter: const ColorFilter.mode(
                          AppColors.green100,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    widthSizedBox(10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Income',
                          style: TextStyles.w500Light80.copyWith(
                            fontSize: 14.sp,
                          ),
                        ),
                        Skeletonizer(
                          enabled: income == null,
                          child: Text(
                            income == null
                                ? '0'
                                : // remove - sign from income and don't show .0 if it's integer
                                '\$${income!.formatNumber()}',
                            style: TextStyles.w600Light80.copyWith(
                              fontSize: 22.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              widthSizedBox(16),
              Container(
                width: 164.w,
                height: 80.h,
                decoration: BoxDecoration(
                  color: AppColors.red100,
                  borderRadius: BorderRadius.circular(28.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 48.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: AppColors.light80,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: SvgPicture.asset(
                        'lib/core/assets/icons/Magicons/Glyph/Finance/expense.svg',
                        colorFilter: const ColorFilter.mode(
                          AppColors.red100,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    widthSizedBox(10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Expenses',
                          style: TextStyles.w500Light80.copyWith(
                            fontSize: 14.sp,
                          ),
                        ),
                        Skeletonizer(
                          enabled: expense == null,
                          child: Text(
                            // remove - sign from expense and don't show .0 if it's integer
                            '\$${expense == null ? 0 : expense!.formatNumber()}',
                            style: TextStyles.w600Light80.copyWith(
                              fontSize: 22.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
