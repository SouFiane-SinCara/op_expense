import 'package:equatable/equatable.dart';

enum Role { user, model }

extension ToRoleExtension on String? {
  Role toRole() {
    switch (this) {
      case 'user':
        return Role.user;
      case 'model':
        return Role.model;
      default:
        return Role.model;
    }
  }
}

class Message extends Equatable {
  final Role role;
  final String message;

  const Message({
    required this.role,
    required this.message,
  });
  @override
  List<Object?> get props => [role, message];
}
