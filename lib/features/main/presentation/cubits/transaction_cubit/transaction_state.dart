part of 'transaction_cubit.dart';

sealed class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object> get props => [];
}

final class TransactionInitial extends TransactionState {}

final class TransactionLoading extends TransactionState {}

final class TransactionSuccess extends TransactionState {}

final class TransactionFailure extends TransactionState {
  final String message;

  const TransactionFailure({required this.message});

  @override
  List<Object> get props => [message];
}
