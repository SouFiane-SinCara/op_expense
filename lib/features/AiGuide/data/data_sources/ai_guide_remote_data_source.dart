import 'dart:convert';

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
  final http.Client client;

  GeminiAiGuideRemoteDataSource(
      {required this.connectivity, required this.client});

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
      // Check if there is an internet connection
      await checkConnection();
      // Load the API key from the .env file
      await dotenv.load(fileName: "gemini_key.env");

      // Get the API key
      final String? apiKey = dotenv.env['GEMINI_API_KEY'];

      if (apiKey == null || apiKey.isEmpty) {
        throw const NoApiKeyException();
      }
      // how can i show all this print message in terminal ?

      // Define Gemini endpoint
      String endPoint =
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent?key=$apiKey";
      // Define the body of the request
      final body = json.encode({
        "contents": [
          MessageModel(role: Role.user, message: '''
        this is my expenses and transactions data :
        ${transactions.map((e) => e.toJson()).toList()},

        current time : ${DateTime.now()}

        wallet : ${paymentSources.map((e) => e.toJson()).toList()}

      ''').toJson(),
          messages
              .map(
                (e) => e.toJson(),
              )
              .toList(),
        ],
        "generationConfig": {
          "temperature": 0.1,
          "topK": 40,
          "topP": 0.95,
          "maxOutputTokens": 8192,
          "responseMimeType": "text/plain"
        }
      });
      // Make the API request
      final response = await client.post(
        Uri.parse(endPoint),
        body: body,
      );

      if (response.statusCode == 200) {
        // If the server returns an OK response, parse the JSON
        final Map<String, dynamic> data = jsonDecode(response.body);

        return MessageModel(
            role: Role.model,
            message: data['candidates'][0]['content']['parts'][0]['text']);
      } else if (response.statusCode == 429) {
        throw const ApiTooManyRequestsException();
      } else {
        // If the server returns an error response, throw an exception
        throw const GeneralApiException();
      }
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
