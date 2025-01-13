import 'package:op_expense/features/AiGuide/domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.role,
    required super.message,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      role: (json['role'] as String?).toRole(),
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role.name,
      'parts': [
        {"text": message},
      ],
    };
  }

  factory MessageModel.fromEntity(Message message) {
    return MessageModel(
      role: message.role,
      message: message.message,
    );
  }
}
