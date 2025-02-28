import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:op_expense/features/Authentication/domain/repositories/auth_repository.dart';

part 'send_email_verification_state.dart';

class SendEmailVerificationCubit extends Cubit<SendEmailVerificationState> {
  AuthRepository authRepository;
  SendEmailVerificationCubit({required this.authRepository})
      : super(SendEmailVerificationInitial());

  void sendEmailVerification() {
    emit(SendEmailVerificationLoading());
    authRepository.sendEmailVerification().then((result) {
      result.fold((fail) {
      
        emit(SendEmailVerificationFailure(message: fail.message));
      }, (_) {
        emit(SendEmailVerificationSuccess());
      });
    });
  }
}
