import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:op_expense/core/errors/exceptions.dart';
import 'package:op_expense/features/Authentication/data/models/account_model.dart';
import 'package:op_expense/features/Authentication/domain/entities/account.dart';
import 'package:op_expense/features/main/data/models/payment_source_model.dart';
import 'package:op_expense/features/main/data/models/transaction_model.dart';
import 'package:op_expense/features/main/domain/entities/transaction.dart'
    as transaction_entity;

abstract class MainRemoteDataSource {
  Future<List<PaymentSourceModel>> getPaymentSources(
      {required Account account});
  Future<void> addNewPaymentSource(
      {required Account account, required PaymentSourceModel paymentSource});
  Future<void> addTransaction(
      {required Account account,
      required transaction_entity.Transaction transaction});
  Future<List<TransactionModel>> getTransactions({required Account account});
  // check if there is any repeated transaction arrived while the user was offline and modify the account balance
  Future<void> checkIfRepeatedTransactionsArrived(
      {required AccountModel account});
}

class MainRemoteDataSourceFirebase extends MainRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final Connectivity connectivity;
  final FirebaseStorage firebaseStorage;
  MainRemoteDataSourceFirebase(
      {required this.firebaseFirestore,
      required this.connectivity,
      required this.firebaseStorage});
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
      print(e);
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

  @override
  Future<void> addTransaction(
      {required Account account,
      required transaction_entity.Transaction transaction}) async {
    try {
      await checkConnection();
      TransactionModel transactionModel =
          TransactionModel.fromEntity(transaction);
      if (transactionModel.attachment != null &&
          transactionModel.attachment!.file != null) {
        // Get the file from the transaction model
        File attachment = File(transactionModel.attachment!.file!.path);
        // Get the current timestamp to avoid duplicate file names
        int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
        // Create a unique file name using the current timestamp
        String fileName =
            '$currentTimestamp.${attachment.path.split('.').last}';
        // Upload the attachment to firebase storage
        TaskSnapshot uploadTask = await firebaseStorage
            .ref('users/${account.userId}/$fileName')
            .putFile(attachment);
        // Get the download url of the uploaded file
        String downloadUrl = await uploadTask.ref.getDownloadURL();
        // Update the attachment url in the transaction model
        transactionModel.attachment!.url = downloadUrl;
      }

      if (transactionModel.repeat) {
        if (transactionModel.frequency == transaction_entity.Frequency.daily) {
          Duration oneDay = const Duration(days: 1);

          DateTime createAt = DateTime(
            transactionModel.createAt.year,
            transactionModel.createAt.month,
            transactionModel.createAt.day,
          );

          while (createAt.isBefore(transactionModel.frequencyEndDate!) ||
              createAt.day == transactionModel.frequencyEndDate!.day) {
            firebaseFirestore
                .collection('users')
                .doc(account.userId)
                .collection('transactions')
                .add(
                  transactionModel.copyWith(createAt: createAt).toJson(),
                );
            createAt = createAt.add(oneDay);
          }
        } else if (transactionModel.frequency ==
            transaction_entity.Frequency.monthly) {
          DateTime createAt = transactionModel.createAt;

          while (createAt.isBefore(transactionModel.frequencyEndDate!)) {
            int day = transactionModel.frequencyDay!;
            int month = createAt.month;
            int year = createAt.year;

            // Handle months with fewer days
            int daysInMonth =
                DateTime(year, month + 1, 0).day; // Last day of the month
            int adjustedDay = day > daysInMonth ? daysInMonth : day;

            DateTime nextTransactionDate = DateTime(year, month, adjustedDay);
            // check if the next transaction date does not exceed the end date
            if (nextTransactionDate
                .isAfter(transactionModel.frequencyEndDate!)) {
              break;
            }
            // Add the transaction to the firestore
            await firebaseFirestore
                .collection('users')
                .doc(account.userId)
                .collection('transactions')
                .add(
                  transactionModel
                      .copyWith(createAt: nextTransactionDate)
                      .toJson(),
                );
            // Move to the next month
            createAt = DateTime(year, month + 1, 1); // Start of the next month
          }
        } else if (transactionModel.frequency ==
            transaction_entity.Frequency.yearly) {
          DateTime createAt = transactionModel.createAt;

          while (createAt.isBefore(transactionModel.frequencyEndDate!) ||
              createAt.isAtSameMomentAs(transactionModel.frequencyEndDate!)) {
            int day = transactionModel.frequencyDay!;
            int month = transactionModel.frequencyMonth!;
            int year = createAt.year;

            // Handle leap year cases for February 29
            bool isLeapYear =
                (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
            if (month == 2 && day == 29 && !isLeapYear) {
              day =
                  28; // Adjust to February 28 if the current year is not a leap year
            }

            // Generate the next transaction date
            DateTime nextTransactionDate = DateTime(year, month, day);

            // Break the loop if the next transaction date exceeds the frequencyEndDate
            if (nextTransactionDate
                .isAfter(transactionModel.frequencyEndDate!)) {
              break;
            }

            // Add the transaction to Firestore
            await firebaseFirestore
                .collection('users')
                .doc(account.userId)
                .collection('transactions')
                .add(
                  transactionModel
                      .copyWith(createAt: nextTransactionDate)
                      .toJson(),
                );

            // Move to the next year
            createAt = DateTime(
                year + 1, month, 1); // Start of the same month in the next year
          }
        }
      } else {
        await firebaseFirestore
            .collection('users')
            .doc(account.userId)
            .collection('transactions')
            .add(
              transactionModel.toJson(),
            );
      }

      // update payment source balance
      final paymentSourceDocument = await firebaseFirestore
          .collection('users')
          .doc(account.userId)
          .collection('wallet')
          .where('name', isEqualTo: transactionModel.paymentSource!.name)
          .get();
      await paymentSourceDocument.docs.first.reference.update(
        {
          'balance':
              transactionModel.paymentSource!.balance + transactionModel.amount,
        },
      );
    } on NoInternetException {
      throw const NoInternetException();
    } on FirebaseException {
      throw const FirebaseStorageException();
    } catch (e) {
      throw const GeneralAddTransactionException();
    }
  }

  @override
  Future<List<TransactionModel>> getTransactions(
      {required Account account}) async {
    
    try {
      await checkConnection();
      List<TransactionModel> transactions = [];
      final transactionsMap = await firebaseFirestore
          .collection('users')
          .doc(account.userId)
          .collection('transactions')
          .get();
      for (var json in transactionsMap.docs) {
        transactions.add(TransactionModel.fromJson(json.data()));
      }
      return transactions;
    } on FirebaseException {
      throw const GeneralFireStoreException();
    } on NoInternetException {
      throw const NoInternetException();
    } catch (e) {
      
      throw const GeneralGetTransactionsException();
    }
  }

  @override
  Future<void> checkIfRepeatedTransactionsArrived(
      {required AccountModel account}) async {
    try {
      await checkConnection();
      List<TransactionModel> transactions =
          await getTransactions(account: account);

      for (var transaction in transactions) {
        if (transaction.repeat &&
            transaction.createAt.isBefore(DateTime.now()) &&
            !(transaction.createAt.day ==
                    DateTime.fromMillisecondsSinceEpoch(account.lastLogin)
                        .day &&
                transaction.createAt.month ==
                    DateTime.fromMillisecondsSinceEpoch(account.lastLogin)
                        .month &&
                transaction.createAt.year ==
                    DateTime.fromMillisecondsSinceEpoch(account.lastLogin)
                        .year) &&
            transaction.createAt.isAfter(
                DateTime.fromMillisecondsSinceEpoch(account.lastLogin))) {
          final paymentSourceDocument = firebaseFirestore
              .collection('users')
              .doc(account.userId)
              .collection('wallet')
              .where('name', isEqualTo: transaction.paymentSource!.name)
              .get();
          paymentSourceDocument.then((value) {
            value.docs.first.reference.update(
              {
                'balance':
                    value.docs.first.data()['balance'] + transaction.amount,
              },
            );
          });
        }
      }
    } on NoInternetException {
      throw const NoInternetException();
    } catch (e) {
      throw const GeneralFireStoreException();
    }
  }
}
