part of 'check_email_verification_cubit.dart';

sealed class CheckEmailVerificationState extends Equatable {
  const CheckEmailVerificationState();

  @override
  List<Object> get props => [];
}

final class CheckEmailVerificationInitial extends CheckEmailVerificationState {}

final class CheckEmailVerificationLoading extends CheckEmailVerificationState {}

final class CheckEmailVerificationSuccess extends CheckEmailVerificationState {
  final bool isVerified;

  const CheckEmailVerificationSuccess({required this.isVerified});
}

final class CheckEmailVerificationFailure extends CheckEmailVerificationState {
  final String message;

  const CheckEmailVerificationFailure({required this.message});
}
