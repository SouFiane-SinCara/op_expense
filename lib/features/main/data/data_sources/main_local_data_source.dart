import 'package:hive/hive.dart';
import 'package:op_expense/core/errors/exceptions.dart';
import 'package:op_expense/features/main/data/models/payment_source_model.dart';

abstract class MainLocalDataSource {
  Future<void> storagePaymentSources(
      {required List<PaymentSourceModel> paymentSources});
  Future<List<PaymentSourceModel>> getPaymentSources();
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
    throw UnimplementedError();
  }

  @override
  Future<List<PaymentSourceModel>> getPaymentSources() async {
    try {
      List<Map> paymentSourcesJson =
          await paymentSourcesBox.get(paymentSourcesKey);
      if (paymentSourcesJson.isEmpty) {
        throw const NoPaymentSourcesLocallyException();
      }
      return paymentSourcesJson
          .map((e) => PaymentSourceModel.fromJson(e))
          .toList();
    } catch (e) {
      throw const HiveStorageException();
    }
  }
}
