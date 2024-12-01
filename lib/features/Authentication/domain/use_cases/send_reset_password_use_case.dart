import 'package:dartz/dartz.dart';
import 'package:op_expense/core/constants/app_constants.dart';
import 'package:op_expense/core/errors/failures.dart';
import 'package:op_expense/features/Authentication/domain/repositories/auth_repository.dart';

class SendResetPasswordUseCase {
  final AuthRepository repository;

  SendResetPasswordUseCase({required this.repository});

  Future<Either<Failures, Unit>> call(String email) async {
    if (email.isEmpty) {
      return left(const EmptyForgotPasswordFieldsFailure());
    } else if (AppConstants.emailRegExp.hasMatch(email) == false) {
      return left(const InvalidEmailResetPasswordFailure());
    } else {
      return await repository.sendResetPassword(email);
    }
  }
}
