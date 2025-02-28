import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:op_expense/features/Authentication/domain/entities/account.dart';
import 'package:op_expense/features/main/domain/entities/transaction.dart';
import 'package:op_expense/features/main/domain/repositories/main_repository.dart';
import 'package:op_expense/features/main/domain/use_cases/add_transaction_use_case.dart';
import 'package:op_expense/features/main/domain/use_cases/get_transactions_use_case.dart';

part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final AddTransactionUseCase addTransactionUseCase;
  final GetTransactionsUseCase getTransactionsUseCase;
  final MainRepository mainRepository;
  List<Transaction> transactions = [];
  TransactionCubit(
      {required this.addTransactionUseCase,
      required this.mainRepository,
      required this.getTransactionsUseCase})
      : super(TransactionInitial());

  Future<void> addTransaction(
      {required Transaction transaction, required Account account}) async {
    emit(TransactionLoading());
    final result =
        await addTransactionUseCase(transaction: transaction, account: account);
    result.fold((failure) => emit(TransactionFailure(message: failure.message)),
        (success) async {
      await getTransactions(account: account);
    });
  }

  Future getTransactions({required Account account}) async {
    emit(TransactionLoading());
    final result = await getTransactionsUseCase(account: account);
    return result.fold((failure) {
      emit(TransactionFailure(message: failure.message));
    }, (transactions) {
      this.transactions = transactions;
      emit(TransactionSuccess(transactions: transactions));
    });
  }

  Future<void> deleteTransaction(
      {required Transaction transaction, required Account account}) async {
    emit(TransactionLoading());
    final result = await mainRepository.deleteTransaction(
        account: account, transaction: transaction);
    result.fold((failure) => emit(TransactionFailure(message: failure.message)),
        (success) async {
      transactions.removeWhere((element) => element.id == transaction.id);
      emit(TransactionSuccess(transactions: transactions));
    });
  }
}
