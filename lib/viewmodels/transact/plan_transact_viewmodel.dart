import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving_app/data/models/category.model.dart';
import 'package:saving_app/data/models/plan_transaction.model.dart';
import 'package:saving_app/data/repositories/plan_transact/plan_transact_repo.dart';
import 'package:saving_app/data/repositories/plan_transact/plan_transact_repo_impl.dart';
import 'package:saving_app/services/notification_service.dart';
import 'package:saving_app/utils/times.dart';
import 'package:saving_app/viewmodels/transact/transact_viewmodel.dart';

class PlanTransactionNotifier extends ChangeNotifier {
  final PlanTransactionRepository _repo;
  final Ref ref;

  PlanTransactionNotifier({
    required this.ref,
    required PlanTransactionRepository repo,
  }) : _repo = repo;
  
  Future<List<PlanTransaction>> getAllPlanTransacts() {
    return _repo.getPlanTransacts();
  }

  Future<PlanTransaction?> getPlanTransactById(String id) {
    return _repo.getPlanTransactById(id);
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
    for(var transact in newPlanTransact.schedule(getRangeOfTheMonth())) {
      ref.read(transactionsViewModelProvider).putTransaction(transact);
    }
    await _repo.putPlanTransact(newPlanTransact);
    if(newPlanTransact.notificationId > 0) { 
      NotificationService().scheduleNotification(newPlanTransact.makeNotification());
    }
    notifyListeners();
  }

  void pushNotification(PlanTransaction newPlanTransact) async {
    NotificationService().scheduleNotification(newPlanTransact.makeNotification());
  }

  void setPlanTransactNoti(String id, bool noti) async {
    final transact = await _repo.getPlanTransactById(id);
    if(transact == null) {
      return;
    }
    if(noti){
      transact.notificationId = Random.secure().nextInt(100000);
      NotificationService().scheduleNotification(transact.makeNotification());
    } else {
      NotificationService().cancelNotification(transact.notificationId);
      transact.notificationId = -1;
    }
    await _repo.updatePlanTransact(transact);
    notifyListeners();
  }
}

final planTransactionProvider = ChangeNotifierProvider((ref) => 
  PlanTransactionNotifier(ref: ref, repo: ref.watch(planTransactRepoProvider))
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

final planTransactNoti = FutureProvider.family((ref, String id) async {
  final transact = await ref.watch(planTransactionProvider).getPlanTransactById(id);
  return transact!.notificationId > 0;
});

final getPlanTransactStatus = Provider.family((ref, List args) {
  final planTransactId = args[0] as String;
  final planTime = args[1] as DateTime;
  final planPeriodic = args[2] as Periodic;
  final transact = ref.watch(transactionsViewModelProvider)
                      .getTransactions()
                      .where((transaction) => 
                        transaction.planTransactId != null 
                        && transaction.planTransactId == planTransactId
                        && switch(planPeriodic) {
                          Periodic.onetime => true,
                          Periodic.daily => true,
                          Periodic.weekly => getRangeOfTheWeek(targetDate: planTime).contain(transaction.timestamp),
                          Periodic.monthly => getRangeOfTheMonth(date: planTime).contain(transaction.timestamp),
                          Periodic.yearly => getRangeOfTheYear(date: planTime).contain(transaction.timestamp),
                        }
                      ).firstOrNull;
  final today = DateTime.now().toDateOnly();
  if(transact == null) {
    if(today.isAfter(planTime)){
      return PaidStatus.late;
    }
  } else {

  }
});