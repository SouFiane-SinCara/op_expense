import 'package:hive/hive.dart';
import 'package:op_expense/core/errors/exceptions.dart';
import 'package:op_expense/core/errors/failures.dart';
import 'package:op_expense/features/Authentication/data/models/account_model.dart';

abstract class AuthLocalDataSource {
  Future<AccountModel> getAccount();
  Future<void> cacheAccount(AccountModel accountModel);
  Future<void> deleteAccount();
}

class AuthLocalDataSourceImpl extends AuthLocalDataSource {
  Box accountBox = Hive.box('account');
  String accountKey = 'account';
  @override
  Future<AccountModel> getAccount() async {
    try {
      final jsonAccount = await accountBox.get(accountKey);

      print("json: " + jsonAccount.toString());
      if (jsonAccount == null) {
        throw const NoAccountLoggedException();
      }
      final accountModel = AccountModel.fromJson(jsonAccount);

      return accountModel;
    } catch (e) {
      throw const HiveStorageException();
    }
  }

  @override
  Future<void> cacheAccount(AccountModel accountModel) async {
    try {
      await accountBox.put(accountKey, accountModel.toJson());
    } catch (e) {
      throw const HiveStorageException();
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await accountBox.delete(accountKey);
    } catch (e) {
      throw const HiveStorageException();
    }
  }
}
