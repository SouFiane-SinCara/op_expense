import 'package:hive/hive.dart';
import 'package:op_expense/core/errors/exceptions.dart';
import 'package:op_expense/features/main/data/models/payment_source_model.dart';

abstract class MainLocalDataSource {
  Future<void> storagePaymentSources(
      {required List<PaymentSourceModel> paymentSources});
  Future<List<PaymentSourceModel>> getPaymentSources();
  Future<void> addNewPaymentSource({required PaymentSourceModel paymentSource});
  Future<void> removeAllPaymentSources();
}

class MainLocalDataSourceHive extends MainLocalDataSource {
  Box paymentSourcesBox = Hive.box('paymentSources');
  String paymentSourcesKey = 'paymentSources';

  @override
  Future<void> storagePaymentSources(
      {required List<PaymentSourceModel> paymentSources}) async {
    try {
      await paymentSourcesBox.put(
          paymentSourcesKey, paymentSources.map((e) => e.toJson()).toList());
    } catch (e) {
      throw const HiveStorageException();
    }
  }

  @override
  Future<List<PaymentSourceModel>> getPaymentSources() async {
    try {
      final paymentSourcesJson = await paymentSourcesBox.get(paymentSourcesKey);

      if (paymentSourcesJson == null || paymentSourcesJson.isEmpty) {
        throw const NoPaymentSourcesLocallyException();
      }

      return paymentSourcesJson
          .map<PaymentSourceModel>((e) => PaymentSourceModel.fromJson(e))
          .toList();
    } on NoPaymentSourcesLocallyException {
      throw const NoPaymentSourcesLocallyException();
    } catch (e) {
      throw const HiveStorageException();
    }
  }

  @override
  Future<void> addNewPaymentSource(
      {required PaymentSourceModel paymentSource}) async {
    List<PaymentSourceModel> paymentSources = [];
    try {
      paymentSources = await getPaymentSources();
    } catch (e) {
      try {
        paymentSources.add(paymentSource);
        await paymentSourcesBox.put(
            paymentSourcesKey, paymentSources.map((e) => e.toJson()).toList());
      } catch (e) {
        throw const HiveStorageException();
      }
    }
  }

  @override
  Future<void> removeAllPaymentSources() async {
    try {
      await paymentSourcesBox.delete(paymentSourcesKey);
    } catch (e) {
      throw const HiveStorageException();
    }
  }
}
