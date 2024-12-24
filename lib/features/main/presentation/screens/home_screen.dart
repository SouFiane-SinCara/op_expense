import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:op_expense/core/helpers/app_extensions.dart';
import 'package:op_expense/core/helpers/sized_boxes.dart';
import 'package:op_expense/core/router/routes_name.dart';
import 'package:op_expense/core/theme/app_colors.dart';
import 'package:op_expense/core/theme/text_styles.dart';
import 'package:op_expense/features/main/domain/entities/payment_source.dart';
import 'package:op_expense/features/main/domain/entities/payments_source_types.dart';
import 'package:op_expense/features/main/presentation/cubits/payment_sources_cubit/payment_sources_cubit.dart';
import 'package:op_expense/features/main/domain/entities/transaction.dart';
import 'package:op_expense/features/main/presentation/widgets/transaction_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double balance = 0;
  int navigationIndex = 0;
  String selectedDuration = 'Week';
  bool dialogShow = false;
  @override
  void initState() {
    balance = BlocProvider.of<PaymentSourcesCubit>(context).getBalance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Sample transactions for testing
    final DateTime staticNow = DateTime(2024, 9, 12, 9, 30);
    final List<Transaction> transactions = [
      Transaction(
        id: '1',
        description: 'Grocery',
        amount: -33.0,
        type: TransactionType.expense,
        date: staticNow.subtract(const Duration(hours: 23)),
        paymentSource: const PaymentSource(
          providerLogo: 'lib/core/assets/images/setup_wallet/visa.png',
          balance: 23.0,
          name: 'Credit Card',
          type: PaymentsSourceTypes.creditCard,
        ),
        category: Category.food,
        repeat: false,
      ),
      Transaction(
        id: '1',
        description: 'Grocery',
        amount: -1.0,
        type: TransactionType.expense,
        date: staticNow.subtract(const Duration(hours: 23)),
        paymentSource: const PaymentSource(
          providerLogo: 'lib/core/assets/images/setup_wallet/visa.png',
          balance: -19.0,
          name: 'Credit Card',
          type: PaymentsSourceTypes.creditCard,
        ),
        category: Category.food,
        repeat: false,
      ),
      Transaction(
        id: '1',
        description: 'Grocery',
        amount: -50.0,
        type: TransactionType.expense,
        date: staticNow.subtract(const Duration(hours: 23)),
        paymentSource: const PaymentSource(
          providerLogo: 'lib/core/assets/images/setup_wallet/visa.png',
          balance: 1000.0,
          name: 'Credit Card',
          type: PaymentsSourceTypes.creditCard,
        ),
        category: Category.food,
        repeat: false,
      ),
      Transaction(
        id: '1',
        description: 'Grocery',
        amount: -50.0,
        type: TransactionType.expense,
        date: staticNow.subtract(const Duration(hours: 23)),
        paymentSource: const PaymentSource(
          providerLogo: 'lib/core/assets/images/setup_wallet/visa.png',
          balance: -50.0,
          name: 'Credit Card',
          type: PaymentsSourceTypes.creditCard,
        ),
        category: Category.food,
        repeat: false,
      ),
      Transaction(
        id: '1',
        description: 'Grocery',
        amount: -50.0,
        type: TransactionType.expense,
        date: staticNow.subtract(const Duration(hours: 23)),
        paymentSource: const PaymentSource(
          providerLogo: 'lib/core/assets/images/setup_wallet/visa.png',
          balance: 1000.0,
          name: 'Credit Card',
          type: PaymentsSourceTypes.creditCard,
        ),
        category: Category.food,
        repeat: false,
      ),
      Transaction(
        id: '2',
        description: 'Rent',
        amount: -1200.0,
        type: TransactionType.expense,
        date: staticNow.subtract(const Duration(days: 5)),
        paymentSource: const PaymentSource(
          providerLogo: 'lib/core/assets/images/setup_wallet/chase-bank.png',
          balance: 5000.0,
          name: 'Bank Transfer',
          type: PaymentsSourceTypes.bank,
        ),
        category: Category.others,
        repeat: false,
      ),
      Transaction(
        id: '3',
        description: 'Salary',
        amount: 5000.0,
        type: TransactionType.income,
        date: staticNow.subtract(const Duration(days: 6)),
        paymentSource: const PaymentSource(
          providerLogo: 'lib/core/assets/images/setup_wallet/chase-bank.png',
          balance: 10000.0,
          name: 'Bank Transfer',
          type: PaymentsSourceTypes.bank,
        ),
        category: Category.salary,
        repeat: false,
      ),
      Transaction(
        id: '4',
        description: 'Electricity Bill',
        amount: -100.0,
        type: TransactionType.expense,
        date: staticNow.subtract(const Duration(days: 7)),
        paymentSource: const PaymentSource(
          providerLogo: 'lib/core/assets/images/setup_wallet/visa.png',
          balance: 800.0,
          name: 'Credit Card',
          type: PaymentsSourceTypes.creditCard,
        ),
        category: Category.subscription,
        repeat: false,
      ),
      Transaction(
        id: '5',
        description: 'Internet Bill',
        amount: -60.0,
        type: TransactionType.expense,
        date: staticNow.subtract(const Duration(days: 90)),
        paymentSource: const PaymentSource(
          providerLogo: 'lib/core/assets/images/setup_wallet/visa.png',
          balance: 700.0,
          name: 'Credit Card',
          type: PaymentsSourceTypes.creditCard,
        ),
        category: Category.subscription,
        repeat: false,
      ),
      Transaction(
        id: '6',
        description: 'Dining Out',
        amount: -75.0,
        type: TransactionType.expense,
        date: staticNow.subtract(const Duration(days: 15)),
        paymentSource: const PaymentSource(
          providerLogo: 'lib/core/assets/images/setup_wallet/visa.png',
          balance: 600.0,
          name: 'Debit Card',
          type: PaymentsSourceTypes.creditCard,
        ),
        category: Category.food,
        repeat: false,
      ),
      Transaction(
        id: '7',
        description: 'Gym Membership',
        amount: -45.0,
        type: TransactionType.expense,
        date: staticNow.subtract(const Duration(days: 60)),
        paymentSource: const PaymentSource(
          providerLogo: 'lib/core/assets/images/setup_wallet/visa.png',
          balance: 500.0,
          name: 'Credit Card',
          type: PaymentsSourceTypes.creditCard,
        ),
        category: Category.subscription,
        repeat: false,
      ),
      Transaction(
        id: '8',
        description: 'Car Maintenance',
        amount: -300.0,
        type: TransactionType.expense,
        date: staticNow.subtract(const Duration(days: 120)),
        paymentSource: const PaymentSource(
          providerLogo: 'lib/core/assets/images/setup_wallet/chase-bank.png',
          balance: 4000.0,
          name: 'Bank Transfer',
          type: PaymentsSourceTypes.bank,
        ),
        category: Category.transport,
        repeat: false,
      ),
      Transaction(
        id: '9',
        description: 'Vacation',
        amount: -2000.0,
        type: TransactionType.expense,
        date: staticNow.subtract(const Duration(days: 180)),
        paymentSource: const PaymentSource(
          providerLogo: 'lib/core/assets/images/setup_wallet/visa.png',
          balance: 3000.0,
          name: 'Credit Card',
          type: PaymentsSourceTypes.creditCard,
        ),
        category: Category.others,
        repeat: false,
      ),
      Transaction(
        id: '10',
        description: 'Books',
        amount: -100.0,
        type: TransactionType.expense,
        date: staticNow.subtract(const Duration(days: 45)),
        paymentSource: const PaymentSource(
          providerLogo: 'lib/core/assets/images/setup_wallet/visa.png',
          balance: 200.0,
          name: 'Debit Card',
          type: PaymentsSourceTypes.creditCard,
        ),
        category: Category.others,
        repeat: false,
      ),
    ];

    return SafeArea(
      child: Scaffold(
          backgroundColor: AppColors.light,
          bottomNavigationBar: showBottomBar(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: showFloatingPlusButton(),
          body: showBody(transactions, staticNow)),
    );
  }

  //!---------- bottom bar-----------
  StatefulBuilder showBottomBar() {
    return StatefulBuilder(
      builder: (BuildContext context, setNavigationState) {
        return BottomNavigationBar(
          currentIndex: navigationIndex,
          onTap: (index) {
            setNavigationState(() {
              navigationIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'lib/core/assets/icons/Magicons/Glyph/User Interface/home.svg',
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
                'lib/core/assets/icons/Magicons/Glyph/Finance/pie-chart.svg',
                colorFilter: ColorFilter.mode(
                  navigationIndex != 2
                      ? AppColors.light20
                      : AppColors.violet100,
                  BlendMode.srcIn,
                ),
              ),
              label: 'Budget',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'lib/core/assets/icons/Magicons/Glyph/Ecommerce & Shopping/user.svg',
                colorFilter: ColorFilter.mode(
                  navigationIndex != 3
                      ? AppColors.light20
                      : AppColors.violet100,
                  BlendMode.srcIn,
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
      List<Transaction> transactions, DateTime staticNow) {
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
                Container(
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
              ],
            ),
          ),
          //!----------------- recent transactions -----------------
          transactions.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    heightSizedBox(100),
                    Text(
                      'No transactions yet',
                      style: TextStyles.darkW500.copyWith(fontSize: 24.sp),
                    ),
                  ],
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: transactions.length > 3 ? 3 : transactions.length,
                  itemBuilder: (BuildContext context, int index) {
                    final transaction = transactions[index];
                    return TransactionCard(transaction: transaction);
                  },
                ),
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
                  dialogShow = true;
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
                        color: AppColors.violet100.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  width: 56.w,
                  child: SvgPicture.asset(
                    // lib\core\assets\icons\Magicons\Glyph\User Interface\close.svg
                    dialogShow
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
      List<Transaction> transactions, DateTime staticNow) {
    return StatefulBuilder(
      builder: (BuildContext context, setSpendFrequencyDurationState) {
        List<FlSpot> spots = [];
        for (var e in transactions) {
          if ((staticNow.subtract(
            Duration(
              days: selectedDuration.durationToNumber(),
            ),
          )).isBefore(e.date)) {
            spots.add(
              FlSpot(spots.length.toDouble(), e.amount),
            );
          }
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
        barrierColor: AppColors.violet10.withOpacity(0.1),
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return PopScope(
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) {
                dialogShow = false;
                setShowDialogState(() {});
              }
            },
            child: GestureDetector(
              onTap: () {
                dialogShow = false;
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

  Container buildBalanceIncomeExpense(double balance) {
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
          Text(
            '\$${balance.toInt() == balance ? balance.toInt() : balance}',
            style: TextStyles.w600Dark75.copyWith(
              fontSize: 39.sp,
            ),
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
                        Text(
                          '\$5000',
                          style: TextStyles.w600Light80.copyWith(
                            fontSize: 22.sp,
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
                        Text(
                          '\$1200',
                          style: TextStyles.w600Light80.copyWith(
                            fontSize: 22.sp,
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
