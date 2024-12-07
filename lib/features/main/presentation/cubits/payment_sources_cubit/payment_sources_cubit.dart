import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:op_expense/features/Authentication/domain/entities/account.dart';
import 'package:op_expense/features/main/domain/entities/payment_source.dart';
import 'package:op_expense/features/main/domain/repositories/main_repository.dart';
import 'package:op_expense/features/main/domain/use_cases/add_new_payment_source_use_case.dart';

part 'payment_sources_state.dart';

class PaymentSourcesCubit extends Cubit<PaymentSourcesState> {
  List<PaymentSource> paymentSources = [];
  final MainRepository mainRepository;
  final AddNewPaymentSourceUseCase addNewPaymentSourceUseCase;
  PaymentSourcesCubit(
      {required this.mainRepository, required this.addNewPaymentSourceUseCase})
      : super(PaymentSourcesInitial());

  Future<List<PaymentSource>> getPaymentSources(
      {required Account account}) async {
        
    emit(PaymentSourcesLoading());
    final paymentSourcesEither =
        await mainRepository.getPaymentSources(account: account);
    return paymentSourcesEither.fold(
      (failure) {
        
        emit(PaymentSourcesError(message: failure.message));
        return [];
      },
      (newPaymentSources) {
        
        paymentSources = newPaymentSources;
        emit(PaymentSourcesLoaded(paymentSources: newPaymentSources));
        return newPaymentSources;
      },
    );
  }

  Future<void> addNewPaymentSource(
      {required Account account, required PaymentSource paymentSource}) async {
    emit(PaymentSourcesLoading());
    final addNewPaymentSourceEither = await addNewPaymentSourceUseCase(
        account: account, paymentSource: paymentSource);
    addNewPaymentSourceEither.fold(
      (failure) {
        emit(PaymentSourcesError(message: failure.message));
      },
      (unit) {
        paymentSources.add(paymentSource);
        emit(PaymentSourcesLoaded(paymentSources: paymentSources));
      },
    );
  }
}
