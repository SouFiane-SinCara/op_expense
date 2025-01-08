import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:op_expense/core/helpers/sized_boxes.dart';
import 'package:op_expense/core/services/dependency_injection.dart';
import 'package:op_expense/core/theme/app_colors.dart';
import 'package:op_expense/core/theme/text_styles.dart';
import 'package:op_expense/core/widgets/primary_button.dart';
import 'package:op_expense/features/main/domain/entities/transaction.dart';
import 'package:op_expense/features/main/presentation/cubits/filter_transactions_cubit/filter_transactions_cubit.dart';
import 'package:op_expense/features/main/presentation/cubits/transaction_cubit/transaction_cubit.dart';
import 'package:op_expense/features/main/presentation/widgets/transaction_card.dart';

class TransactionsHaveSameDay {
  final List<Transaction> transactions;
  final String day;
  TransactionsHaveSameDay({
    required this.transactions,
    required this.day,
  });
}

enum SortType { newest, oldest }

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  TransactionType? filterTransactionType;
  SortType sortType = SortType.newest;
  List<Category> filterCategories = [];
  late FilterTransactionsCubit filterTransactionsCubit;
  @override
  Widget build(BuildContext context) {
    filterTransactionsCubit = sl<FilterTransactionsCubit>();
    return BlocProvider(
      create: (context) => filterTransactionsCubit,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.light,
          body: BlocBuilder<TransactionCubit, TransactionState>(
              builder: (context, transactionState) {
            List<Transaction> transactions = [];
            if (transactionState is TransactionSuccess) {
              transactions = transactionState.transactions;
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  heightSizedBox(20),
                  //!--------- app bar---------
                  Container(
                    height: 50.h,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //!----------- See artificial intelligence suggestion button ----------
                        Expanded(
                          child: Container(
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: AppColors.violet20,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'See artificial intelligence suggestion',
                                    style: TextStyles.w500Violet100,
                                  ),
                                ),
                                //lib\core\assets\icons\Magicons\Glyph\Arrow\arrow-right-2.svg
                                SvgPicture.asset(
                                  'lib/core/assets/icons/Magicons/Glyph/Arrow/arrow-right-2.svg',
                                  height: 32.h,
                                  colorFilter: const ColorFilter.mode(
                                      AppColors.violet100, BlendMode.srcIn),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //!------------ filter icon---------------
                        GestureDetector(
                          onTap: () {
                            showFilterOptions(context, transactions);
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 2.w),
                            child: SvgPicture.asset(
                              'lib/core/assets/icons/Magicons/Glyph/User Interface/sort.svg',
                              height: 30.h,
                              colorFilter: const ColorFilter.mode(
                                  AppColors.dark, BlendMode.srcIn),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  heightSizedBox(20),
                  //!---------- transactions----------
                  BlocBuilder<FilterTransactionsCubit, FilterTransactionsState>(
                    builder: (context, filterTransactionsState) {
                      List<Transaction> shownTransactions =
                          filterTransactionsState is TransactionFilteredSuccess
                              ? filterTransactionsState.transactions
                              : transactions;
                      return Column(
                        children: shownTransactions
                            .groupTransactionsByDate()
                            .map((transactions) => Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      heightSizedBox(20),
                                      //!---------- day----------
                                      Text(
                                        transactions.day,
                                        style: TextStyles.w600Dark
                                            .copyWith(fontSize: 18.sp),
                                      ),
                                      //!---------- transactions----------
                                      Column(
                                        children: transactions.transactions
                                            .map((transaction) =>
                                                TransactionCard(
                                                  transaction: transaction,
                                                ))
                                            .toList(),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      );
                    },
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Future<dynamic> showFilterOptions(
      BuildContext context, List<Transaction> transactions) {
    return showDialog(
      barrierColor: AppColors.violet10.withAlpha((0.1 * 255).toInt()),
      barrierDismissible: true,
      context: context,
      builder: (context) => BlocProvider.value(
        value: filterTransactionsCubit,
        child: Stack(
          children: [
            Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: Container(
                color: AppColors.light,
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 20.h,
                ),
                child: StatefulBuilder(
                  builder: (context, resetState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //!-------- small divider line---------
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            width: 40.w,
                            height: 4.h,
                            decoration: BoxDecoration(
                              color: AppColors.violet40,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        ),
                        heightSizedBox(20),
                        //!-------- filter transaction text---------
                        Row(
                          children: [
                            Text(
                              'Filter Transaction',
                              style:
                                  TextStyles.w600Dark.copyWith(fontSize: 18.sp),
                            ),
                            const Spacer(),
                            //!-------- reset button---------
                            GestureDetector(
                              onTap: () {
                                // reset the filter
                                resetState(() {
                                  filterTransactionType = null;
                                  sortType = SortType.newest;
                                  filterCategories = [];
                                });
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
                                  'Reset',
                                  style: TextStyles.w500Violet100.copyWith(
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        heightSizedBox(20),
                        //!-------- filter by transaction type expense or income ---------
                        Text(
                          'Filter By',
                          style: TextStyles.w600Dark.copyWith(fontSize: 18.sp),
                        ),
                        //!-------- transaction type grid view ---------
                        StatefulBuilder(
                          builder:
                              (BuildContext context, setTransactionTypeFilter) {
                            return GridView.builder(
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 5 / 2,
                              ),
                              itemCount: TransactionType.values.length,
                              itemBuilder: (BuildContext context, int index) {
                                bool isSelected = filterTransactionType ==
                                    TransactionType.values[index];
                                return GestureDetector(
                                  onTap: () {
                                    setTransactionTypeFilter(() {
                                      // if the selected transaction type is the same as the previous one, reset the filter
                                      filterTransactionType ==
                                              TransactionType.values[index]
                                          ? filterTransactionType = null
                                          : filterTransactionType =
                                              TransactionType.values[index];
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 5.w,
                                    ),
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 5.w,
                                      vertical: 5.h,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.light40,
                                        width: 2,
                                      ),
                                      color: isSelected
                                          ? AppColors.violet20
                                          : AppColors.light,
                                      borderRadius: BorderRadius.circular(24.r),
                                    ),
                                    alignment: Alignment.center,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        TransactionType.values[index].name,
                                        style: isSelected
                                            ? TextStyles.w500Violet100
                                            : TextStyles.w500Dark
                                                .copyWith(fontSize: 14.sp),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        heightSizedBox(20),

                        //!-------- sort by newest or oldest ---------
                        Text('Sort By',
                            style:
                                TextStyles.w600Dark.copyWith(fontSize: 18.sp)),
                        StatefulBuilder(
                          builder: (BuildContext context, setSortType) {
                            return GridView.builder(
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 5 / 2,
                              ),
                              itemCount: SortType.values.length,
                              itemBuilder: (BuildContext context, int index) {
                                bool isSelected =
                                    sortType == SortType.values[index];
                                return GestureDetector(
                                  onTap: () {
                                    setSortType(() {
                                      sortType = SortType.values[index];
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 5.w,
                                    ),
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 5.w,
                                      vertical: 5.h,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.light40,
                                        width: 2,
                                      ),
                                      color: isSelected
                                          ? AppColors.violet20
                                          : AppColors.light,
                                      borderRadius: BorderRadius.circular(24.r),
                                    ),
                                    alignment: Alignment.center,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        SortType.values[index].name,
                                        style: isSelected
                                            ? TextStyles.w500Violet100
                                            : TextStyles.w500Dark
                                                .copyWith(fontSize: 14.sp),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        heightSizedBox(20),
                        //!-------- category filter ---------
                        Text('Category',
                            style:
                                TextStyles.w600Dark.copyWith(fontSize: 18.sp)),
                        StatefulBuilder(
                          builder: (BuildContext context, setCategoryFilter) {
                            return GridView.builder(
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 5 / 2,
                              ),
                              itemCount: Category.values.length,
                              itemBuilder: (BuildContext context, int index) {
                                bool isSelected = filterCategories
                                    .contains(Category.values[index]);

                                return GestureDetector(
                                  onTap: () {
                                    setCategoryFilter(() {
                                      // if the selected category is the same as the previous one, remove it from the filter
                                      filterCategories
                                              .contains(Category.values[index])
                                          ? filterCategories
                                              .remove(Category.values[index])
                                          : filterCategories
                                              .add(Category.values[index]);
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 5.w,
                                    ),
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 5.w,
                                      vertical: 5.h,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.light40,
                                        width: 2,
                                      ),
                                      color: isSelected
                                          ? AppColors.violet20
                                          : AppColors.light,
                                      borderRadius: BorderRadius.circular(24.r),
                                    ),
                                    alignment: Alignment.center,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        Category.values[index].name,
                                        style: isSelected
                                            ? TextStyles.w500Violet100
                                            : TextStyles.w500Dark
                                                .copyWith(fontSize: 14.sp),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        heightSizedBox(20),
                        //!-----------------Apply button ----------------
                        PrimaryButton(
                            height: 55.h,
                            text: 'Apply',
                            onPressed: () {
                              Navigator.of(context).pop();
                              context
                                  .read<FilterTransactionsCubit>()
                                  .filterTransactions(
                                    transactions: transactions,
                                    chosenTransactionsType:
                                        filterTransactionType,
                                    chosenSortType: sortType,
                                    chosenCategories: filterCategories,
                                  );
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
    );
  }
}
