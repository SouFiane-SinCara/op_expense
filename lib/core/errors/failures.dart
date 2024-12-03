abstract class Failures {
  final String message;
  const Failures({required this.message});
}

class NoInternetFailure extends Failures {
  const NoInternetFailure() : super(message: 'No internet connection.');
}

abstract class SignUpFailures extends Failures {
  const SignUpFailures({required super.message});
}

abstract class FirebaseAuthFailures extends SignUpFailures {
  const FirebaseAuthFailures({required super.message});
}

class DeclinedTermsAndConditionsFailure extends SignUpFailures {
  DeclinedTermsAndConditionsFailure()
      : super(message: 'You must accept the terms and conditions to proceed.');
}

class GeneralSignInWithGoogleFailure extends SignUpFailures {
  GeneralSignInWithGoogleFailure()
      : super(message: 'An unknown google authentication error. try again.');
}

class EmptySignUpFieldsFailure extends SignUpFailures {
  EmptySignUpFieldsFailure()
      : super(
            message:
                'All fields are required. Please fill out all the fields and try again.');
}

class InvalidUsernameFailure extends SignUpFailures {
  const InvalidUsernameFailure()
      : super(message: "Username can only contain letters and numbers.");
}

class GeneralFireStoreFailure extends SignUpFailures {
  const GeneralFireStoreFailure()
      : super(
            message:
                "An unknown authentication error occurred. Please try again.");
}

class EmailAlreadyInUseFailure extends FirebaseAuthFailures {
  const EmailAlreadyInUseFailure()
      : super(
            message:
                "The email address is already in use. Please try another one.");
}

class UsernameTooLongFailure extends SignUpFailures {
  const UsernameTooLongFailure()
      : super(message: "Username cannot exceed 15 characters.");
}

class InvalidEmailSignUpFailure extends FirebaseAuthFailures {
  const InvalidEmailSignUpFailure()
      : super(
            message:
                "The email address provided is invalid. Please check and try again.");
}

class WeakPasswordFailure extends FirebaseAuthFailures {
  const WeakPasswordFailure()
      : super(
            message:
                "The password provided is too weak. Please use a stronger password.");
}

class OperationNotAllowedFailure extends FirebaseAuthFailures {
  const OperationNotAllowedFailure()
      : super(
            message: "This operation is not allowed. Please contact support.");
}

class UserDisabledFailure extends FirebaseAuthFailures {
  const UserDisabledFailure()
      : super(
            message:
                "The user account has been disabled. Please contact support.");
}

class TooManyRequestsFailure extends FirebaseAuthFailures {
  const TooManyRequestsFailure()
      : super(
            message:
                "Too many requests have been made. Please wait and try again later.");
}

class UnknownAuthFailure extends FirebaseAuthFailures {
  const UnknownAuthFailure()
      : super(
            message:
                "An unknown authentication error occurred. Please try again.");
}

abstract class LoginFailures extends Failures {
  LoginFailures({required super.message});
}

class EmptyLoginFieldsFailure extends LoginFailures {
  EmptyLoginFieldsFailure()
      : super(
            message:
                "All fields are required. Please fill out all the fields and try again.");
}

class GeneralLoginFailure extends LoginFailures {
  GeneralLoginFailure()
      : super(
            message:
                "An unknown error occurred while trying to log in. Please try again.");
}

class InvalidEmailLoginFailure extends LoginFailures {
  InvalidEmailLoginFailure()
      : super(
            message:
                "The email address provided is invalid. Please check and try again.");
}

class InvalidCredentialLoginFailure extends LoginFailures {
  InvalidCredentialLoginFailure()
      : super(
            message:
                "The credentials provided are invalid. Please check and try again.");
}

class UserNotFoundLoginFailure extends LoginFailures {
  UserNotFoundLoginFailure()
      : super(
            message:
                "No user found for the given credentials. Please try again.");
}

class WrongPasswordLoginFailure extends LoginFailures {
  WrongPasswordLoginFailure()
      : super(message: "The password entered is incorrect. Please try again.");
}

class UserDisabledLoginFailure extends LoginFailures {
  UserDisabledLoginFailure()
      : super(
            message:
                "The user account has been disabled. Please contact support.");
}

class TooManyRequestsLoginFailure extends LoginFailures {
  TooManyRequestsLoginFailure()
      : super(
            message:
                "Too many requests have been made. Please wait and try again later.");
}

class UnknownLoginFailure extends LoginFailures {
  UnknownLoginFailure()
      : super(
            message:
                "An unknown error occurred while trying to log in. Please try again.");
}

class HiveStorageFailure extends Failures {
  const HiveStorageFailure()
      : super(message: 'An error occurred while accessing local storage.');
}

class NoAccountLoggedFailure extends Failures {
  const NoAccountLoggedFailure()
      : super(message: 'No account is currently logged in.');
}

class GeneralSignOutFailure extends Failures {
  const GeneralSignOutFailure()
      : super(message: 'An unknown error occurred while trying to sign out.');
}

class GeneralCheckEmailVerificationFailure extends Failures {
  const GeneralCheckEmailVerificationFailure()
      : super(
            message:
                'An unknown error occurred while trying to check email verification.');
}

abstract class SendEmailVerificationFailures extends Failures {
  const SendEmailVerificationFailures({required super.message});
}

class GeneralSendEmailVerificationFailure
    extends SendEmailVerificationFailures {
  const GeneralSendEmailVerificationFailure()
      : super(
            message:
                'An unknown error occurred while sending email verification.');
}

class TooManyRequestsSendEmailVerificationFailure
    extends SendEmailVerificationFailures {
  const TooManyRequestsSendEmailVerificationFailure()
      : super(
            message:
                'Too many requests have been made. Please wait and try again later.');
}

abstract class ResetPasswordFailures extends Failures {
  const ResetPasswordFailures({required super.message});
}

class GeneralResetPasswordFailure extends ResetPasswordFailures {
  const GeneralResetPasswordFailure()
      : super(
            message:
                'An unknown error occurred while trying to reset password.');
}

class TooManyRequestsResetPasswordFailure extends ResetPasswordFailures {
  const TooManyRequestsResetPasswordFailure()
      : super(
            message:
                'Too many requests have been made. Please wait and try again later.');
}

class InvalidEmailResetPasswordFailure extends ResetPasswordFailures {
  const InvalidEmailResetPasswordFailure()
      : super(
            message:
                'The email address provided is invalid. Please check and try again.');
}

class UserNotFoundResetPasswordFailure extends ResetPasswordFailures {
  const UserNotFoundResetPasswordFailure()
      : super(
            message:
                'No user found for the given email address. Please try again.');
}

class EmptyForgotPasswordFieldsFailure extends ResetPasswordFailures {
  const EmptyForgotPasswordFieldsFailure()
      : super(
            message:
                'The email field is required. Please fill out the email field and try again.');
}

abstract class GetPaymentSourcesFailures extends Failures {
  const GetPaymentSourcesFailures({required super.message});
}

class NoPaymentSourcesFailure extends GetPaymentSourcesFailures {
  const NoPaymentSourcesFailure()
      : super(message: 'No payment sources found for this account.');
}

class GeneralGetPaymentSourcesFailure extends GetPaymentSourcesFailures {
  const GeneralGetPaymentSourcesFailure()
      : super(
            message:
                'An unknown error occurred while trying to get payment sources.');
}

