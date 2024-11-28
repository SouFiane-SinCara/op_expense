import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:op_expense/core/errors/failures.dart';
import 'package:op_expense/features/Authentication/domain/entities/account.dart';
import 'package:op_expense/features/Authentication/domain/repositories/auth_repository.dart';
import 'package:op_expense/features/Authentication/domain/use_cases/sign_up_with_email_password_use_case.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final SignUpWithEmailPasswordUseCase signUpUseCase;
  final AuthRepository authRepository;
  SignUpCubit({required this.signUpUseCase, required this.authRepository})
      : super(SignUpInitial()) {
    print("created signup cubit");
  }
  @override
  Future<void> close() {
    print("closed signup cubit");
    return super.close();
  }

  void signUpWithEmailPassword(
      {required String email,
      required String password,
      required String name,
      required bool isAcceptedTerms}) async {
    emit(SignUpLoadingState());
    Either<Failures, Account> result = await signUpUseCase(
      email: email,
      password: password,
      name: name,
      isAcceptedTerms: isAcceptedTerms,
    );
    result.fold(
      (fail) => emit(
        SignUpFailureState(message: fail.message),
      ),
      (account) => emit(
        SignUpWithEmailPasswordSuccessState(account: account),
      ),
    );
  }

  Future<void> signUpWithGoogle() async {
    Either<Failures, Account> result =
        await authRepository.signUpWithGoogle();
    result.fold(
      (fail) => emit(
        SignUpFailureState(message: fail.message),
      ),
      (account) => emit(
        SignUpWithGoogleSuccessState(account: account),
      ),
    );
  }
}
