import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:op_expense/features/Authentication/domain/entities/account.dart';
import 'package:op_expense/features/Authentication/domain/repositories/auth_repository.dart';
import 'package:op_expense/features/Authentication/domain/use_cases/login_use_case.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginUseCase loginUseCase;
  AuthRepository authRepository;
  LoginCubit({required this.loginUseCase, required this.authRepository})
      : super(LoginInitial());

  void login({required String email, required String password}) {
    emit(LoginLoadingState());
    loginUseCase.login(email: email, password: password).then((result) {
      result.fold((fail) {
        print("fail: $fail");
        emit(LoginFailureState(message: fail.message));
      }, (account) async {
        emit(
          LoginSuccessState(account: account),
        );
        await authRepository.cacheAccount(account);
      });
    });
  }

  Future getLoggedInAccount() async {
    emit(LoginLoadingState());
    await authRepository.getLoggedInAccount().then((result) {
      result.fold(
        (fail) {
          emit(LoginInitial());
        },
        (account) => emit(
          LoginSuccessState(account: account),
        ),
      );
    });
  }
}
