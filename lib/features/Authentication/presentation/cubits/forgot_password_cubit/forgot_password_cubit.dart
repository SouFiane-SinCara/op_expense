import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:op_expense/features/Authentication/domain/use_cases/send_reset_password_use_case.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final SendResetPasswordUseCase sendResetPasswordUseCase;
  ForgotPasswordCubit({required this.sendResetPasswordUseCase})
      : super(ForgotPasswordInitial());

  Future<void> sendResetPassword(String email) async {
    emit(ForgotPasswordLoading());
    final result = await sendResetPasswordUseCase(email);
    result.fold(
      (failure) => emit(ForgotPasswordFailure(message: failure.message)),
      (_) => emit(ForgotPasswordSuccess()),
    );
  }
}
