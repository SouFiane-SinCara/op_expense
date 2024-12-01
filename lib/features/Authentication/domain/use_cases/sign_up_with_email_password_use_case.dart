import 'package:dartz/dartz.dart';
import 'package:op_expense/core/constants/app_constants.dart';
import 'package:op_expense/core/errors/failures.dart';
import 'package:op_expense/features/Authentication/domain/entities/account.dart';
import 'package:op_expense/features/Authentication/domain/repositories/auth_repository.dart';

class SignUpWithEmailPasswordUseCase {
  final AuthRepository authRepository;
  SignUpWithEmailPasswordUseCase({required this.authRepository});
  Future<Either<Failures, Account>> call({
    required String email,
    required String password,
    required String name,
    required bool isAcceptedTerms,
  }) async {
    if (email.trim().isEmpty || password.isEmpty || name.trim().isEmpty) {
      return left(EmptySignUpFieldsFailure());
    } else if (name.length > 15) {
      return left(const UsernameTooLongFailure());
    } else if (AppConstants.nameValidationRegExp.hasMatch(name.trim())) {
      return left(const InvalidUsernameFailure());
    } else if (!isAcceptedTerms) {
      return left(DeclinedTermsAndConditionsFailure());
    } else if (AppConstants.emailRegExp.hasMatch(email) == false) {
      return left(const InvalidEmailSignUpFailure());
    }
    return await authRepository.signUpWithEmailPassword(
        email: email, password: password, name: name);
  }
}
