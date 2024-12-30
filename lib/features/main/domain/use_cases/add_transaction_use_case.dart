import 'package:dartz/dartz.dart';
import 'package:op_expense/core/errors/failures.dart';
import 'package:op_expense/features/Authentication/domain/entities/account.dart';
import 'package:op_expense/features/main/domain/entities/transaction.dart';
import 'package:op_expense/features/main/domain/repositories/main_repository.dart';

class AddTransactionUseCase {
  final MainRepository mainRepository;

  AddTransactionUseCase({required this.mainRepository});
  Future<Either<Failures, Unit>> call(
      {required Transaction transaction, required Account account}) async {
    if (transaction.category == null) {
      return const Left(CategoryUnselectedFailure());
    } else if (transaction.paymentSource == null) {
      return const Left(PaymentSourceUnselectedFailure());
    } else if (transaction.amount == 0) {
      return const Left(ZeroAmountFailure());
    } else {
      return await mainRepository.addTransaction(
          transaction: transaction, account: account);
    }
  }
}
