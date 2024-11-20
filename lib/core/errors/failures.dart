abstract class Failures {
  final String message;
  const Failures({required this.message});
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

class EmptyFieldsFailure extends SignUpFailures {
  EmptyFieldsFailure()
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

class InvalidEmailFailure extends FirebaseAuthFailures {
  const InvalidEmailFailure()
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

class UserNotFoundFailure extends FirebaseAuthFailures {
  const UserNotFoundFailure()
      : super(
            message:
                "No user found for the given credentials. Please try again.");
}

class WrongPasswordFailure extends FirebaseAuthFailures {
  const WrongPasswordFailure()
      : super(message: "The password entered is incorrect. Please try again.");
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
