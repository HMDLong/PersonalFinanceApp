import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving_app/data/models/accounts.model.dart';
import 'package:saving_app/data/repositories/accounts/saving/saving_repo.dart';
import 'package:saving_app/data/repositories/accounts/saving/saving_repo_impl.dart';

final savingViewModelProvider = ChangeNotifierProvider(
  (ref) => SavingViewModel(repo: ref.watch(savingRepoProvider))
);

class SavingViewModel extends ChangeNotifier {
  final SavingRepository _repo;

  SavingViewModel({
    required SavingRepository repo
  }) : _repo = repo;

  Future<List<Saving>> getSavings() {
    return _repo.getSavings();
  }

  Future<Saving?> getById(String id) {
    return _repo.getById(id);
  }

  Future<void> putSaving(Saving newSaving) async {
    await _repo.putSaving(newSaving);
    notifyListeners();
  }

  Future<void> updateSaving(Saving newSaving) async {
    await _repo.updateSaving(newSaving);
    notifyListeners();
  }

  Future<void> deleteSaving(String id) async {
    await _repo.deleteSaving(id);
    notifyListeners();
  }

  Future<void> spendFromSaving(String id, int amount) async {
    
  }

  Future<void> save(String id, int amount) async {

  }
}