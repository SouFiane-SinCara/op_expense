import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:op_expense/features/Authentication/domain/entities/account.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  Account? authenticatedAccount;
  AuthenticationCubit() : super(AuthenticationInitial());

  void authenticate(Account account) {
    authenticatedAccount = account;
  }

  Account getAuthenticatedAccount() {
    return authenticatedAccount??const Account.empty();
  }

  void unAuthenticate() {
    authenticatedAccount = null;
  }

  
}
