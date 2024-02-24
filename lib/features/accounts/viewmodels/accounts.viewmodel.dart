import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving_app/data/models/accounts.model.dart';
import 'package:saving_app/features/accounts/repositories/account_repo.dart';

class AccountViewModel extends ChangeNotifier {
  final AccountRepository repo;
  AccountViewModel({required this.repo});

  Future<List<Account>> getAllAccount() async {
    return repo.allAccounts;
  }

  Future<Account?> getAccountById(String id) async {
    return repo.getById(id);
  }

  Future<void> addAccount(Account newAccount) async {
    repo.add(newAccount);
    notifyListeners();
  }

  Future<void> deleteAccount(String accountId) async {
    repo.delete(accountId);
    notifyListeners();
  }

  Future<void> transfer(Account from, Account? to, int amount) async {
    if(from.amount! < amount ) {
      throw Exception("Not enough balance in ${from.title}");
    }
    from.amount = from.amount! - amount;
    repo.update(from);
    if(to != null) {
      to.amount = to.amount! + amount;
      repo.update(to);
    }
    notifyListeners();
  }

  void rollback(Account from, Account? to, int amount) {
    notifyListeners();
  }
}

final accountsProvider = Provider((ref) {
  return AccountViewModel(repo: ref.watch(accountRepoProvider));
});