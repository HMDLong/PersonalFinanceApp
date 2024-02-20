import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving_app/constants/built_in_categories.dart';
import 'package:saving_app/data/models/category.model.dart';
import 'package:saving_app/data/models/transaction.model.dart';
import 'package:saving_app/data/repositories/transact/transact_repo.dart';
import 'package:saving_app/data/repositories/transact/transact_repo_impl.dart';
import 'package:saving_app/utils/times.dart';
import 'package:saving_app/viewmodels/account/account_viewmodel.dart';
import 'package:saving_app/viewmodels/transact/plan_transact_viewmodel.dart';

class TransactionViewModel extends ChangeNotifier {
  final TransactRepository _repo;
  final Ref ref;

  TransactionViewModel(this.ref, this._repo);

  void putTransaction(Transaction newTransaction) {
    if(newTransaction.planTransactId != null && newTransaction.paid) {
      ref.read(planTransactionProvider.notifier).confirmTransact(newTransaction.id, newTransaction.planTransactId!);
    }
    if(newTransaction.paid) {
      ref.watch(updateAccountOnNewTransaction(newTransaction));
    }
    _repo.putTransaction(newTransaction);
    notifyListeners();
  }

  void updateTransaction(Transaction newTransaction) {
    if(newTransaction.planTransactId != null) {
      ref.watch(planTransactionProvider.notifier).confirmTransact(newTransaction.id, newTransaction.planTransactId!);
    }
    // ref.watch(updateAccountOnNewTransaction(newTransaction));
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
                     .where((e) => e.transactType == TransactionType.income && range.contain(e.timestamp) && e.paid);
  return incomes.fold(0, (prev, e) => prev + e.amount);
});

final totalActualExpenseProvider = Provider.family((ref, TimeRange range) {
  final expenses = ref.watch(transactionsViewModelProvider).getTransactions()
                      .where((e) => e.transactType == TransactionType.expense && range.contain(e.timestamp) && e.paid);
  return expenses.fold(0, (previousValue, element) => previousValue + element.amount);
});

final totalExpectedIncomeProvider = Provider.family((ref, TimeRange range) {
  final incomes = ref.watch(transactionsViewModelProvider).getTransactions()
                     .where((e) => e.transactType == TransactionType.income && range.contain(e.timestamp) && !e.paid);
  return incomes.fold(0, (prev, e) => prev + e.amount);                  
});

final totalExpectedExpenseProvider = Provider.family((ref, TimeRange range) {
  final expenses = ref.watch(transactionsViewModelProvider).getTransactions()
                      .where((e) => e.transactType == TransactionType.expense && range.contain(e.timestamp) && !e.paid);
  return expenses.fold(0, (previousValue, element) => previousValue + element.amount);
});

final planExpensesProvider = Provider.family((ref, TimeRange range) {
  return ref.watch(transactionsViewModelProvider).getTransactions()
            .where((e) => e.transactType == TransactionType.expense && range.contain(e.timestamp) && e.planTransactId != null);
});

final planIncomesProvider = Provider.family((ref, TimeRange range) {
  return ref.watch(transactionsViewModelProvider).getTransactions()
            .where((e) => e.transactType == TransactionType.income && range.contain(e.timestamp) && e.planTransactId != null);
});

final scheduledPlanTransactProvider = Provider.family((ref, TimeRange range) {
    return ref.watch(transactionsViewModelProvider).getTransactions()
              .where((e) => range.contain(e.timestamp) && e.planTransactId != null);
});

final currentClosestPlanExpenses = Provider.family((ref, TimeRange range) {
  final res = <Transaction>[];
  final expenses = ref.watch(planExpensesProvider(range))
                      .toList()
                      ..sort((a, b) => a.timestamp.toDateOnly().compareTo(b.timestamp.toDateOnly()));
  final today = DateTime.now().toDateOnly();
  for(var i = 0; i < expenses.length; i++) {
    if(today.isAfter(expenses[i].timestamp.toDateOnly())) {
      res.add(expenses[i]);
      if(i < expenses.length - 1) {
        res.add(expenses[i+1]);
      } 
    }
  }
  return res;
});

final currentClosestPlanIncome = Provider.family((ref, TimeRange range) {
  final res = <Transaction>[];
  final expenses = ref.watch(planIncomesProvider(range))
                      .toList()
                      ..sort((a, b) => a.timestamp.toDateOnly().compareTo(b.timestamp.toDateOnly()));
  final today = DateTime.now().toDateOnly();
  for(var i = 0; i < expenses.length; i++) {
    if(today.isAfter(expenses[i].timestamp.toDateOnly())) {
      res.add(expenses[i]);
      if(i < expenses.length - 1) {
        res.add(expenses[i+1]);
      } 
    }
  }
  return res;
});

final totalAmountByGroupProvider = Provider.family((ref, List args) {
  final categoryId = args[0] as String;
  final timeRange = args[1] as TimeRange;
  for(var group in builtInCategories) {
    if(group.id == categoryId){
      final subIdList = group.subCategories.map((e) => e.id).toList();
      final transactions = ref.watch(transactionsViewModelProvider).getTransactions()
                              .where((transact) => subIdList.contains(transact.categoryId) && timeRange.contain(transact.timestamp));
      return transactions.fold(0, (total, transact) => total + transact.amount);
    }
  }
  return -1;
});

final totalAmountByCategoryProvider = Provider.family((ref, List args) {
  final categoryId = args[0] as String;
  final timeRange = args[1] as TimeRange;
  return ref.watch(transactionsViewModelProvider).getTransactions()
            .where((element) => element.categoryId == categoryId && timeRange.contain(element.timestamp))
            .fold(0, (total, transact) => total + transact.amount);
});

final transactIsLate = Provider.family((ref, String id) {

});

final totalDebtPaidById = Provider.family((ref, String id) {
  final currentMonth = getRangeOfTheMonth();
  final transacts = ref.watch(transactionsViewModelProvider)
                       .getTransactions()
                       .where(
                        (transact) => transact.planTransactId != null 
                                      && transact.paid 
                                      && transact.targetAccountId == id
                                      && currentMonth.contain(transact.timestamp)
                        )
                        .fold(0, (prev, e) => prev + e.amount);
  return transacts;
});

final planTransactById = Provider.family((ref, String id) {
  return ref.watch(transactionsViewModelProvider)
  .getTransactions()
  .where((transact) => transact.planTransactId != null && transact.planTransactId == id)
  .firstOrNull;
});