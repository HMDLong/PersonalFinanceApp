import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving_app/features/accounts/models/account.dart';
import 'package:saving_app/features/accounts/repositories/account_repo.dart';
import 'package:saving_app/features/accounts/repositories/account_repo_impl.dart';

class AccountViewModel extends ChangeNotifier {
  final AccountRepository repo;
  AccountViewModel({required this.repo});

  Future<List<Account>> getAllAccount() async {
    return repo.allAccounts;
  }

  Future<List<Account>> getAccountByType(AccountType type) async {
    return repo.getByType(type);
  }

  Future<Account?> getAccountById(String id) async {
    return repo.getById(id);
  }

  Future<void> addAccount(Account newAccount) async {
    await repo.add(newAccount);
    print("acc added");
    notifyListeners();
  }

  Future<void> deleteAccount(String accountId) async {
    await repo.delete(accountId);
    notifyListeners();
  }

  Future<void> transfer(Account from, Account? to, int amount) async {
    if(from.amount! < amount ) {
      throw Exception("Not enough balance in ${from.title}");
    }
    from.amount = from.amount! - amount;
    await repo.update(from);
    if(to != null) {
      to.amount = to.amount! + amount;
      await repo.update(to);
    }
    notifyListeners();
  }

  void rollback(Account from, Account? to, int amount) {
    notifyListeners();
  }

  Future<void> updateAccount(Account account) async {
    await repo.update(account);
    notifyListeners();
  }
}

final accountsProvider = ChangeNotifierProvider((ref) {
  return AccountViewModel(repo: ref.watch(accountRepoProvider));
});