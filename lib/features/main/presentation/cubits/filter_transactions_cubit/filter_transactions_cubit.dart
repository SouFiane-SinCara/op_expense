import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:op_expense/features/main/domain/entities/transaction.dart';
import 'package:op_expense/features/main/domain/use_cases/filter_transactions_use_case.dart';
import 'package:op_expense/features/main/presentation/screens/transactions_screen.dart';

part 'filter_transactions_state.dart';

class FilterTransactionsCubit extends Cubit<FilterTransactionsState> {
  final FilterTransactionsUseCase filterTransactionsUseCase;
  FilterTransactionsCubit({required this.filterTransactionsUseCase})
      : super(FilterTransactionsInitial());

  void filterTransactions({
    required TransactionType? chosenTransactionsType,
    required SortType chosenSortType,
    required List<Category> chosenCategories,
    required List<Transaction> transactions,
  }) {
    emit(FilterTransactionsLoading());
    emit(TransactionFilteredSuccess(
        transactions: filterTransactionsUseCase(
            chosenTransactionsType: chosenTransactionsType,
            chosenSortType: chosenSortType,
            chosenCategories: chosenCategories,
            transactions: transactions)));
  }
}
