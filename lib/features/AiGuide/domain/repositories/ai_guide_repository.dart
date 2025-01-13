import 'package:dartz/dartz.dart';
import 'package:op_expense/core/errors/failures.dart';
import 'package:op_expense/features/AiGuide/domain/entities/message.dart';
import 'package:op_expense/features/main/domain/entities/payment_source.dart';
import 'package:op_expense/features/main/domain/entities/transaction.dart';

abstract class AiGuideRepository {
  Future<Either<Failures, Message>> sendMessage(
      {required List<Message> messages,
      required List<PaymentSource> paymentSources,
      required List<Transaction> transactions});
}
