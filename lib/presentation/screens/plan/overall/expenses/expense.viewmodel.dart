import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving_app/data/models/plan/income_dist.dart';
import 'package:saving_app/viewmodels/plan/plan_setting_viewmodel.dart';
import 'package:saving_app/viewmodels/transact/plan_transact_viewmodel.dart';

final distMapProvider = Provider((ref) {
  final incomeDist = ref.watch(currentIncomeDistProvider).when(
                  data: (data) => data, 
                  error: (error, _) => null, 
                  loading: () => null
  );
  final totalIncome = ref.watch(totalIncomeProvider).when(
    data: (data) => data, 
    error: (error, _) => 0, 
    loading: () => -1,
  );
  if(incomeDist != null && totalIncome != 0) {
    final data = incomeDist.distributeIncome(totalIncome);
    final res = data.map((key, value) => MapEntry(
      key, 
      [
        switch(key) {
          ExpensesLevel.expense => 10000000,
          ExpensesLevel.nescessity => 1000000,
          ExpensesLevel.personal => 100000,
          ExpensesLevel.saving => 1000000
        },
        value,
      ]
    ));
    return res;
  }
  return {};
});