import 'package:dartz/dartz.dart';
import 'package:op_expense/core/errors/exceptions.dart';
import 'package:op_expense/core/errors/failures.dart';
import 'package:op_expense/features/AiGuide/data/data_sources/ai_guide_remote_data_source.dart';
import 'package:op_expense/features/AiGuide/data/models/message_model.dart';
import 'package:op_expense/features/AiGuide/domain/entities/message.dart';
import 'package:op_expense/features/AiGuide/domain/repositories/ai_guide_repository.dart';
import 'package:op_expense/features/main/data/models/payment_source_model.dart';
import 'package:op_expense/features/main/data/models/transaction_model.dart';
import 'package:op_expense/features/main/domain/entities/payment_source.dart';
import 'package:op_expense/features/main/domain/entities/transaction.dart';

class AiGuideRepositoryImpl extends AiGuideRepository {
  final AiGuideRemoteDataSource remoteDataSource;
  AiGuideRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failures, Message>> sendMessage(
      {required List<Message> messages,
      required List<PaymentSource> paymentSources,
      required List<Transaction> transactions}) async {
    try {
      Message aiResponse = await remoteDataSource.sendMessage(
          paymentSources: paymentSources
              .map((e) => PaymentSourceModel.fromEntity(e))
              .toList(),
          messages: messages.map((e) => MessageModel.fromEntity(e)).toList(),
          transactions:
              transactions.map((e) => TransactionModel.fromEntity(e)).toList());
      return right(aiResponse);
    } on NoInternetException {
      return left(const NoInternetFailure());
    } on NoApiKeyException {
      return left(const NoApiKeyFailure());
    } on ApiTooManyRequestsException {
      return left(const ApiTooManyRequestsFailure());
    } on Exception {
      return left(const GeneralSendMessageFailure());
    }
  }
}
