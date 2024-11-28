import 'package:dartz/dartz.dart';
import 'package:op_expense/core/errors/failures.dart';
import 'package:op_expense/features/Authentication/data/data_sources/auth_local_data_source.dart';
import 'package:op_expense/features/Authentication/data/data_sources/auth_remote_data_source.dart';
import 'package:op_expense/features/Authentication/domain/entities/account.dart';

abstract class AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  AuthRepository(
      {required this.authRemoteDataSource, required this.authLocalDataSource});
  Future<Either<Failures, Account>> signUpWithEmailPassword(
      {required String email, required String password, required String name});
  Future<Either<Failures, Account>> signUpWithGoogle();

  Future<Either<Failures, Account>> login(
      {required String email, required String password});
  Future<Either<Failures, Account>> getLoggedInAccount();
  Future<Either<Failures, Unit>> cacheAccount(Account account);
}
