import 'package:op_expense/features/main/data/models/payment_source_model.dart';
import 'package:op_expense/features/main/domain/entities/payment_source.dart';
import 'package:op_expense/features/main/domain/entities/transaction.dart';

class TransactionModel extends Transaction {
  const TransactionModel({
    required super.type,
    super.id,
    required super.description,
    required super.amount,
    required super.createAt,
    required super.paymentSource,
    required super.category,
    required super.repeat,
    required super.frequencyEndDate,
    required super.frequency,
    required super.attachment,
    required super.frequencyDay,
    required super.frequencyMonth,
  });

  TransactionModel copyWith({
    String? id,
    TransactionType? type,
    String? description,
    double? amount,
    int? frequencyDay,
    int? frequencyMonth,
    DateTime? createAt,
    PaymentSource? paymentSource,
    Attachment? attachment,
    Frequency? frequency,
    Category? category,
    bool? repeat,
    DateTime? frequencyEndDate,
  }) {
    return TransactionModel(
      type: type ?? super.type,
      id: id ?? super.id,
      description: description ?? super.description,
      amount: amount ?? super.amount,
      frequencyDay: frequencyDay ?? super.frequencyDay,
      frequencyMonth: frequencyMonth ?? super.frequencyMonth,
      createAt: createAt ?? super.createAt,
      paymentSource: paymentSource ?? super.paymentSource,
      attachment: attachment ?? super.attachment,
      frequency: frequency ?? super.frequency,
      category: category ?? super.category,
      repeat: repeat ?? super.repeat,
      frequencyEndDate: frequencyEndDate ?? super.frequencyEndDate,
    );
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      type: (json['type'] as String).toTransactionType,
      id: json['id'],
      description: json['description'],
      frequencyDay: json['frequencyDay'],
      frequencyMonth: json['frequencyMonth'],
      amount: json['amount'],
      createAt: DateTime.fromMillisecondsSinceEpoch(json['date']),
      paymentSource: (json['paymentSource']) == null
          ? null
          : PaymentSourceModel.fromJson(json['paymentSource']),
      category: (json['category'] as String).toCategory,
      repeat: json['repeat'],
      attachment: Attachment(url: json['attachmentUrl']),
      frequency: (json['frequency'] as String?).toFrequency,
      frequencyEndDate: json['frequencyEndDate'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['frequencyEndDate']),
    );
  }
  factory TransactionModel.fromEntity(Transaction transaction) {
    return TransactionModel(
      id: transaction.id,
      frequencyDay: transaction.frequencyDay,
      frequencyMonth: transaction.frequencyMonth,
      type: transaction.type,
      description: transaction.description,
      amount: transaction.amount,
      createAt: transaction.createAt,
      paymentSource: transaction.paymentSource,
      category: transaction.category,
      repeat: transaction.repeat,
      attachment: transaction.attachment,
      frequency: transaction.frequency,
      frequencyEndDate: transaction.frequencyEndDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': super.type.name,
      'id': super.id,
      'description': super.description,
      'amount': super.amount,
      'date': super.createAt.millisecondsSinceEpoch,
      'paymentSource': super.paymentSource == null
          ? null
          : PaymentSourceModel.fromEntity(super.paymentSource!).toJson(),
      'category': super.category?.name,
      'repeat': super.repeat,
      'attachmentUrl': super.attachment?.url,
      'attachmentFile': super.attachment?.file?.path,
      'frequency': super.frequency?.name,
      'frequencyEndDate': super.frequencyEndDate?.millisecondsSinceEpoch,
      'frequencyDay': super.frequencyDay,
      'frequencyMonth': super.frequencyMonth,
    };
  }
}
