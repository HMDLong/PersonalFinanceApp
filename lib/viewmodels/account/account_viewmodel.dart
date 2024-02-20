import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving_app/data/models/accounts.model.dart';
import 'package:saving_app/data/models/transaction.model.dart';
import 'package:saving_app/viewmodels/account/cash_viewmodel.dart';
import 'package:saving_app/viewmodels/account/credit_viewmodel.dart';
import 'package:saving_app/viewmodels/account/debit_viewmodel.dart';
import 'package:saving_app/viewmodels/account/debt_viewmodel.dart';
import 'package:saving_app/viewmodels/account/saving_viewmodel.dart';

final allPayableAccountProvider = FutureProvider((ref) async {
  final res = <Account>[];
  final cashAmount = await ref.watch(cashViewModelProvider).getCurrentCash();
  res.add(Account(id: "0", amount: cashAmount));
  res.addAll(await ref.watch(debitViewModelProvider).getDebits());
  res.addAll(await ref.watch(creditViewModelProvider).getCredits());
  res.addAll(await ref.watch(savingViewModelProvider).getSavings());
  return res;
});

final allTargetableAccountProvider = FutureProvider((ref) async {
  final res = <Account>[];
  final cashAmount = await ref.watch(cashViewModelProvider).getCurrentCash();
  res.add(Account(id: "0", amount: cashAmount));
  res.addAll(await ref.watch(debitViewModelProvider).getDebits());
  res.addAll(await ref.watch(creditViewModelProvider).getCredits());
  res.addAll(await ref.watch(debtViewModelProvider).getDebts());
  res.addAll(await ref.watch(savingViewModelProvider).getSavings());
  return res;
});

final totalBalanceProvider = Provider((ref) {
  final accounts = ref.watch(allPayableAccountProvider).when(
    data: (data) => data, 
    error: (error, _) => throw error, 
    loading: () => null,
  );
  if(accounts == null) {
    return -3;
  }
  if(accounts.isEmpty) {
    return -4;
  }
  final res = accounts.fold(0, (prev, e) => prev + e.usableBalance);
  return res;
});


final getAccountByIdProvider = FutureProvider.family((ref, String id) async {
  var res1 = await ref.watch(debitViewModelProvider).getById(id);
  if(res1 != null) return res1;
  var res2 = await ref.watch(creditViewModelProvider).getCreditById(id);
  if(res2 != null) return res2;
  var res3 = await ref.watch(savingViewModelProvider).getById(id);
  if(res3 != null) return res3;
  var res4 = await ref.watch(debtViewModelProvider).getDebtById(id);
  if(res4 != null) return res4;
  return null;
});

final updateAccountOnNewTransaction = Provider.family((ref, Transaction newTransact) {
  if(newTransact.transactAccountId != null) {
    final acc = ref.watch(getAccountByIdProvider(newTransact.transactAccountId!)).when(
      data: (data) => data, 
      error: (error, _) => null, 
      loading: () => null,
    );
    acc!.amount = acc.amount! + newTransact.amount;
  }
});