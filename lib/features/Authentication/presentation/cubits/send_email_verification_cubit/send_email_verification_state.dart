part of 'send_email_verification_cubit.dart';

sealed class SendEmailVerificationState extends Equatable {
  const SendEmailVerificationState();

  @override
  List<Object> get props => [];
}

final class SendEmailVerificationInitial extends SendEmailVerificationState {}

final class SendEmailVerificationSuccess extends SendEmailVerificationState {}

final class SendEmailVerificationFailure extends SendEmailVerificationState {
  final String message;

  const SendEmailVerificationFailure({required this.message});
}

final class SendEmailVerificationLoading extends SendEmailVerificationState {}
