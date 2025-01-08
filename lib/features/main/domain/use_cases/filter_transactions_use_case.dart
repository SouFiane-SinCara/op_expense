import 'package:op_expense/features/main/domain/entities/transaction.dart';
import 'package:op_expense/features/main/presentation/screens/transactions_screen.dart';

class FilterTransactionsUseCase {
  List<Transaction> call(
      {required TransactionType? chosenTransactionsType,
      required SortType chosenSortType,
      required List<Category> chosenCategories,
      required List<Transaction> transactions}) {
    List<Transaction> filteredTransactions = [];
    for (Transaction transaction in transactions) {
      if (chosenTransactionsType == null ||
          transaction.type == chosenTransactionsType) {
        if (chosenCategories.isEmpty ||
            chosenCategories.contains(transaction.category)) {
          filteredTransactions.add(transaction);
        }
      }
    }
 
    return chosenSortType == SortType.newest
        ? filteredTransactions
        : filteredTransactions.reversed.toList();
  }
}
