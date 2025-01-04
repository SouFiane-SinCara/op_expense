import 'package:dartz/dartz.dart';
import 'package:op_expense/core/errors/exceptions.dart';
import 'package:op_expense/core/errors/failures.dart';
import 'package:op_expense/features/Authentication/domain/entities/account.dart';
import 'package:op_expense/features/main/data/data_sources/main_remote_data_source.dart';
import 'package:op_expense/features/main/data/models/payment_source_model.dart';
import 'package:op_expense/features/main/domain/entities/payment_source.dart';
import 'package:op_expense/features/main/domain/entities/transaction.dart';
import 'package:op_expense/features/main/domain/repositories/main_repository.dart';

class MainRepositoryImpl extends MainRepository {
  final MainRemoteDataSource mainRemoteDataSource;

  MainRepositoryImpl({
    required this.mainRemoteDataSource,
  });

  @override
  Future<Either<Failures, List<PaymentSource>>> getPaymentSources(
      {required Account account}) async {
    try {
      // get payment sources from remote data source
      List<PaymentSource> paymentSources;
      paymentSources =
          await mainRemoteDataSource.getPaymentSources(account: account);
      return right(paymentSources);
    } on NoInternetException {
      return left(const NoInternetFailure());
    } on NoPaymentSourcesException {
      return left(const NoPaymentSourcesFailure());
    } catch (e) {
      return left(const GeneralGetPaymentSourcesFailure());
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

      return right(unit);
    } on NoInternetException {
      throw const NoInternetFailure();
    } catch (e) {
      throw const GeneralAddNewPaymentSourceException();
    }
  }

  @override
  Future<Either<Failures, Unit>> addTransaction(
      {required Account account, required Transaction transaction}) async {
    try {
      await mainRemoteDataSource.addTransaction(
          account: account, transaction: transaction);
      return right(unit);
    } on NoInternetException {
      return left(const NoInternetFailure());
    } on FirebaseStorageException {
      return left(const FirebaseStorageFailure());
    } catch (e) {
      return left(const GeneralAddTransactionFailure());
    }
  }

  @override
  Future<Either<Failures, List<Transaction>>> getTransactions(
      {required Account account}) async {
    try {
      List<Transaction> transactions =
          await mainRemoteDataSource.getTransactions(account: account);
      return right(transactions);
    } on NoInternetException {
      return left(const NoInternetFailure());
    } on GeneralGetTransactionsException {
      return left(const GeneralGetTransactionsFailure());
    } catch (e) {
      return left(const GeneralGetTransactionsFailure());
    }
  }
}
