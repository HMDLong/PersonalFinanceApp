import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving_app/data/repositories/accounts/cash/cash_repo.dart';
import 'package:saving_app/data/repositories/accounts/cash/cash_repo_impl.dart';

class CashViewModel extends ChangeNotifier {
  final CashRepository _repo;
  CashViewModel({
    required CashRepository repo
  }) : _repo = repo;

  Future<int> getCurrentCash() {
    return _repo.getCashAmount();
  }

  Future<void> addCash(int amount) async {
    final newCash = (await getCurrentCash()) + amount;
    _repo.setCashAmount(newCash);
  }
}

final cashViewModelProvider = ChangeNotifierProvider((ref) {
  return CashViewModel(repo: ref.watch(cashRepoProvider));
});

final currentCashAmountProvider = FutureProvider((ref) async {
  return await ref.watch(cashViewModelProvider).getCurrentCash();
});
