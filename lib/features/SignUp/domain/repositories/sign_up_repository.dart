import 'package:dartz/dartz.dart';
import 'package:op_expense/core/errors/failures.dart';
import 'package:op_expense/features/SignUp/data/data_sources/sing_up_remote_data_source.dart';
import 'package:op_expense/features/SignUp/domain/entities/account.dart';

abstract class SignUpRepository {
  final SinUpRemoteDataSource signUpRemoteDataSource;

  SignUpRepository({required this.signUpRemoteDataSource});
  Future<Either<SignUpFailures, Account>> signUpWithEmailPassword(
      {required String email, required String password, required String name});
      
}
