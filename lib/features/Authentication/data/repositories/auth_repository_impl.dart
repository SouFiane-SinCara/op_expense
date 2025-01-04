import 'package:dartz/dartz.dart';
import 'package:op_expense/core/errors/exceptions.dart';
import 'package:op_expense/core/errors/failures.dart';
import 'package:op_expense/features/Authentication/data/data_sources/auth_local_data_source.dart';
import 'package:op_expense/features/Authentication/data/data_sources/auth_remote_data_source.dart';
import 'package:op_expense/features/Authentication/data/models/account_model.dart';
import 'package:op_expense/features/Authentication/domain/entities/account.dart';
import 'package:op_expense/features/Authentication/domain/repositories/auth_repository.dart';
import 'package:op_expense/features/main/data/data_sources/main_remote_data_source.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;
  final MainRemoteDataSource mainRemoteDataSource;
  AuthRepositoryImpl(
      {required this.authRemoteDataSource,
      required this.authLocalDataSource,
      required this.mainRemoteDataSource});

  @override
  Future<Either<Failures, Account>> signUpWithEmailPassword(
      {required String email,
      required String password,
      required String name}) async {
    try {
      AccountModel account = await authRemoteDataSource.signUpWithEmailPassword(
          email: email, password: password, name: name);
      authLocalDataSource.cacheAccount(account);
      return right(account);
    } on NoInternetException {
      return left(const NoInternetFailure());
    } on GeneralFireStoreException {
      return left(const GeneralFireStoreFailure());
    } on EmailAlreadyInUseException {
      return left(const EmailAlreadyInUseFailure());
    } on InvalidEmailException {
      return left(const InvalidEmailSignUpFailure());
    } on WeakPasswordException {
      return left(const WeakPasswordFailure());
    } on OperationNotAllowedException {
      return left(const OperationNotAllowedFailure());
    } on UserDisabledException {
      return left(const UserDisabledFailure());
    } on TooManyRequestsException {
      return left(const TooManyRequestsFailure());
    } on UnknownAuthException {
      return left(const UnknownAuthFailure());
    } on HiveStorageException {
      return left(const HiveStorageFailure());
    } catch (e) {
      // Catch any unexpected exceptions and map them to UnknownAuthFailure
      return left(const UnknownAuthFailure());
    }
  }

  @override
  Future<Either<Failures, Account>> signUpWithGoogle() async {
    try {
      AccountModel account = await authRemoteDataSource.signUpWithGoogle();
      await authLocalDataSource.cacheAccount(account);

      return right(account);
    } on NoInternetException {
      return left(const NoInternetFailure());
    } on HiveStorageException {
      return left(const HiveStorageFailure());
    } catch (e) {
      return left(GeneralSignInWithGoogleFailure());
    }
  }

  @override
  Future<Either<Failures, Account>> login(
      {required String email, required String password}) async {
    try {
      AccountModel account =
          await authRemoteDataSource.login(email: email, password: password);
      return right(account);
    } on NoInternetException {
      return left(const NoInternetFailure());
    } on GeneralLoginFailure {
      return left(GeneralLoginFailure());
    } on InvalidEmailLoginException {
      return left(InvalidEmailLoginFailure());
    } on UserNotFoundLoginException {
      return left(UserNotFoundLoginFailure());
    } on WrongPasswordLoginException {
      return left(WrongPasswordLoginFailure());
    } on InvalidCredentialLoginException {
      return left(InvalidCredentialLoginFailure());
    } on UserDisabledException {
      return left(UserDisabledLoginFailure());
    } on TooManyRequestsException {
      return left(TooManyRequestsLoginFailure());
    } on UnknownAuthException {
      return left(UnknownLoginFailure());
    } on HiveStorageException {
      return left(const HiveStorageFailure());
    } catch (e) {
      return left(UnknownLoginFailure());
    }
  }

  @override
  Future<Either<Failures, Account>> getLoggedInAccount() async {
    try {
      AccountModel account = await authRemoteDataSource.getLoggedUserAccount();
      // check if there is any repeated transaction arrived while the user was offline and modify the account balance
      await mainRemoteDataSource.checkIfRepeatedTransactionsArrived(
          account: account);
      // Update the last login time
      await authRemoteDataSource.updateLastLogin(account: account);
      return right(account);
    } on NoAccountLoggedException {
      return left(const NoAccountLoggedFailure());
    } on NoInternetException {
      return left(const NoInternetFailure());
    } on GeneralFireStoreException {
      return left(const GeneralFireStoreFailure());
    } catch (e) {
      return left(const HiveStorageFailure());
    }
  }

  @override
  Future<Either<Failures, Unit>> cacheAccount(Account account) async {
    try {
      await authLocalDataSource.cacheAccount(AccountModel.fromAccount(account));
      return right(unit);
    } catch (e) {
      return left(const HiveStorageFailure());
    }
  }

  @override
  Future<Either<Failures, Unit>> signOut() async {
    try {
      await authRemoteDataSource.signOut();
      // Clear all local data maybe the user will login with a different account
      await authLocalDataSource.deleteAccount();
      return right(unit);
    } on NoInternetException {
      return left(const NoInternetFailure());
    } on HiveStorageException {
      return left(const HiveStorageFailure());
    } catch (e) {
      return left(const GeneralSignOutFailure());
    }
  }

  @override
  Future<Either<Failures, bool>> checkEmailVerification() async {
    try {
      bool isVerified = await authRemoteDataSource.checkEmailVerification();
      if (isVerified) authLocalDataSource.verifyEmail();
      return right(isVerified);
    } on NoInternetException {
      return left(const NoInternetFailure());
    } catch (e) {
      return left(const GeneralCheckEmailVerificationFailure());
    }
  }

  @override
  Future<Either<Failures, Unit>> sendEmailVerification() async {
    try {
      await authRemoteDataSource.sendEmailVerification();
      return right(unit);
    } on NoInternetException {
      return left(const NoInternetFailure());
    } on TooManyRequestsSendEmailVerificationException {
      return left(const TooManyRequestsSendEmailVerificationFailure());
    } catch (e) {
      return left(const GeneralSendEmailVerificationFailure());
    }
  }

  @override
  Future<Either<Failures, Unit>> sendResetPassword(String email) async {
    try {
      await authRemoteDataSource.sendResetPassword(email);
      return right(unit);
    } on NoInternetException {
      return left(const NoInternetFailure());
    } on UserNotFoundResetPasswordException {
      return left(const UserNotFoundResetPasswordFailure());
    } on TooManyRequestsResetPasswordException {
      return left(const TooManyRequestsResetPasswordFailure());
    } catch (e) {
      return left(const GeneralResetPasswordFailure());
    }
  }

  @override
  Future<Either<Failures, Unit>> checkIfUserIsLoggedLocally() async {
    try {
      await authLocalDataSource.checkIfUserIsLoggedLocally();
      return right(unit);
    } on NoAccountLoggedException {
      return left(const NoAccountLoggedFailure());
    } on HiveStorageException {
      return left(const HiveStorageFailure());
    } catch (e) {
      return left(const NoAccountLoggedFailure());
    }
  }
}
