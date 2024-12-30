import 'package:op_expense/features/main/domain/entities/payment_source.dart';
import 'package:op_expense/features/main/domain/entities/transaction.dart';

class TransactionModel extends Transaction {
  const TransactionModel({
    required super.type,
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
      type: json['type'],
      description: json['description'],
      frequencyDay: json['frequencyDay'],
      frequencyMonth: json['frequencyMonth'],
      amount: json['amount'],
      createAt: json['date'],
      paymentSource: json['paymentSource'],
      category: json['category'],
      repeat: json['repeat'],
      attachment:
          Attachment(file: json['attachmentFile'], url: json['attachmentUrl']),
      frequency: json['frequency'],
      frequencyEndDate: json['frequencyEndDate'],
    );
  }
  factory TransactionModel.fromEntity(Transaction transaction) {
    return TransactionModel(
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
      'description': super.description,
      'amount': super.amount,
      'date': super.createAt.millisecondsSinceEpoch,
      'paymentSource': super.paymentSource?.name,
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
