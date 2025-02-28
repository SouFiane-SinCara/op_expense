import 'package:dartz/dartz.dart';
import 'package:op_expense/core/errors/failures.dart';
import 'package:op_expense/features/Authentication/domain/entities/account.dart';
import 'package:op_expense/features/main/domain/entities/transaction.dart';
import 'package:op_expense/features/main/domain/repositories/main_repository.dart';

class GetTransactionsUseCase {
  final MainRepository mainRepository;

  GetTransactionsUseCase({required this.mainRepository});

  Future<Either<Failures, List<Transaction>>> call(
      {required Account account}) async {
    final result = await mainRepository.getTransactions(account: account);
    return result.fold((failure) {
      return left(failure);
    }, (transactions) {
      // Filter transactions that are current or passed transactions to return it because there is some transactions that are in the future created from the repeat transaction feature
      List<Transaction> currentOrPassedTransactions = [];
      for (var element in transactions) {
        
        if (element.createAt.isBefore(DateTime.now())) {
          currentOrPassedTransactions.add(element);
        }
      }
      // Sort the transactions by the createAt field in descending order
      currentOrPassedTransactions
          .sort((a, b) => b.createAt.compareTo(a.createAt));

      return right(currentOrPassedTransactions);
    });
  }
}
