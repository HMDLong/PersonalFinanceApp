import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving_app/data/models/category.model.dart';
import 'package:saving_app/data/models/plan_transaction.model.dart';
import 'package:saving_app/data/repositories/plan_transact/plan_transact_repo.dart';
import 'package:saving_app/data/repositories/plan_transact/plan_transact_repo_impl.dart';
import 'package:saving_app/services/notification_service.dart';

class PlanTransactionNotifier extends ChangeNotifier {
  final PlanTransactionRepository _repo; 

  PlanTransactionNotifier({
    required PlanTransactionRepository repo
  }) : _repo = repo;
  
  Future<List<PlanTransaction>> getAllPlanTransacts() {
    return _repo.getPlanTransacts();
  }

  void confirmTransact(String transactId, String planTransactId) async {
    final planTransact = await _repo.getPlanTransactById(planTransactId);
    if(planTransact != null) {
      planTransact.status = PaidStatus.paid;
      await _repo.updatePlanTransact(planTransact);
    }
    notifyListeners();
  }

  void putPlanTransact(PlanTransaction newPlanTransact) async {
    await _repo.putPlanTransact(newPlanTransact);
    if(newPlanTransact.notificationId > 0) { 
      NotificationService().scheduleNotification(newPlanTransact.makeNotification());
    }
    notifyListeners();
  }

  void pushNotification(PlanTransaction newPlanTransact) async {
    NotificationService().scheduleNotification(newPlanTransact.makeNotification());
  }
}

final planTransactionProvider = ChangeNotifierProvider((ref) => 
  PlanTransactionNotifier(repo: ref.watch(planTransactRepoProvider))
);

final incomeProvider = FutureProvider((ref) async {
  final planTransacts = await ref.watch(planTransactionProvider).getAllPlanTransacts();
  return planTransacts.where((transact) => transact.transactType == TransactionType.income).toList();
});

final expensesProvider = FutureProvider((ref) async {
  final planTransacts = await ref.watch(planTransactionProvider).getAllPlanTransacts();
  return planTransacts.where((transact) => transact.transactType == TransactionType.expense).toList();
});

final transactProvider = FutureProvider((ref) async {
  final planTransacts = await ref.watch(planTransactionProvider).getAllPlanTransacts();
  return planTransacts.where((transact) => transact.transactType == TransactionType.transact).toList();
});

final totalIncomeProvider = FutureProvider((ref) async {
  final planTransacts = await ref.watch(planTransactionProvider).getAllPlanTransacts();
  final res = planTransacts.where((transact) => transact.transactType == TransactionType.income)
  .fold(0, (prev, transact) => prev + transact.amount);
  return res;
});
