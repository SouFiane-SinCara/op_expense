import 'package:equatable/equatable.dart';
import 'package:op_expense/features/main/domain/entities/payments_source_types.dart';

class PaymentSource extends Equatable {
  final double balance;
  final String name;
  final PaymentsSourceTypes? type;
  final String? providerLogo;
  const PaymentSource({
    required this.providerLogo,
    required this.balance,
    required this.name,
    required this.type,
  });

  PaymentSource copyWith({
    double? balance,
    String? name,
    PaymentsSourceTypes? type,
    String? providerLogo,
  }) {
    return PaymentSource(
      balance: balance ?? this.balance,
      name: name ?? this.name,
      type: type ?? this.type,
      providerLogo: providerLogo ?? this.providerLogo,
    );
  }
  @override
  List<Object?> get props => [balance, name, type, providerLogo];
}
