import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction.dart';

class TransactionNotifier extends AutoDisposeNotifier<List<Transaction>> {
  @override
  List<Transaction> build() => [];

  void addTransaction(String title, String category, double amount) {
    state = [
      ...state,
      Transaction(
        title: title,
        category: category,
        amount: amount,
        date: DateTime.now(),
      ),
    ];
  }

  double get total => state.fold(0, (sum, tx) => sum + tx.amount);
}

final transactionProvider =
AutoDisposeNotifierProvider<TransactionNotifier, List<Transaction>>(
    TransactionNotifier.new);
