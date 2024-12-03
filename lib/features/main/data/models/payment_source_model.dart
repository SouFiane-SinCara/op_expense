import 'package:op_expense/features/main/domain/entities/payment_source.dart';
import 'package:op_expense/features/main/domain/entities/payments_source_types.dart';

class PaymentSourceModel extends PaymentSource {
  const PaymentSourceModel(
      {required super.balance, required super.name, required super.type});

  factory PaymentSourceModel.fromJson(Map json) {
    return PaymentSourceModel(
      balance: json['balance'],
      name: json['name'],
      type: (json['type'] as String).toPaymentsSourceTypes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
      'name': name,
      'type': type.toString(),
    };
  }
}
