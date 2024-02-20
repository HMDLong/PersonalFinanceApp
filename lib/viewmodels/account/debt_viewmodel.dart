import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving_app/data/models/accounts.model.dart';
import 'package:saving_app/data/models/plan/debt_strat.dart';
import 'package:saving_app/data/models/plan/plan.dart';
import 'package:saving_app/data/repositories/accounts/debt/debt_repo.dart';
import 'package:saving_app/data/repositories/accounts/debt/debt_repo_impl.dart';
import 'package:saving_app/domain/providers/transaction_provider.dart';
import 'package:saving_app/utils/times.dart';
import 'package:saving_app/viewmodels/plan/plan_setting_viewmodel.dart';
import 'package:saving_app/viewmodels/transact/plan_transact_viewmodel.dart';

class DebtViewModel extends ChangeNotifier {
  final DebtRepository _repo;

  DebtViewModel({
    required DebtRepository repo,
  }) : _repo = repo;

  Future<List<Debt>> getDebts() {
    return _repo.getDebts();
  }

  Future<Debt?> getDebtById(String id) {
    return _repo.getDebtById(id);
  }

  Future<void> putDebt(Debt newDebt) async {
    await _repo.putDebt(newDebt);
    notifyListeners();
  }

  Future<void> payDebt(String id, int amount) async {
    final data = await _repo.getDebtById(id);
    if(data != null) {
      await _repo.putDebt(data..amount = data.amount! - amount);
    }
  }

  Future<void> calculateSnowball(PlanSetting planSetting) async {
    
  }
}

final debtViewModelProvider = ChangeNotifierProvider((ref) {
  return DebtViewModel(repo: ref.watch(debtRepoProvider));
});

final totalDebtProvider = FutureProvider((ref) async {
  final debts = await ref.watch(debtViewModelProvider).getDebts();
  final res = debts.fold(0, (prev, e) => prev + e.amount!);
  return res;
});

final totalDebtToPay = FutureProvider.family((ref, TimeRange range) async {
  final debts = await ref.watch(debtViewModelProvider).getDebts();
  final total = debts.fold(0, (prev, debt) => prev + debt.payment.minimumPayment);
  return total;
});

final totalDebtPaidProvider = Provider.family((ref, TimeRange range) {
  final datas = ref.watch(transactionProvider).getAllTransaction();
  return datas
  .where((transact) => range.contain(transact.timestamp) && ["c9.3", "c12.1"].contains(transact.categoryId))
  .fold(0, (prev, transact) => prev + transact.amount);
});

final snowballAmount = FutureProvider((ref) async {
  final incomeDist = ref.watch(currentIncomeDistProvider).when(
                  data: (data) => data, 
                  error: (error, _) => null, 
                  loading: () => null
  );
  final totalIncome = ref.watch(totalIncomeProvider).when(
    data: (data) => data, 
    error: (error, _) => 0, 
    loading: () => -1,
  );
  if(incomeDist != null && totalIncome != null) {
    
  }
});

final debtsProvider = FutureProvider((ref) async {
  return await ref.watch(debtViewModelProvider).getDebts();
});

final debtStrategiesProvider = Provider((ref) => [
  AvalanceStrategy(),
  SnowballStrategy(),
]);


