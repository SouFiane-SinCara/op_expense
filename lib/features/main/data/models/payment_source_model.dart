import 'package:op_expense/features/main/domain/entities/payment_source.dart';
import 'package:op_expense/features/main/domain/entities/payments_source_types.dart';

class PaymentSourceModel extends PaymentSource {
  const PaymentSourceModel(
      {required super.balance,
      required super.name,
      required super.type,
      required super.providerLogo});

  factory PaymentSourceModel.fromJson(Map json) {
    return PaymentSourceModel(
      providerLogo: json['providerLogo'],
      balance: json['balance'] == 0 ? 0.0 : json['balance'].toDouble(),
      name: json['name'],
      type: (json['type'] as String).toPaymentsSourceTypes,
    );
  }
  factory PaymentSourceModel.fromEntity(PaymentSource paymentSource) {
    return PaymentSourceModel(
      providerLogo: paymentSource.providerLogo,
      balance: paymentSource.balance,
      name: paymentSource.name,
      type: paymentSource.type,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'providerLogo': providerLogo,
      'balance': balance,
      'name': name,
      'type': type.toString(),
    };
  }
}
