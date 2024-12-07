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
    // try to get payment sources from local data source if it fails get it from remote data source
    try {
      List<PaymentSourceModel> paymentSources =
          await mainLocalDataSource.getPaymentSources();
          
      return right(paymentSources);
    } catch (e) {
      // after failing to get payment sources from local data source try to get it from remote data source
      try {
        // get payment sources from remote data source
        List<PaymentSourceModel> paymentSources;

        paymentSources =
            await mainRemoteDataSource.getPaymentSources(account: account);
        // after getting payment sources from remote data source store it in local data source for future use
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

  @override
  Future<Either<Failures, Unit>> addNewPaymentSource(
      {required Account account, required PaymentSource paymentSource}) async {
    try {
      PaymentSourceModel paymentSourceModel =
          PaymentSourceModel.fromEntity(paymentSource);
      await mainRemoteDataSource.addNewPaymentSource(
          account: account, paymentSource: paymentSourceModel);
      mainLocalDataSource.addNewPaymentSource(
          paymentSource: paymentSourceModel);
      return right(unit);
    } on NoInternetException {
      throw const NoInternetFailure();
    } catch (e) {
      throw const GeneralAddNewPaymentSourceException();
    }
  }
}
