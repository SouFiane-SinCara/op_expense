import 'package:dartz/dartz.dart';
import 'package:op_expense/core/constants/app_constants.dart';
import 'package:op_expense/core/errors/failures.dart';
import 'package:op_expense/features/SignUp/domain/entities/account.dart';
import 'package:op_expense/features/SignUp/domain/repositories/sign_up_repository.dart';

class SignUpWithEmailPasswordUseCase {
  final SignUpRepository signUpRepository;
  SignUpWithEmailPasswordUseCase({required this.signUpRepository});
  Future<Either<SignUpFailures, Account>> call({
    required String email,
    required String password,
    required String name,
    required bool isAcceptedTerms,
  }) async {
    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      return left(EmptyFieldsFailure());
    } else if (name.length > 15) {
      return left(const UsernameTooLongFailure());
    } else if (!AppConstants.nameValidationRegExp.hasMatch(name)) {
      return left(const InvalidUsernameFailure());
    } else if (!isAcceptedTerms) {
      return left(DeclinedTermsAndConditionsFailure());
    }
    return await signUpRepository.signUpWithEmailPassword(
        email: email, password: password, name: name);
  }
}
