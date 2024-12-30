import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:op_expense/features/Authentication/data/data_sources/auth_local_data_source.dart';
import 'package:op_expense/features/Authentication/data/data_sources/auth_remote_data_source.dart';
import 'package:op_expense/features/Authentication/data/repositories/auth_repository_impl.dart';
import 'package:op_expense/features/Authentication/domain/repositories/auth_repository.dart';
import 'package:op_expense/features/Authentication/domain/use_cases/login_use_case.dart';
import 'package:op_expense/features/Authentication/domain/use_cases/send_reset_password_use_case.dart';
import 'package:op_expense/features/Authentication/domain/use_cases/sign_up_with_email_password_use_case.dart';
import 'package:op_expense/features/Authentication/presentation/cubits/authentication_cubit/authentication_cubit.dart';
import 'package:op_expense/features/Authentication/presentation/cubits/check_email_verification_cubit/check_email_verification_cubit.dart';
import 'package:op_expense/features/Authentication/presentation/cubits/forgot_password_cubit/forgot_password_cubit.dart';
import 'package:op_expense/features/Authentication/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:op_expense/features/Authentication/presentation/cubits/send_email_verification_cubit/send_email_verification_cubit.dart';
import 'package:op_expense/features/Authentication/presentation/cubits/sign_out_cubit/sign_out_cubit.dart';
import 'package:op_expense/features/Authentication/presentation/cubits/sign_up_cubit/sign_up_cubit.dart';
import 'package:op_expense/features/main/data/data_sources/main_local_data_source.dart';
import 'package:op_expense/features/main/data/data_sources/main_remote_data_source.dart';
import 'package:op_expense/features/main/data/repositories_impl/main_repository_impl.dart';
import 'package:op_expense/features/main/domain/repositories/main_repository.dart';
import 'package:op_expense/features/main/domain/use_cases/add_new_payment_source_use_case.dart';
import 'package:op_expense/features/main/domain/use_cases/add_transaction_use_case.dart';
import 'package:op_expense/features/main/presentation/cubits/payment_sources_cubit/payment_sources_cubit.dart';
import 'package:op_expense/features/main/presentation/cubits/transaction_cubit/transaction_cubit.dart';

GetIt sl = GetIt.instance;
void setup() {
  //!------------ Auth feature --------------
  sl
    //*--------- controller ----------
    ..registerFactory(
      () => SignUpCubit(
          signUpUseCase: sl(), authRepository: sl(), authenticationCubit: sl()),
    )
    ..registerFactory(
      () => LoginCubit(
          loginUseCase: sl(), authRepository: sl(), authenticationCubit: sl()),
    )
    ..registerLazySingleton(
      () => AuthenticationCubit(),
    )
    ..registerFactory(
        () => SignOutCubit(repository: sl(), authenticationCubit: sl()))
    ..registerFactory(
      () => CheckEmailVerificationCubit(
        repository: sl(),
      ),
    )
    ..registerFactory(
      () => ForgotPasswordCubit(sendResetPasswordUseCase: sl()),
    )
    ..registerFactory(
      () => SendEmailVerificationCubit(
        authRepository: sl(),
      ),
    )
    //*-------- use case ----------
    ..registerLazySingleton(
      () => SignUpWithEmailPasswordUseCase(authRepository: sl()),
    )
    ..registerLazySingleton(
      () => LoginUseCase(authRepository: sl()),
    )
    ..registerLazySingleton(
      () => SendResetPasswordUseCase(repository: sl()),
    )
    //*-------- repository ----------

    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        mainLocalDataSource: sl(),
        authRemoteDataSource: sl(),
        authLocalDataSource: sl()))
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

  //!------------ Main feature --------------

  sl
    //*-------- controller ----------
    ..registerFactory(
      () => PaymentSourcesCubit(
        mainRepository: sl(),
        addNewPaymentSourceUseCase: sl(),
      ),
    )
    ..registerFactory(
      () => TransactionCubit(
        addTransactionUseCase: sl(),
      ),
    )
    //*-------- use case ----------
    ..registerLazySingleton(
      () => AddNewPaymentSourceUseCase(mainRepository: sl()),
    )
    ..registerLazySingleton(
      () => AddTransactionUseCase(mainRepository: sl()),
    )
    //*-------- repository ----------
    ..registerLazySingleton<MainRepository>(
      () => MainRepositoryImpl(
        mainLocalDataSource: sl(),
        mainRemoteDataSource: sl(),
      ),
    )
    //*-------- data source ----------
    ..registerLazySingleton<MainRemoteDataSource>(
      () => MainRemoteDataSourceFirebase(
        connectivity: sl(),
        firebaseFirestore: sl(),
        firebaseStorage: sl(),
      ),
    )
    ..registerLazySingleton<MainLocalDataSource>(
      () => MainLocalDataSourceHive(),
    )
    //*-------- services  ----------
    //some services already registered in the auth feature
    ..registerLazySingleton(
      () => FirebaseStorage.instance, 
    );
}
