import 'package:equatable/equatable.dart';


class Account extends Equatable {
  final String name;

  final String email;

  final String password;

  final bool isVerified;

  final String userId;

  const Account({
    required this.name,
    required this.email,
    required this.password,
    required this.isVerified,
    required this.userId,
  });

  @override
  List<Object?> get props => [name, email, password, isVerified, userId];
}
