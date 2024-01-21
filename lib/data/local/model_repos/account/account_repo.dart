import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:saving_app/data/local/local_repository.dart';
import 'package:saving_app/data/local/model_repos/account/credit_repo.dart';
import 'package:saving_app/data/local/model_repos/account/debit_repo.dart';
import 'package:saving_app/data/local/model_repos/account/savings_repo.dart';
import 'package:saving_app/data/models/accounts.model.dart';

class AccountManager {
  Map<String, BaseLocalRepository> accountRepos;

  int get totalBalance => 
  (accountRepos["debits"] as DebitRepository).getAll().map((e) => e.amount!).reduce((value, element) => value + element)
  + (accountRepos["credits"] as CreditRepository).getAll().map((e) => e.limit! - e.amount!).reduce((value, element) => value + element)
  + (accountRepos["savings"] as SavingRepository).getAll().map((e) => e.amount!).reduce((value, element) => value + element);

  AccountManager.of(BuildContext context) :
    accountRepos = {
      "debits": context.read<DebitRepository>(),
      "credit": context.read<CreditRepository>(),
      "savings": context.read<SavingRepository>(),
    };
  
  Account? getAccountById(String id) {
    for(var repo in accountRepos.values) {
      var res = repo.getAt(id);
      if(res != null){
        return res;
      }
    }
    return null;
  }

  void updateAccountBalance(String accountId, int amount) {
    for(var repo in accountRepos.values) {
      var res = repo.getAt(accountId) as Account?;
      if(res != null){
        res.amount = res.amount! + amount;
        repo.updateAt(accountId, res);
      }
    }
  }

  void deleteAccount(String id) {
    for(var repo in accountRepos.values) {
      repo.deleteAt(id);
    }
  }
}