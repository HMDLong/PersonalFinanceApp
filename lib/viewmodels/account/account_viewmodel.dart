import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving_app/data/models/accounts.model.dart';
import 'package:saving_app/viewmodels/account/cash_viewmodel.dart';
import 'package:saving_app/viewmodels/account/credit_viewmodel.dart';
import 'package:saving_app/viewmodels/account/debit_viewmodel.dart';
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

final totalBalanceProvider = FutureProvider((ref) async {
  final accounts = ref.watch(allPayableAccountProvider).when(
    data: (data) => data, 
    error: (error, _) => null, 
    loading: () => null,
  );
  if(accounts == null) {
    return 0;
  }
  return accounts.fold(0, (prev, e) => prev + e.usableBalance);
});
