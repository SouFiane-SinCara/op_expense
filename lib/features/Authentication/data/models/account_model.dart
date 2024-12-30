import 'package:op_expense/features/Authentication/domain/entities/account.dart';

class AccountModel extends Account {
  const AccountModel({
    required super.name,
    required super.lastLogin,
    required super.email,
    required super.password,
    required super.isVerified,
    required super.userId,
  });
  Map<String, dynamic> toJson() => {
        "userId": userId,
        "name": name,
        "email": email,
        "password": password,
        "isVerified": isVerified,
        "lastLogin": lastLogin,
      };
  factory AccountModel.fromAccount(Account account) {
    return AccountModel(
      name: account.name,
      email: account.email,
      lastLogin: account.lastLogin,
      password: account.password,
      isVerified: account.isVerified,
      userId: account.userId,
    );
  }
  factory AccountModel.fromJson(Map json) {
    return AccountModel(
      name: json["name"],
      email: json["email"],
      password: json["password"],
      lastLogin: json["lastLogin"] ?? 0,
      isVerified: json["isVerified"],
      userId: json["userId"],
    );
  }
}
