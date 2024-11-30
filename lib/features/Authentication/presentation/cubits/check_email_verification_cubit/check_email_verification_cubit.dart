import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:op_expense/features/Authentication/domain/repositories/auth_repository.dart';

part 'check_email_verification_state.dart';

class CheckEmailVerificationCubit extends Cubit<CheckEmailVerificationState> {
  final AuthRepository repository;

  CheckEmailVerificationCubit({
    required this.repository,
  }) : super(CheckEmailVerificationInitial());

  Future<void> checkEmailVerification() async {
    emit(CheckEmailVerificationLoading());
    final result = await repository.checkEmailVerification();
    result.fold((fail) {
      emit(CheckEmailVerificationFailure(message: fail.message));
    }, (isVerified) {
      emit(CheckEmailVerificationSuccess(isVerified: isVerified));
    });
  }
}
