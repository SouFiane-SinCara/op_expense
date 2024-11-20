abstract class Exceptions {
  final String code;
  const Exceptions({required this.code});
}

abstract class SignUpExceptions extends Exceptions {
  const SignUpExceptions({required super.code});
}

abstract class FirebaseAuthExceptions extends SignUpExceptions {
  const FirebaseAuthExceptions({required super.code});
}

class GeneralFireStoreException extends SignUpExceptions {
  const GeneralFireStoreException() : super(code: '');
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

class UserNotFoundException extends FirebaseAuthExceptions {
  const UserNotFoundException()
      : super(
          code: "user-not-found",
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
