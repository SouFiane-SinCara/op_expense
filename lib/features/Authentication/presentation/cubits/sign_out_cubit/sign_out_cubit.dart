import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:op_expense/features/Authentication/domain/repositories/auth_repository.dart';
import 'package:op_expense/features/Authentication/presentation/cubits/authentication_cubit/authentication_cubit.dart';

part 'sign_out_state.dart';

class SignOutCubit extends Cubit<SignOutState> {
  final AuthRepository repository;
  final AuthenticationCubit authenticationCubit;
  SignOutCubit({required this.repository, required this.authenticationCubit})
      : super(SignOutInitial());

  Future<void> signOut() async {
    emit(SignOutLoading());
    final result = await repository.signOut();
    result.fold((fail) {
      emit(SignOutFailure(message: fail.message));
    }, (_) {
      emit(SignOutSuccess());
      authenticationCubit.unAuthenticate();
    });
  }
}
