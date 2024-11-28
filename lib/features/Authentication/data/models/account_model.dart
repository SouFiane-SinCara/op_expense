import 'package:op_expense/features/Authentication/domain/entities/account.dart';

class AccountModel extends Account {
  const AccountModel({
    required super.name,
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
      };
  factory AccountModel.fromAccount(Account account) {
    return AccountModel(
      name: account.name,
      email: account.email,
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
      isVerified: json["isVerified"],
      userId: json["userId"],
    );
  }
}
