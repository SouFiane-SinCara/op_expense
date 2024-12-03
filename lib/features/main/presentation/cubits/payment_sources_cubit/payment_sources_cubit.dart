import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:op_expense/features/Authentication/domain/entities/account.dart';
import 'package:op_expense/features/main/domain/entities/payment_source.dart';
import 'package:op_expense/features/main/domain/repositories/main_repository.dart';

part 'payment_sources_state.dart';

class PaymentSourcesCubit extends Cubit<PaymentSourcesState> {
  final List<PaymentSource> paymentSources = [];
  final MainRepository mainRepository;
  PaymentSourcesCubit({required this.mainRepository})
      : super(PaymentSourcesInitial());

  Future<void> getPaymentSources({required Account account}) async {
    emit(PaymentSourcesLoading());
    final paymentSourcesEither =
        await mainRepository.getPaymentSources(account: account);
    paymentSourcesEither.fold(
      (failure) {
        emit(PaymentSourcesError(message: failure.message));
      },
      (paymentSources) {
        this.paymentSources.addAll(paymentSources);
        emit(PaymentSourcesLoaded(paymentSources: paymentSources));
      },
    );
  }
}
