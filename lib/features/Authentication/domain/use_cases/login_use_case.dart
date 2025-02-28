import 'package:dartz/dartz.dart';
import 'package:op_expense/core/constants/app_constants.dart';
import 'package:op_expense/core/errors/failures.dart';
import 'package:op_expense/features/Authentication/domain/entities/account.dart';
import 'package:op_expense/features/Authentication/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository authRepository;

  LoginUseCase({required this.authRepository});

  Future<Either<Failures, Account>> login(
      {required String email, required String password}) async {
    if (email.trim().isEmpty || password.isEmpty) {
      return left(EmptyLoginFieldsFailure());
    } else if (AppConstants.emailRegExp.hasMatch(email) == false) {
      return left(InvalidEmailLoginFailure());
    }
    return await authRepository.login(email: email, password: password);
  }
}
