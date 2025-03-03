import 'package:dartz/dartz.dart';
import 'package:op_expense/core/errors/failures.dart';
import 'package:op_expense/features/Authentication/domain/entities/account.dart';

abstract class AuthRepository {
  AuthRepository();

  Future<Either<Failures, Account>> signUpWithEmailPassword(
      {required String email, required String password, required String name});
  Future<Either<Failures, Account>> signUpWithGoogle();
  Future<Either<Failures, Account>> login(
      {required String email, required String password});
  Future<Either<Failures, Account>> getLoggedInAccount();
  Future<Either<Failures, Unit>> cacheAccount(Account account);
  Future<Either<Failures, Unit>> signOut();
  Future<Either<Failures, bool>> checkEmailVerification();
  Future<Either<Failures, Unit>> sendEmailVerification();
  Future<Either<Failures, Unit>> sendResetPassword(String email);

  Future<Either<Failures, Unit>> checkIfUserIsLoggedLocally();
}
