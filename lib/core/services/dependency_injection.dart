import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:op_expense/features/SignUp/data/data_sources/sing_up_remote_data_source.dart';
import 'package:op_expense/features/SignUp/data/repositories/sign_up_repository_impl.dart';
import 'package:op_expense/features/SignUp/domain/repositories/sign_up_repository.dart';
import 'package:op_expense/features/SignUp/domain/use_cases/sign_up_with_email_password_use_case.dart';
import 'package:op_expense/features/SignUp/presentation/state_management/sign_up_cubit/sign_up_cubit.dart';

GetIt sl = GetIt.instance;
void setup() {
  //!------------ Sign up feature --------------
  sl
    //*--------- controller ----------
    ..registerFactory(
      () => SignUpCubit(signUpUseCase: sl()),
    )
    //*-------- use case ----------
    ..registerLazySingleton(
      () => SignUpWithEmailPasswordUseCase(signUpRepository: sl()),
    )
    //*-------- repository ----------

    ..registerLazySingleton<SignUpRepository>(
        () => SignUpRepositoryImpl(signUpRemoteDataSource: sl()))
    //*-------- data source ----------

    ..registerLazySingleton<SinUpRemoteDataSource>(
      () => SignUpFireBaseRemoteDataSource(
          firebaseAuth: sl(), firebaseFirestore: sl()),
    )
    //*-------- services  ----------

    ..registerLazySingleton(
      () => FirebaseAuth.instance,
    )
    ..registerLazySingleton(
      () => FirebaseFirestore.instance,
    );
}
