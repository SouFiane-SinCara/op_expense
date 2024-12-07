import 'package:dartz/dartz.dart';
import 'package:op_expense/core/errors/failures.dart';
import 'package:op_expense/features/Authentication/domain/entities/account.dart';
import 'package:op_expense/features/main/domain/entities/payment_source.dart';

abstract class MainRepository {
  Future<Either<Failures, List<PaymentSource>>> getPaymentSources(
      {required Account account});
  Future<Either<Failures, Unit>> addNewPaymentSource(
      {required Account account, required PaymentSource paymentSource});
}
