import 'dart:math';

import 'package:flutter/material.dart';
import 'package:saving_app/data/local/model_repos/budget/budget_json_repo.dart';
import 'package:saving_app/data/local/model_repos/records/category_repository.dart';
import 'package:saving_app/data/local/model_repos/plan_transact/plan_transact_repo.dart';
import 'package:saving_app/data/local/model_repos/records/transact_repo.dart';
import 'package:saving_app/data/models/category.model.dart';
import 'package:saving_app/data/models/plan_transaction.model.dart';
import 'package:saving_app/services/notification_service.dart';
import 'package:saving_app/utils/times.dart';

class PlanController extends ChangeNotifier {
  final PlanTransactJsonRepository _planTransactRepo;
  final BudgetJsonRepository _budgetRepo;
  final PlanSettings _planSettings;
  final CategoryRepository _categoryRepository;
  final TransactionRepository _transactRepo;

  PlanController({
    required PlanTransactJsonRepository planTransactRepo,
    required BudgetJsonRepository budgetRepo,
    required CategoryRepository categoryRepo,
    required PlanSettings planSettings,
    required TransactionRepository transactRepo,
  }) : _planTransactRepo = planTransactRepo,
       _budgetRepo = budgetRepo,
       _planSettings = planSettings,
       _categoryRepository = categoryRepo,
       _transactRepo = transactRepo;

  void notifyPlanController() {
    notifyListeners();
  }

  List<PlanTransaction> getAllPlanTransaction() {
    return _planTransactRepo.getAll();
  }

  PlanTransaction? getPlanTransactById(String id) {
    return _planTransactRepo.getAt(id);
  }

  void newPlanTransaction(PlanTransaction newPlanTransaction) {
    _planTransactRepo.put(newPlanTransaction);
    if(newPlanTransaction.notificationId >= 0) {
      NotificationService().scheduleNotification(newPlanTransaction.makeNotification());
    }
    notifyListeners();
  }

  void setNotification(String planTransactId, bool notiOn) {
    final transact = _planTransactRepo.getAt(planTransactId);
    if(transact == null) {
      return;
    }
    if(notiOn){
      transact.notificationId = Random.secure().nextInt(100000);
      NotificationService().scheduleNotification(transact.makeNotification());
    } else {
      NotificationService().cancelNotification(transact.notificationId);
      transact.notificationId = -1;
    }
    _planTransactRepo.updateAt(transact.id, transact);
    notifyListeners();
  }

  void removePlanTransaction(String id) {
    _planTransactRepo.deleteAt(id);
    notifyListeners();
  }

  double getRecommend(String categoryId) {
    final plannedIncomes = _planTransactRepo
    .getAll()
    .where((planTransact) => planTransact.amount > 0);
    if(plannedIncomes.isEmpty) {
      print("incomes not found");
      return 0.0;
    }
    final totalIncome = plannedIncomes.map((planTransact) => planTransact.amount)
    .reduce((value, element) => value + element);
    return _planSettings.getRecommendForId(categoryId, totalIncome);
  }

  void newBudget(Budget newBudget) {
    final group = _categoryRepository.getParentByChild(newBudget.categoryId!);
    final groupBudget = group!.budget;
    if(groupBudget == null) {
      _budgetRepo.put(Budget(
        amount: newBudget.amount! * switch(newBudget.period) {
          BudgetPeriod.weekly => 4,
          _ => 1,
        }, 
        categoryId: group.id)
      );
    } else {
      groupBudget.amount = groupBudget.amount! + newBudget.amount!;
      _budgetRepo.updateAt(group.id, groupBudget);
    }
    _budgetRepo.put(newBudget);
    notifyListeners();
  }

  void removeBudget(String categoryId) {
    _budgetRepo.deleteAt(categoryId);
    notifyListeners();
  }

  void editBudget(Budget newBudget){
    _budgetRepo.updateAt(newBudget.categoryId, newBudget);
    notifyListeners();
  }

  List<Map<String, dynamic>> getBudgetsWithProgress(TimeRange? range) {
    final res = <Map<String, dynamic>>[];
    for(var budget in _budgetRepo.getAll()){
      final category = _categoryRepository.getAt(budget.categoryId);
      final transacts = _transactRepo.getAll()
                      .where(
                        (transact) => (range == null ? true : range.contain(transact.timestamp))
                                      && transact.categoryId == budget.categoryId
                      );
      if(transacts.isEmpty) {
        res.add({
          "budget": budget,
          "category": category,
          "spentAmount": 0
        });
      } else {
        res.add({
          "budget": budget,
          "category": category,
          "spentAmount": transacts.map((e) => e.amount).reduce((val, e) => val + e),
        });
      }
    }
    return res;
  }

  TransactCategory? getCategoryById(String id){
    return _categoryRepository.getAt(id);
  }

  CategoryGroup? getGroupCategoryBySubId(String id) {
    return _categoryRepository.getParentByChild(id);
  }

  List<double> getCurrentPlan() {
    return _planSettings.currentIncomeDist;
  }

  int getExpectedIncomes() {
    final res = _planTransactRepo.getAll()
    .where((element) => element.amount > 0);
    if(res.isEmpty) return 0;
    return res.map((e) => e.amount).reduce((value, element) => value + element);
  }

  int getActualIncomes() {
    final currentMonth = getRangeOfTheMonth();
    final res = _transactRepo.getAll()
    .where((e) => e.amount > 0 && currentMonth.contain(e.timestamp))
    .map((e) => e.amount);
    if(res.isEmpty) return 0;
    return res.reduce((value, element) => value + element);
  }

  int getTotalBudget() {
    final all = _categoryRepository.getAllCategories();
    return all.fold(
      0, 
      (previousValue, element){
        return previousValue + (element.budget == null ? 0 : element.budget!.amount!);
      }
    );
  }

  int getTotalSpentAmount() {
    final res = _transactRepo.getAll().where((element) => element.amount < 0);
    int amount = 0;
    for(var transact in res) {
      amount += transact.amount;
    }
    return amount;
  }
}

class PlanSettings {
  Map<String, double> budgetDist = {
    
  };
  
  int _currentPlan = 0;
  List<List<double>> _incomeDist = [
    [0.5, 0.3, 0.2],
    [0.7, 0.2, 0.1],
    []
  ];

  

  List<double> get currentIncomeDist => _incomeDist[_currentPlan];

  set currentPlan(int newPlan) {
    _currentPlan = newPlan;
  }

  double getRecommendForId(String id, int amount) {
    return 0.2 * amount;
  }
}
