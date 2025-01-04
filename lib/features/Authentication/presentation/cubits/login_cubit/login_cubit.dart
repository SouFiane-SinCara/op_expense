import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:op_expense/features/Authentication/domain/entities/account.dart';
import 'package:op_expense/features/Authentication/domain/repositories/auth_repository.dart';
import 'package:op_expense/features/Authentication/domain/use_cases/login_use_case.dart';
import 'package:op_expense/features/Authentication/presentation/cubits/authentication_cubit/authentication_cubit.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginUseCase loginUseCase;
  AuthRepository authRepository;
  AuthenticationCubit authenticationCubit;

  LoginCubit(
      {required this.loginUseCase,
      required this.authRepository,
      required this.authenticationCubit})
      : super(LoginInitial());

  void login({required String email, required String password}) {
    emit(LoginLoadingState());
    loginUseCase.login(email: email, password: password).then((result) {
      result.fold((fail) {
        emit(LoginFailureState(message: fail.message));
      }, (account) async {
        authenticationCubit.authenticate(account);
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
      result.fold((fail) {
        emit(LoginFailureState(message: fail.message));
      }, (account) {
        authenticationCubit.authenticate(account);
        emit(
          LoginSuccessState(account: account),
        );
      });
    });
  }

  Future checkIfUserIsLogged() async {
    await authRepository.checkIfUserIsLoggedLocally().then((result) {
      result.fold((fail) {
        emit(LoginFailureState(message: fail.message));
      }, (unit) {
        emit(LoginSuccessState(account: const Account.empty()));
      });
    });
  }
}
