import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:op_expense/core/errors/exceptions.dart';
import 'package:op_expense/features/SignUp/data/models/account_model.dart';
import 'package:op_expense/features/SignUp/domain/entities/account.dart';

abstract class SinUpRemoteDataSource {
  Future<Account> signUpWithEmailPassword({
    required String email,
    required String password,
    required String name,
  });
}

class SignUpFireBaseRemoteDataSource extends SinUpRemoteDataSource {
  FirebaseAuth firebaseAuth;
  FirebaseFirestore firebaseFirestore;
  SignUpFireBaseRemoteDataSource(
      {required this.firebaseAuth, required this.firebaseFirestore});
  @override
  Future<AccountModel> signUpWithEmailPassword(
      {required String email,
      required String password,
      required String name}) async {
    try {
      //!----------- create a user in firebase auth -----------------
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      //!------------- create a user in firebase firestore -------------------
      AccountModel accountModel = AccountModel(
        name: name,
        email: email,
        password: password,
        isVerified: false,
        userId: userCredential.user!.uid,
      );
      await firebaseFirestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .set(
            accountModel.toJson(),
          );
      return accountModel;
    } on FirebaseAuthException catch (authError) {
      switch (authError.code) {
        case "email-already-in-use":
          throw const EmailAlreadyInUseException();
        case "invalid-email":
          throw const InvalidEmailException();
        case "weak-password":
          throw const WeakPasswordException();
        case "operation-not-allowed":
          throw const OperationNotAllowedException();
        case "user-disabled":
          throw const UserDisabledException();
        case "user-not-found":
          throw const UserNotFoundException();
        case "wrong-password":
          throw const WrongPasswordException();
        case "too-many-requests":
          throw const TooManyRequestsException();
        default:
          throw const UnknownAuthException();
      }
    } on FirebaseException {
      throw const GeneralFireStoreException();
    }
  }
}
