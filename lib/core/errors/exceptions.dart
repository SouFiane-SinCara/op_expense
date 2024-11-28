abstract class Exceptions {
  final String code;
  const Exceptions({required this.code});
}

class NoInternetException extends Exceptions {
  const NoInternetException() : super(code: '');
}

class GeneralFireStoreException extends Exceptions {
  const GeneralFireStoreException() : super(code: '');
}

abstract class SignUpExceptions extends Exceptions {
  const SignUpExceptions({required super.code});
}

abstract class FirebaseAuthExceptions extends SignUpExceptions {
  const FirebaseAuthExceptions({required super.code});
}

class GeneralSignInWithGoogleException extends SignUpExceptions {
  GeneralSignInWithGoogleException() : super(code: '');
}

// Specific FirebaseAuthExceptions
class EmailAlreadyInUseException extends FirebaseAuthExceptions {
  const EmailAlreadyInUseException()
      : super(
          code: "email-already-in-use",
        );
}

class InvalidEmailException extends FirebaseAuthExceptions {
  const InvalidEmailException()
      : super(
          code: "invalid-email",
        );
}

class WeakPasswordException extends FirebaseAuthExceptions {
  const WeakPasswordException()
      : super(
          code: "weak-password",
        );
}

class OperationNotAllowedException extends FirebaseAuthExceptions {
  const OperationNotAllowedException()
      : super(
          code: "operation-not-allowed",
        );
}

class UserDisabledException extends FirebaseAuthExceptions {
  const UserDisabledException()
      : super(
          code: "user-disabled",
        );
}

class WrongPasswordException extends FirebaseAuthExceptions {
  const WrongPasswordException()
      : super(
          code: "wrong-password",
        );
}

class TooManyRequestsException extends FirebaseAuthExceptions {
  const TooManyRequestsException()
      : super(
          code: "too-many-requests",
        );
}

class UnknownAuthException extends FirebaseAuthExceptions {
  const UnknownAuthException()
      : super(
          code: "unknown",
        );
}

abstract class LoginExceptions extends Exceptions {
  const LoginExceptions({required super.code});
}

class GeneralLoginException extends LoginExceptions {
  const GeneralLoginException() : super(code: '');
}

class InvalidEmailLoginException extends LoginExceptions {
  const InvalidEmailLoginException()
      : super(
          code: "invalid-email",
        );
}

class InvalidCredentialLoginException extends LoginExceptions {
  const InvalidCredentialLoginException()
      : super(
          code: "invalid-credential",
        );
}

class EmailNotFoundException extends LoginExceptions {
  const EmailNotFoundException()
      : super(
          code: "email-not-found",
        );
}

class WrongPasswordLoginException extends LoginExceptions {
  const WrongPasswordLoginException()
      : super(
          code: "wrong-password",
        );
}

class UserDisabledLoginException extends LoginExceptions {
  const UserDisabledLoginException()
      : super(
          code: "user-disabled",
        );
}

class UserNotFoundLoginException extends LoginExceptions {
  const UserNotFoundLoginException()
      : super(
          code: "user-not-found",
        );
}

class TooManyRequestsLoginException extends LoginExceptions {
  const TooManyRequestsLoginException()
      : super(
          code: "too-many-requests",
        );
}

class UnknownLoginException extends LoginExceptions {
  const UnknownLoginException()
      : super(
          code: "unknown",
        );
}

class HiveStorageException extends Exceptions {
  const HiveStorageException() : super(code: 'hive-storage-error');
}

class NoAccountLoggedException extends Exceptions {
  const NoAccountLoggedException() : super(code: 'no-account-logged');
}
