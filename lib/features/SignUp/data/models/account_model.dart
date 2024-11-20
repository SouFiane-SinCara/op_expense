import 'package:op_expense/features/SignUp/domain/entities/account.dart';

class AccountModel extends Account {
  AccountModel({
    required super.name,
    required super.email,
    required super.password,
    required super.isVerified,
    required super.userId,
  });
  Map<String, dynamic> toJson() => {
        "userId": userId,
        "name": userId,
        "email": email,
        "password": password,
      };
}
