import 'dart:convert';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:op_expense/core/errors/exceptions.dart';
import 'package:op_expense/features/AiGuide/data/models/message_model.dart';
import 'package:op_expense/features/AiGuide/domain/entities/message.dart';
import 'package:op_expense/features/main/data/models/payment_source_model.dart';
import 'package:op_expense/features/main/data/models/transaction_model.dart';
import 'package:http/http.dart' as http;

abstract class AiGuideRemoteDataSource {
  Future<MessageModel> sendMessage({
    required List<MessageModel> messages,
    required List<TransactionModel> transactions,
    required List<PaymentSourceModel> paymentSources,
  });
}

class GeminiAiGuideRemoteDataSource implements AiGuideRemoteDataSource {
  final Connectivity connectivity;
  final Gemini gemini;

  GeminiAiGuideRemoteDataSource(
      {required this.connectivity, required this.gemini});

  // Method to check internet connection
  Future checkConnection() async {
    final result = await connectivity.checkConnectivity();
    if (result.last == ConnectivityResult.none) {
      throw const NoInternetException();
    }
  }

  @override
  Future<MessageModel> sendMessage(
      {required List<MessageModel> messages,
      required List<TransactionModel> transactions,
      required List<PaymentSourceModel> paymentSources}) async {
    try {
      await checkConnection();

      // Build context prompt from your domain data
      final String contextPrompt = '''
You are an AI financial guide inside an expense tracking app.
Use the following data (transactions + wallets) to give personalized insights.

Current time: ${DateTime.now()}

Wallets:
${paymentSources.map((e) => e.toJson()).toList()}

Transactions:
${transactions.map((e) => e.toJson()).toList()}
''';

      // Last user message (assuming your MessageModel has role + message)
      final MessageModel lastUserMessage = messages.lastWhere(
        (m) => m.role == Role.user,
        orElse: () => MessageModel(role: Role.user, message: ''),
      );

      // Combine context + user question
      final String fullUserText = '''
$contextPrompt

User message:
${lastUserMessage.message}
''';

      // DEBUG: see what you send
      print('AI request prompt:\n$fullUserText');

      // Call Gemini (non-stream)
      final response = await gemini.text(
        fullUserText,
      );

      if (response == null ||
          response.output == null ||
          response.output!.isEmpty) {
        throw const GeneralApiException();
      }

      final String reply = response.output!;

      print('AI response:\n$reply');

      return MessageModel(
        role: Role.model,
        message: reply,
      );
    } on NoInternetException {
      throw const NoInternetException();
    } on NoApiKeyException {
      throw const NoApiKeyException();
    } on ApiTooManyRequestsException {
      throw const ApiTooManyRequestsException();
    } on GeneralApiException {
      throw const GeneralApiException();
    } catch (e) {
      print('Error: $e');
      throw const GeneralApiException();
    }
  }
}
