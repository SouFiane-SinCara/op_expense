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

class GeneralSignOutException extends Exceptions {
  const GeneralSignOutException() : super(code: 'general-sign-out-error');
}

class GeneralCheckEmailVerificationException extends Exceptions {
  const GeneralCheckEmailVerificationException()
      : super(code: 'general-check-email-verification-error');
}

abstract class SendEmailVerificationExceptions extends Exceptions {
  const SendEmailVerificationExceptions({required super.code});
}

class GeneralSendEmailVerificationException
    extends SendEmailVerificationExceptions {
  const GeneralSendEmailVerificationException()
      : super(code: 'general-send-email-verification-error');
}

class TooManyRequestsSendEmailVerificationException
    extends SendEmailVerificationExceptions {
  const TooManyRequestsSendEmailVerificationException()
      : super(code: 'too-many-requests-send-email-verification-error');
}

abstract class ResetPasswordExceptions extends Exceptions {
  const ResetPasswordExceptions({required super.code});
}

class GeneralResetPasswordException extends ResetPasswordExceptions {
  const GeneralResetPasswordException()
      : super(code: 'general-reset-password-error');
}

class TooManyRequestsResetPasswordException extends ResetPasswordExceptions {
  const TooManyRequestsResetPasswordException()
      : super(code: 'too-many-requests-reset-password-error');
}

class UserNotFoundResetPasswordException extends ResetPasswordExceptions {
  const UserNotFoundResetPasswordException()
      : super(code: 'user-not-found-reset-password-error');
}


abstract class GetPaymentSourcesExceptions extends Exceptions {
  const GetPaymentSourcesExceptions({required super.code});
}

class GeneralGetPaymentSourcesException extends GetPaymentSourcesExceptions {
  const GeneralGetPaymentSourcesException()
      : super(code: 'general-get-payment-sources-error');
}

class NoPaymentSourcesException extends GetPaymentSourcesExceptions {
  const NoPaymentSourcesException()
      : super(code: 'no-payment-sources-error');
}

class NoPaymentSourcesLocallyException extends GetPaymentSourcesExceptions {
  const NoPaymentSourcesLocallyException()
      : super(code: 'no-payment-sources-localy-error');
}
abstract class AddNewPaymentSourceExceptions extends Exceptions {
  const AddNewPaymentSourceExceptions({required super.code});
}

class GeneralAddNewPaymentSourceException extends AddNewPaymentSourceExceptions {
  const GeneralAddNewPaymentSourceException()
      : super(code: 'general-add-new-payment-source-error');
}