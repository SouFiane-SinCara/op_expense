import 'package:dartz/dartz.dart';
import 'package:op_expense/core/errors/failures.dart';
import 'package:op_expense/features/Authentication/domain/entities/account.dart';
import 'package:op_expense/features/main/domain/entities/payment_source.dart';
import 'package:op_expense/features/main/domain/repositories/main_repository.dart';

class AddNewPaymentSourceUseCase {
  final MainRepository mainRepository;

  AddNewPaymentSourceUseCase({required this.mainRepository});

  Future<Either<Failures, Unit>> call(
      {required Account account, required PaymentSource paymentSource}) async {
    if (paymentSource.name.isEmpty) {
      return const Left(EmptyNameAddNewPaymentSourceFailure());
    } else if (paymentSource.type == null) {
      return left(const PaymentSourceTypeNotSelectedFailure());
    } else if (paymentSource.providerLogo == null) {
      return left(const ProviderLogoNotSelectedFailure());
    } else {
      return await mainRepository.addNewPaymentSource(
          account: account, paymentSource: paymentSource);
    }
  }
}
