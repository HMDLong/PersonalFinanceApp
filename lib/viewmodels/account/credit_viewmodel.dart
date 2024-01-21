import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving_app/data/models/accounts.model.dart';
import 'package:saving_app/data/repositories/accounts/credit/credit_repo_impl.dart';

import '../../data/repositories/accounts/credit/credit_repo.dart';

final creditViewModelProvider = ChangeNotifierProvider((ref) {
  return CreditViewModel(repo: ref.watch(creditRepoProvider));
});

class CreditViewModel extends ChangeNotifier {
  final CreditRepository _repo;

  CreditViewModel({
    required CreditRepository repo,
  }) : _repo = repo;

  Future<List<Credit>> getCredits() async {
    return _repo.getCredits();
  }

  Future<Credit?> getCreditById(String id) async {
    return _repo.getById(id);
  }

  Future<void> setCredit(Credit newCredit) async {
    _repo.putCredit(newCredit);
    notifyListeners();
  }

  Future<void> creditSpend(String creditId, int amount) async {

  }

  Future<void> creditRepay(String creditId, int amount) async {

  }
}