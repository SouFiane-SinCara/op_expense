import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:op_expense/features/Authentication/data/data_sources/auth_local_data_source.dart';
import 'package:op_expense/features/Authentication/data/data_sources/auth_remote_data_source.dart';
import 'package:op_expense/features/Authentication/data/repositories/auth_repository_impl.dart';
import 'package:op_expense/features/Authentication/domain/repositories/auth_repository.dart';
import 'package:op_expense/features/Authentication/domain/use_cases/login_use_case.dart';
import 'package:op_expense/features/Authentication/domain/use_cases/sign_up_with_email_password_use_case.dart';
import 'package:op_expense/features/Authentication/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:op_expense/features/Authentication/presentation/cubits/sign_up_cubit/sign_up_cubit.dart';

GetIt sl = GetIt.instance;
void setup() {
  //!------------ Auth feature --------------
  sl
    //*--------- controller ----------
    ..registerFactory(
      () => SignUpCubit(signUpUseCase: sl(), authRepository: sl()),
    )
    ..registerFactory(
      () => LoginCubit(loginUseCase: sl(), authRepository: sl()),
    )
    //*-------- use case ----------
    ..registerLazySingleton(
      () => SignUpWithEmailPasswordUseCase(authRepository: sl()),
    )
    ..registerLazySingleton(
      () => LoginUseCase(authRepository: sl()),
    )
    //*-------- repository ----------

    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        authRemoteDataSource: sl(), authLocalDataSource: sl()))
    //*-------- data source ----------
    ..registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(),
    )
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthFireBaseRemoteDataSource(
          connectivity: sl(),
          firebaseAuth: sl(),
          firebaseFirestore: sl(),
          googleSignIn: sl()),
    )
    //*-------- services  ----------

    ..registerLazySingleton(
      () => FirebaseAuth.instance,
    )
    ..registerLazySingleton(
      () => FirebaseFirestore.instance,
    )
    ..registerLazySingleton(
      () => Connectivity(),
    )
    ..registerLazySingleton(
      () => GoogleSignIn(),
    );
}
