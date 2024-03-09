import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving_app/features/accounts/models/account.dart';
import 'package:saving_app/features/accounts/repositories/account_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountRepositoryImpl extends AccountRepository {
  final sharedRef = SharedPreferences.getInstance();

  @override
  Future<void> add(Account newAccount) async {
    print("repo impl adding");
    final accs = await allAccounts;
    await save(accs..add(newAccount), await sharedRef);
    print("repo impl added");
  }

  @override
  Future<void> update(Account newAccount) async {
    final accs = await allAccounts;
    await save(accs.map((e) => e.id == newAccount.id ? newAccount : e).toList(), await sharedRef);
  }

  @override
  Future<void> delete(String id) async {

  }

  @override
  Future<List<Account>> get allAccounts async {
    final ref = await sharedRef;
    final datas = ref.getStringList("accounts");
    if(datas == null) {
      print("datas == null");
      return [];
    }
    print(datas);
    return datas.map((e) => Account.createFromJson(json.decode(e) as Map<String, dynamic>)).toList();
  }

  Future<void> save(List<Account> accounts, SharedPreferences sharedRef) async {
    await sharedRef.setStringList("accounts", accounts.map((acc) => json.encode(acc.toJson())).toList());
  }
}

final accountRepoProvider = Provider((ref) => AccountRepositoryImpl());