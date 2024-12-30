import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:op_expense/core/errors/exceptions.dart';
import 'package:op_expense/features/Authentication/data/models/account_model.dart';

// Abstract class defining the methods for authentication data source
abstract class AuthRemoteDataSource {
  // Method to sign up with email and password
  Future<AccountModel> signUpWithEmailPassword({
    required String email,
    required String password,
    required String name,
  });

  // Method to sign up with Google
  Future<AccountModel> signUpWithGoogle();

  // Method to log in with email and password
  Future<AccountModel> login({required String email, required String password});

  // Method to sign out
  Future<void> signOut();

  // Method to check email verification status
  Future<bool> checkEmailVerification();

  // Method to send email verification
  Future<void> sendEmailVerification();

  // Method to reset password
  Future<void> sendResetPassword(String email);

  // method to update last login time
  Future<void> updateLastLogin({required AccountModel account});
}

// Implementation of AuthRemoteDataSource using Firebase
class AuthFireBaseRemoteDataSource extends AuthRemoteDataSource {
  Connectivity connectivity;
  FirebaseAuth firebaseAuth;
  FirebaseFirestore firebaseFirestore;
  GoogleSignIn googleSignIn;

  AuthFireBaseRemoteDataSource({
    required this.firebaseAuth,
    required this.firebaseFirestore,
    required this.googleSignIn,
    required this.connectivity,
  });

  // Method to check internet connection
  Future checkConnection() async {
    final result = await connectivity.checkConnectivity();
    if (result.last == ConnectivityResult.none) {
      throw const NoInternetException();
    }
  }

  @override
  Future<AccountModel> signUpWithEmailPassword(
      {required String email,
      required String password,
      required String name}) async {
    try {
      await checkConnection();

      // Create a user in Firebase Auth
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Create a user in Firebase Firestore
      AccountModel accountModel = AccountModel(
        lastLogin: DateTime.now().millisecondsSinceEpoch,
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
      // Handle Firebase Auth exceptions
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
        case "too-many-requests":
          throw const TooManyRequestsException();
        default:
          throw const UnknownAuthException();
      }
    } on NoInternetException {
      throw const NoInternetException();
    } on FirebaseException {
      throw const GeneralFireStoreException();
    } on HiveError {
      throw const HiveStorageException();
    }
  }

  @override
  Future<AccountModel> signUpWithGoogle() async {
    try {
      await checkConnection();
      await googleSignIn.signOut();
      GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);

      AccountModel account = AccountModel(
          name: googleUser.displayName!,
          lastLogin: DateTime.now().millisecondsSinceEpoch,
          email: googleUser.email,
          password: "googleUser",
          isVerified: true,
          userId: userCredential.user!.uid);
      await firebaseFirestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .set(
            account.toJson(),
          );

      return account;
    } on FirebaseException {
      throw const GeneralFireStoreException();
    } on NoInternetException {
      throw const NoInternetException();
    } on HiveError {
      throw const HiveStorageException();
    } catch (e) {
      throw GeneralSignInWithGoogleException();
    }
  }

  @override
  Future<AccountModel> login(
      {required String email, required String password}) async {
    try {
      await checkConnection();
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      firebaseFirestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .update(
        {
          "lastLogin": DateTime.now().millisecondsSinceEpoch,
        },
      );

      final map = await firebaseFirestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .get();
      print('email ${map.data()!["email"]}');
      AccountModel accountModel = AccountModel.fromJson(map.data()!);

      return accountModel;
    } on FirebaseAuthException catch (authError) {
      // Handle Firebase Auth exceptions
      switch (authError.code) {
        case "email-not-found":
          throw const EmailNotFoundException();
        case "wrong-password":
          throw const WrongPasswordLoginException();
        case "invalid-email":
          throw const InvalidEmailLoginException();
        case "too-many-requests":
          throw const TooManyRequestsLoginException();
        case "invalid-credential":
          throw const InvalidCredentialLoginException();
        case "user-disabled":
          throw const UserDisabledLoginException();
        case "user-not-found":
          throw const UserNotFoundLoginException();
        default:
          throw const UnknownLoginException();
      }
    } on FirebaseException {
      throw const GeneralFireStoreException();
    } on NoInternetException {
      throw const NoInternetException();
    } on HiveError {
      throw const HiveStorageException();
    } catch (e) {
      throw const GeneralLoginException();
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await checkConnection();
      await firebaseAuth.signOut();
      await googleSignIn.signOut();
    } on FirebaseException {
      throw const GeneralFireStoreException();
    } on NoInternetException {
      throw const NoInternetException();
    } catch (e) {
      throw const GeneralSignOutException();
    }
  }

  @override
  Future<bool> checkEmailVerification() async {
    try {
      await checkConnection();
      await firebaseAuth.currentUser!.reload();
      bool isVerified = firebaseAuth.currentUser!.emailVerified;
      if (isVerified) {
        await firebaseFirestore
            .collection("users")
            .doc(firebaseAuth.currentUser!.uid)
            .update({
          "isVerified": true,
        });
      }

      return isVerified;
    } on NoInternetException {
      throw const NoInternetException();
    } catch (e) {
      throw const GeneralCheckEmailVerificationException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      await checkConnection();
      await firebaseAuth.currentUser!.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      if (e.code == "too-many-requests") {
        throw const TooManyRequestsSendEmailVerificationException();
      }
      throw const GeneralFireStoreException();
    } on NoInternetException {
      throw const NoInternetException();
    } catch (e) {
      throw const GeneralSendEmailVerificationException();
    }
  }

  @override
  // Method to reset password
  Future<void> sendResetPassword(String email) async {
    try {
      await checkConnection();
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw const UserNotFoundResetPasswordException();
      } else if (e.code == 'too-many-requests') {
        throw const TooManyRequestsResetPasswordException();
      } else if (e.code == 'invalid-email') {
        throw const InvalidEmailException();
      } else {
        throw const GeneralResetPasswordException();
      }
    } on NoInternetException {
      throw const NoInternetException();
    } catch (e) {
      throw const GeneralResetPasswordException();
    }
  }

  @override
  Future<void> updateLastLogin({required AccountModel account}) async {
    try {
      await checkConnection();
      await firebaseFirestore.collection('users').doc(account.userId).update(
        {
          "lastLogin": DateTime.now().millisecondsSinceEpoch,
        },
      );
    } on NoInternetException {
      throw const NoInternetException();
    } catch (e) {
      throw const GeneralFireStoreException();
    }
  }
}
