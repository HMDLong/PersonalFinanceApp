import 'package:flutter/material.dart';
import 'package:saving_app/constants/built_in_categories.dart';
import 'package:saving_app/data/local/model_repos/plan_transact/plan_transact_repo.dart';
import 'package:saving_app/data/local/model_repos/records/transact_repo.dart';
import 'package:saving_app/data/models/category.model.dart';
import 'package:saving_app/data/models/plan_transaction.model.dart';
import 'package:saving_app/data/models/transaction.model.dart';
import 'package:saving_app/services/notification_service.dart';
import 'package:saving_app/utils/times.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionRepository _transactRepo;
  final PlanTransactJsonRepository _planTransactRepo;

  TransactionProvider({
    required TransactionRepository transactRepo,
    required PlanTransactJsonRepository planTransactRepo,
  }) : _transactRepo = transactRepo,
       _planTransactRepo = planTransactRepo;

  int getSumOfCategoryInRange(String categoryId, TimeRange range) {
    final matched = _transactRepo.getAll().where(
      (transact) => transact.categoryId == categoryId && range.contain(transact.timestamp)
    );
    if(matched.isEmpty) return 0;
    return matched.fold(0, (prev, e) => prev + e.amount);
  }

  int getSumOfCategoriesInRange(List<String> categoryIds, TimeRange range) {
    return categoryIds.fold(0, (prev, e) => prev + getSumOfCategoryInRange(e, range));
  }

  List<Transaction> getAllTransaction() {
    return _transactRepo.getAll();
  }

  List<Transaction> getByCategory(String categoriesId) {
    return _transactRepo.getAll().where((e) => e.categoryId == categoriesId).toList();
  }

  List<Transaction> getByType(TransactionType type) {
    final categoryIdsOfType = builtInCategories
    .where((element) => element.type == type)
    .fold(<String>[], (prev, group) {
      for(var sub in group.subCategories) {
        prev.add(sub.id!);
      }
      return prev;
    });
    return _transactRepo.getAll().where((e) => categoryIdsOfType.contains(e.id)).toList();
  }

  void putTransaction(Transaction newTransaction) {
    _transactRepo.put(newTransaction);
    notifyListeners();
  }

  void putPlanTransaction(PlanTransaction newPlanTransact){
    _planTransactRepo.put(newPlanTransact);
    if(newPlanTransact.notificationId > 0) {
      NotificationService().scheduleNotification(newPlanTransact.makeNotification());
    }
    notifyListeners();
  }

  List<PlanTransaction> getPlanTransactsByType(TransactionType type) {
    return _planTransactRepo.getAll().where((e) => e.transactType == type).toList();
  }

  List<PlanTransaction> getIncomes() {
    return _planTransactRepo.getAll().where((e) => e.amount > 0).toList();
  }

  List<PlanTransaction> getExpenses() {
    return _planTransactRepo.getAll().where((e) => e.amount < 0).toList();
  }

  int getTotalSpentAmount() {
    return _transactRepo.getAll()
    .where((transact) => transact.amount < 0 && getRangeOfTheMonth().contain(transact.timestamp))
    .fold(0, (sum, transact) => sum + transact.amount).abs();
  }
}
