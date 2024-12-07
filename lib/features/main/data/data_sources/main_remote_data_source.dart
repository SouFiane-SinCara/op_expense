import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:op_expense/core/errors/exceptions.dart';
import 'package:op_expense/features/Authentication/domain/entities/account.dart';
import 'package:op_expense/features/main/data/models/payment_source_model.dart';

abstract class MainRemoteDataSource {
  Future<List<PaymentSourceModel>> getPaymentSources(
      {required Account account});
  Future<void> addNewPaymentSource(
      {required Account account, required PaymentSourceModel paymentSource});
}

class MainRemoteDataSourceFirebase extends MainRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final Connectivity connectivity;
  MainRemoteDataSourceFirebase(
      {required this.firebaseFirestore, required this.connectivity});
  // Method to check internet connection
  Future checkConnection() async {
    final result = await connectivity.checkConnectivity();
    if (result.last == ConnectivityResult.none) {
      throw const NoInternetException();
    }
  }

  @override
  Future<List<PaymentSourceModel>> getPaymentSources(
      {required Account account}) async {
    try {
      // Check internet connection before making the request if no internet throw NoInternetException
      checkConnection();
      // Get the payment sources from firebase firestore using the account userId
      final walletCollection = await firebaseFirestore
          .collection('users')
          .doc(account.userId)
          .collection('wallet')
          .get();
      // Map the data in to list of PaymentSourceModel

      List<PaymentSourceModel> paymentSources = walletCollection.docs.map(
        (e) {
          return PaymentSourceModel.fromJson(e.data());
        },
      ).toList();
      if (paymentSources.isEmpty) {
        throw const NoPaymentSourcesException();
      } else {
        return paymentSources;
      }
    } on NoPaymentSourcesException {
      throw const NoPaymentSourcesException();
    } on NoInternetException {
      throw const NoInternetException();
    } catch (e) {
      throw const GeneralGetPaymentSourcesException();
    }
  }

  @override
  Future<void> addNewPaymentSource(
      {required Account account,
      required PaymentSourceModel paymentSource}) async {
    try {
      checkConnection();
      await firebaseFirestore
          .collection('users')
          .doc(account.userId)
          .collection('wallet')
          .add(paymentSource.toJson());
    } on NoInternetException {
      throw const NoInternetException();
    } catch (e) {
      throw const GeneralAddNewPaymentSourceException();
    }
  }
}
