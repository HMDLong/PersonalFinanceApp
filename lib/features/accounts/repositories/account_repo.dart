import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving_app/data/models/accounts.model.dart';

class AccountRepository {
  int get cash {
    return 0;
  }

  List<Debit> get debits {
    return [];
  }

  List<Credit> get credits {
    return [];
  }

  List<Debt> get debts {
    return [];
  }

  List<Account> get allAccounts {
    return [];
  }

  Account? getById(String id) {
    final res = allAccounts.where((acc) => acc.id == id);
    if(res.isEmpty) {
      return null;
    }
    return res.first;
  }

  void add(Account newAccount) {

  }

  void update(Account newAccount) {

  }

  void delete(String id) {

  }
}

final accountRepoProvider = Provider((ref) => AccountRepository());