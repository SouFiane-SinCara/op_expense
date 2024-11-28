part of 'sign_up_cubit.dart';

@immutable
sealed class SignUpState {}

final class SignUpInitial extends SignUpState {}

final class SignUpLoadingState extends SignUpState {}

final class SignUpWithEmailPasswordSuccessState extends SignUpState {
  final Account account;
  SignUpWithEmailPasswordSuccessState({required this.account});
}
final class SignUpWithGoogleSuccessState extends SignUpState {
  final Account account;
  SignUpWithGoogleSuccessState({required this.account});
}
final class SignUpFailureState extends SignUpState {
  final String message;
  SignUpFailureState({required this.message});
}
