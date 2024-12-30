import 'package:equatable/equatable.dart';

class Account extends Equatable {
  final String name;

  final String email;

  final String password;

  final bool isVerified;

  final String userId;

  final int lastLogin;
  const Account({
    required this.name,
    required this.lastLogin,
    required this.email,
    required this.password,
    required this.isVerified,
    required this.userId,
  });
  const Account.empty()
      : name = '',
        lastLogin = 0,
        email = '',
        password = '',
        isVerified = false,
        userId = '';

  @override
  List<Object?> get props =>
      [name, email, password, isVerified, userId, lastLogin];
}
