import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving_app/data/models/transaction.model.dart';
import 'package:saving_app/data/repositories/transact/transact_repo.dart';
import 'package:saving_app/data/repositories/transact/transact_repo_impl.dart';
import 'package:saving_app/utils/times.dart';
import 'package:saving_app/viewmodels/transact/plan_transact_viewmodel.dart';

class TransactionViewModel extends ChangeNotifier {
  final TransactRepository _repo;
  final Ref ref;

  TransactionViewModel(this.ref, this._repo);

  void putTransaction(Transaction newTransaction) {
    if(newTransaction.planTransactId != null) {
      ref.watch(planTransactionProvider.notifier).confirmTransact(newTransaction.id, newTransaction.planTransactId!);
    }
    _repo.putTransaction(newTransaction);
    notifyListeners();
  }

  Transaction? getTransactionById(String id) {
    return _repo.getTransactionById(id);
  }

  List<Transaction> getTransactions() {
    return _repo.getTransactions();
  }

  void deleteTransaction(String id) {
    _repo.deleteTransaction(id);
    notifyListeners();
  }
}

final transactionsViewModelProvider = ChangeNotifierProvider((ref) {
  return TransactionViewModel(ref, ref.watch(transactionRepoProvider));
});

final totalActualIncomeProvider = Provider.family((ref, TimeRange range) {
  final incomes = ref.watch(transactionsViewModelProvider).getTransactions()
                     .where((e) => e.amount > 0 && range.contain(e.timestamp));
  return incomes.fold(0, (prev, e) => prev + e.amount);
});

final totalActualExpenseProvider = Provider.family((ref, TimeRange range) {
  final expenses = ref.watch(transactionsViewModelProvider).getTransactions()
                      .where((e) => e.amount < 0 && range.contain(e.timestamp));
  return expenses.fold(0, (previousValue, element) => previousValue + element.amount);
});