part of 'payment_sources_cubit.dart';

sealed class PaymentSourcesState extends Equatable {
  const PaymentSourcesState();

  @override
  List<Object> get props => [];
}

final class PaymentSourcesInitial extends PaymentSourcesState {}

final class PaymentSourcesLoading extends PaymentSourcesState {}

final class PaymentSourcesLoaded extends PaymentSourcesState {
  final List<PaymentSource> paymentSources;

  const PaymentSourcesLoaded({required this.paymentSources});

  @override
  List<Object> get props => [paymentSources];
}

final class PaymentSourcesError extends PaymentSourcesState {
  final String message;

  const PaymentSourcesError({required this.message});

  @override
  List<Object> get props => [message];
}
