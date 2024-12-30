import 'package:dartz/dartz.dart';
import 'package:op_expense/core/errors/failures.dart';
import 'package:op_expense/features/Authentication/domain/entities/account.dart';
import 'package:op_expense/features/main/domain/entities/payment_source.dart';
import 'package:op_expense/features/main/domain/entities/transaction.dart';

abstract class MainRepository {
  Future<Either<Failures, List<PaymentSource>>> getPaymentSources(
      {required Account account});
  Future<Either<Failures, Unit>> addNewPaymentSource(
      {required Account account, required PaymentSource paymentSource});
  Future<Either<Failures, Unit>> addTransaction(
      {required Account account, required Transaction transaction});
      
}
