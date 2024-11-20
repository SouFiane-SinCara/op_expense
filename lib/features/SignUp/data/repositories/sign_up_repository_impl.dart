import 'package:dartz/dartz.dart';
import 'package:op_expense/core/errors/exceptions.dart';
import 'package:op_expense/core/errors/failures.dart';
import 'package:op_expense/features/SignUp/domain/entities/account.dart';
import 'package:op_expense/features/SignUp/domain/repositories/sign_up_repository.dart';

class SignUpRepositoryImpl extends SignUpRepository {
  SignUpRepositoryImpl({required super.signUpRemoteDataSource});

  @override
  Future<Either<SignUpFailures, Account>> signUpWithEmailPassword(
      {required String email,
      required String password,
      required String name}) async {
    try {
      Account account = await signUpRemoteDataSource.signUpWithEmailPassword(
          email: email, password: password, name: name);
      return right(account);
    } on GeneralFireStoreException {
   
      return left(const GeneralFireStoreFailure());
    } on EmailAlreadyInUseException {
      return left(const EmailAlreadyInUseFailure());
    } on InvalidEmailException {
      return left(const InvalidEmailFailure());
    } on WeakPasswordException {
      return left(const WeakPasswordFailure());
    } on OperationNotAllowedException {
      return left(const OperationNotAllowedFailure());
    } on UserDisabledException {
      return left(const UserDisabledFailure());
    } on UserNotFoundException {
      return left(const UserNotFoundFailure());
    } on WrongPasswordException {
      return left(const WrongPasswordFailure());
    } on TooManyRequestsException {
      return left(const TooManyRequestsFailure());
    } on UnknownAuthException {
      return left(const UnknownAuthFailure());
    } catch (e) {
      // Catch any unexpected exceptions and map them to UnknownAuthFailure
      return left(const UnknownAuthFailure());
    }
  }
}
