import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:op_expense/features/Authentication/domain/entities/account.dart';
import 'package:op_expense/features/main/domain/entities/transaction.dart';
import 'package:op_expense/features/main/domain/use_cases/add_transaction_use_case.dart';

part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final AddTransactionUseCase addTransactionUseCase;
  TransactionCubit({required this.addTransactionUseCase})
      : super(TransactionInitial());

  Future<void> addTransaction(
      {required Transaction transaction, required Account account}) async {
    emit(TransactionLoading());
    final result = await addTransactionUseCase.call(
        transaction: transaction, account: account);
    result.fold((failure) => emit(TransactionFailure(message: failure.message)),
        (success) {
      emit(TransactionSuccess());
    });
  }
}
