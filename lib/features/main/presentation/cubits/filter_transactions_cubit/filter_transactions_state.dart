part of 'filter_transactions_cubit.dart';

sealed class FilterTransactionsState extends Equatable {
  const FilterTransactionsState();

  @override
  List<Object> get props => [];
}

final class FilterTransactionsInitial extends FilterTransactionsState {}

final class FilterTransactionsLoading extends FilterTransactionsState {}

final class TransactionFilteredSuccess extends FilterTransactionsState {
  final List<Transaction> transactions;

  const TransactionFilteredSuccess({required this.transactions});

  @override
  List<Object> get props => [transactions];
}