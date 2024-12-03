import 'package:dartz/dartz.dart';
import 'package:op_expense/core/errors/exceptions.dart';
import 'package:op_expense/core/errors/failures.dart';
import 'package:op_expense/features/Authentication/domain/entities/account.dart';
import 'package:op_expense/features/main/data/data_sources/main_local_data_source.dart';
import 'package:op_expense/features/main/data/data_sources/main_remote_data_source.dart';
import 'package:op_expense/features/main/data/models/payment_source_model.dart';
import 'package:op_expense/features/main/domain/entities/payment_source.dart';
import 'package:op_expense/features/main/domain/repositories/main_repository.dart';

class MainRepositoryImpl extends MainRepository {
  final MainRemoteDataSource mainRemoteDataSource;
  final MainLocalDataSource mainLocalDataSource;
  MainRepositoryImpl(
      {required this.mainRemoteDataSource, required this.mainLocalDataSource});

  @override
  Future<Either<Failures, List<PaymentSource>>> getPaymentSources(
      {required Account account}) async {
    try {
      List<PaymentSourceModel> paymentSources =
          await mainLocalDataSource.getPaymentSources();
      if (paymentSources.isNotEmpty) return right(paymentSources);

      paymentSources =
          await mainRemoteDataSource.getPaymentSources(account: account);
      await mainLocalDataSource.storagePaymentSources(
          paymentSources: paymentSources);
      return right(paymentSources);
    } on NoInternetException {
      return left(const NoInternetFailure());
    } on NoPaymentSourcesException {
      return left(const NoPaymentSourcesFailure());
    } catch (e) {
      return left(const GeneralGetPaymentSourcesFailure());
    }
  }
}
