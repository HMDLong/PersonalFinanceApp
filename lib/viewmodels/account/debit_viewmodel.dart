import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving_app/data/models/accounts.model.dart';
import 'package:saving_app/data/repositories/accounts/debit/debit_repo.dart';
import 'package:saving_app/data/repositories/accounts/debit/debit_repo_impl.dart';

final debitViewModelProvider = ChangeNotifierProvider((ref) {
  return DebitViewModel(repo: ref.watch(debitRepoProvider));
});

class DebitViewModel extends ChangeNotifier {
  final DebitRepository _repo;

  DebitViewModel({required DebitRepository repo}) : _repo = repo;

  Future<void> putDebit(Debit newDebit) async {
    await _repo.putDebit(newDebit);
    notifyListeners();
  }
  
  Future<List<Debit>> getDebits() {
    return _repo.getDebits();
  }

  Future<Debit?> getById(String id) {
    return _repo.getById(id);
  }

  Future<void> updateDebit(Debit newDebit) async {
    await _repo.updateDebit(newDebit);
    notifyListeners();
  }
  
  Future<void> removeDebit(String id) async {
    await _repo.deleteDebit(id);
    notifyListeners();
  }

  Future<void> addToDebit(String id, int amount) async {
    final debit = await _repo.getById(id);
    if(debit != null) {
      debit.amount = debit.amount! + amount;
      await _repo.updateDebit(debit);
      notifyListeners();
    }
  }

  Future<void> spendOnDebit(String id, int amount) async {
    final debit = await _repo.getById(id);
    if(debit != null) {
      if(amount > debit.amount!) {
        throw Exception("Debit{id=$id}: amount > debit.amount");
      }
      debit.amount = debit.amount! - amount;
      await _repo.updateDebit(debit);
      notifyListeners();
    }
  }
}